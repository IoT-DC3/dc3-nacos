FROM registry.cn-beijing.aliyuncs.com/dc3/buildpack-deps:buster-curl as installer

ARG NACOS_VERSION=2.3.0
ARG HOT_FIX_FLAG=""

ADD distribution/target/nacos-server-${NACOS_VERSION}.tar.gz /home

RUN set -x \
    && rm -rf /home/nacos/bin/* /home/nacos/conf/*.properties /home/nacos/conf/*.example /home/nacos/conf/nacos-mysql.sql

FROM registry.cn-beijing.aliyuncs.com/dc3/openjdk8:jre8u372

# set environment
ENV MODE="cluster" \
    PREFER_HOST_MODE="ip"\
    BASE_DIR="/home/nacos" \
    CLASSPATH=".:/home/nacos/conf:$CLASSPATH" \
    CLUSTER_CONF="/home/nacos/conf/cluster.conf" \
    FUNCTION_MODE="all" \
    NACOS_USER="nacos" \
    JAVA="/opt/java/openjdk/bin/java" \
    JVM_XMS="1g" \
    JVM_XMX="1g" \
    JVM_XMN="512m" \
    JVM_MS="128m" \
    JVM_MMS="320m" \
    NACOS_DEBUG="n" \
    TOMCAT_ACCESSLOG_ENABLED="false" \
    TZ="Asia/Shanghai"

WORKDIR $BASE_DIR

# copy nacos bin
COPY --from=installer ["/home/nacos", "/home/nacos"]

ADD dc3/bin/docker-startup.sh bin/docker-startup.sh
ADD dc3/conf/application.properties conf/application.properties

# set startup log dir
RUN mkdir -p logs \
    && cd logs \
    && touch start.out \
    && ln -sf /dev/stdout start.out \
    && ln -sf /dev/stderr start.out
RUN chmod +x bin/docker-startup.sh

EXPOSE 8848
ENTRYPOINT ["bin/docker-startup.sh"]