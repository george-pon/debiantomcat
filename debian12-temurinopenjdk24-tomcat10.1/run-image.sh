#!/bin/bash
#
# test run image
#

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

#         -p 8180:8080 \

for i in $TAG_LIST
do
    ${WINPTY_CMD} docker run -i -t --rm \
        -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
        ${IMAGE_NAME}:${i}
    break
done
