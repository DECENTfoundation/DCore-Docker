ARG IMAGE_VERSION=latest
FROM ubuntu:$IMAGE_VERSION
LABEL maintainer="DECENT"

# register Bintray repository
RUN . /etc/os-release && apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg curl && \
    curl https://bintray.com/user/downloadSubjectPublicKey?username=decentfoundation | apt-key add - && \
    echo "deb https://dl.bintray.com/decentfoundation/ubuntu $VERSION_CODENAME libpbc" | tee -a /etc/apt/sources.list && \
    apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# DCore
ARG DCORE_VERSION
COPY dcore_${DCORE_VERSION}-*.deb /tmp/
RUN . /etc/os-release && export ARCH=`dpkg --print-architecture` && \
    apt-get update && apt-get install -y /tmp/dcore_$DCORE_VERSION-${ID}${VERSION_ID}_${ARCH}.deb && \
    apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV DCORE_USER=dcore
ENV DCORE_HOME=/home/dcore
RUN if [ $DCORE_USER != "root" ]; then useradd --home-dir $DCORE_HOME --create-home $DCORE_USER; fi

USER $DCORE_USER
WORKDIR $DCORE_HOME
RUN mkdir -p $DCORE_HOME/.decent/data

EXPOSE 40000 8090
ENTRYPOINT ["decentd", "--rpc-endpoint", "0.0.0.0:8090"]
