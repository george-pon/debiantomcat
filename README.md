# debiantomcat

debian10 + openjdk11 + tomcat9 for linux/arm/v7 (raspberry pi 4 32bit) and linux/aarch64 (raspberry pi 4 64bit) and linux/amd64 (x86-64 64bit)

### Dockerfile

* https://github.com/george-pon/debiantomcat

### tags

* debian10-adoptopenjdk17-tomcat10
* debian10-openjdk11-tomcat9, latest

### arch

* linux/amd64 ( x86-64 )
* linux/arm64 ( Raspberry Pi 4 + Ubuntu 20.04 arm 64bit )
* linux/arm/v7 ( Raspberry Pi 4 + RaspBian OS arm 32bit )

### how to build

docker buildx build -t latest --platform=linux/amd64,linux/arm64,linux/arm/v7 --push .

see build-image.sh

