FROM debian:buster

ENV DEBIANTOMCAT_VERSION build-target
ENV DEBIANTOMCAT_VERSION latest
ENV DEBIANTOMCAT_VERSION stable
ENV DEBIANTOMCAT_IMAGE debiantomcat

ENV DEBIAN_FRONTEND noninteractive

# set locale
RUN apt-get update && \
    apt-get install -y locales  apt-transport-https  ca-certificates  software-properties-common && \
    localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8 && \
    apt-get clean
ENV LANG ja_JP.utf8

# set timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ENV TZ Asia/Tokyo

# install etc utils
RUN apt-get install -y \
        curl \
        dnsutils \
        iproute2 \
        jq \
        lsof \
        netcat \
        net-tools \
        rsync \
        sudo \
        openjdk12 \
        tomcat9 \
        tcpdump \
        traceroute \
        tree \
        unzip \
        zip \
    && apt-get clean all


ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ADD bashrc /root/.bashrc
ADD bash_profile /root/.bash_profile
ADD vimrc /root/.vimrc
ADD emacsrc /root/.emacs
ADD bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

ENV HOME /root
ENV ENV $HOME/.bashrc

# add sudo user
# https://qiita.com/iganari/items/1d590e358a029a1776d6 Dockerコンテナ内にsudoユーザを追加する - Qiita
# ユーザー名 debian
# パスワード hogehoge
RUN groupadd -g 1000 debian && \
    useradd  -g      debian -G sudo -m -s /bin/bash debian && \
    echo 'debian:hogehoge' | chpasswd && \
    echo 'Defaults visiblepw'            >> /etc/sudoers && \
    echo 'debian ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# use normal user debian
# USER debian

CMD ["/usr/local/bin/docker-entrypoint.sh"]

