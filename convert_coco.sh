#!/bin/bash

# Function to echo in yellow color
colored_echo() {
    local text=$1
    echo -e "\033[1;33m${text}\033[0m"
}

# --- ステップ1: coco_convertedの初期設定 ---

# 既存の coco_converted ディレクトリを削除
if [ -d "coco_converted" ]; then
    colored_echo "Removing existing coco_converted directory..."
    rm -rf coco_converted*
fi

# COCO変換スクリプトを実行
colored_echo "Converting coco..."
python convert_coco.py

# 必要なディレクトリを作成
mkdir -p coco_converted/images
mkdir -p coco_converted/labels/images
mkdir -p coco_converted/labels/annotations
mkdir -p coco_converted/train/images
mkdir -p coco_converted/train/labels
mkdir -p coco_converted/val/images
mkdir -p coco_converted/val/labels

# PNG画像を指定ディレクトリにコピー
colored_echo "Copying PNG images..."
cp ./preprocess/data/coco/images/*.jpg coco_converted/images

# 必要に応じてアノテーションファイルをlabelsにコピー（例として）
# cp ./preprocess/data/coco/labels/*.txt coco_converted/labels/annotations

# 画像の総数をカウント
total_images=$(ls coco_converted/images | wc -l)
colored_echo "Total number of images: $total_images"

# TrainとValの画像数を計算
train_count=$((total_images * 8 / 10))
val_count=$((total_images - train_count))

# --- ステップ2: train/valへの分割 ---

# 画像をシャッフルしてリストを作成
colored_echo "Shuffling images..."
ls coco_converted/images | shuf > shuffled_images.txt

colored_echo "Distributing images and corresponding annotations to train and val directories..."

# Train用の処理
head -n "$train_count" shuffled_images.txt | while read -r image_file; do
    # 画像ファイルを移動
    mv "coco_converted/images/$image_file" "coco_converted/train/images/"
    
    # 画像に対応するラベルファイルを処理
    base_name="${image_file%.*}"
    
    # labels/images 内の対応するファイルがあれば移動
    if [ -f "coco_converted/labels/images/${base_name}.txt" ]; then
        mv "coco_converted/labels/images/${base_name}.txt" "coco_converted/train/labels/"
    fi
    
    # labels/annotations 内の対応するファイルがあればコピー
    if [ -f "coco_converted/labels/annotations/${base_name}.txt" ]; then
        cp "coco_converted/labels/annotations/${base_name}.txt" "coco_converted/train/labels/"
    fi
done

# Val用の処理
tail -n "$val_count" shuffled_images.txt | while read -r image_file; do
    # 画像ファイルを移動
    mv "coco_converted/images/$image_file" "coco_converted/val/images/"
    
    # 画像に対応するラベルファイルを処理
    base_name="${image_file%.*}"
    
    # labels/images 内の対応するファイルがあれば移動
    if [ -f "coco_converted/labels/images/${base_name}.txt" ]; then
        mv "coco_converted/labels/images/${base_name}.txt" "coco_converted/val/labels/"
    fi
    
    # labels/annotations 内の対応するファイルがあればコピー
    if [ -f "coco_converted/labels/annotations/${base_name}.txt" ]; then
        cp "coco_converted/labels/annotations/${base_name}.txt" "coco_converted/val/labels/"
    fi
done

colored_echo "Train/Val distribution completed."
