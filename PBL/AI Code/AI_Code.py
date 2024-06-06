import cv2
import math
import mediapipe as mp
from mediapipe.framework.formats import landmark_pb2
from ultralytics import YOLO
from ultralytics.utils.plotting import Annotator
from datetime import datetime
import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud.firestore_v1 import Increment
from mjpeg_streamer import MjpegServer, Stream
import numpy as np
from PIL import Image
import numpy as np
import io
import base64

# Initialize Firestore
cred = credentials.Certificate('officialpbl-firebase-adminsdk-3qtj6-7e0d0b4e07.json')
firebase_admin.initialize_app(cred)
db = firestore.client()


# Constants
IP = "192.168.1.3"
PORT = 5555
SAFETY_MODEL_CONF_THRESHOLD = 0.6
HUMAN_MODEL_CONF_THRESHOLD = 0.5
DISTANCE_THRESHOLD = 15
CROP_MARGIN = 2
FRAME_WIDTH = 640
FRAME_HEIGHT = 480
HALF_FRAME_HEIGHT = FRAME_HEIGHT // 2
HUMAN_CLASS = 0
HELMET_CLASS = 1
GLOVES_CLASS = 0
GOOGLES_CLASS = 2
VEST_CLASS = 3
RESIZE_SCALE = 0.15
GREEN_COLOR = (0, 255, 0)
RED_COLOR = (0, 0, 255)
LINE_THICKNESS = 2
X_MIN_INDEX = 0
Y_MIN_INDEX = 1
X_MAX_INDEX = 2
Y_MAX_INDEX = 3
NOSE_INDEX = 0
LEG_INDEX = 29
HAND_INDEX = 15
BELLY_INDEX = 23
VIDEO = 'IMG_4326.MOV'
# VIDEO = 'http://192.168.137.147:8000/stream.mjpg'     switch to stream
SAFETY_MODEL = 'last.pt'
HUMAN_MODEL = 'yolov8n.pt'
COLLECTION_NAME = 'Errors '
DOCUMENT_ID_HELMET = 'Helmet'
DOCUMENT_ID_LINE = 'Line'
DOCUMENT_ID_GOOGLE = 'Google'
DOCUMENT_ID_VEST = 'Vest'
DOCUMENT_ID_GLOVE = 'Glove'
class DetectionModel:
    """
    Class for YOLO detection models.
    """
    def __init__(self, model_path, classes=None):
        """
        Initializes the DetectionModel object.

        Args:
            model_path (str): Path to the YOLO model.
            classes (list): List of classes for the model.
        """
        self.model = YOLO(model_path)
        if classes:
            self.model.classes = classes

    def predict_and_annotate(self, img, conf_threshold, color=(0, 0, 255)):
        """
        Predicts objects in the image and annotates them.

        Args:
            img (numpy.ndarray): Input image.
            conf_threshold (float): Confidence threshold for detection.
            color (tuple): Bounding box color.

        Returns:
            numpy.ndarray: Bounding box coordinates.
            Annotator: Annotator object with annotated image.
        """
        results = self.predict(img)
        annotator = Annotator(img)
        for result in results:
            boxes = result.boxes
            for box in result.boxes:
                if box.conf > conf_threshold:
                    box_coords = box.xyxy[0]
                    class_index = box.cls
                    annotator.box_label(box_coords, self.model.names[int(class_index)], color=color)
        return boxes, annotator

    def predict(self, img):
        """
        Performs prediction on the image.

        Args:
            img (numpy.ndarray): Input image.

        Returns:
            List: Prediction results.
        """
        return self.model.predict(img)


def preprocess_frame(frame, flip_horizontal=True, flip_vertical=True, resize_scale=0.15):
    """
    Preprocesses the input frame.

    Args:
        frame (numpy.ndarray): The input frame.
        flip_horizontal (bool): Whether to flip the frame horizontally. Default is True.
        flip_vertical (bool): Whether to flip the frame vertically. Default is True.
        resize_scale (float): Scaling factor for resizing the frame. Default is 0.15.

    Returns:
        numpy.ndarray: Preprocessed image in RGB format.
        numpy.ndarray: Preprocessed frame.
    """
    # Flip the frame horizontally if specified
    if flip_horizontal:
        frame = cv2.flip(frame, X_MIN_INDEX)
    
    # Flip the frame vertically if specified
    if flip_vertical:
        frame = cv2.flip(frame, Y_MIN_INDEX)

    # Resize the frame
    frame = cv2.resize(frame, (0, 0), fx=resize_scale, fy=resize_scale)

    # Convert the frame to RGB format
    img = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    return img, frame


