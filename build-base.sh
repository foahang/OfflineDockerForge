#!/bin/bash

# 定义基础镜像列表
declare -a BASE_IMAGES=(
    "linux linux:9"
    "linux-compile linux-compile:9"
)

# 保存当前目录
current_dir=$(pwd)

# 遍历基础镜像列表
for image_info in "${BASE_IMAGES[@]}"; do
    # 分割目录名和镜像名:标签
    read -r dir image_tag <<< "$image_info"
    
    # 检查目录中是否存在 Dockerfile
    if [ -f "$dir/Dockerfile" ]; then
        echo "Building base image for $dir: $image_tag"
        
        # 进入镜像目录
        cd "$dir" || exit 1
        
        # 构建镜像
        docker build -t "$image_tag" .
        
        # 检查构建是否成功
        if [ $? -eq 0 ]; then
            echo "Successfully built $image_tag"
        else
            echo "Failed to build $image_tag"
            cd "$current_dir"
            exit 1  # 如果构建失败，退出脚本
        fi
        
        # 返回原目录
        cd "$current_dir" || exit 1
        
        echo "------------------------"
    else
        echo "Dockerfile not found in $dir, skipping..."
    fi
done

echo "All base image builds completed."
