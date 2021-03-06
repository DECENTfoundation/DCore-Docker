Building Decent in Docker
-------------------------

Official images can be found in [Docker Hub](https://hub.docker.com/u/decentnetwork) repository. If you like to build your own image see instructions below.

## DCore run

There are separate DCore images for each of the supported platforms.

| OS name | Image name |
| ------- | ---------- |
| Ubuntu | dcore.ubuntu |
| Debian | dcore.debian |
| Fedora | dcore.fedora |
| CentOS | dcore.centos |

DCore image exposes 2 ports: 8090 (websocket RPC to listen on) and 40000 (P2P node).
You can mount an external data directory (to persist the blockchain) and genesis file (when using custom configuration) to the running container.

The default mapping of local paths to container paths:

| Host | Container path |
| ---- | -------------- |
| /path/to/data | $DCORE_HOME/.decent/data |
| /path/to/genesis.json | $DCORE_HOME/.decent/genesis.json |
| /path/to/wallet.json | $DCORE_HOME/.decent/wallet.json |

To run the node as root user set the container environment variables:

| Environment variable | Default value |
| -------------------- | ------------- |
| DCORE_HOME | /home/dcore |
| DCORE_USER | dcore |

You can use helper scripts to run the node or wallet:

`dcore.sh` - run the mainnet node

    Usage: ./dcore.sh image_name data_dir [container_user] [container_home]

    ./dcore.sh dcore.ubuntu:1.4.0 $HOME/.decent/data

`dcore_custom_net.sh` - run node on custom net

    Usage: ./dcore_custom_net.sh image_name data_dir genesis_json [container_user] [container_home]

    ./dcore_custom_net.sh dcore.ubuntu:1.4.0 $HOME/.decent/data $HOME/.decent/genesis.json

`cli_wallet.sh` - start CLI wallet and attach to running node

    Usage: ./cli_wallet.sh wallet_file [container_name]

    ./cli_wallet.sh $HOME/.decent/wallet.json

To stop running node:

    docker stop DCore

## DCore build

Because build is specific for each platform, there is a helper script to make life easier. It requires three mandatory arguments (base OS image name and version, DCore version) and three optional arguments (git revision tag - defaults to DCore version if not specified, build type - defaults to Release, packages directory - defaults to packages subdirectory).

    Usage: ./build.sh base_image image_version dcore_version [git_revision] [build_type] [packages_dir]

### Ubuntu (latest, 19.04, 18.04)

To create deb packages and OS build image:

    # the latest OS image
    ./build.sh ubuntu latest 1.4.0
    # or specific OS version
    ./build.sh ubuntu 18.04 1.4.0
    ls packages
    # dcore_1.4.0-ubuntu18.04_amd64.deb

### Debian (latest, 10)

To create deb packages and OS build image:

    # the latest OS image
    ./build.sh debian latest 1.4.0
    # or specific OS version
    ./build.sh debian 10 1.4.0
    ls packages
    # dcore_1.4.0-debian10_amd64.deb

### Fedora (latest, 31, 30)

To create rpm packages and OS build image:

    # the latest OS image
    ./build.sh fedora latest 1.4.0
    # or specific OS version
    ./build.sh fedora 31 1.4.0
    ls packages
    # DCore-1.4.0-1.fc31.x86_64.rpm

### CentOS (latest, 8)

To create rpm packages and OS build image:

    # the latest OS image
    ./build.sh centos latest 1.4.0
    # or specific OS version
    ./build.sh centos 8 1.4.0
    ls packages
    # DCore-1.4.0-1.el8.x86_64.rpm

Naming convention for images: use `dcore.` prefix, then append base image name and `.build` suffix, e.g. `dcore.ubuntu.build`.

| Build argument | Default value |
| --------------- | ------------- |
| IMAGE_VERSION | latest |

Examples:

    # the latest (18.04) Ubuntu image
    docker build -t dcore.ubuntu.build -f ubuntu/Dockerfile.build ubuntu

    # Ubuntu 18.04 image
    docker build -t dcore.ubuntu.build:18.04 -f ubuntu/Dockerfile.build --build-arg IMAGE_VERSION=18.04 ubuntu

    # Debian 10 image
    docker build -t dcore.debian.build:10 -f debian/Dockerfile.build --build-arg IMAGE_VERSION=10 debian

    # Fedora 31 image
    docker build -t dcore.fedora.build:31 -f fedora/Dockerfile.build --build-arg IMAGE_VERSION=31 fedora

    # CentOS 8 image
    docker build -t dcore.centos.build:8 -f centos/Dockerfile.build --build-arg IMAGE_VERSION=8 centos

## DCore runtime image

If you have DCore deb or rpm packages ready you can build the runtime image. There is a helper script which requires three mandatory arguments (base OS image name and version, DCore version) and two optional arguments (image tag - defaults to DCore version, packages directory - defaults to packages subdirectory).

> Usage: ./build_runtime.sh base_image image_version dcore_version [image_tag] [packages_dir]

Naming convention for images: `dcore.` prefix and append base image name, e.g. `dcore.ubuntu`. You must specify DCore installation package version in `DCORE_VERSION` build argument. Optionally you can specify the OS layer image version using the `IMAGE_VERSION` build argument.

| Build argument | Default value |
| --------------- | ------------- |
| DCORE_VERSION | - |
| IMAGE_VERSION | latest |

    # the latest (18.04) Ubuntu OS image
    docker build -t dcore.ubuntu:1.4.0 -f ubuntu/Dockerfile --build-arg DCORE_VERSION=1.4.0 packages/ubuntu/18.04

    # specific Ubuntu OS version
    docker build -t dcore.ubuntu:1.4.0 -f ubuntu/Dockerfile --build-arg DCORE_VERSION=1.4.0 --build-arg IMAGE_VERSION=18.04 packages/ubuntu/18.04

    # specific Debian OS version
    docker build -t dcore.debian:1.4.0 -f debian/Dockerfile --build-arg DCORE_VERSION=1.4.0 --build-arg IMAGE_VERSION=10 packages/debian/10

    # specific Fedora OS version
    docker build -t dcore.fedora:1.4.0 -f fedora/Dockerfile --build-arg DCORE_VERSION=1.4.0 --build-arg IMAGE_VERSION=31 packages/fedora/31

    # specific CentOS OS version
    docker build -t dcore.centos:1.4.0 -f centos/Dockerfile --build-arg DCORE_VERSION=1.4.0 --build-arg IMAGE_VERSION=8 packages/centos/8

## DCore custom build

It is also possible to build DCore on custom OS image which satisfy all required dependencies.

| Build argument | Default value |
| --------------- | ------------- |
| BUILD_IMAGE | - |
| BASE_IMAGE | - |
| GIT_REV | master |
| BUILD_TYPE | Release |

Examples:

    # the latest DCore version
    docker build -t dcore.custom -f Dockerfile.dcore --build-arg BUILD_IMAGE=custom --build-arg BASE_IMAGE=ubuntu .

    # specific DCore release
    docker build -t dcore.custom:1.4.0 -f Dockerfile.dcore --build-arg BUILD_IMAGE=custom --build-arg BASE_IMAGE=ubuntu --build-arg GIT_REV=1.4.0 .
