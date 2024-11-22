# Openssl Example

## OpenSSL을 사용한 암복호화 방법

### 1. Symmetric Key

#### 1-1. Generate Key

**1-1-1. Generate 128-size Key**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# head /dev/urandom | sha1sum
d10a5143d6ecdafd57af383760ddea5dc6f6d2d9  -
root@96c336b21c00:/#
```
{% endcode %}

**1-1-2. Generate 256-size Key**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# head /dev/urandom | sha256sum
7e12003b50ef320480cfcc7f92a73e830f1dfb3054f6df732c0733e04138d271  -
root@96c336b21c00:/#
```
{% endcode %}

#### 1-2. En/Decrypt

**1-2-1. Encrypt**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# cat sample.xml
<?xml version="1.0" ?>
<configuration>
	<gui>
		<mainWindow>
			<location x="0" y="25"></location>
			<size w="1860" h="1132"></size>
			<maximize>true</maximize>
		</mainWindow>
		<lookAndFeel>com.apple.laf.AquaLookAndFeel</lookAndFeel>
	</gui>
	
	... 
	
	<preferences>
		<JdGuiPreferences.errorBackgroundColor>0xFF6666</JdGuiPreferences.errorBackgroundColor>
		<JdGuiPreferences.jdCoreVersion>1.1.3</JdGuiPreferences.jdCoreVersion>
		<ViewerPreferences.fontSize>13</ViewerPreferences.fontSize>
	</preferences>
