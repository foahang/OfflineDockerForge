# 使用基础镜像
FROM linux:9

# 安装编译所需的依赖
RUN set -eux \
    && dnf update -y \
    && dnf install -y \
        gcc \
        gcc-c++ \
        make \
        autoconf \
        automake \
        libtool \
        pkgconfig \
        cmake \
        bison \
        flex \
        gdb \
        libatomic \
    && dnf clean all \
    && rm -rf /tmp/* /var/tmp/*

# 设置工作目录
WORKDIR /src