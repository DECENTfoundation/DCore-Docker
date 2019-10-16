#!/bin/bash

[ $# -lt 1 ] && { echo "Usage: $0 dcore_version [git_revision] [build_type]"; exit 1; }

DCORE_VERSION=$1
if [ $# -lt 2 ]; then GIT_REV=$DCORE_VERSION; else GIT_REV=$2; fi
if [ $# -lt 3 ]; then BUILD_TYPE="Release"; else BUILD_TYPE=$3; fi

set -e
. /etc/os-release

BASEDIR=$(dirname "$0")
echo "Building DCore GUI $DCORE_VERSION (git revision $GIT_REV) for $PRETTY_NAME"

# custom Boost and CMake on Debian prior to 10
if [ $VERSION_ID -lt 10 ]; then
   export BOOST_ROOT=/root/boost
   export PATH=/root/cmake/bin:$PATH
fi

# build DCore
git clone --single-branch --branch $GIT_REV git@github.com:DECENTfoundation/DECENT-GUI.git
cd DECENT-GUI
git submodule update --init --recursive
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_INSTALL_PREFIX=../DCore .
make -j$(nproc) install
cd ..

# copy the binary
mkdir -p dcore-gui/usr/bin
mkdir -p dcore-gui/DEBIAN
cp DCore/bin/DECENT dcore-gui/usr/bin

# generate the control file
echo "Package: DCore-GUI" > dcore-gui/DEBIAN/control
echo "Version: $DCORE_VERSION" >> dcore-gui/DEBIAN/control
echo "Maintainer: DECENT <support@decent.ch>" >> dcore-gui/DEBIAN/control
echo "Homepage: https://decent.ch" >> dcore-gui/DEBIAN/control
echo "Source: https://github.com/DECENTfoundation/DECENT-GUI/archive/$DCORE_VERSION.tar.gz" >> dcore-gui/DEBIAN/control
echo "Section: net" >> dcore-gui/DEBIAN/control
echo "Priority: optional" >> dcore-gui/DEBIAN/control
echo "Architecture: amd64" >> dcore-gui/DEBIAN/control
if [ $VERSION_ID -lt 10 ]; then
   echo "Depends: libpbc, libreadline7, libcrypto++6, libssl1.0.2, libcurl3, qt5-default" >> dcore-gui/DEBIAN/control
else
   echo "Depends: libpbc, libreadline7, libcrypto++6, libssl1.1, libcurl4, libncurses6, qt5-default" >> dcore-gui/DEBIAN/control
fi
echo "Description: Fast, powerful and cost-efficient blockchain." >> dcore-gui/DEBIAN/control
echo " DCore is the blockchain you can easily build on. As the world’s first blockchain" >> dcore-gui/DEBIAN/control
echo " designed for digital content, media and entertainment, it provides user-friendly" >> dcore-gui/DEBIAN/control
echo " software development kits (SDKs) that empower developers and businesses to build" >> dcore-gui/DEBIAN/control
echo " decentralized applications for real-world use cases. DCore is packed-full of" >> dcore-gui/DEBIAN/control
echo " customizable features making it the ideal blockchain for any size project." >> dcore-gui/DEBIAN/control

# build the deb package
dpkg-deb --build dcore-gui packages
mv packages/dcore-gui_${DCORE_VERSION}_amd64.deb packages/dcore-gui_${DCORE_VERSION}-debian${VERSION_ID}_amd64.deb

# clean up
rm -rf DECENT-GUI dcore-gui