</configuration>
root@96c336b21c00:/# openssl enc -aes-256-cbc -K 1959c51ea294412b8bb238a446e9d4be744cf91c54f045c9caf8fe433dba1e01  -iv 302775dfc35a35c8081bbc6fdeacbd86 -a -e -in sample.xml -out result.enc
root@aabc2ffe1c3e:/# cat result.enc | base64
YVVUQ1JFSnJkdkNzZk9xSlBPMWZicU41OUZXMGFqMUt3WnhacGplQkVweHIwdU9FTUtidEZlZXky
b0Z2VkdCWQorYVFMYUtGR0Njc0Z3NGZDQlZKYStoTGVZTTg3NzZWOFhvZ2NCM092SUlFanpNUlFl
N3VMWjY0VGp2alNrbS8xCklnK1JxeDRONEJqMkNEY3J0SWlmM0pkdXFYN3NZemJXV3JCV3h2Nnk5
VEVUSjlLU2psY2VsaUxKYnFrMWtqSzkKMkVyeWdoZTR5Q0x5a3U5dXRCL0lRRUZiaW9aaFM4QWRK
cGwvZnd2ZDhzSU83Sm5YeE9hN2dUTHpQRitpZWlONgpoQkV3SFR4Y3FwV1B1b3dmdnhreW1EMHNP
THFBK0RuV3g1emlOYS9uV1YyREM1eEFyci9rbUpJcDVXYmx0ZnBBCkk4aXNnczhVdmdOQk9tRllt
YXExNVBWbDV1WURkelloS3VqNWw5ZGhyUWpOMERhUEN4Nkh1L0RmaCsrVHZJUHYKM3B2aEFtNWJv
QXdXYzZxUUp0RURkdEtCTFIrdjdPUWN1QlJhMUxYbVUxejRrbnNORHFtSHVwRDd3c1NNdm9oNgpv
clI1Z1JrZzRIbWNBL3FRQ2JBeFlKSHo5aTdmVzhXeFF1cU5NNTRiM0tYTFR1Y0x2bFBUZzV4UE92
eUJsYXRVCmdnMExPZDhTb2xVeWppZHhCUitMNHZYcHV5ell1VG13UmpyeXNIakVjWThYS0JFYnJG
Ny9KL20yejJBTWpBRmMKVHErenFibUFXaTB3VHVnZVlGRVp6dS9HMlpQQUJCZXdPZVVtUlIrUW9y
bHB2anpraUhYUmYzZ0MzS2dIU0lKcgpvcXd3YXp5c0RIWnB4RmNpcEQyUWsrQVFuTnBOM0xqdkpK
R0g1VEF6T1VSVVFIZjRCRC9RODg1c1o2cy9ZNjRRCnNhdnNmT0pDWjg1Um9hUko0MXY2V1V2NHk1
TU12WUkvclFlUk1haHk4MnlZN3Q1ZDJNRStLV3IrRmp2WmRON3EKaUV4RkdWMEtIeVNQTG5FRnlM
MXFQdWVYZ0dzb08zUDVYVG5ZZkdSZzVTRlJuRjJncWlEMENwV2YrejJaWEtleApXKzlDMTZqRURm
UWZDNFRsMVZnbUZ4K0VJNjNlU3k0dG1hWjVldXFLclBJU2hCbnpTczg0QjNUUGNyRllBNmtVCjlw
T0dTVDU5WG9LZ2lxd0JNS0hlTjhXRjlqRDN4NVhkU0p3ZW02d2RUZUJxVHR3T0ZtNDFPNzI2M1JZ
SC9BUHkKSEgzVDk0UEZxVklIMEZDWitDY3U2MEIzd25mbDJYamhVU1U1TkdTT1J4aWlweFcvRzRp
ekdXaHBzREErSWE0Tgp2aFA2RmJweEp0UUZuQ2lYRjBQNlFyTUpDQ0lvcHJYV2U3UmV3dHUrU1Rl
N3RtTUFZcUdod0w0RjR0N2NSY0hnCkVveHArOFhPc210TUpqWjRKZDdiWGxZOUtQMGhiam56TURm
ZTVLdnZ2UVROc2U5Z1Z4WWdzWkVOOG55OU9QZkUKNkFTNjlsaHNDVlFWa1psaERYZU5zUm5DUXpC
UXVvNU9vZ0xoYmp6RzBmanZrQmZNUGVsd0pQek9pZnNkdVU1bApvZlRMQmhER0IvZHYrLyt2bGM2
M3psT2FiRW9WN3VLQkNpTjFlTzFsdnFQd0tXMmhpRDBHczJYejg4Y2lpRG0vCitMSGNBcVo0R3Uw
WmN3dFFneEo2cmwzWDRqcnN6Vkg3QTlhc2hMRklMSEtPY3psMFhBMGtyM1lWeEZtWFZscU0KdWgx
NGQwWXhTM1lLckF4S3BvVlB3SnFkN2RHakFCSEFid3lNWFZTRWwySzhralk4eXJHV3UzVzd4Q0pG
R01YdApiM0dUVUdzUkNLV2U5MlUxUEpzb3ZieVRnUkxEUVpkMXA1OE5uYlZlSDFVWFZEVDkxbUd6
bnpKSnFxbkFNQU9NCm9ic1kxNFc5d2tzbzJJMW9oODQxSXZseUJycFNXWEI5MmRWNFZCdWN1Smha
dDIyWERFbVZ2Yy8ydzZCMm5JYWUKaWRUSmtGSUNGbFArTHlKK3VZMUJoYUFiaXJzcDRrQVphc1pH
NEYxZkhlVT0K
```
{% endcode %}

**1-2-2. Decrypt**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@aabc2ffe1c3e:/# openssl enc -aes-256-cbc -K 1959c51ea294412b8bb238a446e9d4be744cf91c54f045c9caf8fe433dba1e01  -iv 302775dfc35a35c8081bbc6fdeacbd86 -a -d -in result.enc -out plain.xml
root@aabc2ffe1c3e:/# cat plain.xml
<?xml version="1.0" ?>
<configuration>
	<gui>
		<mainWindow>
			<location x="0" y="25"></location>
			<size w="1860" h="1132"></size>
			<maximize>true</maximize>
		</mainWindow>
		<lookAndFeel>com.apple.laf.AquaLookAndFeel</lookAndFeel>
	</gui>
	
	...
	
	<preferences>
		<JdGuiPreferences.errorBackgroundColor>0xFF6666</JdGuiPreferences.errorBackgroundColor>
		<JdGuiPreferences.jdCoreVersion>1.1.3</JdGuiPreferences.jdCoreVersion>
		<ViewerPreferences.fontSize>13</ViewerPreferences.fontSize>
	</preferences>
</configuration>
```
{% endcode %}

### 2. Asymmetric Key

#### 2-1. RSA

**2-1-1. Generate Key Pair**

