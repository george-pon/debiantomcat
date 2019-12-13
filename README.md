# debiantomcat

debian + openjdk11 + tomcat for linux/arm/v7 (raspberry pi 4) and linux/amd64

### tags

* latest
* debian10-openjdk11-tomcat9

### how to build

docker buildx build -t latest --platform=linux/amd64,linux/arm/v7 --push .

see build-image.sh


