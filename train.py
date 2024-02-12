from ultralytics import YOLO

model = YOLO('yolov8n.pt')

results = model.train(
    data='custom.yaml',
    epochs=10, 
#    imgsz=640, 
    device='mps'
)
