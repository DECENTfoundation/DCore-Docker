#!/bin/bash

[ $# -lt 1 ] && { echo "Usage: $0 dcore_version [git_revision] [build_type]"; exit 1; }

DCORE_VERSION=$1
if [ $# -lt 2 ]; then GIT_REV=$DCORE_VERSION; else GIT_REV=$2; fi
if [ $# -lt 3 ]; then BUILD_TYPE="Release"; else BUILD_TYPE=$3; fi

set -e
. /etc/os-release

BASEDIR=$(dirname "$0")
echo "Building DCore $DCORE_VERSION (git revision $GIT_REV) for $PRETTY_NAME"

# custom Boost and CMake on Debian prior to 10
if [ $VERSION_ID -lt 10 ]; then
   export BOOST_ROOT=/root/boost
   export PATH=/root/cmake/bin:$PATH
fi

# build DCore
git clone --single-branch --branch $GIT_REV https://github.com/decent-dcore/DCore-Python.git
cd DCore-Python
git submodule update --init --recursive
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_INSTALL_PREFIX=../DCore .
make -j$(nproc) install
cd ..

# copy the binaries
mkdir -p dcore-python3/DEBIAN
cp -a DCore/* dcore-python3

# generate the control files
echo "Package: DCore-python3" > dcore-python3/DEBIAN/control
echo "Version: $DCORE_VERSION" >> dcore-python3/DEBIAN/control
echo "Maintainer: DECENT <support@decent.ch>" >> dcore-python3/DEBIAN/control
echo "Homepage: https://decent.ch" >> dcore-python3/DEBIAN/control
echo "Source: https://github.com/decent-dcore/DCore-Python/archive/$DCORE_VERSION.tar.gz" >> dcore-python3/DEBIAN/control
echo "Section: net" >> dcore-python3/DEBIAN/control
echo "Priority: optional" >> dcore-python3/DEBIAN/control
echo "Architecture: amd64" >> dcore-python3/DEBIAN/control
if [ $VERSION_ID -lt 10 ]; then
   echo "Depends: libpbc, libreadline7, libcrypto++6, libssl1.0.2, libcurl3" >> dcore-python3/DEBIAN/control
else
   echo "Depends: libpbc, libreadline7, libcrypto++6, libssl1.1, libncurses6, libcurl4, libboost-filesystem1.67.0, libboost-thread1.67.0, libboost-iostreams1.67.0, libboost-date-time1.67.0, libboost-chrono1.67.0, libboost-context1.67.0, libboost-python1.67.0" >> dcore-python3/DEBIAN/control
fi
echo "Description: Fast, powerful and cost-efficient blockchain." >> dcore-python3/DEBIAN/control
echo " DCore is the blockchain you can easily build on. As the world’s first blockchain" >> dcore-python3/DEBIAN/control
echo " designed for digital content, media and entertainment, it provides user-friendly" >> dcore-python3/DEBIAN/control
echo " software development kits (SDKs) that empower developers and businesses to build" >> dcore-python3/DEBIAN/control
echo " decentralized applications for real-world use cases. DCore is packed-full of" >> dcore-python3/DEBIAN/control
echo " customizable features making it the ideal blockchain for any size project." >> dcore-python3/DEBIAN/control

# build the deb packages
dpkg-deb --build dcore-python3 packages
mv packages/dcore-python3_${DCORE_VERSION}_amd64.deb packages/dcore-python3_${DCORE_VERSION}-debian${VERSION_ID}_amd64.deb

# clean up
rm -rf DCore-Python dcore-python3
