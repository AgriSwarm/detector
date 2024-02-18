import subprocess
import json
import sys
import os
import random
import string
import shutil
import requests
from pathlib import Path

def find_docker_container(container_name, call_count=0):
    try:
        output = subprocess.check_output(["docker", "ps", "-q", "-f", f"name={container_name}"])
        results = output.decode('utf-8').strip()
        if results:
            return results
    except subprocess.CalledProcessError:
        pass

    print("Cannot find Docker container. Starting a new one.")
    subprocess.check_call("sh run_docker.sh".split())
    if call_count == 0:
        return find_docker_container(container_name, call_count=1)
    else:
        return None

def inference(image):
    url = "http://localhost:3100/predict/"
    response = requests.post(url, files={"file": ("tmp.jpg", image, "image/jpeg")})
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to get a response, status code: {response.status_code}")
        return None

def predict(image):
    random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=10))
    container_name = "mito_detector"  
    results_file_path = f"results_{random_string}.json"

    container_id = find_docker_container(container_name)
    if not container_id:
        print("Docker container not found.")
        sys.exit(1)

    # copy image_path to ./workspace not using docker
    # run_server_in_docker(container_id)
    results = inference(image)
    return results

# debug
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python predict_shot.py <path_to_image>")
        sys.exit(1)

    image_path = sys.argv[1]
    with open(image_path, 'rb') as file:
        image = file.read()
        results = predict(image)
    print("DEBUG:",results)