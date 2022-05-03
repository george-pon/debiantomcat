# debiantomcat

debian11 + adoptium openjdk18 + tomcat10

### Dockerfile

* https://github.com/george-pon/debiantomcat

### tags

* debian11-adoptiumopenjdk18-tomcat10

### arch

* linux/amd64 ( x86-64 )
* linux/arm64 ( Raspberry Pi 4 + Ubuntu 20.04 arm 64bit )

### how to build

docker buildx build -t latest --platform=linux/amd64,linux/arm64 --push .

see build-image.sh

