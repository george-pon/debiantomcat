#!/bin/bash
#
# test run image
#

TAG_LIST=$(awk '/^ENV DEBIANTOMCAT_VERSION/ {print $3;}' Dockerfile)
IMAGE_NAME=$(awk '/^ENV DEBIANTOMCAT_IMAGE/ {print $3;}' Dockerfile)

REPO_SERV=docker.io/

for i in $TAG_LIST
do
    ${WINPTY_CMD} docker run -i -t --rm \
        -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
        -p 8180:8080 \
        ${IMAGE_NAME}:${i}
    break
done
