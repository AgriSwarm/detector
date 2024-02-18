# detector

## Usage

### Python

下記のように`predict(...)`を呼ぶことで推論できます．

```python
import json
from predict_shot import predict

with open("coco_converted/val/images/000056.jpg", 'rb') as file:
    image = file.read()
    results = predict(image)
print(json.dumps(results,indent=4))
```

```bash
[
    {
        "bbox_xyxy": [
            214.08851623535156,
            846.3001098632812,
            541.779296875,
            1198.1767578125
        ],
        "conf": 0.896393895149231
    },
    ...
]
```

![target](https://github.com/AgriSwarm/detector/assets/51681991/f27ff1e6-ffa7-4c92-8212-48e3ab75c2cb)

### CLI
```
python predict_shot.py coco_converted/val/images/000056.jpg
```
### Dockerコンテナを自分で立ち上げる必要がある場合

下記コマンドを実行してください．

```bash
bash run_docker.sh
```

## For ML engineer
```bash
bash run_docker.sh
bash all_pipeline.sh
```
