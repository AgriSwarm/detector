#!/bin/bash

# Function to echo in yellow color
colored_echo() {
    local text=$1
    echo -e "\033[1;33m${text}\033[0m"
}

# Check if coco_converted directory exists and delete it
if [ -d "coco_converted" ]; then
    colored_echo "Removing existing coco_converted directory..."
    rm -rf coco_converted*
fi

# Run Python script to convert coco
colored_echo "Converting coco..."
python convert_coco.py

# Create necessary directories
mkdir -p coco_converted/images
mkdir -p coco_converted/labels
mkdir -p coco_converted/train/images
mkdir -p coco_converted/train/labels
mkdir -p coco_converted/val/images
mkdir -p coco_converted/val/labels

# Copy JPEG images to the coco_converted/images directory
colored_echo "Copying JPEG images..."
cp ./preprocess/data/coco/*.jpg coco_converted/images

# Count total images
total_images=$(ls coco_converted/images | wc -l)
colored_echo "Total number of images: $total_images"

# Calculate the number of images for training and validation
train_count=$((total_images * 8 / 10))
val_count=$((total_images - train_count))

# Move images to train and val directories
colored_echo "Distributing images to train and val directories..."
ls coco_converted/images | head -n "$train_count" | xargs -I {} mv coco_converted/images/{} coco_converted/train/images
ls coco_converted/images | tail -n "$val_count" | xargs -I {} mv coco_converted/images/{} coco_converted/val/images

# Move annotations to the corresponding train and val labels directories
colored_echo "Distributing labels to train and val directories..."
ls coco_converted/labels/annotations | head -n "$train_count" | xargs -I {} mv coco_converted/labels/annotations/{} coco_converted/train/labels
ls coco_converted/labels/annotations | tail -n "$val_count" | xargs -I {} mv coco_converted/labels/annotations/{} coco_converted/val/labels

colored_echo "Script execution completed."
