from ultralytics.data.converter import convert_coco
from pathlib import Path

path = Path('./preprocess/data/coco/')
assert path.exists()
print(path.glob("*.json"))

convert_coco(labels_dir=f"{path}")
