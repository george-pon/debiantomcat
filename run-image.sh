#!/bin/bash
#
# test run image
#
function docker-run-debiantomcat() {
    ${WINPTY_CMD} docker run -i -t --rm \
        -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
        debiantomcat:latest
}
docker-run-debiantomcat
