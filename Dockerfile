FROM openjdk:8-jdk-slim

ENV HADOOP_VERSION 3.2
ENV SPARK_VERSION 3.1.1
ENV TAR_FILE spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
ENV SPARK_HOME /opt/spark
ENV PATH "${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin"

# Instala Python/WGET e Symlink python3
RUN apt update; \
    apt install -y python3 \
    python3-pip \
    wget; \
    ln -sL $(which python3) /usr/bin/python;\
    mkdir -p ${SPARK_HOME}

# Baixa Spark+Hadoop
RUN wget -nv https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${TAR_FILE}

# Untar e symlink
RUN tar -xzvf ${TAR_FILE} --strip-components=1 -C ${SPARK_HOME}; \
    rm /${TAR_FILE}; \
    apt remove -y wget

COPY config/log4j.properties $SPARK_HOME/conf/log4j.properties

WORKDIR ${SPARK_HOME}
