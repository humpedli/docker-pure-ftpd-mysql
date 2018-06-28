FROM ubuntu:18.04

# install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update &&  apt-get -y dist-upgrade && \
    apt-get -y --force-yes install openssl dpkg-dev debhelper && \
    apt-get -y build-dep pure-ftpd-mysql && \
    mkdir /ftpdata && \
    mkdir /tmp/pure-ftpd-mysql && \
    cd /tmp/pure-ftpd-mysql && \
    apt-get source pure-ftpd-mysql && \
    cd pure-ftpd-* && \
    sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
    dpkg-buildpackage -b -uc && \
    dpkg -i /tmp/pure-ftpd-mysql/pure-ftpd-common*.deb && \
    apt-get -y install openbsd-inetd \
    mysql-client && \
    dpkg -i /tmp/pure-ftpd-mysql/pure-ftpd-mysql*.deb && \
    apt-mark hold pure-ftpd pure-ftpd-mysql pure-ftpd-common

# setup ftpgroup and ftpuser
RUN groupadd ftpgroup && \
    useradd -g ftpgroup -d /dev/null -s /etc ftpuser

# cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# run mysql configuration creator script
COPY run.sh /run.sh
RUN chmod u+x /run.sh

# entry point
ENTRYPOINT ["/run.sh"]

# define important volumes
VOLUME /ftpdata

# expose important ports
EXPOSE 20 21 30000-30009