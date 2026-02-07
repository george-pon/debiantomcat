#!/bin/bash

function env_search() {
    if [ $# -eq 0 ]; then
        echo "NOT_FOUND"
    fi
    arg_name=$1
    cat Dockerfile | sed -e 's%ENV '"$arg_name"'=%ENV '"$arg_name"' %g' | awk '/^ENV '"$arg_name"'[ ]/ {print $3;}'
}

TAG_LIST=$( env_search DEBIANTOMCAT_VERSION )
IMAGE_NAME=${IMAGE_PREFIX}$( env_search DEBIANTOMCAT_IMAGE )

REPO_SERV=docker.io/

for i in $TAG_LIST
do
    echo $SUDO_DOCKER docker tag ${IMAGE_NAME}:$i ${REPO_SERV}${IMAGE_NAME}:$i
    $SUDO_DOCKER docker tag ${IMAGE_NAME}:$i ${REPO_SERV}${IMAGE_NAME}:$i
    echo $SUDO_DOCKER docker push ${REPO_SERV}${IMAGE_NAME}:$i
    $SUDO_DOCKER docker push ${REPO_SERV}${IMAGE_NAME}:$i
done
