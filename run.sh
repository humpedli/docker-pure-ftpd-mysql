#!/bin/bash

# mysql configuration
cat << EOM > /etc/pure-ftpd/db/mysql.conf
#MYSQLSocket        /var/run/mysqld/mysqld.sock
MYSQLServer         ${MYSQL_HOST:-mysql}
MYSQLPort           ${MYSQL_PORT:-3306}
MYSQLUser           ${MYSQL_USER:-pureftpd}
MYSQLPassword       ${MYSQL_PASSWORD:-password}
MYSQLDatabase       ${MYSQL_DATABASE:-pureftpd}
MYSQLCrypt          md5
MYSQLGetPW          SELECT Password FROM ftpd WHERE User="\L" AND status="1" AND (ipaccess = "*" OR ipaccess LIKE "\R")
MYSQLGetUID         SELECT Uid FROM ftpd WHERE User="\L" AND status="1" AND (ipaccess = "*" OR ipaccess LIKE "\R")
MYSQLGetGID         SELECT Gid FROM ftpd WHERE User="\L"AND status="1" AND (ipaccess = "*" OR ipaccess LIKE "\R")
MYSQLGetDir         SELECT Dir FROM ftpd WHERE User="\L"AND status="1" AND (ipaccess = "*" OR ipaccess LIKE "\R")
MySQLGetBandwidthUL SELECT ULBandwidth FROM ftpd WHERE User="\L"AND status="1" AND (ipaccess = "*" OR ipaccess LIKE "\R")
MySQLGetBandwidthDL SELECT DLBandwidth FROM ftpd WHERE User="\L"AND status="1" AND (ipaccess = "*" OR ipaccess LIKE "\R")
MySQLGetQTASZ       SELECT QuotaSize FROM ftpd WHERE User="\L"AND status="1" AND (ipaccess = "*" OR ipaccess LIKE "\R")
MySQLGetQTAFS       SELECT QuotaFiles FROM ftpd WHERE User="\L"AND status="1" AND (ipaccess = "*" OR ipaccess LIKE "\R")
EOM

# tls enable and certificate mix
TLS=0
if [ -e /etc/ssl/private/imported-key.pem ] && [ -e /etc/ssl/private/imported-cert.pem ];
then
    cat /etc/ssl/private/imported-key.pem /etc/ssl/private/imported-cert.pem > /etc/ssl/private/pure-ftpd.pem
    chmod 600 /etc/ssl/private/pure-ftpd.pem
    TLS=1
fi
if [ -e /etc/ssl/private/imported.pem ];
then
	cat /etc/ssl/private/imported.pem > /etc/ssl/private/pure-ftpd.pem
	chmod 600 /etc/ssl/private/pure-ftpd.pem
	TLS=1
fi

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
/usr/sbin/pure-ftpd-mysql -l mysql:/etc/pure-ftpd/db/mysql.conf -J 'ALL:!aNULL:!SSLv3' -E -O clf:/var/log/pure-ftpd/transfer.log -8 UTF-8 -u 30 -U 111:000 -p 30000:30009 -Y $TLS -H -A -B -P ${EXTERNAL_IP:-localhost} && tail -f && tail -f /var/log/*.log