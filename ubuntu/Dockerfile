ARG IMAGE_VERSION=latest
FROM ubuntu:$IMAGE_VERSION
LABEL maintainer="DECENT"

# prerequisites
RUN . /etc/os-release && apt-get update && \
    if [ "$VERSION_ID" \< "18.04" ]; then apt-get install -y --no-install-recommends \
       libreadline6 \
       libcrypto++9v5 \
       libssl1.0.0 \
       libcurl3 \
       curl \
       apt-transport-https \
       ca-certificates; \
    elif [ "$VERSION_ID" \< "19.04" ]; then apt-get install -y --no-install-recommends \
       libreadline7 \
       libcrypto++6 \
       libssl1.1 \
       libcurl4 \
       curl \
       gnupg \
       apt-transport-https \
       ca-certificates; \
    else apt-get install -y --no-install-recommends \
       libreadline8 \
       libcrypto++6 \
       libssl1.1 \
       libcurl4 \
       curl \
       gnupg \
       apt-transport-https \
       ca-certificates; \
    fi && \
    curl https://bintray.com/user/downloadSubjectPublicKey?username=decentfoundation | apt-key add - && \
    echo "deb https://dl.bintray.com/decentfoundation/ubuntu $VERSION_CODENAME libpbc" | tee -a /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends less libpbc && \
    apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# DCore
ARG DCORE_VERSION
COPY dcore_${DCORE_VERSION}-*.deb /tmp/
RUN . /etc/os-release && export ARCH=`dpkg --print-architecture` && \
    dpkg -i /tmp/dcore_$DCORE_VERSION-${ID}${VERSION_ID}_${ARCH}.deb && \
    rm /tmp/dcore_${DCORE_VERSION}-*.deb

EXPOSE 40000 8090

ENV DCORE_USER=dcore
ENV DCORE_HOME=/home/dcore
RUN if [ $DCORE_USER != "root" ]; then useradd --home-dir $DCORE_HOME --create-home $DCORE_USER; fi

USER $DCORE_USER
WORKDIR $DCORE_HOME
RUN mkdir $DCORE_HOME/.decent

ENV DCORE_EXTRA_ARGS=""
ENV DCORE_DATA_DIR=$DCORE_HOME"/.decent/data"
CMD decentd -d $DCORE_DATA_DIR --rpc-endpoint 0.0.0.0:8090 $DCORE_EXTRA_ARGS
