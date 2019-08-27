#!/bin/bash

[ $# -lt 3 ] && { echo "Usage: $0 base_image image_version dcore_version [git_revision] [build_type] [packages_dir] [build_script]"; exit 1; }

set -e
BASE_IMAGE=$1
IMAGE_VERSION=$2
DCORE_VERSION=$3

if [ $# -lt 4 ]; then GIT_REV=$DCORE_VERSION; else GIT_REV=$4; fi

if [ $# -lt 5 ]; then BUILD_TYPE="Release"; else BUILD_TYPE=$5; fi

if [ $# -lt 6 ]; then PACKAGES_DIR="$PWD/packages"; else PACKAGES_DIR=$6; fi

if [ $# -lt 7 ]; then BUILD_SCRIPT="build.sh"; else BUILD_SCRIPT=$7; fi

IMAGE_NAME=dcore.$BASE_IMAGE.build:$IMAGE_VERSION
IMAGE_HASH=`docker images -q $IMAGE_NAME`
if [ -z $IMAGE_HASH ]; then
    echo "Building $IMAGE_NAME"
    docker build -t $IMAGE_NAME -f $BASE_IMAGE/Dockerfile.build --pull --build-arg IMAGE_VERSION=$IMAGE_VERSION $BASE_IMAGE
else
    echo "Using existing $IMAGE_NAME image $IMAGE_HASH"
fi

PACKAGES_PATH=$PACKAGES_DIR/$BASE_IMAGE/$IMAGE_VERSION
mkdir -p $PACKAGES_PATH
docker run -w /root --rm --name $BASE_IMAGE.build.$IMAGE_VERSION \
    --mount type=bind,src=$PACKAGES_PATH,dst=/root/packages \
    --mount type=bind,src=$PWD/$BASE_IMAGE,dst=/root/$BASE_IMAGE,readonly \
    $IMAGE_NAME $BASE_IMAGE/$BUILD_SCRIPT $DCORE_VERSION $GIT_REV $BUILD_TYPE
