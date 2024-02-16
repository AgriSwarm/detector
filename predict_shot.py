import subprocess
import json
import sys
import os
import random
import string
import shutil
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

def run_inference_in_docker(container_id, image_path, result_path):
    try:
        subprocess.check_call(["docker", "exec", container_id, "sh", "workspace/inference.sh", image_path, result_path])
    except subprocess.CalledProcessError:
        print("Error running inference script in Docker")

def read_results(file_path):
    if not os.path.exists(file_path):
        print(f"Results file not found: {file_path}")
        return None

    with open(file_path, 'r') as file:
        data = json.load(file)
    os.remove(file_path)
    return data

def predict(image_path):
    random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=10))
    container_name = "mito_detector"  
    results_file_path = f"results_{random_string}.json"

    container_id = find_docker_container(container_name)
    if not container_id:
        print("Docker container not found.")
        sys.exit(1)

    # copy image_path to ./workspace not using docker
    dest = "target" + Path(image_path).suffix
    shutil.copy(image_path, dest)
    run_inference_in_docker(container_id, dest, results_file_path)
    results = read_results(results_file_path)
    return results

# debug
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python predict_shot.py <path_to_image>")
        sys.exit(1)

    image_path = sys.argv[1]
    results = predict(image_path)
    print("DEBUG:",results)