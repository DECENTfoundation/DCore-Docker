ARG IMAGE_VERSION=latest
FROM debian:$IMAGE_VERSION
LABEL maintainer="DECENT"

# register Bintray repository
RUN . /etc/os-release && \
    DIST=$(echo $VERSION | sed 's/[0-9]\+ (\(.*\))/\1/') && \
    apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg curl && \
    curl https://bintray.com/user/downloadSubjectPublicKey?username=decentfoundation | apt-key add - && \
    echo "deb https://dl.bintray.com/decentfoundation/debian $DIST libpbc" | tee -a /etc/apt/sources.list && \
    apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# DCore
ARG DCORE_VERSION
COPY dcore_${DCORE_VERSION}-*.deb /tmp/
RUN . /etc/os-release && export ARCH=`dpkg --print-architecture` && \
    apt-get update && apt-get install -y /tmp/dcore_$DCORE_VERSION-${ID}${VERSION_ID}_${ARCH}.deb && \
    apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 40000 8090

ENV DCORE_USER=dcore
ENV DCORE_HOME=/home/dcore
RUN useradd --home-dir $DCORE_HOME --create-home $DCORE_USER

USER $DCORE_USER
WORKDIR $DCORE_HOME
RUN mkdir $DCORE_HOME/.decent

ENV DCORE_EXTRA_ARGS=""
ENV DCORE_DATA_DIR=$DCORE_HOME"/.decent/data"
CMD decentd -d $DCORE_DATA_DIR --rpc-endpoint 0.0.0.0:8090 $DCORE_EXTRA_ARGS
