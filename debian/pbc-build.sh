#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 pbc_version gpg_key_id [git_revision]"; exit 1; }

PBC_VERSION=$1
GPG_KEY_ID=$2
if [ $# -lt 3 ]; then GIT_REV=$PBC_VERSION; else GIT_REV=$3; fi

set -e
. /etc/os-release

echo "Building PBC $PBC_VERSION (git revision $GIT_REV) for $PRETTY_NAME"

apt-get update
apt-get install -y --no-install-recommends \
    build-essential \
    autotools-dev \
    automake \
    autoconf \
    libtool \
    make \
    cmake \
    gcc \
    flex \
    bison \
    git \
    libgmp-dev \
    dpkg-sig \
    ca-certificates

# build PBC
git clone --single-branch --branch $GIT_REV https://github.com/DECENTfoundation/pbc.git
cd pbc

./setup
./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
make -j$(nproc) install

cd ..
mkdir -p libpbc/usr/lib/x86_64-linux-gnu
cp -a /usr/lib/x86_64-linux-gnu/libpbc.so.* libpbc/usr/lib/x86_64-linux-gnu

mkdir -p libpbc/DEBIAN
cp pbc/debian/copyright libpbc/DEBIAN

echo "Package: libpbc" > libpbc/DEBIAN/control
echo "Version: $PBC_VERSION" >> libpbc/DEBIAN/control
echo "Maintainer: DECENT <support@decent.ch>" >> libpbc/DEBIAN/control
echo "Homepage: https://crypto.stanford.edu/pbc" >> libpbc/DEBIAN/control
echo "Source: https://crypto.stanford.edu/pbc/files/pbc-$PBC_VERSION.tar.gz" >> libpbc/DEBIAN/control
echo "Section: libs" >> libpbc/DEBIAN/control
echo "Priority: optional" >> libpbc/DEBIAN/control
echo "Architecture: amd64" >> libpbc/DEBIAN/control
echo "Build-Depends: debhelper (>= 5), autotools-dev, libreadline-dev, flex, bison" >> libpbc/DEBIAN/control
echo "Description: Pairing-Based Crypto library." >> libpbc/DEBIAN/control
echo " Pairing-based cryptography is a relatively young area of cryptography that" >> libpbc/DEBIAN/control
echo " revolves around a certain function with special properties. The PBC library is" >> libpbc/DEBIAN/control
echo " designed to be the backbone of implementations of pairing-based cryptosystems," >> libpbc/DEBIAN/control
echo " thus speed and portability are important goals. It provides routines such as" >> libpbc/DEBIAN/control
echo " elliptic curve generation, elliptic curve arithmetic and pairing computation." >> libpbc/DEBIAN/control

mkdir -p libpbc-dev/usr/include
cp -R /usr/include/pbc libpbc-dev/usr/include

mkdir -p libpbc-dev/usr/lib/x86_64-linux-gnu
cp /usr/lib/x86_64-linux-gnu/libpbc.a libpbc-dev/usr/lib/x86_64-linux-gnu
cp -a /usr/lib/x86_64-linux-gnu/libpbc.so libpbc-dev/usr/lib/x86_64-linux-gnu

mkdir -p libpbc-dev/DEBIAN
cp pbc/debian/copyright libpbc-dev/DEBIAN

echo "Package: libpbc-dev" > libpbc-dev/DEBIAN/control
echo "Version: $PBC_VERSION" >> libpbc-dev/DEBIAN/control
echo "Maintainer: DECENT <support@decent.ch>" >> libpbc-dev/DEBIAN/control
echo "Homepage: https://crypto.stanford.edu/pbc" >> libpbc-dev/DEBIAN/control
echo "Source: https://crypto.stanford.edu/pbc/files/pbc-$PBC_VERSION.tar.gz" >> libpbc-dev/DEBIAN/control
echo "Section: libdevel" >> libpbc-dev/DEBIAN/control
echo "Priority: optional" >> libpbc-dev/DEBIAN/control
echo "Architecture: amd64" >> libpbc-dev/DEBIAN/control
echo "Depends: libpbc (= $PBC_VERSION)" >> libpbc-dev/DEBIAN/control
echo "Description: Pairing-Based Crypto library." >> libpbc-dev/DEBIAN/control
echo " Pairing-based cryptography is a relatively young area of cryptography that" >> libpbc-dev/DEBIAN/control
echo " revolves around a certain function with special properties. The PBC library is" >> libpbc-dev/DEBIAN/control
echo " designed to be the backbone of implementations of pairing-based cryptosystems," >> libpbc-dev/DEBIAN/control
echo " thus speed and portability are important goals. It provides routines such as" >> libpbc-dev/DEBIAN/control
echo " elliptic curve generation, elliptic curve arithmetic and pairing computation." >> libpbc-dev/DEBIAN/control

dpkg-deb --build libpbc packages
dpkg-deb --build libpbc-dev packages

dpkg-sig -s builder -k "$GPG_KEY_ID" packages/libpbc_${PBC_VERSION}_amd64.deb
dpkg-sig -s builder -k "$GPG_KEY_ID" packages/libpbc-dev_${PBC_VERSION}_amd64.deb

mv packages/libpbc_${PBC_VERSION}_amd64.deb packages/libpbc_${PBC_VERSION}-debian${VERSION_ID}_amd64.deb
mv packages/libpbc-dev_${PBC_VERSION}_amd64.deb packages/libpbc-dev_${PBC_VERSION}-debian${VERSION_ID}_amd64.deb

rm -rf libpbc*
