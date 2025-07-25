#!/bin/bash
#
#
#  compile test
#    env no_cache=true USE_BUILDX=no bash build-image.sh
#

function car() {
    echo $1
}

function cdr() {
    shift
    echo "$@"
}

function env_search() {
    if [ $# -eq 0 ]; then
        echo "NOT_FOUND"
    fi
    arg_name=$1
    cat Dockerfile | sed -e 's%ENV '"$arg_name"'=%ENV '"$arg_name"' %g' | awk '/^ENV '"$arg_name"'[ ]/ {print $3;}'
}

function f_docker_build() {
    TAG_LIST=$( env_search DEBIANTOMCAT_VERSION )
    IMAGE_NAME=${IMAGE_PREFIX}$( env_search DEBIANTOMCAT_IMAGE )
    # TAG_LIST="$TAG_LIST monthly$(date +%Y%m) "
    TAG_CAR=$(car $TAG_LIST)
    TAG_CDR=$(cdr $TAG_LIST)
    echo IMAGE_PREFIX is $IMAGE_PREFIX
    echo TAG_CAR is $TAG_CDR
    echo TAG_CDR is $TAG_CDR
    local MACHINE=$( uname -m )
    echo MACHINE is $MACHINE

    if [ ! -z "$HTTP_PROXY" ]; then
        BUILD_OPT="$BUILD_OPT  --build-arg HTTP_PROXY=$HTTP_PROXY"
    fi
    if [ ! -z "$HTTPS_PROXY" ]; then
        BUILD_OPT="$BUILD_OPT  --build-arg HTTPS_PROXY=$HTTPS_PROXY"
    fi
    if [ ! -z "$http_proxy" ]; then
        BUILD_OPT="$BUILD_OPT  --build-arg http_proxy=$http_proxy"
    fi
    if [ ! -z "$https_proxy" ]; then
        BUILD_OPT="$BUILD_OPT  --build-arg https_proxy=$https_proxy"
    fi
    if [ ! -z "$NO_PROXY" ]; then
        BUILD_OPT="$BUILD_OPT  --build-arg NO_PROXY=$NO_PROXY"
    fi
    if [ ! -z "$no_proxy" ]; then
        BUILD_OPT="$BUILD_OPT  --build-arg no_proxy=$no_proxy"
    fi

    if [ ! -z "$no_cache" ]; then
        BUILD_OPT="$BUILD_OPT  --no-cache=$no_cache"
    fi
    #BUILD_OPT="$BUILD_OPT  --no-cache=true"
    BUILD_OPT="$BUILD_OPT  --progress=plain"

    # check use buildx
    if [ x"$USE_BUILDX"x = x""x ] ; then
        if docker buildx ls 1>/dev/null 2>/dev/null ; then
            if docker buildx ls 2>/dev/null | grep linux/arm64 ; then
                if docker buildx ls 2>/dev/null | grep linux/amd64 ; then
                    USE_BUILDX=yes
                fi
            fi
        fi
    fi
    echo USE_BUILDX is $USE_BUILDX

    if [ x"$USE_BUILDX"x = x"yes"x ]; then
        # docker buildx is available
        PLATOPT=
        MACHINE=$( uname -m )
        case $MACHINE in
            x86_64) PLATOPT='--platform=linux/amd64' ;;
            armv7l) PLATOPT='--platform=linux/arm/v7' ;;
            aarch64) PLATOPT='--platform=linux/amd64,linux/arm64' ;;
        esac
        DOCKER_TAG_OPT=""
        for TAG_CAR in $TAG_LIST
        do
            DOCKER_TAG_OPT="${DOCKER_TAG_OPT} -t ${IMAGE_NAME}:${TAG_CAR}"
        done
        export DOCKER_BUILDKIT=1
        echo $SUDO_DOCKER docker buildx build $BUILD_OPT ${DOCKER_TAG_OPT} $PLATOPT --push  .
        $SUDO_DOCKER docker buildx build $BUILD_OPT ${DOCKER_TAG_OPT} $PLATOPT --push  .
        RC=$?
        if [ $RC -ne 0 ]; then
            echo "ERROR: docker build failed."
            return 1
        fi
        echo "sleeping 15 seconds."
        sleep 15
        docker buildx imagetools inspect ${IMAGE_NAME}:${TAG_CAR}
        RC=$?
        if [ $RC -ne 0 ]; then
            echo "ERROR: docker build failed."
            return 1
        fi
        echo "sleeping 15 seconds."
        sleep 15
    else
        export DOCKER_BUILDKIT=1
        echo $SUDO_DOCKER docker build $BUILD_OPT -t ${IMAGE_NAME}:${TAG_CAR} .
        $SUDO_DOCKER docker build $BUILD_OPT -t ${IMAGE_NAME}:${TAG_CAR} .
        RC=$?
        if [ $RC -ne 0 ]; then
            echo "ERROR: docker build failed."
            return 1
        fi
        for i in $TAG_CDR
        do
            echo docker tag ${IMAGE_NAME}:$TAG_CAR ${IMAGE_NAME}:$i
            $SUDO_DOCKER docker tag ${IMAGE_NAME}:$TAG_CAR ${IMAGE_NAME}:$i
        done
    fi

    return 0
}

f_docker_build