def check_body_part_presence(result, body_index, box_coords, body_parts, img_shape, DISTANCE_THRESHOLD):
    """
    Checks if a specified body part (e.g., helmet) is present near a person's body landmark.

    Args:
        result (object): Result object containing pose landmarks.
        body_index (int): Index of the body landmark in the result object.
        box_coords (list): Bounding box coordinates of the person.
        body_parts (list): List of bounding boxes for the body parts to check (e.g., helmets).
        img_shape (tuple): Shape of the image.
        DISTANCE_THRESHOLD (float): The distance threshold to consider a body part near the body landmark.

    Returns:
        bool: True if a body part is present, False otherwise.
    """
    # Get the landmark of the person's body part using the body index
    body_landmark = result.pose_landmarks.landmark[body_index]

    # Extract image height, width, and number of channels from img_shape
    ih, iw, _ = img_shape

    # Calculate the x and y coordinates of the body landmark in the image
    body_x, body_y = int(body_landmark.x * iw), int(body_landmark.y * ih)

    # Add the x and y coordinates of the bounding box to get the absolute position of the body landmark
    body_x += int(box_coords[X_MIN_INDEX])
    body_y += int(box_coords[Y_MIN_INDEX])

    # Iterate through each body part bounding box
    for part_coord in body_parts:
        # Calculate the center coordinates of the body part
        part_center_x = (part_coord[X_MIN_INDEX] + part_coord[X_MAX_INDEX]) / 2
        part_center_y = (part_coord[Y_MIN_INDEX] + part_coord[Y_MAX_INDEX]) / 2

        # Calculate the distance between the body landmark and the center of the body part
        distance = math.sqrt((body_x - part_center_x)**2 + (body_y - part_center_y)**2)

        # Check if the distance is less than the threshold or if the body landmark is within the body part bounding box
        if (distance < DISTANCE_THRESHOLD or
                (part_coord[X_MIN_INDEX] < body_x < part_coord[X_MAX_INDEX] and 
                 part_coord[Y_MIN_INDEX] < body_y < part_coord[Y_MAX_INDEX])):
            return True  # Body part is present

    return False  # Body part is not present



def check_leg_position(leg_landmark, box_coords, img_shape, frame, not_passing):
    """
    Checks if a person's leg position is above a certain threshold.

    Args:
        leg_landmark (Landmark): Landmark of the person's leg.
        box_coords (list): Bounding box coordinates of the person.
        img_shape (tuple): Shape of the image.
        frame (numpy.ndarray): Input frame.
        not_passing (bool): Flag indicating if the person is not passing the threshold.

    Returns:
        bool: Updated flag indicating if the person is not passing the threshold.
    """
    # Extract image height, width, and number of channels from img_shape
    ih, iw, _ = img_shape
    
    # Calculate the x and y coordinates of the leg in the image
    leg_x, leg_y = int(leg_landmark.x * iw), int(leg_landmark.y * ih)
    
    # Add the x and y coordinates of the bounding box to get the absolute position of the leg
    leg_x += int(box_coords[X_MIN_INDEX])
    leg_y += int(box_coords[Y_MIN_INDEX])

    # Check if the leg's x-coordinate is above a certain threshold
    if not_passing == False and leg_x > HALF_FRAME_HEIGHT:
        # Draw a line on the frame to indicate the threshold line
        cv2.line(frame, (0, HALF_FRAME_HEIGHT), (frame.shape[1], HALF_FRAME_HEIGHT), RED_COLOR, LINE_THICKNESS)
        # Update the not_passing flag to True since the person's leg is above the threshold
        not_passing = True

    # Return the updated not_passing flag
    return not_passing

def upload_Image_FireBase(collection_name, document_id, cropped_img, error_message):
    """
    Uploads a image to Firestore.

    Args:
        collection_name (str): Name of the Firestore collection.
        document_id (str): ID of the document to be created/updated.
        cropped_img (numpy.ndarray): Cropped image array.
        error_message (str): Error message to be stored in the document.

    Returns:
        None
    """
    # Convert NumPy array to image
    image = Image.fromarray(cropped_img)

    # Save image to a bytes buffer
    buffer = io.BytesIO()
    image.save(buffer, format="PNG")
    buffer.seek(0)

    # Get the byte data
    image_bytes = buffer.getvalue()
    #Encode image bytes to base64 string
    image_base64 = base64.b64encode(image_bytes).decode('utf-8')
    # Get the current timestamp
    current_time = datetime.now()
    
    # Construct the document reference
    doc_ref = db.collection(collection_name).document(document_id)
    
    # Set document data
    doc_ref.set({
        'base64': image_base64,
        'error': error_message,
        'data_time': current_time
    })
    
