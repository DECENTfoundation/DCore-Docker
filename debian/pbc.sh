#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 image_version pbc_version [git_revision] [packages_dir]"; exit 1; }

set -e
PBC_VERSION=$2
BASE_IMAGE=debian

if [ $# -lt 3 ]; then GIT_REV=$2; else GIT_REV=$3; fi

if [ $# -lt 4 ]; then PACKAGES_DIR="$PWD/packages"; else PACKAGES_DIR=$4; fi

PACKAGES_PATH=$PACKAGES_DIR/$BASE_IMAGE/$IMAGE_VERSION
mkdir -p $PACKAGES_PATH
docker run -w /root --rm --name $BASE_IMAGE.pbc.$1 \
    --mount type=bind,src=$PACKAGES_PATH,dst=/root/packages \
    --mount type=bind,src=$PWD/$BASE_IMAGE,dst=/root/$BASE_IMAGE,readonly \
    $BASE_IMAGE:$1 $BASE_IMAGE/pbc-build.sh $PBC_VERSION $GIT_REV
