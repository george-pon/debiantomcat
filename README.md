# debiantomcat

debian + openjdk11 + tomcat for linux/arm/v7 (raspberry pi 4) and linux/amd64

### Dockerfile

* https://github.com/george-pon/debiantomcat
* https://github.com/george-pon/debiantomcat/blob/master/Dockerfile

### tags

* debian10-adoptopenjdk16-tomcat10

* debian10-adoptopenjdk15-tomcat9

* debian10-openjdk11-tomcat9, latest, monthly202101

### arch

* linux/amd64 ( x86-64 )
* linux/arm64 ( Raspberry Pi 4 + Ubuntu 20.04 arm 64bit )
* linux/arm/v7 ( Raspberry Pi 4 + RaspBian OS arm 32bit )

### how to build

docker buildx build -t latest --platform=linux/amd64,linux/arm64,linux/arm/v7 --push .

see build-image.sh