def retrieve_and_save_image(collection_name, document_id, save_path):
    """
    Retrieves an image from Firestore, reshapes it, and saves it as a file.

    Args:
        collection_name (str): Name of the Firestore collection.
        document_id (str): ID of the document containing the image.
        save_path (str): Path to save the image file.

    Returns:
        None
    """
    # Access Firestore
    db = firestore.client()
    
    # Access the specified collection
    collection_ref = db.collection(collection_name)
    
    # Access the document within the collection
    doc_ref = collection_ref.document(document_id)
    
    # Retrieve the data from the document
    doc_data = doc_ref.get().to_dict()
    
    # Get the original shape of the image
    original_shape = doc_data['shape']  
    
    # Retrieve the flattened image array and reshape it
    original_array = np.array(doc_data['image_url']).reshape(original_shape)
    
    # Save the image
    cv2.imwrite(save_path, original_array)
    
    # Delete the document from Firestore
    doc_ref.delete()

def update_or_create_document(collection_name, document_id, data):
    """
    Updates an existing document or creates a new document in a Firestore collection.

    This function sets the data for a specified document in a given collection. 
    If the document does not exist, it will be created. If the document already 
    exists, the provided data will be merged with the existing data.

    Parameters:
    collection_name (str): The name of the Firestore collection.
    document_id (str): The ID of the document to update or create.
    data (dict): The data to set in the document. If merging with an existing document, 
                 this data will be combined with the existing data.

    Returns:
    None
    """
    # Reference the document in the specified collection
    doc_ref = db.collection(collection_name).document(document_id)
    
    # Set the data for the document, merging with existing data if the document exists
    doc_ref.set(data, merge=True)


def set_up_stream(ip, port, w=640, h=480):
    """
    Sets up a streaming server for a camera.

    This function initializes a streaming server with specified IP and port, 
    and sets up a camera stream with given width, height, quality, and frame rate.

    Parameters:
    ip (str): The IP address for the streaming server.
    port (int): The port number for the streaming server.
    w (int, optional): The width of the video stream. Defaults to 640.
    h (int, optional): The height of the video stream. Defaults to 480.

    Returns:
    Stream: The initialized Stream object for the camera.
    """
    # Initialize the camera stream with specified size, quality, and frame rate
    streamer = Stream("my_camera", size=(w, h), quality=40, fps=15)
    
    # Set up the MJPEG server with the given IP and port
    server = MjpegServer(ip, port)
    
    # Add the camera stream to the server
    server.add_stream(streamer)
    
    # Start the server to begin streaming
    server.start()
    
    # Return the Stream object
    return streamer 

def stream_frame(streamer, frame):
    """
    Streams a single frame to the streaming server.

    This function sets a new frame for the specified streamer to broadcast.

    Parameters:
    streamer (Stream): The Stream object used to broadcast the video.
    frame: The frame to be streamed.

    Returns:
    None
    """
    # Set the current frame for the streamer
    streamer.set_frame(frame)

# Define the DetectionModel class instances
safety_model = DetectionModel(SAFETY_MODEL)
human_model = DetectionModel(HUMAN_MODEL, classes=[HUMAN_CLASS])

cap = cv2.VideoCapture(VIDEO)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, FRAME_WIDTH)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, FRAME_HEIGHT)

mp_pose = mp.solutions.pose
mp_drawing = mp.solutions.drawing_utils
pose = mp_pose.Pose()

