#!/bin/bash

[ $# -lt 4 ] && { echo "Usage: $0 image_tag image_version dcore_version packages_dir"; exit 1; }

set -e
BASEDIR=$(dirname "$0")
cp $BASEDIR/bintray-decentfoundation.repo $4
docker build -t $1 -f $BASEDIR/Dockerfile --pull --build-arg IMAGE_VERSION=$2 --build-arg DCORE_VERSION=$3 $4
rm $4/bintray-decentfoundation.repo
