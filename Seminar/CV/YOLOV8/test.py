from ultralytics import YOLO
import cv2
from ultralytics.utils.plotting import Annotator
import matplotlib.pyplot as plt
from PIL import Image
import numpy as np
import os 

# loading the trained custom model
model = YOLO('best.pt')
model2 = YOLO('yolov8n.pt')
conf = 0.6
googles_conf = 0.001
gloves_conf  = 0.001
helmets_conf = 0.001
vests_conf = 0.001

def rescale_frame(frame, percent=75):
    width = int(frame.shape[1] * percent / 100)
    height = int(frame.shape[0] * percent / 100)
    dim = (width, height)
    return cv2.resize(frame, dim, interpolation=cv2.INTER_AREA)


def s(num):
    if num < 2 or num >= 10:
        return ""
    return "s"


# font settings
font = cv2.FONT_HERSHEY_SIMPLEX
fontScale = 1.2
font_color = (84, 184, 211)
font_color2 = (211, 184, 84)
font_thickness_bg = 6
font_thickness = 4


vid_name = "IMG_4325"
vid_path = "D:\\IME PPL"
final_path = os.path.join(vid_path, vid_name + ".MOV")

# running the real-time model detection
cap = cv2.VideoCapture(final_path)
width, height = int(cap.get(3)), int(cap.get(4))
fourcc = cv2.VideoWriter_fourcc(*'XVID')
video_out = cv2.VideoWriter(vid_name + "_detected.avi", fourcc, 20.0, (width, height))


i = 0
cv2.destroyAllWindows()
while cap.isOpened():

    ret, frame = cap.read()
    
    if not ret:
        break
    # Make detections
    # frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = model.predict(frame, show_conf=True)

    # bbx = results[0].boxes.xyxy.numpy()
    # cls1 = results[0].boxes.cls.numpy()

    results2 = model2.predict(frame, show_conf=True)

    # bbx2 = results2[0].boxes.xyxy.numpy()
    # cls2 = results2[0].boxes.cls.numpy()
    # num_persons = np.count_nonzero(cls2 == 0.0)    
    # num_gloves = np.count_nonzero(cls1 == 0.0)   
    # num_googles = np.count_nonzero(cls1 == 1.0)
    # num_helmets = np.count_nonzero(cls1 == 2.0)
    # num_vests = np.count_nonzero(cls1 == 3.0)

    num_persons = 0  
    num_gloves = 0  
    num_googles = 0
    num_helmets = 0
    num_vests = 0
    # Apply bounding boxes and display image after predictions
    for r in results:
        annotator = Annotator(frame)
        boxes = r.boxes
        for box in boxes:
                b = box.xyxy[0]  # get box coordinates in (top, left, bottom, right) format
                c = box.cls
                x = box
                annotator.box_label(b, model.names[int(c)])
                if c == 0.0 and box.conf > gloves_conf:
                    num_gloves += 1
                elif c == 1.0 and box.conf > googles_conf:
                    num_googles += 1
                elif c == 2.0 and box.conf > helmets_conf:
                    num_helmets += 1
                elif c == 3.0 and box.conf > vests_conf:
                    num_vests += 1


    image_with_boxes = annotator.result()

    for r in results2:
        annotator = Annotator(image_with_boxes)
        boxes = r.boxes
        for box in boxes:
            if(box.conf > conf and box.cls == 0):
                num_persons += 1
                b = box.xyxy[0]  # get box coordinates in (top, left, bottom, right) format
                c = box.cls
                x = box
                annotator.box_label(b, model2.names[int(c)])

    image_with_boxes = annotator.result()
    results = image_with_boxes

    h, w = results.shape[:2]
    if w > width:
        results = rescale_frame(results, 60)
    elif w < width//2:
        results = rescale_frame(results, 150)
    h, w = results.shape[:2]
    text_spacing = h // 20
    if num_vests < num_persons:
        print(f"{num_persons} person with {num_vests} reflective vest")
        results = cv2.putText(results,
                            f"{num_persons} person{s(num_persons)} with {num_vests} reflective vest{s(num_vests)}",
                            (w // 20, h - text_spacing * 1), font, fontScale, (0, 0, 0), font_thickness_bg, cv2.LINE_AA)
        results = cv2.putText(results,
                            f"{num_persons} person{s(num_persons)} with {num_vests} reflective vest{s(num_vests)}",
                            (w // 20, h - text_spacing * 1), font, fontScale, (0, 0, 220), font_thickness, cv2.LINE_AA)

    
    if num_helmets < num_persons:
        print(f"{num_persons} person with {num_helmets} helmet")
        results = cv2.putText(results,
                            f"{num_persons} person{s(num_persons)} with {num_helmets} helmet{s(num_helmets)}",
                            (w // 20, h - text_spacing * 2), font, fontScale, (0, 0, 0), font_thickness_bg, cv2.LINE_AA)
        results = cv2.putText(results,
                            f"{num_persons} person{s(num_persons)} with {num_helmets} helmet{s(num_helmets)}",
                            (w // 20, h - text_spacing * 2), font, fontScale, (0, 0, 220), font_thickness, cv2.LINE_AA)

    if num_gloves/2 < num_persons:
        print(f"{num_persons} person with {num_gloves} gloves")
        results = cv2.putText(results,
                            f"{num_persons} person{s(num_persons)} with {num_gloves} gloves{s(num_gloves)}",
                            (w // 20, h - text_spacing * 3), font, fontScale, (0, 0, 0), font_thickness_bg, cv2.LINE_AA)
        results = cv2.putText(results,
                            f"{num_persons} person{s(num_persons)} with {num_gloves} gloves{s(num_gloves)}",
                            (w // 20, h - text_spacing * 3), font, fontScale, (0, 0, 220), font_thickness, cv2.LINE_AA)

    if num_googles < num_persons:
        print(f"{num_persons} person with {num_googles} googles")
        results = cv2.putText(results,
                            f"{num_persons} person{s(num_persons)} with {num_googles} googles{s(num_googles)}",
                            (w // 20, h - text_spacing * 4), font, fontScale, (0, 0, 0), font_thickness_bg, cv2.LINE_AA)
        results = cv2.putText(results,
                            f"{num_persons} person{s(num_persons)} with {num_googles} googles{s(num_googles)}",
                            (w // 20, h - text_spacing * 4), font, fontScale, (0, 0, 220), font_thickness, cv2.LINE_AA)

    video_out.write(results)  
    
    # cv2.imshow('Hazard Detection and Safety system', results)
    if cv2.waitKey(1) & 0xFF == 27:
        break

# Release the video writer before closing
video_out.release()
cap.release()
cv2.destroyAllWindows()