STREAMER = set_up_stream(IP, PORT)
# Main loop to process frames from the video capture
while cap.isOpened():
    # Read a frame from the video capture
    ret, frame = cap.read()

    # Break the loop if no frame is read
    if not ret:
        break

    # Preprocess the frame
    img, frame = preprocess_frame(frame, False, False, 0.5)

    # Draw a horizontal line on the frame
    cv2.line(frame, (0, HALF_FRAME_HEIGHT), (frame.shape[1], HALF_FRAME_HEIGHT), GREEN_COLOR, LINE_THICKNESS)

    # Prediction and annotation for safety model
    safety_boxes, annotator = safety_model.predict_and_annotate(frame, SAFETY_MODEL_CONF_THRESHOLD)
    frame = annotator.result()

    # Extract helmet boxes
    helmets = list(safety_boxes.data[safety_boxes.data[:, 5] == HELMET_CLASS])

    # Extract gloves boxes
    gloves = list(safety_boxes.data[safety_boxes.data[:, 5] == GLOVES_CLASS])

    # Extract vest boxes
    vest = list(safety_boxes.data[safety_boxes.data[:, 5] == VEST_CLASS])

    # Extract googles boxes
    googles = list(safety_boxes.data[safety_boxes.data[:, 5] == GOOGLES_CLASS])

    
    # Prediction and annotation for human model
    human_boxes, annotator = human_model.predict_and_annotate(frame, HUMAN_MODEL_CONF_THRESHOLD, color=(255, 0, 0))

    humans =  list(human_boxes.data[human_boxes.data[:, 5] == HUMAN_CLASS])
    # Flag to track if a person is not passing the threshold
    not_passing = False
    # Process each detected human
    for box_coords in human_boxes:
        box_coords = box_coords.xyxy[0]
        # Crop the image around the detected human
        cropped_img = img[int(box_coords[Y_MIN_INDEX]):int(box_coords[Y_MAX_INDEX]),
                      int(box_coords[X_MIN_INDEX]):int(box_coords[X_MAX_INDEX])]
        
        # Process pose landmarks
        result = pose.process(cropped_img)

        if result.pose_landmarks:
            # Extract leg landmarks
            leg_landmark = result.pose_landmarks.landmark[LEG_INDEX]

            # Check if a helmet is present near the person's head
            hel = check_body_part_presence(result, NOSE_INDEX, box_coords, helmets, cropped_img.shape, DISTANCE_THRESHOLD)
            if not hel:
                upload_Image_FireBase(DOCUMENT_ID_HELMET, DOCUMENT_ID_HELMET, cropped_img, "No Helmet")
                cv2.imwrite('helmet_without_person.jpg', cropped_img)

            # Check if a gloves is present near the person's hand
            glo = check_body_part_presence(result, HAND_INDEX, box_coords, gloves, cropped_img.shape, DISTANCE_THRESHOLD)
            if not glo:
                upload_Image_FireBase(DOCUMENT_ID_GLOVE, DOCUMENT_ID_GLOVE, cropped_img, "No Glove")
                cv2.imwrite('gloves_without_person.jpg', cropped_img)

            # Check if a vests is present near the person's body
            ves = check_body_part_presence(result, BELLY_INDEX, box_coords, vest, cropped_img.shape, DISTANCE_THRESHOLD)
            if not ves:
                upload_Image_FireBase(DOCUMENT_ID_VEST, DOCUMENT_ID_VEST, cropped_img, "No Vest")
                cv2.imwrite('vest_without_person.jpg', cropped_img)

            # Check if a googles is present near the person's eye
            goog = check_body_part_presence(result, NOSE_INDEX, box_coords, googles, cropped_img.shape, DISTANCE_THRESHOLD)
            if not goog:
                upload_Image_FireBase(DOCUMENT_ID_GOOGLE, DOCUMENT_ID_GOOGLE, cropped_img, "No Google")
                cv2.imwrite('googles_without_person.jpg', cropped_img)
        

            # Check if the person's leg position is above a certain threshold
            if not_passing == False:
                not_passing = check_leg_position(leg_landmark, box_coords, cropped_img.shape, frame, not_passing)
                if not_passing:
                    upload_Image_FireBase(DOCUMENT_ID_LINE, DOCUMENT_ID_LINE, cv2.resize(frame[frame.shape[0]//2:frame.shape[0], 0:frame.shape[1]], (int(400 * (frame.shape[1] / (frame.shape[0]//2))), 400)), "Passing The Line")
                    cv2.imwrite('xx.jpg', frame[HALF_FRAME_HEIGHT:FRAME_HEIGHT, 0:frame.shape[1]])

            # Draw landmarks on the frame
            landmark_subset = landmark_pb2.NormalizedLandmarkList(
                landmark=result.pose_landmarks.landmark[:NOSE_INDEX+1])
            mp_drawing.draw_landmarks(frame[int(box_coords[Y_MIN_INDEX]):int(box_coords[Y_MAX_INDEX]),
                                      int(box_coords[X_MIN_INDEX]):int(box_coords[X_MAX_INDEX])], landmark_subset)
    frame = annotator.result()

    # Send detected data to Firestore
    detection_data = {
        'timestamp': datetime.now(),
        'num_persons': len(humans),
        'num_gloves' : len(gloves),
        'num_googles': len(googles),
        'num_helmets': len(helmets),
        'num_vests': len(vest)
    }
    
    # Update or create a document in Firestore
    update_or_create_document('notifications_', 'detection_data', detection_data)
    
    # Display the annotated frame
    cv2.imshow('YOLO V8 Detection', frame)
    stream_frame(STREAMER, frame)
    # Break the loop if 'q' is pressed
    if cv2.waitKey(10) & 0xFF == ord('q'):
        break

# Release the video capture and close all windows
cap.release()
cv2.destroyAllWindows()
