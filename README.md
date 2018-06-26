Pure-ftpd with MySQL, TLS, Quota, Bandwith control and Passive mode

## Usage

* Create a MySQL container and import `pureftp.sql` file to create the database
* Insert an user into previously created database
* Run container with the following configuration:

---
**Docker command:**

```bash
docker run --name=pure-ftpd-mysql \
  --restart-always \
  -v <path_to_pem/file.pem>:/etc/ssl/private/imported.pem:ro \
  -v <path_to_data>:/ftpdata \
  --link mysql:mysql \
  -e EXTERNAL_IP=<external_ip_for_passive_mode> \
  -e MYSQL_HOST=mysql \
  -e MYSQL_PORT=3306 \
  -e MYSQL_USER=<mysql_user> \
  -e MYSQL_PASSWORD=<mysql_password> \
  -e MYSQL_DATABASE=<mysql_database> \
  -p 20-21:20-21 \
  -p 30000-30009:30000-30009 \
  -d humpedli/docker-pureftpd-mysql
```

---
**Docker compose:**

```bash
version: '3'
services:
  pure-ftpd-mysql:
    container_name: "pure-ftpd-mysql"
    image: "humpedli/docker-pure-ftpd-mysql"
    ports:
      - "20-21:20-21"
      - "30000-30009:30000-30009"
    volumes:
      - "<path_to_pem/file.pem>:/etc/ssl/private/imported.pem:ro"
      - "<path_to_data>:/ftpdata"
    environment:
      - "EXTERNAL_IP=<external_ip_for_passive_mode>"
      - "MYSQL_HOST=mysql"
      - "MYSQL_PORT=3306"
      - "MYSQL_USER=<mysql_user>"
      - "MYSQL_PASSWORD=<mysql_password>"
      - "MYSQL_DATABASE=<mysql_database>"
    depends_on:
      - mysql
    restart: "always"
```

---
### If you have separated private key and cert for TLS define like this:

**Docker command:**

```bash
-v <path_to_key/key.pem>:/etc/ssl/private/imported-key.pem:ro \
-v <path_to_cert/cert.pem>:/etc/ssl/private/imported-cert.pem:ro \
```

---
**Docker compose:**

```bash
volumes:
      - "<path_to_key/key.pem>:/etc/ssl/private/imported-key.pem:ro"
      - "<path_to_cert/cert.pem>:/etc/ssl/private/imported-cert.pem:ro"
```