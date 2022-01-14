#!/bin/bash

TAG_LIST=$(awk '/^ENV DEBIANTOMCAT_VERSION/ {print $3;}' Dockerfile)
IMAGE_NAME=$(awk '/^ENV DEBIANTOMCAT_IMAGE/ {print $3;}' Dockerfile)

REPO_SERV=docker.io/georgesan/

for i in $TAG_LIST
do
    echo $SUDO_DOCKER docker tag ${IMAGE_NAME}:$i ${REPO_SERV}${IMAGE_NAME}:$i
    $SUDO_DOCKER docker tag ${IMAGE_NAME}:$i ${REPO_SERV}${IMAGE_NAME}:$i
    echo $SUDO_DOCKER docker push ${REPO_SERV}${IMAGE_NAME}:$i
    $SUDO_DOCKER docker push ${REPO_SERV}${IMAGE_NAME}:$i
done

