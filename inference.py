import argparse
import json
import sys
import cv2
import numpy as np
from ultralytics import YOLO

from fastapi.responses import JSONResponse
from fastapi import FastAPI, File, UploadFile
from ultralytics import YOLO
import cv2
import numpy as np
import json

app = FastAPI()
args, model = None, None

@app.post("/predict/")
async def create_upload_file(file: UploadFile = File(...)):
    contents = await file.read()
    nparr = np.frombuffer(contents, np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    if image is None:
        return {"error": "Invalid image"}

    results = predict(args,image)
    return results


def predict(args, image):
    if image is None:
        print("Error loading image")
        return {"error": "Invalid image"}

    res = model.predict(image, save=True, conf=args.conf)
    assert len(res) == 1
    res = res[0]
    
    outputs = []
    boxes = res.boxes
    
    postprocess = lambda x: x.cpu().numpy().tolist()
    for bbox,conf in zip(boxes.xyxy,boxes.conf):
        outputs.append({
            "bbox_xyxy": postprocess(bbox),
            "conf": postprocess(conf)
        })
    
    return JSONResponse(content=json.dumps(outputs, indent=4))

if __name__ == "__main__":
    import uvicorn
    parser = argparse.ArgumentParser(description='Run YOLO model inference.')
    parser.add_argument('--checkpoint', type=str, required=True, help='Path to the model checkpoint.')
    parser.add_argument('--conf', type=float, default=0.3, help='Confidence threshold for predictions.')

    args = parser.parse_args()
    model = YOLO(args.checkpoint)
    uvicorn.run(app, host="0.0.0.0", port=3100)