**2-1-1-1. Generate Private Key**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl genrsa -out rsa_2048_pri.key 2048
root@96c336b21c00:/# cat rsa_2048_pri.key
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDIpMUBNr5gIMUw
dfuBUJ8Nv5UrMHmxebv8AQlq5Zcd/lknPYgNK+NtJnyj5HmQ7pQnXf34EIP0Edhw
ZFFBXXbI5PW7w1GIP5VlDvK6CqIeXO5yEkSgDplj84H+C2/m9pZ4aLTl3/VRqfTV
jbh44gFPDgjZ4xTYDiHsIN1vLQvneK4jLcE8aWXn+8jUh2oDfKBsmovu1BxHV8w6
nAAy4VF62mY2t/8MsIpBzUOH62lX+5ZPxhSWcDiehufYy3KQrZDFDdfCucbLA16m
OW87P+ptemD3T/QXhONlC4+iOdSIZ0WjvxrTOMva17UUsk3xRbycDv4TfaSjr7YF
O7JyxSAZAgMBAAECggEAEV2jeHCsxwSnFIPtpfpcndPCXSfXrIrxAIV1c3VWIEAy
prEObLdq+ng9ivDcLbVciNC7icQiK5Z80XN5TetBO++HLj5gOObp7wJ9cyk28WJR
N/nJS0IgOBSsIFkMkSSwDtFfMNMyuCP53x7iQ8Ip41X/YZ5kIDQO7xFEIRp4wIqb
6K63owz4ZLv8o6h7wbjwSXWevCpl/OSbocFsFtaIr101dP5jKc7WdxgOqakS8yR2
/aih5tm0KBywqYCid/JUefo57EW3v4GuMUmIeeYKG1lth88GX2qhnFNBMuiB9CNU
T3USp+4bkjh7JbQyyrOFbcY9K7Ic/gkNuF0UomIXRQKBgQDm78wmAwujmv/+bsSd
otB4O4cEPzXgWQLJZeQTwwQLCYxNkFtwsgIurhDov1+Wy14bgNOIGZ/ypE5KTKWv
Hna0oB37Wn0fVcQVScD/mQGsYuwOl7G6dJnOlYSK4d9hvn6OjTYO18rh9SpJSOVT
jJ5/ExZ6+ccKQGwE1a70gor2lQKBgQDea1P2SdLEJzamANcZrfDhnwLBNIO5MWe6
eq17hwudCG8yiQKcuE6wKFT095AjjSwAJTNPeyw6v3R1mNDzUPYK5gCkrjUvEc1U
n4PgXYSGHz9VvIf0odih4kwQVOhCZo+MR1bvEzDT0vfFTpyKVb7fVMpjwlvYbR+q
To2cX4M2dQKBgBdzXFiz0HfBoqM0nlSflunOqaw9uvvYLhdDeIClOgDg7FVoBlEQ
UnZpCKCJ5mwKpLjIQTK932clVinnVJ/OySEYbVL74l7PN8UtoyKRaAEYXn4w20Ri
2MeImVf9DdEAJhvVrRqewSRm3+9nLppoWiPvTUYZnSOmXRG0nTqJExFtAoGBAJq2
h6Hy+hQNvtq8DOPE9aDLrevc7p+ceS3i9dfOOUrTOh4p5dJD9iBc/bOknPPN2ESF
m+p2oG6BDK5cTURjFbLBCMOElmQWewCZMO+ZvXxaMgEecme9SOZadlSJ60F8++81
FIiajcVao5TwuL0VJf9NiLbZ1G94gKVDnQef/LKdAoGAKRHt9fwUeLKC+CTHz7HS
RmDbi1obbNeFW4n5UO6yxoZ9y3+x676HzHIj6zd+6h0BLbobFw+jtUVXhTGpy24n
gzjZHLvnjIit2wbhDaTQyXOZ93QNiSruBoWzccyVQMpyGhpbe7PeIFRSxOLVzSkh
4SHuZX0ndIYct5szwhuh75A=
-----END PRIVATE KEY-----
root@96c336b21c00:/# openssl rsa -noout -text -in rsa_2048_pri.key
Private-Key: (2048 bit, 2 primes)
modulus:
    00:c8:a4:c5:01:36:be:60:20:c5:30:75:fb:81:50:
    9f:0d:bf:95:2b:30:79:b1:79:bb:fc:01:09:6a:e5:
    97:1d:fe:59:27:3d:88:0d:2b:e3:6d:26:7c:a3:e4:
    79:90:ee:94:27:5d:fd:f8:10:83:f4:11:d8:70:64:
    51:41:5d:76:c8:e4:f5:bb:c3:51:88:3f:95:65:0e:
    f2:ba:0a:a2:1e:5c:ee:72:12:44:a0:0e:99:63:f3:
    81:fe:0b:6f:e6:f6:96:78:68:b4:e5:df:f5:51:a9:
    f4:d5:8d:b8:78:e2:01:4f:0e:08:d9:e3:14:d8:0e:
    21:ec:20:dd:6f:2d:0b:e7:78:ae:23:2d:c1:3c:69:
    65:e7:fb:c8:d4:87:6a:03:7c:a0:6c:9a:8b:ee:d4:
    1c:47:57:cc:3a:9c:00:32:e1:51:7a:da:66:36:b7:
    ff:0c:b0:8a:41:cd:43:87:eb:69:57:fb:96:4f:c6:
    14:96:70:38:9e:86:e7:d8:cb:72:90:ad:90:c5:0d:
    d7:c2:b9:c6:cb:03:5e:a6:39:6f:3b:3f:ea:6d:7a:
    60:f7:4f:f4:17:84:e3:65:0b:8f:a2:39:d4:88:67:
    45:a3:bf:1a:d3:38:cb:da:d7:b5:14:b2:4d:f1:45:
    bc:9c:0e:fe:13:7d:a4:a3:af:b6:05:3b:b2:72:c5:
    20:19
