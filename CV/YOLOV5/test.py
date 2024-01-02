import torch
import numpy as np
import cv2
# loading the trained custom model
model = torch.hub.load('ultralytics/yolov5', 'custom', path="best.pt",
                       force_reload=True)
model.conf = 0.5  # NMS confidence threshold

model2 = torch.hub.load('ultralytics/yolov5', "yolov5n", force_reload=True)
model2.conf = 0.5  # NMS confidence threshold
model2.classes = [0]  # person detection


def rescale_frame(frame, percent=75):
    width = int(frame.shape[1] * percent / 100)
    height = int(frame.shape[0] * percent / 100)
    dim = (width, height)
    return cv2.resize(frame, dim, interpolation=cv2.INTER_AREA)


def s(num):
    if num < 2:
        return ""
    return "s"


# font settings
font = cv2.FONT_HERSHEY_SIMPLEX
fontScale = 0.9
font_color = (84, 184, 211)
font_color2 = (211, 184, 84)
font_thickness = 4

# running the real-time model detection
cap = cv2.VideoCapture("D:\\IME PPL\\IMG_4330.MOV")
width, height = int(cap.get(3)), int(cap.get(4))
fourcc = cv2.VideoWriter_fourcc(*'XVID')
video_out = cv2.VideoWriter('output2.avi', fourcc, 20.0, (width, height))


i = 0
cv2.destroyAllWindows()
while cap.isOpened():

    ret, frame = cap.read()
    
    if not ret:
        break
    # Make detections
    frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = model(frame)

    df = results.xyxy[0].numpy()

    classes = []
    for i in range(len(df)):
        classes.append(df[i][5])


    results2 = model2(np.squeeze(results.render()))
    df = results2.xyxy[0].numpy()
    classes2 = []
    for i in range(len(df)):
        classes2.append(df[i][5])
    num_persons = len(classes2)
    num_vests = classes.count(3.0)
    num_helmets = classes.count(4.0)
    num_gloves = classes.count(10.0)
    results = cv2.cvtColor(np.squeeze(results.render()), cv2.COLOR_RGB2BGR)
    h, w = results.shape[:2]
    if w > width:
        results = rescale_frame(results, 60)
    elif w < width//2:
        results = rescale_frame(results, 150)
    h, w = results.shape[:2]

  
    if num_vests < num_persons:
                print(f"{num_persons} person with {num_vests} reflective vest")
                results = cv2.putText(results,
                                      f"{num_persons} person{s(num_persons)} with {num_vests} reflective vest{s(num_vests)}",
                                      (w // 20, h * 19 // 20), font, 0.6, (0, 0, 0), 3, cv2.LINE_AA)
                results = cv2.putText(results,
                                      f"{num_persons} person{s(num_persons)} with {num_vests} reflective vest{s(num_vests)}",
                                      (w // 20, h * 19 // 20), font, 0.6, (0, 0, 220), 2, cv2.LINE_AA)

  
    if num_helmets < num_persons:
                print(f"{num_persons} person with {num_helmets} helmet")
                results = cv2.putText(results,
                                      f"{num_persons} person{s(num_persons)} with {num_helmets} helmet{s(num_helmets)}",
                                      (w // 20, h * 17 // 20), font, 0.6, (0, 0, 0), 3, cv2.LINE_AA)
                results = cv2.putText(results,
                                      f"{num_persons} person{s(num_persons)} with {num_helmets} helmet{s(num_helmets)}",
                                      (w // 20, h * 17 // 20), font, 0.6, (0, 0, 220), 2, cv2.LINE_AA)

    if num_gloves/2 < num_persons:
                print(f"{num_persons} person with {num_gloves} gloves")
                results = cv2.putText(results,
                                      f"{num_persons} person{s(num_persons)} with {num_gloves} gloves{s(num_gloves)}",
                                      (w // 20, h * 15 // 20), font, 0.6, (0, 0, 0), 3, cv2.LINE_AA)
                results = cv2.putText(results,
                                      f"{num_persons} person{s(num_persons)} with {num_gloves} gloves{s(num_gloves)}",
                                      (w // 20, h * 15 // 20), font, 0.6, (0, 0, 220), 2, cv2.LINE_AA)

    video_out.write(results)  
    
    # cv2.imshow('Hazard Detection and Safety system', results)
    if cv2.waitKey(1) & 0xFF == 27:
        break

# Release the video writer before closing
video_out.release()
cap.release()
cv2.destroyAllWindows()