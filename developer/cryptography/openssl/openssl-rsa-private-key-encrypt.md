# Openssl RSA Private Key Encrypt

### Encrypt RSA Private Key

```bash
openssl rsa -aes256 -in your.key -out your.encrypted.key
```

`The -aes256` tells `openssl` to encrypt the key with `AES256-CBC.`



to _decrypt_ a rsa encrypted key, drop the `-aes256` flag:

```bash
openssl rsa -in your.encrupted.key -out your.decrypted.key
```



### Encrypt RSA Private Key with PKCS8

`openssl pkcs8` - it uses a key derivation function and supports RSA, ECC and Edwards keys:

```bash
openssl pkcs8 -topk8 -in your.key -out your.encrypted.key
```



For even better security use the `scrypt` KDF:

```bash
openssl pkcs8 -topk8 -scrypt -in your.key -out your.encrypted.key
```



to _decrypt_ a pkcs8 encrypted key, drop the `-topk8` flag:

```bash
openssl pkcs8 -in your.encrypted.key -out your.decrypted.key
```
