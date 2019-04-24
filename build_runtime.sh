#!/bin/bash

[ $# -lt 3 ] && { echo "Usage: $0 base_image image_version dcore_version [image_tag] [packages_dir]"; exit 1; }

BASE_IMAGE=$1
IMAGE_VERSION=$2
DCORE_VERSION=$3

if [ $# -lt 4 ]; then IMAGE_TAG=$DCORE_VERSION; else IMAGE_TAG=$4; fi

if [ $# -lt 5 ]; then PACKAGES_DIR="$PWD/packages/$BASE_IMAGE/$IMAGE_VERSION"; else PACKAGES_DIR=$5; fi

IMAGE_NAME="dcore.$BASE_IMAGE:$IMAGE_TAG"
docker build -t $IMAGE_NAME -f $BASE_IMAGE/Dockerfile \
    --build-arg IMAGE_VERSION=$IMAGE_VERSION \
    --build-arg DCORE_VERSION=$DCORE_VERSION \
    $PACKAGES_DIR
