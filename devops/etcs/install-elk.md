# Install ELK

## Import the Elasticsearch PGP Key

Download and install the public signing key:

{% code overflow="wrap" %}
```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```
{% endcode %}

### Installing from the APT repository

You may need to install the `apt-transport-https` package on Debian before proceeding:

{% code overflow="wrap" %}
```bash
sudo apt-get install apt-transport-https
```
{% endcode %}

Save the repository definition to `/etc/apt/sources.list.d/elastic-8.x.list`:

{% code overflow="wrap" %}
```bash
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```
{% endcode %}

## Install Elasticsearch

You can install the Elasticsearch Debian package with:

{% code overflow="wrap" %}
```bsh
sudo apt-get update && sudo apt-get install elasticsearch
```
{% endcode %}

### Check elastic password

\[\*] When you installing Elasticsearch. you have to check this message:

{% code overflow="wrap" %}
```bash
--------------------------- Security autoconfiguration information ------------------------------

Authentication and authorization are enabled.
TLS for the transport and HTTP layers is enabled and configured.

The generated password for the elastic built-in superuser is : ZqC_399l*z0*uQKWXp9w

If this node should join an existing cluster, you can reconfigure this with
'/usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token <token-here>'
after creating an enrollment token on your existing cluster.

You can complete the following actions at any time:

Reset the password of the elastic built-in superuser with
'/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic'.

Generate an enrollment token for Kibana instances with
 '/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana'.

Generate an enrollment token for Elasticsearch nodes with
'/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node'.

-------------------------------------------------------------------------------------------------
### NOT starting on installation, please execute the following statements to configure elasticsearch service to start automatically using systemd
 sudo systemctl daemon-reload
 sudo systemctl enable elasticsearch.service
### You can start elasticsearch service by executing
 sudo systemctl start elasticsearch.service
```
{% endcode %}

in this case `elastic` user password is `ZqC_399l*z0*uQKWXp9w`. if you want to change password for user `elastic` , use `elasticsearch-reset-password -u elastic`.

### Running Elasticsearch with `systemd`

To configure Elasticsearch to start automatically when the system boot up, run the following commands:

{% code overflow="wrap" %}
```bash
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
```
{% endcode %}

Elasticsearch can be startted and stopped as follows:

{% code overflow="wrap" %}
```bash
sudo systemctl start elasticsearch.service
sudo systemctl stop elasticsearch.service
```
{% endcode %}

### Testing Elasticsearch

{% code overflow="wrap" %}
```bash
vagrant@ubuntu-focal:~$ sudo curl --cacert /etc/elasticsearch/certs/http_ca.crt -X GET -u elastic https://localhost:9200
Enter host password for user 'elastic':
{
  "name" : "ubuntu-focal",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "I_z7OoaoSX-xwxBAWtqXyg",
  "version" : {
    "number" : "8.6.2",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "2d58d0f136141f03239816a4e360a8d17b6d8f29",
    "build_date" : "2023-02-13T09:35:20.314882762Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
vagrant@ubuntu-focal:~$
```
{% endcode %}



{% embed url="https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html" %}

## Install Logstash

Run `sudo apt-get update` and the repository is ready for use. You can install it with:

{% code overflow="wrap" %}
```bash
sudo apt-get update && sudo apt-get install logstash
```
{% endcode %}

### Running Logstash with `systemd`

{% code overflow="wrap" %}
```bash
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start logstash.service
```
{% endcode %}

https://www.elastic.co/guide/en/logstash/8.6/running-logstash.html

### Configuration

#### TLS configuration for logstash access

generate rsa key and certificate.

{% code overflow="wrap" %}
```bash
openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout logstash-remote.key -out logstash-remote.crt
```
{% endcode %}

copy cert file (`logstash-remote.crt`) and key file(`logstash-remote.key`) to user directory(in this case `/home/vagrant`).

and add `other read` access permission.

{% code overflow="wrap" %}
```bash
cp logstash-remote* /home/vagrant
chmod o+r /home/vagrant/logstash-remote*
```
{% endcode %}

#### For access Elasticsearch, need certificate and user authentication.

copy cert file( `/etc/elasticsearch/certs/http_ca.cert` ) to user directory(in this case `/home/vagrant`).

and modify file permission `644`.

