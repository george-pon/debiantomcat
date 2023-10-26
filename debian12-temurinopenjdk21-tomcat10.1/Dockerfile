FROM debian:12

ENV DEBIANTOMCAT_VERSION build-target-11
ENV DEBIANTOMCAT_VERSION debian12-temurinopenjdk21-tomcat10.1
ENV DEBIANTOMCAT_IMAGE georgesan/debiantomcat

ENV DEBIAN_FRONTEND noninteractive

# set locale
RUN apt update --allow-releaseinfo-change && apt upgrade -y && \
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
    netcat-openbsd \
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
# RUN apt install -y openjdk-17-jdk && apt clean all

# install Java from tar.gz
# see https://adoptium.net/releases.html
# https://github.com/adoptium
# https://github.com/adoptium/temurin18-binaries/releases
# https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_aarch64_linux_hotspot_18.0.2.1_1.tar.gz
# https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_x64_linux_hotspot_18.0.2.1_1.tar.gz
# https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_x64_linux_hotspot_19_36.tar.gz
# https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_aarch64_linux_hotspot_19_36.tar.gz
# https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_x64_linux_hotspot_19.0.1_10.tar.gz
# https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_aarch64_linux_hotspot_19.0.1_10.tar.gz
# https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz
# https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_aarch64_linux_hotspot_19.0.2_7.tar.gz
# https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20%2B36/OpenJDK20U-jdk_aarch64_linux_hotspot_20_36.tar.gz
# https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20%2B36/OpenJDK20U-jdk_x64_linux_hotspot_20_36.tar.gz
# https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.1%2B9/OpenJDK20U-jdk_aarch64_linux_hotspot_20.0.1_9.tar.gz
# https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.1%2B9/OpenJDK20U-jdk_x64_linux_hotspot_20.0.1_9.tar.gz
# https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.2%2B9/OpenJDK20U-jdk_x64_linux_hotspot_20.0.2_9.tar.gz
# https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.2%2B9/OpenJDK20U-jdk_aarch64_linux_hotspot_20.0.2_9.tar.gz
# https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21%2B35/OpenJDK21U-jdk_aarch64_linux_hotspot_21_35.tar.gz
# https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21%2B35/OpenJDK21U-jdk_x64_linux_hotspot_21_35.tar.gz
# https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.1%2B12/OpenJDK21U-debugimage_aarch64_linux_hotspot_21.0.1_12.tar.gz
# https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.1%2B12/OpenJDK21U-debugimage_x64_linux_hotspot_21.0.1_12.tar.gz
ENV OPENJDK_VER_MAJOR 21
ENV OPENJDK_VER_NAME 21.0.1_12
ENV OPENJDK_VER_ESCAPED 21.0.1%2B12
ENV OPENJDK_VER_DIRNAME jdk-21.0.1+12
ENV OPENJDK_VER_DIRNAME2 jdk-21.0.1-12
ENV JAVA_HOME /opt/jvm/${OPENJDK_VER_DIRNAME2}
RUN if [ x"$(uname -m)"x = x"x86_64"x ] ; then \
    export OPENJDK_FILENAME=OpenJDK${OPENJDK_VER_MAJOR}U-jdk_x64_linux_hotspot_${OPENJDK_VER_NAME} && \
    echo "getting https://github.com/adoptium/temurin${OPENJDK_VER_MAJOR}-binaries/releases/download/jdk-${OPENJDK_VER_ESCAPED}/${OPENJDK_FILENAME}.tar.gz " && \
    curl -fLO https://github.com/adoptium/temurin${OPENJDK_VER_MAJOR}-binaries/releases/download/jdk-${OPENJDK_VER_ESCAPED}/${OPENJDK_FILENAME}.tar.gz && \
    mkdir -p /opt/jvm && \
    tar xzf ${OPENJDK_FILENAME}.tar.gz -C /opt/jvm && \
    mv /opt/jvm/${OPENJDK_VER_DIRNAME} /opt/jvm/${OPENJDK_VER_DIRNAME2} && \
    /bin/echo '#!/bin/bash' >> /etc/profile.d/javapath.sh && \
    /bin/echo "export PATH=/opt/jvm/${OPENJDK_VER_DIRNAME2}/bin:"'$PATH' >> /etc/profile.d/javapath.sh ; \
    rm ${OPENJDK_FILENAME}.tar.gz ; \
    fi
RUN if [ x"$(uname -m)"x = x"aarch64"x ] ; then \
    export OPENJDK_FILENAME=OpenJDK${OPENJDK_VER_MAJOR}U-jdk_aarch64_linux_hotspot_${OPENJDK_VER_NAME} && \
    echo "https://github.com/adoptium/temurin${OPENJDK_VER_MAJOR}-binaries/releases/download/jdk-${OPENJDK_VER_ESCAPED}/${OPENJDK_FILENAME}.tar.gz" && \
    curl -fLO https://github.com/adoptium/temurin${OPENJDK_VER_MAJOR}-binaries/releases/download/jdk-${OPENJDK_VER_ESCAPED}/${OPENJDK_FILENAME}.tar.gz && \
    mkdir -p /opt/jvm && \
    tar xzf ${OPENJDK_FILENAME}.tar.gz -C /opt/jvm && \
    mv /opt/jvm/${OPENJDK_VER_DIRNAME} /opt/jvm/${OPENJDK_VER_DIRNAME2} && \
    /bin/echo '#!/bin/bash' >> /etc/profile.d/javapath.sh && \
    /bin/echo "export PATH=/opt/jvm/${OPENJDK_VER_DIRNAME2}/bin:"'$PATH' >> /etc/profile.d/javapath.sh ; \
    rm ${OPENJDK_FILENAME}.tar.gz ; \
    fi
ENV PATH /opt/jvm/${OPENJDK_VER_DIRNAME2}/bin:$PATH

# https://tomcat.apache.org/
# install Tomcat (remove host-manager and manager)
ENV TOMCAT_VERSION 10.1.15
RUN groupadd -g 995 tomcat && \
    useradd -m -u 995 -g 995 -d /opt/tomcat10 -s /bin/false tomcat && \
    curl -LO https://ftp.jaist.ac.jp/pub/apache/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar xpvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat10 --strip-components=1 && \
    chown -R tomcat:tomcat /opt/tomcat10/ && \
    chmod -R u+x /opt/tomcat10/bin && \
    rm -rf /opt/tomcat10/webapps/docs && \
    rm -rf /opt/tomcat10/webapps/examples && \
    rm -rf /opt/tomcat10/webapps/host-manager && \
    rm -rf /opt/tomcat10/webapps/manager && \
    rm -f apache-tomcat-${TOMCAT_VERSION}.tar.gz

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

