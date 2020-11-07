FROM debian:buster

ENV DEBIANTOMCAT_VERSION build-target-2
ENV DEBIANTOMCAT_VERSION debian10-adoptopenjdk15-tomcat9
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

# install Java
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
    apt update && \
    apt install -y adoptopenjdk-15-hotspot
ENV JAVA_HOME $( update-alternatives --list java | head -n 1 | sed -e 's%/bin/java$%%g' )

# install Tomcat
RUN apt install -y tomcat9

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