{% code overflow="wrap" %}
```bash
cp /etc/elasticsearch/certs/http_ca.crt /home/vagrant/
chmod 644 /home/vagrant/http_ca.crt
```
{% endcode %}

generage config file(`sample.conf`) in `/etc/logstash/conf.d` directory

{% code overflow="wrap" %}
```ruby
input {
        http {
                host => "0.0.0.0"
                port => 3000
                codec => json_lines
          			ssl => true
          			ssl_certificate => "/home/vagrant/logstash-remote.crt"
          			ssl_key => "/home/vagrant/logstash-remote.key"
          			user => "logstash_user"
          			password => "votmdnjem"
        }
}

filter {
}

output {
  			file {
		        		path => "/tmp/file_log.log"
          			codec => rubydebug
        }
        elasticsearch {
          			index => "my-http-client-%{+yyyy.MM.dd}"
                hosts => [ "localhost:9200" ]
                ssl => true
                user => "elastic"
                password => "ZqC_399l*z0*uQKWXp9w"
                cacert => "/home/vagrant/http_ca.crt"
        }
}
```
{% endcode %}

### Testing Logstash

{% code overflow="wrap" %}
```bash
vagrant@ubuntu-focal:~$ curl -u "logstash_user:votmdnjem" -H "Content-Type: application/json" -d '{"Hello":"ELK"}' -X POST -vk https://localhost:3000
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server did not agree to a protocol
* Server certificate:
*  subject: C=AU; ST=Some-State; O=Internet Widgits Pty Ltd
*  start date: Mar 15 04:17:05 2023 GMT
*  expire date: Apr 14 04:17:05 2023 GMT
*  issuer: C=AU; ST=Some-State; O=Internet Widgits Pty Ltd
*  SSL certificate verify result: self signed certificate (18), continuing anyway.
* Server auth using Basic with user 'logstash_user'
> POST / HTTP/1.1
> Host: localhost:3000
> Authorization: Basic bG9nc3Rhc2hfdXNlcjp2b3RtZG5qZW0=
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Type: application/json
> Content-Length: 15
>
* upload completely sent off: 15 out of 15 bytes
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< content-length: 2
< content-type: text/plain
<
* Connection #0 to host localhost left intact
ok
vagrant@ubuntu-focal:~$
```
{% endcode %}

> curl -k 옵션으로 self-signed certificate 에 대한 오류사항을 무시할 수 있다.

{% code overflow="wrap" %}
```bash
curl https://localhost:9200/my-http-client*/_search
```
{% endcode %}

## Install Kibana

Run `sudo apt-get update` and the repository is ready for use. You can install it with:

{% code overflow="wrap" %}
```bash
sudo apt-get update && sudo apt-get install kibana
```
{% endcode %}

### Running Kibana with `systemd`

{% code overflow="wrap" %}
```bash
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service
```
{% endcode %}

### Testing Kibana

{% code overflow="wrap" %}
```bash
curl localhost:5601/
```
{% endcode %}

### Configuration

in `/etc/kibana/kibana.yml` for access any.

{% code overflow="wrap" %}
```yaml
server.host: "0.0.0.0"
```
{% endcode %}

reboot kibana

{% code overflow="wrap" %}
```bash
sudo systemctl restart kibana.service
```
{% endcode %}

connect http://{ipaddress}:5601/

generate an enrollment token for kibana

{% code overflow="wrap" %}
```bash
sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```
{% endcode %}

token example

{% code overflow="wrap" %}
```bash
eyJ2ZXIiOiI4LjYuMiIsImFkciI6WyIxMC4wLjIuMTU6OTIwMCJdLCJmZ3IiOiJmOWQ4OTdhMjQ3ZDc2ZWY2ZDgzZmIyM2E1ZThkM2IzMTJmMWFmMGQxMjRmMDNkNjgxNWQ2ZjNiNTk0MjE0YzFkIiwia2V5IjoiYzJBWTVJWUJSdnU5UDlvWWMxT2g6cDM1QlZhV0xTVENkUlk3UDY0N2w0QSJ9
```
{% endcode %}

copy token and paste to kibana web

&#x20;

generate authentication code

{% code overflow="wrap" %}
```bash
sudo /usr/share/kibana/bin/kibana-verification-code
```
{% endcode %}



enter 6-digits authentication code and login with `elastic` username and password.



{% embed url="https://www.elastic.co/guide/en/kibana/current/deb.html" %}