publicExponent: 65537 (0x10001)
privateExponent:
    11:5d:a3:78:70:ac:c7:04:a7:14:83:ed:a5:fa:5c:
    9d:d3:c2:5d:27:d7:ac:8a:f1:00:85:75:73:75:56:
    
    ...
    
coefficient:
    29:11:ed:f5:fc:14:78:b2:82:f8:24:c7:cf:b1:d2:
    46:60:db:8b:5a:1b:6c:d7:85:5b:89:f9:50:ee:b2:
    c6:86:7d:cb:7f:b1:eb:be:87:cc:72:23:eb:37:7e:
    ea:1d:01:2d:ba:1b:17:0f:a3:b5:45:57:85:31:a9:
    cb:6e:27:83:38:d9:1c:bb:e7:8c:88:ad:db:06:e1:
    0d:a4:d0:c9:73:99:f7:74:0d:89:2a:ee:06:85:b3:
    71:cc:95:40:ca:72:1a:1a:5b:7b:b3:de:20:54:52:
    c4:e2:d5:cd:29:21:e1:21:ee:65:7d:27:74:86:1c:
    b7:9b:33:c2:1b:a1:ef:90    
```
{% endcode %}

**2-1-1-2. Generate Public Key**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl rsa -in rsa_2048_pri.key -pubout -out rsa_2048_pub.key
writing RSA key
root@96c336b21c00:/# cat rsa_2048_pub.key
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyKTFATa+YCDFMHX7gVCf
Db+VKzB5sXm7/AEJauWXHf5ZJz2IDSvjbSZ8o+R5kO6UJ139+BCD9BHYcGRRQV12
yOT1u8NRiD+VZQ7yugqiHlzuchJEoA6ZY/OB/gtv5vaWeGi05d/1Uan01Y24eOIB
Tw4I2eMU2A4h7CDdby0L53iuIy3BPGll5/vI1IdqA3ygbJqL7tQcR1fMOpwAMuFR
etpmNrf/DLCKQc1Dh+tpV/uWT8YUlnA4nobn2MtykK2QxQ3XwrnGywNepjlvOz/q
bXpg90/0F4TjZQuPojnUiGdFo78a0zjL2te1FLJN8UW8nA7+E32ko6+2BTuycsUg
GQIDAQAB
-----END PUBLIC KEY-----
root@96c336b21c00:/# openssl rsa -noout -text -pubin -in rsa_2048_pub.key
Public-Key: (2048 bit)
Modulus:
    00:c8:a4:c5:01:36:be:60:20:c5:30:75:fb:81:50:
    9f:0d:bf:95:2b:30:79:b1:79:bb:fc:01:09:6a:e5:
    97:1d:fe:59:27:3d:88:0d:2b:e3:6d:26:7c:a3:e4:
    79:90:ee:94:27:5d:fd:f8:10:83:f4:11:d8:70:64:
    51:41:5d:76:c8:e4:f5:bb:c3:51:88:3f:95:65:0e:
    f2:ba:0a:a2:1e:5c:ee:72:12:44:a0:0e:99:63:f3:
    81:fe:0b:6f:e6:f6:96:78:68:b4:e5:df:f5:51:a9:
    f4:d5:8d:b8:78:e2:01:4f:0e:08:d9:e3:14:d8:0e:
    21:ec:20:dd:6f:2d:0b:e7:78:ae:23:2d:c1:3c:69:
    65:e7:fb:c8:d4:87:6a:03:7c:a0:6c:9a:8b:ee:d4:
    1c:47:57:cc:3a:9c:00:32:e1:51:7a:da:66:36:b7:
    ff:0c:b0:8a:41:cd:43:87:eb:69:57:fb:96:4f:c6:
    14:96:70:38:9e:86:e7:d8:cb:72:90:ad:90:c5:0d:
    d7:c2:b9:c6:cb:03:5e:a6:39:6f:3b:3f:ea:6d:7a:
    60:f7:4f:f4:17:84:e3:65:0b:8f:a2:39:d4:88:67:
    45:a3:bf:1a:d3:38:cb:da:d7:b5:14:b2:4d:f1:45:
    bc:9c:0e:fe:13:7d:a4:a3:af:b6:05:3b:b2:72:c5:
    20:19
Exponent: 65537 (0x10001)
```
{% endcode %}

