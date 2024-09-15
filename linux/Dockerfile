FROM rockylinux:9

RUN set -eux \
    # 更新系统包并升级所有已安装的包
    && dnf update -y \
    && dnf upgrade --refresh -y \
    # 安装必要的工具和仓库
    && dnf install -y \
        'dnf-command(config-manager)' \
        epel-release \
        https://rpms.remirepo.net/enterprise/remi-release-9.rpm \
        unzip \
        wget \
        tzdata \
        vim \
        git \
        tar \
        gzip \
    # 启用 CRB (CodeReady Builder) 仓库
    && dnf config-manager --set-enabled crb \
    # 设置时区为上海
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    # 清理 DNF 缓存和临时文件
    && dnf clean all \
    && rm -rf /tmp/* /var/tmp/*