import argparse
from ultralytics import YOLO

def main():
    parser = argparse.ArgumentParser(description='Run YOLO model inference.')
    parser.add_argument('target', type=str, help='Target file for inference.')
    parser.add_argument('--checkpoint', type=str, required=True, help='Path to the model checkpoint.')
    parser.add_argument('--conf', type=float, default=0.3, help='Confidence threshold for predictions.')

    args = parser.parse_args()

    model = YOLO(args.checkpoint)
    model.predict(args.target, save=True, conf=args.conf)

if __name__ == '__main__':
    main()