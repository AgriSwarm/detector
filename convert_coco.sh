#!/bin/bash

# Function to echo in yellow color
colored_echo() {
    local text=$1
    local color_code="\033[1;33m"  # Yellow color code
    echo -e "${color_code}${text}\033[0m"
}

# Check if coco_converted directory exists and delete it
if [ -d "coco_converted" ]; then
    colored_echo "Removing existing coco_converted directory..."
    rm -rf coco_converted*
fi

# Run Python script to convert coco
colored_echo "Converting coco..."
python convert_coco.py

# Create necessary directories if they don't exist
mkdir -p coco_converted/images
mkdir -p coco_converted/labels

# Copy JPEG images to the coco_converted/images directory
colored_echo "Copying JPEG images..."
cp ./preprocess/data/coco/*.jpg coco_converted/images

# Move annotations to the labels directory
colored_echo "Moving annotations..."
mv coco_converted/labels/annotations/* coco_converted/labels/

colored_echo "Script execution completed."