**2-1-1-3. Generate Self-Signed Cert**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl req -new -x509 -key rsa_2048_pri.key -out rsa-cert.pem -days 365
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
root@96c336b21c00:/# cat rsa-cert.pem
-----BEGIN CERTIFICATE-----
MIIDazCCAlOgAwIBAgIUd8sOwbttyvcD85XrYr+m+Ya+fh8wDQYJKoZIhvcNAQEL
BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yNDExMjIwNjIzMzRaFw0yNTEx
MjIwNjIzMzRaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEw
HwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDIpMUBNr5gIMUwdfuBUJ8Nv5UrMHmxebv8AQlq5Zcd
/lknPYgNK+NtJnyj5HmQ7pQnXf34EIP0EdhwZFFBXXbI5PW7w1GIP5VlDvK6CqIe
XO5yEkSgDplj84H+C2/m9pZ4aLTl3/VRqfTVjbh44gFPDgjZ4xTYDiHsIN1vLQvn
eK4jLcE8aWXn+8jUh2oDfKBsmovu1BxHV8w6nAAy4VF62mY2t/8MsIpBzUOH62lX
+5ZPxhSWcDiehufYy3KQrZDFDdfCucbLA16mOW87P+ptemD3T/QXhONlC4+iOdSI
Z0WjvxrTOMva17UUsk3xRbycDv4TfaSjr7YFO7JyxSAZAgMBAAGjUzBRMB0GA1Ud
DgQWBBRzzJw5hPR8ZGHsA+j1UwSLwd0XKDAfBgNVHSMEGDAWgBRzzJw5hPR8ZGHs
A+j1UwSLwd0XKDAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQCb
MIEf00FmTPsLiz1CXAVeD3hKubvJVDE/mtMrnw/LFgieRe2HYEx3zg+aKnsV2A1/
cXj2ln4mXcqPcrmF3U8qVucl4eiJmAiE99t0/FFml1tfqXATo/ThpCZfLYlV6+Tl
78bVvqYu8SeN+WUdgb7cZMLUh1A4mOxgtGMFYpPXeFreZ+HSnis42ACtHKi2VeHw
xLcXmTL4KBIhtl41nQnqHt7ikzICG2lwxwA/1zofwTJdythVw0T19zbnu9zaCdk6
ig3n81fSE1HaYO0YMZeUNKARJo+ge7Wgr7NeB9OOtyoZR/fNuibQE29fbVufUUEu
2U234ZGPdx3VNMoAt0lb
-----END CERTIFICATE-----
root@96c336b21c00:/# openssl x509 -noout -text -in rsa-cert.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            77:cb:0e:c1:bb:6d:ca:f7:03:f3:95:eb:62:bf:a6:f9:86:be:7e:1f
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = AU, ST = Some-State, O = Internet Widgits Pty Ltd
        Validity
            Not Before: Nov 22 06:23:34 2024 GMT
            Not After : Nov 22 06:23:34 2025 GMT
        Subject: C = AU, ST = Some-State, O = Internet Widgits Pty Ltd
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c8:a4:c5:01:36:be:60:20:c5:30:75:fb:81:50:
                    9f:0d:bf:95:2b:30:79:b1:79:bb:fc:01:09:6a:e5:
                    97:1d:fe:59:27:3d:88:0d:2b:e3:6d:26:7c:a3:e4:
                    79:90:ee:94:27:5d:fd:f8:10:83:f4:11:d8:70:64:
                    51:41:5d:76:c8:e4:f5:bb:c3:51:88:3f:95:65:0e:
                    f2:ba:0a:a2:1e:5c:ee:72:12:44:a0:0e:99:63:f3:
                    81:fe:0b:6f:e6:f6:96:78:68:b4:e5:df:f5:51:a9:
                    f4:d5:8d:b8:78:e2:01:4f:0e:08:d9:e3:14:d8:0e:
                    21:ec:20:dd:6f:2d:0b:e7:78:ae:23:2d:c1:3c:69:
                    65:e7:fb:c8:d4:87:6a:03:7c:a0:6c:9a:8b:ee:d4:
                    1c:47:57:cc:3a:9c:00:32:e1:51:7a:da:66:36:b7:
                    ff:0c:b0:8a:41:cd:43:87:eb:69:57:fb:96:4f:c6:
                    14:96:70:38:9e:86:e7:d8:cb:72:90:ad:90:c5:0d:
                    d7:c2:b9:c6:cb:03:5e:a6:39:6f:3b:3f:ea:6d:7a:
                    60:f7:4f:f4:17:84:e3:65:0b:8f:a2:39:d4:88:67:
                    45:a3:bf:1a:d3:38:cb:da:d7:b5:14:b2:4d:f1:45:
                    bc:9c:0e:fe:13:7d:a4:a3:af:b6:05:3b:b2:72:c5:
                    20:19
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                73:CC:9C:39:84:F4:7C:64:61:EC:03:E8:F5:53:04:8B:C1:DD:17:28
            X509v3 Authority Key Identifier:
                73:CC:9C:39:84:F4:7C:64:61:EC:03:E8:F5:53:04:8B:C1:DD:17:28
            X509v3 Basic Constraints: critical
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        9b:30:81:1f:d3:41:66:4c:fb:0b:8b:3d:42:5c:05:5e:0f:78:
        4a:b9:bb:c9:54:31:3f:9a:d3:2b:9f:0f:cb:16:08:9e:45:ed:
        87:60:4c:77:ce:0f:9a:2a:7b:15:d8:0d:7f:71:78:f6:96:7e:
        26:5d:ca:8f:72:b9:85:dd:4f:2a:56:e7:25:e1:e8:89:98:08:
        84:f7:db:74:fc:51:66:97:5b:5f:a9:70:13:a3:f4:e1:a4:26:
        5f:2d:89:55:eb:e4:e5:ef:c6:d5:be:a6:2e:f1:27:8d:f9:65:
        1d:81:be:dc:64:c2:d4:87:50:38:98:ec:60:b4:63:05:62:93:
        d7:78:5a:de:67:e1:d2:9e:2b:38:d8:00:ad:1c:a8:b6:55:e1:
        f0:c4:b7:17:99:32:f8:28:12:21:b6:5e:35:9d:09:ea:1e:de:
        e2:93:32:02:1b:69:70:c7:00:3f:d7:3a:1f:c1:32:5d:ca:d8:
        55:c3:44:f5:f7:36:e7:bb:dc:da:09:d9:3a:8a:0d:e7:f3:57:
        d2:13:51:da:60:ed:18:31:97:94:34:a0:11:26:8f:a0:7b:b5:
        a0:af:b3:5e:07:d3:8e:b7:2a:19:47:f7:cd:ba:26:d0:13:6f:
        5f:6d:5b:9f:51:41:2e:d9:4d:b7:e1:91:8f:77:1d:d5:34:ca:
        00:b7:49:5b
