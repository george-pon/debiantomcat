#!/bin/bash
#
# test run image
#
function docker-push-debiantomcat() {
    docker tag debiantomcat:latest georgesan/debiantomcat:latest
    docker push georgesan/debiantomcat:latest
    docker tag debiantomcat:latest georgesan/debiantomcat:debian10-openjdk11-tomcat9
    docker push georgesan/debiantomcat:debian10-openjdk11-tomcat9
}
docker-push-debiantomcat
