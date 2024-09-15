# 使用编译基础镜像
FROM linux-compile:9 AS builder

# 定义Redis版本和RedisBloom版本
ARG REDIS_VERSION=6.2.14
ARG REDISBLOOM_VERSION=2.2.18

# 复制本地源码文件到镜像中
COPY redis-${REDIS_VERSION}.tar.gz /tmp/
COPY RedisBloom-${REDISBLOOM_VERSION}.tar.gz /tmp/redisbloom.tar.gz

# 编译Redis和RedisBloom
RUN set -eux \
    && cd /tmp \
    && tar -xzf redis-${REDIS_VERSION}.tar.gz \
    && cd redis-${REDIS_VERSION} \
    && make \
    && make install \
    && cd /tmp \
    && tar -xzf redisbloom.tar.gz \
    && cd RedisBloom-${REDISBLOOM_VERSION} \
    && make \
    && mkdir -p /usr/local/lib \
    && cp redisbloom.so /usr/local/lib/redisbloom.so \
    && rm -rf /tmp/*

# 第二层：最终镜像
FROM linux:9

# 设置默认的Redis密码环境变量
ENV REDIS_PASSWORD=defaultpassword

# 从builder阶段复制编译好的文件
COPY --from=builder /usr/local/bin/redis* /usr/local/bin/
COPY --from=builder /usr/local/lib/redisbloom.so /usr/local/lib/

# 创建配置文件并执行必要的清理
RUN set -eux \
    && mkdir -p /etc/redis \
    && echo "loadmodule /usr/local/lib/redisbloom.so" > /etc/redis/redis.conf \
    && echo "requirepass ${REDIS_PASSWORD}" >> /etc/redis/redis.conf \
    && echo "protected-mode yes" >> /etc/redis/redis.conf \
    && echo "bind 127.0.0.1" >> /etc/redis/redis.conf \
    && dnf clean all \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/cache/dnf/*

# 暴露Redis端口
EXPOSE 6379

# 设置启动命令
CMD ["redis-server", "/etc/redis/redis.conf"]