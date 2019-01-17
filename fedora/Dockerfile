ARG IMAGE_VERSION=latest
FROM fedora:$IMAGE_VERSION
LABEL maintainer="DECENT"

# prerequisites
RUN dnf install -y cryptopp wget procps && dnf clean all

# PBC
ARG PBC_VERSION=0.5.14
RUN export FEDORA=`rpm -E "%{fedora}"` && \
    wget -P /tmp https://github.com/DECENTfoundation/pbc/releases/download/$PBC_VERSION/libpbc-$PBC_VERSION-1.fc$FEDORA.x86_64.rpm && \
    rpm -i /tmp/libpbc-$PBC_VERSION-* && rm /tmp/libpbc-$PBC_VERSION-*

# IPFS
ARG IPFS_VERSION=v0.4.18
ARG TARGETOS=linux
ARG TARGETARCH=amd64
RUN wget -P /tmp "https://dist.ipfs.io/go-ipfs/${IPFS_VERSION}/go-ipfs_${IPFS_VERSION}_${TARGETOS}-${TARGETARCH}.tar.gz" && \
    cd /tmp && tar xvf "go-ipfs_${IPFS_VERSION}_${TARGETOS}-${TARGETARCH}.tar.gz" && \
    cp go-ipfs/ipfs /usr/bin && \
    rm -rf go-ipfs*

# prepare directories
ENV DCORE_HOME=/root
ENV DCORE_USER=root
USER $DCORE_USER
WORKDIR $DCORE_HOME

# DCore
ARG DCORE_VERSION
COPY DCore-$DCORE_VERSION-*.rpm /tmp
RUN mkdir $DCORE_HOME/.decent && rpm -i /tmp/DCore-$DCORE_VERSION-* && rm /tmp/DCore-$DCORE_VERSION-*

EXPOSE 40000
EXPOSE 8090

ENV DCORE_EXTRA_ARGS=""
CMD decentd -d $DCORE_HOME/.decent/data --rpc-endpoint 0.0.0.0:8090 $DCORE_EXTRA_ARGS