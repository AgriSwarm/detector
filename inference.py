import argparse
import json
from ultralytics import YOLO

def main():
    parser = argparse.ArgumentParser(description='Run YOLO model inference.')
    parser.add_argument('target', type=str, help='Target file for inference.')
    parser.add_argument('--save_path', type=str, required=True, help='Path to save the results.')
    parser.add_argument('--checkpoint', type=str, required=True, help='Path to the model checkpoint.')
    parser.add_argument('--conf', type=float, default=0.3, help='Confidence threshold for predictions.')

    args = parser.parse_args()

    model = YOLO(args.checkpoint)
    res = model.predict(args.target, save=True, conf=args.conf)
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
    json.dump(outputs, open(args.save_path,"w"), indent=4)

if __name__ == '__main__':
    main()