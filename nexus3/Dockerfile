FROM jdk:17

ARG NEXUS_VERSION=3.72.0-04

# 配置Nexus运行时环境
ENV SONATYPE_DIR=/opt/sonatype
ENV NEXUS_HOME=${SONATYPE_DIR}/nexus \
    NEXUS_DATA=/nexus-data \
    NEXUS_CONTEXT='' \
    SONATYPE_WORK=${SONATYPE_DIR}/sonatype-work

RUN groupadd --gid 200 -r nexus \
    && useradd --uid 200 -r nexus -g nexus -s /bin/false -d /opt/sonatype/nexus -c 'Nexus Repository Manager user'

WORKDIR ${SONATYPE_DIR}

# 复制并设置Nexus
COPY nexus-${NEXUS_VERSION}-unix.tar.gz .
RUN tar -xvf nexus-${NEXUS_VERSION}-unix.tar.gz \
    && rm -f nexus-${NEXUS_VERSION}-unix.tar.gz \
    && mv nexus-${NEXUS_VERSION} $NEXUS_HOME \
    && mkdir -p ${SONATYPE_WORK} \
    && chown -R nexus:nexus ${SONATYPE_WORK} \
    && mkdir -p ${NEXUS_DATA} \
    && chown -R nexus:nexus ${NEXUS_DATA} \
    && ln -s ${NEXUS_DATA} ${SONATYPE_WORK}/nexus3

# 从nexus.vmoptions中移除Java内存设置，因为现在我们使用INSTALL4J_ADD_VM_PARAMS
RUN sed -i '/^-Xms/d;/^-Xmx/d;/^-XX:MaxDirectMemorySize/d' $NEXUS_HOME/bin/nexus.vmoptions

RUN echo "#!/bin/bash" >> ${SONATYPE_DIR}/start-nexus-repository-manager.sh \
   && echo "cd /opt/sonatype/nexus" >> ${SONATYPE_DIR}/start-nexus-repository-manager.sh \
   && echo "exec ./bin/nexus run" >> ${SONATYPE_DIR}/start-nexus-repository-manager.sh \
   && chmod a+x ${SONATYPE_DIR}/start-nexus-repository-manager.sh \
   && sed -e '/^nexus-context/ s:$:${NEXUS_CONTEXT}:' -i ${NEXUS_HOME}/etc/nexus-default.properties

# 修改INSTALL4J_JAVA_HOME_OVERRIDE的值
RUN sed -i 's|^# INSTALL4J_JAVA_HOME_OVERRIDE=.*|INSTALL4J_JAVA_HOME_OVERRIDE=/opt/java/openjdk|' ${NEXUS_HOME}/bin/nexus

VOLUME ${NEXUS_DATA}

EXPOSE 8081
USER nexus

ENV INSTALL4J_ADD_VM_PARAMS="-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs"

CMD ["/opt/sonatype/nexus/bin/nexus", "run"]