#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 image_version pbc_version [git_revision]"; exit 1; }

PBC_VERSION=$2
if [ $# -lt 3 ]; then GIT_REV=$2; else GIT_REV=$3; fi

docker run -it -w /root --rm --name centos.pbc.$1 \
    --mount type=bind,src=$PWD/packages,dst=/root/rpmbuild/RPMS/x86_64 \
    --mount type=bind,src=$PWD/centos,dst=/root/centos,readonly \
    centos:$1 centos/pbc-build.sh $PBC_VERSION $GIT_REV
