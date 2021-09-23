FROM debian:buster

ENV DEBIANTOMCAT_VERSION build-target-4
ENV DEBIANTOMCAT_VERSION debian10-adoptopenjdk17-tomcat10
ENV DEBIANTOMCAT_IMAGE georgesan/debiantomcat

ENV DEBIAN_FRONTEND noninteractive

# set locale
RUN apt update && apt upgrade -y && \
    apt install -y locales  apt-transport-https  ca-certificates  software-properties-common && \
    localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8 && \
    apt clean all
ENV LANG ja_JP.utf8

# set timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ENV TZ Asia/Tokyo

# install etc utils
RUN apt install -y \
        curl \
        wget \
        dnsutils \
        iproute2 \
        gnupg2 \
        jq \
        lsof \
        netcat \
        net-tools \
        procps \
        rsync \
        sudo \
        tcpdump \
        traceroute \
        tree \
        unzip \
        zip \
    && apt clean all

# install Java from debian package
# RUN apt-get install wget apt-transport-https gnupg && \
#     wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
#     CODENAME=$( cat /etc/os-release | grep VERSION_CODENAME | cut -d = -f 2 ) && \
#     echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb ${CODENAME} main" | tee /etc/apt/sources.list.d/adoptopenjdk.list && \
#     apt-get update && \
#     apt-cache search adoptopenjdk && \
#     apt-get install -y adoptopenjdk-17-hotspot
# RUN ln -sf $( update-alternatives --list java | head -n 1 | sed -e s%/bin/java$%%g )  /opt/jvm
# ENV JAVA_HOME /opt/jvm

# install Java from tar.gz x86-64 only
RUN if [ x"$(uname -m)"x = x"x86_64"x ] ; then \
    export OPENJDK_FILENAME=OpenJDK17-jdk_x64_linux_hotspot_17_35 && \
    curl -LO https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/${OPENJDK_FILENAME}.tar.gz && \
    mkdir -p /opt/jvm && \
    tar xzf ${OPENJDK_FILENAME}.tar.gz -C /opt/jvm && \
    mv /opt/jvm/jdk-17+35 /opt/jvm/jdk-17-35 && \
    /bin/echo '#!/bin/bash' >> /etc/profile.d/javapath.sh && \
    /bin/echo 'export PATH=/opt/jvm/jdk-17-35/bin:$PATH' >> /etc/profile.d/javapath.sh ; \
    fi
RUN if [ x"$(uname -m)"x = x"aarch64"x ] ; then \
    export OPENJDK_FILENAME=OpenJDK17-jdk_aarch64_linux_hotspot_17_35 && \
    curl -LO https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/${OPENJDK_FILENAME}.tar.gz && \
    mkdir -p /opt/jvm && \
    tar xzf ${OPENJDK_FILENAME}.tar.gz -C /opt/jvm && \
    mv /opt/jvm/jdk-17+35 /opt/jvm/jdk-17-35 && \
    /bin/echo '#!/bin/bash' >> /etc/profile.d/javapath.sh && \
    /bin/echo 'export PATH=/opt/jvm/jdk-17-35/bin:$PATH' >> /etc/profile.d/javapath.sh ; \
    fi
RUN if [ x"$(uname -m)"x = x"armv7l"x ] ; then \
    export OPENJDK_FILENAME=OpenJDK17-jdk_aarch64_linux_hotspot_17_35 && \
    curl -LO https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/${OPENJDK_FILENAME}.tar.gz && \
    mkdir -p /opt/jvm && \
    tar xzf ${OPENJDK_FILENAME}.tar.gz -C /opt/jvm && \
    mv /opt/jvm/jdk-17+35 /opt/jvm/jdk-17-35 && \
    /bin/echo '#!/bin/bash' >> /etc/profile.d/javapath.sh && \
    /bin/echo 'export PATH=/opt/jvm/jdk-17-35/bin:$PATH' >> /etc/profile.d/javapath.sh ; \
    fi
ENV PATH /opt/jvm/jdk-17-35/bin:$PATH

# install Tomcat (remove host-manager and manager)
ENV TOMCAT_VERSION 10.0.11
RUN useradd -m -u 998 -U -d /opt/tomcat10 -s /bin/false tomcat && \
    curl -LO https://ftp.jaist.ac.jp/pub/apache/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar xpvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat10 --strip-components=1 && \
    chown -R tomcat:tomcat /opt/tomcat10/ && \
    chmod -R u+x /opt/tomcat10/bin && \
    rm -rf /opt/tomcat10/webapps/docs && \
    rm -rf /opt/tomcat10/webapps/examples && \
    rm -rf /opt/tomcat10/webapps/host-manager && \
    rm -rf /opt/tomcat10/webapps/manager

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV HOME /home/tomcat

RUN mkdir -p     $HOME
ADD bashrc       $HOME/.bashrc
ADD bash_profile $HOME/.bash_profile
ADD vimrc        $HOME/.vimrc
ADD emacsrc      $HOME/.emacs
ENV ENV $HOME/.bashrc

ADD bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

# add sudo user
# https://qiita.com/iganari/items/1d590e358a029a1776d6 Dockerコンテナ内にsudoユーザを追加する - Qiita
RUN echo 'Defaults visiblepw'            >> /etc/sudoers && \
    echo 'tomcat ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# log to stderr/stdout
RUN cp -p /opt/tomcat10/conf/logging.properties /opt/tomcat10/conf/logging.properties.orig
COPY logging.properties /opt/tomcat10/conf/logging.properties

# log to stderr/stdout
RUN cp -p /opt/tomcat10/conf/server.xml /opt/tomcat10/conf/server.xml.orig
COPY server.xml /opt/tomcat10/conf/server.xml

# use system tomcat
USER tomcat

# CMD ["/usr/local/bin/docker-entrypoint.sh"]

# Tomcat Configuration
ENV CATALINA_HOME /opt/tomcat10
ENV CATALINA_BASE /opt/tomcat10
ENV CATALINA_TMPDIR /tmp
ENV JAVA_OPTS -Djava.awt.headless=true

# Path Info
# ReadWritePaths=/opt/tomcat10/conf/Catalina/
# ReadWritePaths=/var/lib/tomcat10/webapps/
# ReadWritePaths=/var/log/tomcat10/
# RequiresMountsFor=/var/log/tomcat10

CMD ["/opt/tomcat10/bin/catalina.sh", "run"]

EXPOSE 8080

