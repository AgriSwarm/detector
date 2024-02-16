t=ultralytics/ultralytics:8.1.14
sudo docker pull $t
sudo docker run -d --name "mito_detector" -v=`pwd`:/usr/src/ultralytics/workspace  -v=`pwd`/runs:/usr/src/ultralytics/runs --ipc=host --gpus all $t  sleep infinity
exit 0
