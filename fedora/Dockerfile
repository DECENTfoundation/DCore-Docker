ARG IMAGE_VERSION=latest
FROM fedora:$IMAGE_VERSION
LABEL maintainer="DECENT"

# register Bintray repository
RUN curl https://bintray.com/user/downloadSubjectPublicKey?username=decentfoundation -o /etc/pki/rpm-gpg/RPM-GPG-KEY-decentfoundation && \
    curl https://docs.decent.ch/assets/bintray-decentfoundation.repo -o /etc/yum.repos.d/bintray-decentfoundation.repo

# prerequisites
RUN dnf install -y cryptopp libpbc less procps && dnf clean all

# DCore
ARG DCORE_VERSION
COPY DCore-$DCORE_VERSION-1.fc*.rpm /tmp/
RUN export FEDORA=`rpm -E "%{fedora}"` && \
    export ARCH=`rpm -E "%{_arch}"` && \
    rpm -i /tmp/DCore-$DCORE_VERSION-1.fc$FEDORA.$ARCH.rpm && \
    rm /tmp/DCore-$DCORE_VERSION-1.fc*.rpm

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
