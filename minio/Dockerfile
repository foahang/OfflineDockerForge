FROM linux:9

# 复制 MinIO 二进制文件到容器中
COPY minio /usr/local/bin/minio

# 设置可执行权限
RUN chmod +x /usr/local/bin/minio

# 创建数据目录
RUN mkdir -p /data

# 设置工作目录
WORKDIR /data

# 暴露 /data 目录
VOLUME ["/data"]

# 暴露 MinIO 默认端口
EXPOSE 9000 9001

# 设置环境变量
ENV MINIO_ROOT_USER=${MINIO_ROOT_USER:-minioadmin}
ENV MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD:-minioadmin}

# 设置启动命令
CMD ["minio", "server", "/data", "--console-address", ":9001"]
