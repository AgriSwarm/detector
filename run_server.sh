#!/bin/bash
cd ./workspace
if ! pip freeze | grep -q fastapi; then
    echo "FastAPI is not installed. Installing FastAPI and Uvicorn..."
    pip install fastapi uvicorn
    pip install python-multipart
else
    echo "FastAPI is already installed."
fi

# Find the most recent 'best.pt' checkpoint
ckpt=$(find . -name "best.pt" | xargs ls -lt | awk '{ print $NF }' | grep -v '^$' | head -n 1)

# Check if a checkpoint file was found
if [ -z "$ckpt" ]; then
    echo "Error: No 'best.pt' checkpoint file found."
    exit 1
fi

# Run the inference script, reading the image data from STDIN
# cat /dev/stdin | python inference.py --checkpoint "$ckpt" --save_path="$save_path"
python inference.py --checkpoint "$ckpt" &
exit 0