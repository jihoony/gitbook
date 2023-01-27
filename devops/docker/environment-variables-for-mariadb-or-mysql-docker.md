# Environment Variables for MariaDB or MySQL Docker

## Environments

| Environment   | MariaDB                 | MySQL                 |
| ------------- | ----------------------- | --------------------- |
| root password | MARIADB\_ROOT\_PASSWORD | MYSQL\_ROOT\_PASSWORD |
| database      | MARIADB\_DATABASE       | MYSQL\_DATABASE       |
| user          | MARIADB\_USER           | MYSQL\_USER           |
| password      | MARIADB\_PASSWORD       | MYSQL\_PASSWORD       |

### Example

{% code overflow="wrap" %}
```bash
$ docker run -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=my-database -e MYSQL_USER=my-user -e MYSQL_PASSWORD=my-password mysql:latest
```
{% endcode %}

## Reference

{% embed url="https://mariadb.com/kb/en/mariadb-docker-environment-variables/" %}

{% embed url="https://hub.docker.com/_/mariadb" %}
