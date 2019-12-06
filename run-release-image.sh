#!/bin/bash
#
# test run image
#
function docker-run-debiantomcat() {
    docker pull registry.gitlab.com/george-pon/debiantomcat:latest
    ${WINPTY_CMD} docker run -i -t --rm \
        -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
        registry.gitlab.com/george-pon/debiantomcat:latest
}
docker-run-debiantomcat
