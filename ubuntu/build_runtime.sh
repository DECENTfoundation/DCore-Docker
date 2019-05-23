#!/bin/bash

[ $# -lt 4 ] && { echo "Usage: $0 image_tag image_version dcore_version packages_dir"; exit 1; }

BASEDIR=$(dirname "$0")
docker build -t $1 -f $BASEDIR/Dockerfile --pull --build-arg IMAGE_VERSION=$2 --build-arg DCORE_VERSION=$3 $4
