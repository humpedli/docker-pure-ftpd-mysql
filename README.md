Pure-ftpd with MySQL, TLS, Quota, Bandwith control and Passive mode

## Usage

* Create a MySQL container and import `pureftp.sql` file to create the database
* Run container with the following configuration:

```bash
docker run --name=pure-ftpd-mysql \
  -v <path_to_cert/cert.pem>:/etc/ssl/private/pure-ftpd.pem \
  -v <path_to_data>:/ftpdata \
  -v <path_to_config>:/etc/pure-ftpd \
  --link db:db \
  -e EXTERNALIP=<external_ip_for_passive_mode> \
  -e MYSQL_USER=<mysql_user> \
  -e MYSQL_PASSWORD=<mysql_password> \
  -e MYSQL_DATABASE=<mysql_database> \
  -p 20-21:20-21 \
  -p 30000-30009:30000-30009 \
  -d humpedli/docker-pureftpd-mysql
```