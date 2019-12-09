#!/bin/bash
#
# test run image
#
${WINPTY_CMD} docker run -i -t --rm \
    -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -e no_proxy="${no_proxy}" \
    -p 8180:8080 \
    debiantomcat:latest