```
{% endcode %}

**2-1-2. En/Decrypt and Sign/Verify**

**2-1-2-1. Public Key Encrypt**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# cat sample.txt
hello world
root@96c336b21c00:/# openssl rsautl -encrypt -inkey rsa_2048_pub.key -pubin -in sample.xml -out result.enc
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
root@96c336b21c00:/# cat result.enc |base64
RdecpHOtZEVdyTO6fjaH2Z5AXIdpIabjEobPfhVDvRg8gbeKrsqMvzUsnQiDIFsaWfIrhkcasYUA
KDN3hygtD4mhn+r9SSCWJv61U1fOeAAum3UQQyDNTmW5NELqWKCTgVKiGoAOnwOAupvshM2Q+oep
ya81GO8YShfAZ4tac4i8cqmsIRf96qYC5Btys/NoqvhDalkT/ldRQ4m9jwGFMMNrPJwbR4P2MwVW
cSHQsqc0vbAILgu/bpEV9CWJv1xH4MPymoopSpHTQEx6+BbHbTcVb03F9nfut/33xbFiw1Lrc6vf
NKyHofqu7Pxj8LemxuA+JdLOVnwbbGUIL/Eldw==
```
{% endcode %}

**2-1-2-2. Private Key Decrypt**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl rsautl -decrypt -inkey rsa_2048_pri.key -in result.enc -out plain.txt
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
root@96c336b21c00:/# cat plain.txt
hello world
```
{% endcode %}

**2-1-2-3. Private Key Sign**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl dgst -sha256 -sign rsa_2048_pri.key -out sha256.sign sample.xml
root@96c336b21c00:/# cat sha256.sign | base64
tZ/2zbpd0pG6ZFie774vyQTxy2h6ttx1K+bOuzgjRRtCmpwtk/mlxHn7L0TG3gvtmGYzAlxVwmPg
1F7LueAehawVLjaquRV/d3Res8kmFnCFkR664PyCHU+5hqn5w0Rfl3vIHoApwjc7FT8zfBvhoJ3M
xBk2wssJJY6yYesmspIdpGGwaoep+L3HsYdk0J2qi9VQNDt1PxbusB3x2+FR8yxNIcG/xWMf/3hh
93cEml0ym17b5y19hFmz5HMghS7uk24esL1o4BzZUPBUUbZpEp1uzkQxT3jeo+J+RASRqB5T5xIS
HSrnnDCUQavsurq9Acw33MQuUXPx2EFWS8U1Gw==
```
{% endcode %}

