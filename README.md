# Detector

## Usage

### Python

Perform inference effortlessly by calling `predict(...)` as demonstrated below:

```python
import json
from predict_shot import predict

with open("coco_converted/val/images/000056.jpg", 'rb') as file:
    image = file.read()
    results = predict(image)
print(json.dumps(results, indent=4))
```

Sample output:

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

![image0](https://github.com/user-attachments/assets/c816a02b-db79-443a-a63f-6e27b9ade279)


### Command Line Interface (CLI)

Run inference directly from the command line:

```bash
python predict_shot.py coco_converted/val/images/000056.jpg
```

### Setting Up the Docker Container

If you need to launch your own Docker container, simply execute the following command:

```bash
bash run_docker.sh
```

## For Machine Learning Engineers

Streamline your workflow with the full pipeline:

```bash
bash run_docker.sh
bash all_pipeline.sh
```

Elevate your ML tasks with these simple, yet powerful commands!
