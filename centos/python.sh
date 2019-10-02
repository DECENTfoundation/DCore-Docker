#!/bin/bash

[ $# -lt 1 ] && { echo "Usage: $0 dcore_version [git_revision] [build_type]"; exit 1; }

set -e
DCORE_VERSION=$1
if [ $# -lt 2 ]; then GIT_REV=$DCORE_VERSION; else GIT_REV=$2; fi
if [ $# -lt 3 ]; then BUILD_TYPE="Release"; else BUILD_TYPE=$3; fi

CENTOS=`rpm -E "%{centos}"`
echo "Building DCore-python3 $DCORE_VERSION (git revision $GIT_REV) for CentOS $CENTOS"

BASEDIR=$(dirname "$0")
rpmbuild -bb -D "dcore_version $DCORE_VERSION" -D "git_revision $GIT_REV" -D "build_type $BUILD_TYPE" -D "boost_python_version 3" $BASEDIR/DCore-python3.spec
