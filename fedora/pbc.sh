#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 image_version pbc_version [git_revision] [packages_dir]"; exit 1; }

PBC_VERSION=$2
BASE_IMAGE=fedora

if [ $# -lt 3 ]; then GIT_REV=$2; else GIT_REV=$3; fi

if [ $# -lt 4 ]; then PACKAGES_DIR="$PWD/packages/$BASE_IMAGE/$IMAGE_VERSION"; else PACKAGES_DIR=$4; fi

mkdir -p $PACKAGES_DIR
docker run -w /root --rm --name $BASE_IMAGE.pbc.$1 \
    --mount type=bind,src=$PACKAGES_DIR,dst=/root/rpmbuild/RPMS/x86_64 \
    --mount type=bind,src=$PWD/$BASE_IMAGE,dst=/root/$BASE_IMAGE,readonly \
    $BASE_IMAGE:$1 $BASE_IMAGE/pbc-build.sh $PBC_VERSION $GIT_REV
