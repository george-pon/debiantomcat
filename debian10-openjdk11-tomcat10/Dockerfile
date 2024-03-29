FROM debian:buster

ENV DEBIANTOMCAT_VERSION build-target-5
ENV DEBIANTOMCAT_VERSION debian10-openjdk11-tomcat10
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
        openjdk-11-jdk \
        tcpdump \
        traceroute \
        tree \
        unzip \
        zip \
    && apt clean all

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

