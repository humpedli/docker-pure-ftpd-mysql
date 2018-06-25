FROM ubuntu:14.04

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
    useradd -g ftpgroup -d /dev/null -s /etc ftpuser && \
    chown -R ftpuser:ftpgroup /ftpdata

# cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# run mysql configuration creator script
COPY run.sh /run.sh
RUN chmod u+x /run.sh && \
    /run.sh

# define important volumes
VOLUME /ftpdata

# run command
# -l define login/mysql configuration
# -J define TLS cypher
# -E no anonymous connect
# -O alt log
# -8 filesystem charset
# -u min uid
# -U file/dir umask
# -p passive port range
# -Y TLS
# -H dont resolve dns
# -A chroot everyone
# -B daemonize
# -P external ip for passive mode
CMD /usr/sbin/pure-ftpd-mysql -l mysql:/etc/pure-ftpd/db/mysql.conf -J ALL:!aNULL:!SSLv3 -E -O clf:/var/log/pure-ftpd/transfer.log -8 UTF-8 -u 30 -U 111:000 -p 30000:30009 -Y 1 -H -A -B -P $EXTERNAL_IP

# expose important ports
EXPOSE 20 21 30000-30009