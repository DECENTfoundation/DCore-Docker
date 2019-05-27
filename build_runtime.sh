#!/bin/bash

[ $# -lt 3 ] && { echo "Usage: $0 base_image image_version dcore_version [image_tag] [packages_dir]"; exit 1; }

set -e
BASE_IMAGE=$1
IMAGE_VERSION=$2
DCORE_VERSION=$3

if [ $# -lt 4 ]; then IMAGE_TAG=$DCORE_VERSION; else IMAGE_TAG=$4; fi

if [ $# -lt 5 ]; then PACKAGES_DIR="$PWD/packages"; else PACKAGES_DIR=$5; fi

PACKAGES_PATH=$PACKAGES_DIR/$BASE_IMAGE/$IMAGE_VERSION
$BASE_IMAGE/build_runtime.sh dcore.$BASE_IMAGE:$IMAGE_TAG $IMAGE_VERSION $DCORE_VERSION $PACKAGES_PATH
