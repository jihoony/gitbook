# OpenSSL Certificate Command

## Pre-Requist

### Create certificate extensions files

* ca.conf
* server.conf
* client.conf



{% code title="ca.conf" lineNumbers="true" %}
```
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = KR
O = ksmartech.com
OU = rnd
CN = caroot

[extensions]
basicConstraints = critical, @basic_constraints
keyUsage = keyEncipherment, digitalSignature, nonRepudiation, keyCertSign

subjectKeyIdentifier = hash
subjectAltName = @alt_names

[basic_constraints]
CA = true
pathlen = 1

[alt_names]
DNS.1 = localhost
```
{% endcode %}



{% code title="server.conf" lineNumbers="true" %}
```
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = KR
O = ksmartech.com
OU = rnd
CN = server

[extensions]
basicConstraints = critical, @basic_constraints
keyUsage = keyEncipherment, digitalSignature, nonRepudiation
extendedKeyUsage = serverAuth
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[basic_constraints]
CA = false

[alt_names]
DNS.1 = localhost
```
{% endcode %}



{% code title="client.conf" lineNumbers="true" %}
```
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = KR
O = ksmartech.com
OU = rnd
CN = client

[extensions]
basicConstraints = critical, @basic_constraints
keyUsage = keyEncipherment, digitalSignature, nonRepudiation
extendedKeyUsage = clientAuth
subjectKeyIdentifier = hash

[basic_constraints]
CA = false
```
{% endcode %}

## Generate

### Generate CA Private Key and Certificate

{% code overflow="wrap" lineNumbers="true" fullWidth="false" %}
```bash
openssl req -x509 -nodes -days 1000 -newkey rsa:2048 -sha256 -keyout ca.key -out ca.crt -config ca.conf -extensions extensions
```
{% endcode %}





### Generate Server & Client CSR

{% code overflow="wrap" lineNumbers="true" fullWidth="false" %}
```bash
# generate private key and csr
openssl req -newkey rsa:2048 -nodes -sha256 -keyout server.key -out server.csr -config server.conf -extensions extensions
# generate csr with existing private key
openssl req -out server.csr -key server.key -new -config server.conf -extensions extensions
 

# generate private key and csr
openssl req -newkey rsa:2048 -nodes -sha256 -keyout client.key -out client.csr -config client.conf -extensions extensions
# generate csr with existing private key
openssl req -out client.csr -key client.key -new -config client.conf -extensions extensions
```
{% endcode %}



#### Verify Generated CSR & Private Key

{% code overflow="wrap" lineNumbers="true" fullWidth="false" %}
```bash
openssl rsa -check -in server.key
openssl req -text -noout -verify -in server.csr
 
openssl rsa -check -in client.key
openssl req -text -noout -verify -in client.csr
```
{% endcode %}



### Generate Certificate

{% code overflow="wrap" lineNumbers="true" fullWidth="false" %}
```bash
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -out server.crt -days 365 -extfile server.conf -extensions extensions
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -out client.crt -days 365 -extfile client.conf -extensions extensions
```
{% endcode %}



#### Verify Generated Certificate

{% code overflow="wrap" lineNumbers="true" fullWidth="false" %}
```bash
openssl x509 -noout -text -in server.crt
openssl x509 -noout -text -in client.crt
```
{% endcode %}







## References

{% embed url="https://docs.openssl.org/master/man5/x509v3_config/#basic-constraints" %}

{% embed url="https://www.ibm.com/support/pages/how-self-sign-or-certify-csr-san-x509-v3-extension-using-ibm-pase-openssl" %}

{% embed url="https://www.xolphin.com/support/OpenSSL/Frequently_used_OpenSSL_Commands" %}







