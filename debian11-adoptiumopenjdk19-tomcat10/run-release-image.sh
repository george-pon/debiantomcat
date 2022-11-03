#!/bin/bash
#
# test run image
#
docker pull docker.io/georgesan/debiantomcat:debian11-adoptiumopenjdk18-tomcat10
${WINPTY_CMD} docker run -i -t --rm \
    -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
    docker.io/georgesan/debiantomcat:debian11-adoptiumopenjdk19-tomcat10