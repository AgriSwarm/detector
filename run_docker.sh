t=ultralytics/ultralytics:8.1.14
sudo docker pull $t
sudo docker run -d --name "mito_detector" -p=3100:3100 -v=`pwd`:/usr/src/ultralytics/workspace  -v=`pwd`/runs:/usr/src/ultralytics/runs --ipc=host --gpus all $t sleep infinity
sudo docker exec mito_detector sh workspace/run_server.sh
exit 0