**2-1-2-4. Public Key Verify**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl dgst -sha256 -verify rsa_2048_pub.key -signature sha256.sign sample.xml
Verified OK
```
{% endcode %}

#### 2-2. EC

**2-2-1. Generate Key Pair**

**2-2-1-1. Generate Private Key**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl ecparam -name prime256v1 -genkey -noout -out ec-private-key.pem
root@96c336b21c00:/# cat ec-private-key.pem
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIN2zONAjTzJfE+I1B5UACDnrqgQzdSaAnPuppJcTinCqoAoGCCqGSM49
AwEHoUQDQgAEgkare3cxqVMXsrGBrhp9GDd0c6McFdCeigkxqX2Ehsi50XlLJxNN
aVpc5dBZrpFFOuF/8h6XTREGXqJhYoPpSg==
-----END EC PRIVATE KEY-----
root@96c336b21c00:/# openssl ec -noout -text -in ec-private-key.pem
read EC key
Private-Key: (256 bit)
priv:
    dd:b3:38:d0:23:4f:32:5f:13:e2:35:07:95:00:08:
    39:eb:aa:04:33:75:26:80:9c:fb:a9:a4:97:13:8a:
    70:aa
pub:
    04:82:46:ab:7b:77:31:a9:53:17:b2:b1:81:ae:1a:
    7d:18:37:74:73:a3:1c:15:d0:9e:8a:09:31:a9:7d:
    84:86:c8:b9:d1:79:4b:27:13:4d:69:5a:5c:e5:d0:
    59:ae:91:45:3a:e1:7f:f2:1e:97:4d:11:06:5e:a2:
    61:62:83:e9:4a
ASN1 OID: prime256v1
NIST CURVE: P-256
```
{% endcode %}

**2-2-1-2. Generate Public Key**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl ec -in ec-private-key.pem -pubout -out ec-public-key.pem
read EC key
writing EC key
root@96c336b21c00:/# cat ec-public-key.pem
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEgkare3cxqVMXsrGBrhp9GDd0c6Mc
FdCeigkxqX2Ehsi50XlLJxNNaVpc5dBZrpFFOuF/8h6XTREGXqJhYoPpSg==
-----END PUBLIC KEY-----
root@96c336b21c00:/# openssl ec -noout -text -pubin -in ec-public-key.pem
read EC key
Public-Key: (256 bit)
pub:
    04:82:46:ab:7b:77:31:a9:53:17:b2:b1:81:ae:1a:
    7d:18:37:74:73:a3:1c:15:d0:9e:8a:09:31:a9:7d:
    84:86:c8:b9:d1:79:4b:27:13:4d:69:5a:5c:e5:d0:
    59:ae:91:45:3a:e1:7f:f2:1e:97:4d:11:06:5e:a2:
    61:62:83:e9:4a
