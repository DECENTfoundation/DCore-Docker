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
git clone --single-branch --branch $GIT_REV https://github.com/DECENTfoundation/DECENT-Network.git
cd DECENT-Network
git submodule update --init --recursive
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_INSTALL_PREFIX=../dcore-node/usr .
make -j$(nproc) install
cd ..

# generate the control file
mkdir -p dcore-node/DEBIAN
echo "Package: DCore" > dcore-node/DEBIAN/control
echo "Version: $DCORE_VERSION" >> dcore-node/DEBIAN/control
echo "Maintainer: DECENT <support@decent.ch>" >> dcore-node/DEBIAN/control
echo "Homepage: https://decent.ch/dcore" >> dcore-node/DEBIAN/control
echo "Source: https://github.com/DECENTfoundation/DECENT-Network/archive/$DCORE_VERSION.tar.gz" >> dcore-node/DEBIAN/control
echo "Section: net" >> dcore-node/DEBIAN/control
echo "Priority: optional" >> dcore-node/DEBIAN/control
echo "Architecture: amd64" >> dcore-node/DEBIAN/control
if [ $VERSION_ID -lt 10 ]; then
   echo "Depends: libpbc, libreadline7, libcrypto++6, libssl1.0.2, libcurl3" >> dcore-node/DEBIAN/control
else
   echo "Depends: libpbc, libreadline7, libcrypto++6, libssl1.1, libncurses6, libcurl4" >> dcore-node/DEBIAN/control
fi
echo "Description: Fast, powerful and cost-efficient blockchain." >> dcore-node/DEBIAN/control
echo " DCore is the blockchain you can easily build on. As the world’s first blockchain" >> dcore-node/DEBIAN/control
echo " designed for digital content, media and entertainment, it provides user-friendly" >> dcore-node/DEBIAN/control
echo " software development kits (SDKs) that empower developers and businesses to build" >> dcore-node/DEBIAN/control
echo " decentralized applications for real-world use cases. DCore is packed-full of" >> dcore-node/DEBIAN/control
echo " customizable features making it the ideal blockchain for any size project." >> dcore-node/DEBIAN/control

# copy the service files
cp $BASEDIR/postinst dcore-node/DEBIAN
cp $BASEDIR/postrm dcore-node/DEBIAN
cp $BASEDIR/prerm dcore-node/DEBIAN
mkdir -p dcore-node/etc/systemd/system
cp DECENT-Network/DCore.service dcore-node/etc/systemd/system

# enable core dump for debug configurations
if [ $BUILD_TYPE = "RelWithDebInfo" ] || [ $BUILD_TYPE = "Debug" ]; then
   crudini --set dcore-node/etc/systemd/system/DCore.service Service LimitCORE infinity
fi

# build the deb packages
dpkg-deb --build dcore-node packages
mv packages/dcore_${DCORE_VERSION}_amd64.deb packages/dcore_${DCORE_VERSION}-debian${VERSION_ID}_amd64.deb

# clean up
rm -rf DECENT-Network dcore-node
