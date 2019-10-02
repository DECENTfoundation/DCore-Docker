ARG IMAGE_VERSION=latest
FROM centos:$IMAGE_VERSION
LABEL maintainer="DECENT"

# register Bintray repository
RUN curl https://bintray.com/user/downloadSubjectPublicKey?username=decentfoundation -o /etc/pki/rpm-gpg/RPM-GPG-KEY-decentfoundation
COPY bintray-decentfoundation.repo /etc/yum.repos.d/bintray-decentfoundation.repo

# DCore
ARG DCORE_VERSION
COPY DCore-$DCORE_VERSION-1.el*.rpm /tmp/
RUN export CENTOS=`rpm -E "%{centos}"` && \
    export ARCH=`rpm -E "%{_arch}"` && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$CENTOS.noarch.rpm && \
    dnf install -y /tmp/DCore-$DCORE_VERSION-1.el$CENTOS.$ARCH.rpm && \
    dnf clean all && \
    rm /tmp/DCore-$DCORE_VERSION-1.el*.rpm

ENV DCORE_USER=dcore
ENV DCORE_HOME=/home/dcore
RUN if [ $DCORE_USER != "root" ]; then useradd --home-dir $DCORE_HOME --create-home $DCORE_USER; fi

USER $DCORE_USER
WORKDIR $DCORE_HOME
RUN mkdir -p $DCORE_HOME/.decent/data

EXPOSE 40000 8090
ENTRYPOINT ["decentd", "--rpc-endpoint", "0.0.0.0:8090"]
