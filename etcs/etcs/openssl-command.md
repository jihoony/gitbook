# OpenSSL Command

### OpenSSL Command

```bash
root@b892fc78f0ae:/tmp# openssl help
Standard commands
asn1parse         ca                ciphers           cms
crl               crl2pkcs7         dgst              dhparam
dsa               dsaparam          ec                ecparam
enc               engine            errstr            gendsa
genpkey           genrsa            help              list
nseq              ocsp              passwd            pkcs12
pkcs7             pkcs8             pkey              pkeyparam
pkeyutl           prime             rand              rehash
req               rsa               rsautl            s_client
s_server          s_time            sess_id           smime
speed             spkac             srp               storeutl
ts                verify            version           x509

Message Digest commands (see the `dgst' command for more details)
blake2b512        blake2s256        gost              md4
md5               rmd160            sha1              sha224
sha256            sha3-224          sha3-256          sha3-384
sha3-512          sha384            sha512            sha512-224
sha512-256        shake128          shake256          sm3

Cipher commands (see the `enc' command for more details)
aes-128-cbc       aes-128-ecb       aes-192-cbc       aes-192-ecb
aes-256-cbc       aes-256-ecb       aria-128-cbc      aria-128-cfb
aria-128-cfb1     aria-128-cfb8     aria-128-ctr      aria-128-ecb
aria-128-ofb      aria-192-cbc      aria-192-cfb      aria-192-cfb1
aria-192-cfb8     aria-192-ctr      aria-192-ecb      aria-192-ofb
aria-256-cbc      aria-256-cfb      aria-256-cfb1     aria-256-cfb8
aria-256-ctr      aria-256-ecb      aria-256-ofb      base64
bf                bf-cbc            bf-cfb            bf-ecb
bf-ofb            camellia-128-cbc  camellia-128-ecb  camellia-192-cbc
camellia-192-ecb  camellia-256-cbc  camellia-256-ecb  cast
cast-cbc          cast5-cbc         cast5-cfb         cast5-ecb
cast5-ofb         des               des-cbc           des-cfb
des-ecb           des-ede           des-ede-cbc       des-ede-cfb
des-ede-ofb       des-ede3          des-ede3-cbc      des-ede3-cfb
des-ede3-ofb      des-ofb           des3              desx
rc2               rc2-40-cbc        rc2-64-cbc        rc2-cbc
rc2-cfb           rc2-ecb           rc2-ofb           rc4
rc4-40            seed              seed-cbc          seed-cfb
seed-ecb          seed-ofb          sm4-cbc           sm4-cfb
sm4-ctr           sm4-ecb           sm4-ofb

root@b892fc78f0ae:/tmp#
```

#### X509 Sub-Command

| Sub-Command           | Description                                                                             |
| --------------------- | --------------------------------------------------------------------------------------- |
| -help                 | Display this summary                                                                    |
| -inform format        | Input format - default PEM (one of DER or PEM)                                          |
| -in infile            | Input file - default stdin                                                              |
| -outform format       | Output format - default PEM (one of DER or PEM)                                         |
| -out outfile          | Output file - default stdout                                                            |
| -keyform PEM          | DER                                                                                     |
| -passin val           | Private key password/pass-phrase source                                                 |
| -serial               | Print serial number value                                                               |
| -subject\_hash        | Print subject hash value                                                                |
| -issuer\_hash         | Print issuer hash value                                                                 |
| -hash                 | Synonym for -subject\_hash                                                              |
| -subject              | Print subject DN                                                                        |
| -issuer               | Print issuer DN                                                                         |
| -email                | Print email address(es)                                                                 |
| -startdate            | Set notBefore field                                                                     |
| -enddate              | Set notAfter field                                                                      |
| -purpose              | Print out certificate purposes                                                          |
| -dates                | Both Before and After dates                                                             |
| -modulus              | Print the RSA key modulus                                                               |
| -pubkey               | Output the public key                                                                   |
| -fingerprint          | Print the certificate fingerprint                                                       |
| -alias                | Output certificate alias                                                                |
| -noout                | No output, just status                                                                  |
| -nocert               | No certificate output                                                                   |
| -ocspid               | Print OCSP hash values for the subject name and public key                              |
| -ocsp\_uri            | Print OCSP Responder URL(s)                                                             |
| -trustout             | Output a trusted certificate                                                            |
| -clrtrust             | Clear all trusted purposes                                                              |
| -clrext               | Clear all certificate extensions                                                        |
| -addtrust val         | Trust certificate for a given purpose                                                   |
| -addreject val        | Reject certificate for a given purpose                                                  |
| -setalias val         | Set certificate alias                                                                   |
| -days int             | How long till expiry of a signed certificate - def 30 days                              |
| -checkend intmax      | <p>Check whether the cert expires in the next arg seconds<br>Exit 1 if so, 0 if not</p> |
| -signkey val          | Self sign cert with arg                                                                 |
| -x509toreq            | Output a certification request object                                                   |
| -req                  | Input is a certificate request, sign and output                                         |
| -CA infile            | Set the CA certificate, must be PEM format                                              |
| -CAkey val            | The CA key, must be PEM format; if not in CAfile                                        |
| -CAcreateserial       | Create serial number file if it does not exist                                          |
| -CAserial val         | Serial file                                                                             |
| -set\_serial val      | Serial number to use                                                                    |
| -text                 | Print the certificate in text form                                                      |
| -ext val              | Print various X509V3 extensions                                                         |
| -C                    | Print out C code forms                                                                  |
| -extfile infile       | File with X509V3 extensions to add                                                      |
| -rand val             | Load the file(s) into the random number generator                                       |
| -writerand outfile    | Write random data to the specified file                                                 |
| -extensions val       | Section from config file to use                                                         |
| -nameopt val          | Various certificate name options                                                        |
| -certopt val          | Various certificate text options                                                        |
| -checkhost val        | Check certificate matches host                                                          |
| -checkemail val       | Check certificate matches email                                                         |
| -checkip val          | Check certificate matches ipaddr                                                        |
| -CAform PEM           | DER                                                                                     |
| -CAkeyform PEM        | DER                                                                                     |
| -sigopt val           | Signature parameter in n:v form                                                         |
| -force\_pubkey infile | Force the Key to put inside certificate                                                 |
| -next\_serial         | Increment current certificate serial number                                             |
| -clrreject            | Clears all the prohibited or rejected uses of the certificate                           |
| -badsig               | Corrupt last byte of certificate signature (for test)                                   |
| -\*                   | Any supported digest                                                                    |
| -subject\_hash\_old   | Print old-style (MD5) issuer hash value                                                 |
| -issuer\_hash\_old    | Print old-style (MD5) subject hash value                                                |
| -engine val           | Use engine, possibly a hardware device                                                  |
| -preserve\_dates      | preserve existing dates when signing                                                    |
