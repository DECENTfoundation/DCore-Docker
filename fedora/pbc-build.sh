#!/bin/bash

[ $# -lt 1 ] && { echo "Usage: $0 pbc_version [git_revision]"; exit 1; }

set -e
PBC_VERSION=$1
if [ $# -lt 2 ]; then GIT_REV=$PBC_VERSION; else GIT_REV=$2; fi

BASEDIR=$(dirname "$0")
FEDORA=`rpm -E "%{fedora}"`
echo "Building PBC $PBC_VERSION (git revision $GIT_REV) for Fedora $FEDORA"

dnf install -y automake autoconf libtool make gcc git flex bison which gmp-devel rpm-build
rpmbuild -bb -D "pbc_version $PBC_VERSION" -D "git_revision $GIT_REV" $BASEDIR/libpbc.spec
