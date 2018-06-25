#!/bin/bash

# mysql configuration
cat << EOM > /etc/pure-ftpd/db/mysql.conf
#MYSQLSocket        /var/run/mysqld/mysqld.sock
MYSQLServer         db
MYSQLPort           3306
MYSQLUser           $MYSQL_USER
MYSQLPassword       $MYSQL_PASSWORD
MYSQLDatabase       $MYSQL_DATABASE
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

# pureftpd configuration
echo "clf:/var/log/pure-ftpd/transfer.log" > /etc/pure-ftpd/conf/AltLog
echo "yes" > /etc/pure-ftpd/conf/ChrootEveryone
echo "no" > /etc/pure-ftpd/conf/CreateHomeDir
echo "yes" > /etc/pure-ftpd/conf/DontResolve
echo "UTF-8" > /etc/pure-ftpd/conf/FSCharset
echo "30" > /etc/pure-ftpd/conf/MinUID
echo "yes" > /etc/pure-ftpd/conf/NoAnonymous
echo "no" > /etc/pure-ftpd/conf/PAMAuthentication
echo "30000 30009" > /etc/pure-ftpd/conf/PassivePortRange
echo "111 000" > /etc/pure-ftpd/conf/Umask
echo "no" > /etc/pure-ftpd/conf/UnixAuthentication

# tls configuration
echo "1" > /etc/pure-ftpd/conf/TLS

chown -R ftpuser:ftpgroup /ftpdata