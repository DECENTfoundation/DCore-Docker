#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 pbc_version gpg_key_id [git_revision]"; exit 1; }

set -e
PBC_VERSION=$1
GPG_KEY_ID=$2
if [ $# -lt 3 ]; then GIT_REV=$PBC_VERSION; else GIT_REV=$3; fi

BASEDIR=$(dirname "$0")
FEDORA=`rpm -E "%{fedora}"`
echo "Building PBC $PBC_VERSION (git revision $GIT_REV) for Fedora $FEDORA"

dnf install -y automake autoconf libtool make gcc git flex bison which gmp-devel rpm-build rpm-sign
rpmbuild -bb -D "pbc_version $PBC_VERSION" -D "git_revision $GIT_REV" $BASEDIR/libpbc.spec

ARCH=`rpm -E "%{_arch}"`
rpmsign --addsign --key-id "$GPG_KEY_ID" /root/rpmbuild/RPMS/$ARCH/libpbc-$PBC_VERSION-1.fc$FEDORA.$ARCH.rpm
rpmsign --addsign --key-id "$GPG_KEY_ID" /root/rpmbuild/RPMS/$ARCH/libpbc-devel-$PBC_VERSION-1.fc$FEDORA.$ARCH.rpm
rpmsign --addsign --key-id "$GPG_KEY_ID" /root/rpmbuild/RPMS/$ARCH/libpbc-static-$PBC_VERSION-1.fc$FEDORA.$ARCH.rpm