ASN1 OID: prime256v1
NIST CURVE: P-256
```
{% endcode %}

**2-2-1-2. Generate Self-Signed Cert**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl req -new -x509 -key ec-private-key.pem -out ec-cert.pem -days 365
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
root@96c336b21c00:/# cat ec-cert.pem
-----BEGIN CERTIFICATE-----
MIIB4DCCAYWgAwIBAgIUUi+8vF+kssVO+FRXWprS5Pl9OU0wCgYIKoZIzj0EAwIw
RTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoMGElu
dGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yNDExMjIwNjIyMDlaFw0yNTExMjIw
NjIyMDlaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYD
VQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwWTATBgcqhkjOPQIBBggqhkjO
PQMBBwNCAASCRqt7dzGpUxeysYGuGn0YN3RzoxwV0J6KCTGpfYSGyLnReUsnE01p
Wlzl0FmukUU64X/yHpdNEQZeomFig+lKo1MwUTAdBgNVHQ4EFgQU85xL4OqkpLHi
iyCZK2oZ/FqhDu8wHwYDVR0jBBgwFoAU85xL4OqkpLHiiyCZK2oZ/FqhDu8wDwYD
VR0TAQH/BAUwAwEB/zAKBggqhkjOPQQDAgNJADBGAiEAwEWvL9Ci7xXVQZs/z+Z1
qk3WFhH4fGvJla+bMYk5xCwCIQD/IMrXd8l5TQg1ttoCxMDBnEtrOhc+wosjMCqg
1qS++w==
-----END CERTIFICATE-----
root@96c336b21c00:/# openssl x509 -noout -text -in ec-cert.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            52:2f:bc:bc:5f:a4:b2:c5:4e:f8:54:57:5a:9a:d2:e4:f9:7d:39:4d
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: C = AU, ST = Some-State, O = Internet Widgits Pty Ltd
        Validity
            Not Before: Nov 22 06:22:09 2024 GMT
            Not After : Nov 22 06:22:09 2025 GMT
        Subject: C = AU, ST = Some-State, O = Internet Widgits Pty Ltd
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:82:46:ab:7b:77:31:a9:53:17:b2:b1:81:ae:1a:
                    7d:18:37:74:73:a3:1c:15:d0:9e:8a:09:31:a9:7d:
                    84:86:c8:b9:d1:79:4b:27:13:4d:69:5a:5c:e5:d0:
                    59:ae:91:45:3a:e1:7f:f2:1e:97:4d:11:06:5e:a2:
                    61:62:83:e9:4a
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                F3:9C:4B:E0:EA:A4:A4:B1:E2:8B:20:99:2B:6A:19:FC:5A:A1:0E:EF
            X509v3 Authority Key Identifier:
                F3:9C:4B:E0:EA:A4:A4:B1:E2:8B:20:99:2B:6A:19:FC:5A:A1:0E:EF
            X509v3 Basic Constraints: critical
                CA:TRUE
    Signature Algorithm: ecdsa-with-SHA256
    Signature Value:
        30:46:02:21:00:c0:45:af:2f:d0:a2:ef:15:d5:41:9b:3f:cf:
        e6:75:aa:4d:d6:16:11:f8:7c:6b:c9:95:af:9b:31:89:39:c4:
        2c:02:21:00:ff:20:ca:d7:77:c9:79:4d:08:35:b6:da:02:c4:
        c0:c1:9c:4b:6b:3a:17:3e:c2:8b:23:30:2a:a0:d6:a4:be:fb
```
{% endcode %}

**2-2-2. Sign/Verify**

**2-2-2-1. Private Key Sign**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl dgst -sha256 -sign ec-private-key.pem -out ec-sha256.sign sample.xml
root@96c336b21c00:/# cat ec-sha256.sign | base64
MEUCIFHhUOPDC0l3ntkjX8ouEPfQGwbwacGCUesIGcFIvT81AiEA6wmTFZxZLnniy9IEpodyrhJe
pSdvZHv9VLro2Y1MYd0=
```
{% endcode %}

**2-2-2-2. Private Key Verify**

{% code overflow="wrap" fullWidth="false" %}
```bash
root@96c336b21c00:/# openssl dgst -sha256 -verify ec-public-key.pem -signature ec-sha256.sign sample.xml
Verified OK
```
{% endcode %}

## Reference

* Symmetric cipher commands
  * [https://docs.openssl.org/1.1.1/man1/enc/](https://docs.openssl.org/1.1.1/man1/enc/)
* Genarates an RSA private key
  * [https://docs.openssl.org/1.1.1/man1/genrsa/](https://docs.openssl.org/1.1.1/man1/genrsa/)
* Processes RSA Keys
  * [https://docs.openssl.org/1.1.1/man1/rsa/](https://docs.openssl.org/1.1.1/man1/rsa/)
* Processes EC Keys
  * [https://docs.openssl.org/1.1.1/man1/ec/](https://docs.openssl.org/1.1.1/man1/ec/)
* Manipulate or Generate EC parameter files
  * [https://docs.openssl.org/1.1.1/man1/ecparam/](https://docs.openssl.org/1.1.1/man1/ecparam/)
* Creates and processes certificate requests in PKCS#10 format
  * [https://docs.openssl.org/1.1.1/man1/req/](https://docs.openssl.org/1.1.1/man1/req/)
* Message digest
  * [https://docs.openssl.org/1.1.1/man1/dgst/](https://docs.openssl.org/1.1.1/man1/dgst/)
* Sign, Verify, Encrypt and Decrypt data using the RSA algorithm
  * [https://docs.openssl.org/1.1.1/man1/rsautl/](https://docs.openssl.org/1.1.1/man1/rsautl/)
