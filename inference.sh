#!/bin/bash
cd workspace

# Check if an argument is given (image file path)
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 image_path"
    exit 1
fi

image_path=$1

# Check if the image file exists
if [ ! -f "$image_path" ]; then
    echo "Error: File not found - $image_path"
    exit 1
fi

# Find the most recent 'best.pt' checkpoint
ckpt=$(find . -name "best.pt" | xargs ls -lt | awk '{ print $NF }' | grep -v '^$' | head -n 1)

# Check if a checkpoint file was found
if [ -z "$ckpt" ]; then
    echo "Error: No 'best.pt' checkpoint file found."
    exit 1
fi

# Run the inference script
python inference.py "$image_path" --checkpoint "$ckpt" --save_path=results.json