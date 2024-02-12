from ultralytics import YOLO

model = YOLO('yolov8n.pt')

results = model.train(
    data='custom.yaml',
    epochs=30, 
#    imgsz=640, 
    device='cuda'
)
