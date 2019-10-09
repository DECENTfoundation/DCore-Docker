#!/bin/bash

[ $# -lt 3 ] && { echo "Usage: $0 image_version pbc_version gpg_key_id [git_revision] [packages_dir] [gnupg_dir]"; exit 1; }

set -e
PBC_VERSION=$2
GPG_KEY_ID=$3
BASE_IMAGE=debian

if [ $# -lt 4 ]; then GIT_REV=$2; else GIT_REV=$4; fi

if [ $# -lt 5 ]; then PACKAGES_DIR="$PWD/packages"; else PACKAGES_DIR=$5; fi

if [ $# -lt 6 ]; then GNUPG_DIR="$HOME/.gnupg"; else GNUPG_DIR=$6; fi

PACKAGES_PATH=$PACKAGES_DIR/$BASE_IMAGE/$IMAGE_VERSION
mkdir -p $PACKAGES_PATH
docker run -w /root --rm --name $BASE_IMAGE.pbc.$1 \
    --mount type=bind,src=$PACKAGES_PATH,dst=/root/packages \
    --mount type=bind,src=$PWD/$BASE_IMAGE,dst=/root/$BASE_IMAGE,readonly \
    --mount type=bind,src=$GNUPG_DIR,dst=/root/.gnupg \
    $BASE_IMAGE:$1 $BASE_IMAGE/pbc-build.sh $PBC_VERSION "$GPG_KEY_ID" $GIT_REV
