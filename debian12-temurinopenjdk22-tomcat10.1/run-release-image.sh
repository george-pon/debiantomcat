#!/bin/bash
#
# test run image
#
docker pull docker.io/georgesan/debiantomcat:debian12-temurinopenjdk22-tomcat10.1
${WINPTY_CMD} docker run -i -t --rm \
    -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
    docker.io/georgesan/debiantomcat:debian12-temurinopenjdk22-tomcat10.1
