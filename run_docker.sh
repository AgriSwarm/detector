t=ultralytics/ultralytics:latest

# Pull the latest ultralytics image from Docker Hub
sudo docker pull $t

# Run the ultralytics image in a container with GPU support
sudo docker run -it -v=`pwd`:/usr/src/ultralytics/workspace  -v=`pwd`/runs:/usr/src/ultralytics/runs --ipc=host --gpus all $t  # all GPUs
