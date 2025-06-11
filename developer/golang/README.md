# GoLang

## Golang gRPC with mutual TLS



### 개요

본 문서는 Golang언어로 gRPC 통신에 사용하기 위한 mTLS를 구축하는 예시 코드를 기술한다. mTLS는 mutual TLS의 약어로, 서버-클라이언트 간의 양방향 인증을 수행하는 방식을 말한다.



### 준비사항

mTLS를 구현하기 위해서는 다음의 인증서를 준비해야 한다.

* `rootCA.crt`: 루트 인증서
* `server.crt`, `server.key`: 루트의 개인키로 서명된 서버용 인증서
* `client.crt`, `client.key`: 루트의 개인키로 서명된 클라이언트용 인증서

&#x20;

본 문서에서는 인증서를 생성하기 위한 방법에 대해서는 기술하지 않고, 만들어진 인증서를 사용하여 코드를 작성하는 부분을 기술한다.



### Source Code

#### Server Source

```go
func main(){
    port := 40000
    ip := "0.0.0.0"
 
    rootCAFile := "./test/certs/rootCa.crt"
    certFile := "./test/certs/server.crt"
    keyFile := "./test/certs/server.key"
 
    // read keypair
    x509KeyPair, err := tls.LoadX509KeyPair(certFile, keyFile)
 
    // read rootCA
    rootCACertData, err := os.ReadFile(rootCAFile)
    if err != nil {
        log.Fatal(err)
    }
 
    // create cert pool
    certPool := x509.NewCertPool()
    certPool.AppendCertsFromPEM(rootCACertData)
 
    // create cert pool
    certPool := x509.NewCertPool()
    certPool.AppendCertsFromPEM(rootCACertData)
 
    // create tls config
    tlsConfig := &tls.Config{
        Certificates: []tls.Certificate{x509KeyPair},
        ClientCAs:    certPool,
        CipherSuites: []uint16{
            tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
            tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
        },
        ClientAuth: tls.RequireAndVerifyClientCert,
    }
    tlsCredentials := credentials.NewTLS(tlsConfig)   
 
 
    // create listener
    serverAddress := fmt.Sprintf("%s:%d", ip, port)
    lis, err := net.Listen("tcp", serverAddress)
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
 
    // create server
 
    grpcServer := grpc.NewServer(grpc.Creds(tlsCredentials))
 
    // register service
    // pma.NewEventListenerService()는 gRPC로 구현된 서비스 객체이다.
    pm.RegisterPmAgentEventServiceServer(grpcServer, pma.NewEventListenerService())
 
    fmt.Printf("PM Server Start listen...%s\n", serverAddress)
 
    // start server
    grpcServer.Serve(lis)     
}

```

#### Client Source

```go
func main(){
    serverPort := 40000
    serverIp := "127.0.0.1"
 
    rootCAFile := "./test/certs/rootCa.crt"
    certFile := "./test/certs/client.crt"
    keyFile := "./test/certs/client.key"
 
    // read keypair
    x509KeyPair, err := tls.LoadX509KeyPair(certFile, keyFile)
 
    // read rootCA
    rootCACertData, err := os.ReadFile(rootCAFile)
    if err != nil {
        log.Fatal(err)
    }
 
    // create cert pool
    certPool := x509.NewCertPool()
    certPool.AppendCertsFromPEM(rootCACertData)
 
    // Setup HTTPS client
    tlsConfig := &tls.Config{
        Certificates: []tls.Certificate{clientCert},
        RootCAs:      certPool,
        ServerName:   "server", // server.crt의 cn 값 혹은 SAN에 해당하는 값을 넣는다.
    }
    tlsCredential := credentials.NewTLS(tlsConfig)
 
 
    // keep alive time
    keepaliveClientParams := keepalive.ClientParameters{
        Time:                10 * time.Second, // send pings every 10 seconds if there is no activity
        Timeout:             1 * time.Second,  // wait 1 second for ping ack before considering the connection dead
        PermitWithoutStream: true,             // send pings even without active streams
    }
 
    // tls
    var opts []grpc.DialOption
    opts = append(opts, grpc.WithTransportCredentials(tlsCredential))
    opts = append(opts, grpc.WithDefaultServiceConfig(`{"loadBalancingPolicy":"pick_first"}`))
    opts = append(opts, grpc.WithKeepaliveParams(keepaliveClientParams))
 
 
    conn, err := grpc.NewClient(fmt.Sprintf("%s:%d", serverIp, serverPort), opts...)
    if err != nil {
        log.Fatal(err)
    }
 
 
    // TODO: something with conn
 
    ....
 
}
```



### 암호가 있는 개인키의 경우

```go
import (
    "github.com/youmark/pkcs8"
)
 
// Load client clientKey
keyPEMBlock, err := os.ReadFile(keyFile)
if err != nil {
    return err
}
 
block, _ := pem.Decode(keyPEMBlock)
if block == nil {
    return errors.New(fmt.Sprintf("Pem Decode Error"))
}
 
const passPhrase = "this is passphrase"
privateKey, err := pkcs8.ParsePKCS8PrivateKeyRSA(block.Bytes, []byte(passPhrase))
if err != nil{
    return err
}
 
decryptedPrivatePem := x509.MarshalPKCS1PrivateKey(privateKey)
privateKeyPEM := &pem.Block{
    Type: "RSA PRIVATE KEY",
    Bytes: decryptedPrivatePem,
}
 
// encode private key to pem
var buf bytes.Buffer
err = pem.Encode(&buf, privateKeyPEM)
if err != nil {
    return err
}
 
// Load client clientCert
certPEMBlock, err := os.Readfile(certFile)
if err != nil {
    return err
}
 
// set TLS key pair
clientCertKeyPair, err := tls.X509KeyPair(certPEMBlock, buf.Bytes())
 
// use clientCertKeyPair
```





