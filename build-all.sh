#!/bin/bash

# 定义镜像列表，格式为：目录名 镜像名:标签
declare -a IMAGE_LIST=(
    "jdk21 jdk:21"
    "redis6 redis:6"
)

# 保存当前目录
current_dir=$(pwd)

# 检查是否提供了目录参数
if [ $# -eq 1 ]; then
    specific_dir="$1"
    echo "Building only for directory: $specific_dir"
fi

# 遍历镜像列表
for image_info in "${IMAGE_LIST[@]}"; do
    # 分割目录名和镜像名:标签
    read -r dir image_tag <<< "$image_info"
    
    # 如果指定了特定目录，跳过其他目录
    if [ -n "$specific_dir" ] && [ "$dir" != "$specific_dir" ]; then
        continue
    fi
    
    # 检查目录中是否存在 Dockerfile
    if [ -f "$dir/Dockerfile" ]; then
        echo "Building image for $dir: $image_tag"
        
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

if [ -n "$specific_dir" ]; then
    echo "Build for $specific_dir completed."
else
    echo "All builds completed successfully."
fi
