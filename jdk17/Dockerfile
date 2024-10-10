# 使用基础镜像
FROM linux:9

# 定义变量
ARG JAVA_VERSION=17.0.12_7
ARG JAVA_TAR=OpenJDK17U-jdk_x64_linux_hotspot_${JAVA_VERSION}.tar.gz
ARG JAVA_HOME=/opt/java/openjdk

# 复制 JDK 压缩包到镜像中，解压，设置环境变量，并清理
COPY ${JAVA_TAR} /tmp/
RUN set -eux \
    # 创建目录并解压 JDK
    && mkdir -p ${JAVA_HOME} \
    && tar -xzf /tmp/${JAVA_TAR} -C ${JAVA_HOME} --strip-components=1 \
    # 清理
    && rm -rf /tmp/${JAVA_TAR} \
    && rm -rf /tmp/* /var/tmp/* \
    # 设置环境变量
    && echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile.d/java.sh \
    && echo "export PATH=${JAVA_HOME}/bin:\$PATH" >> /etc/profile.d/java.sh

ENV LANG=C.UTF-8 \
    JAVA_HOME=${JAVA_HOME} \
    PATH=${JAVA_HOME}/bin:$PATH