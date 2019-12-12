FROM debian:buster

ENV DEBIANTOMCAT_VERSION build-target
ENV DEBIANTOMCAT_VERSION latest
ENV DEBIANTOMCAT_VERSION debian10-openjdk11-tomcat9
ENV DEBIANTOMCAT_IMAGE debiantomcat

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
        dnsutils \
        iproute2 \
        jq \
        lsof \
        netcat \
        net-tools \
        rsync \
        sudo \
        openjdk-11-jdk \
        tomcat9 \
        tcpdump \
        traceroute \
        tree \
        unzip \
        zip \
    && apt clean all


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
RUN cp -p /etc/tomcat9/logging.properties /etc/tomcat9/logging.properties.orig
COPY logging.properties /etc/tomcat9/logging.properties

# log to stderr/stdout
RUN cp -p /etc/tomcat9/server.xml /etc/tomcat9/server.xml.orig
COPY server.xml /etc/tomcat9/server.xml

# use system tomcat
USER tomcat

# CMD ["/usr/local/bin/docker-entrypoint.sh"]

# Tomcat Configuration
ENV CATALINA_HOME /usr/share/tomcat9
ENV CATALINA_BASE /var/lib/tomcat9
ENV CATALINA_TMPDIR /tmp
ENV JAVA_OPTS -Djava.awt.headless=true

# Path Info
# ReadWritePaths=/etc/tomcat9/Catalina/
# ReadWritePaths=/var/lib/tomcat9/webapps/
# ReadWritePaths=/var/log/tomcat9/
# RequiresMountsFor=/var/log/tomcat9

CMD ["/usr/libexec/tomcat9/tomcat-start.sh"]

EXPOSE 8080

