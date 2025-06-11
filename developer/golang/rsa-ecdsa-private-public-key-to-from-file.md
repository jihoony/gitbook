# RSA/ECDSA Private/Public Key To/From File

## Private Key



### Write RSA Private Key to file

```go
 import (
     "crypto/rand"
     "crypto/rsa"
     "crypto/x509"
     "encoding/pem"
     "os"
 )
 func saveRSAPrivateKey(key *rsa.PrivateKey, filename string) error {
     keyBytes := x509.MarshalPKCS1PrivateKey(key)
     pemBlock := &pem.Block{
         Type:  "RSA PRIVATE KEY",
         Bytes: keyBytes,
     }
     pemFile, err := os.Create(filename)
     if err != nil {
         return err
     }
     defer pemFile.Close()
     return pem.Encode(pemFile, pemBlock)
 }
 func main(){
     // Example Usage
     privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
     if err != nil {
         panic(err)
     }
     err = saveRSAPrivateKey(privateKey, "rsa_private.pem")
     if err != nil {
         panic(err)
     }
 }

```

### Read RSA Private Key from file

```go
 import (
     "crypto/rsa"
     "crypto/x509"
     "encoding/pem"
     "os"
     "io/ioutil"
 )
 func readRSAPrivateKey(filename string) (*rsa.PrivateKey, error) {
     pemFile, err := os.Open(filename)
     if err != nil {
         return nil, err
     }
     defer pemFile.Close()
     pemBytes, err := ioutil.ReadAll(pemFile)
     if err != nil {
         return nil, err
     }
     pemBlock, _ := pem.Decode(pemBytes)
     if pemBlock == nil || pemBlock.Type != "RSA PRIVATE KEY" {
         return nil, err
     }
     key, err := x509.ParsePKCS1PrivateKey(pemBlock.Bytes)
     if err != nil {
         return nil, err
     }
     return key, nil
 }

 func main(){
     // Example Usage
     privateKey, err := readRSAPrivateKey("rsa_private.pem")
     if err != nil {
         panic(err)
     }
     println("RSA Private Key read successfully", privateKey.N)
 }

```



### Write ECDSA Private Key to file

```go
 import (
     "crypto/ecdsa"
     "crypto/elliptic"
     "crypto/x509"
     "encoding/pem"
     "os"
 )
 func saveECDSAPrivateKey(key *ecdsa.PrivateKey, filename string) error {
     keyBytes, err := x509.MarshalECPrivateKey(key)
     if err != nil {
         return err
     }
     pemBlock := &pem.Block{
         Type:  "EC PRIVATE KEY",
         Bytes: keyBytes,
     }
     pemFile, err := os.Create(filename)
     if err != nil {
         return err
     }
     defer pemFile.Close()
     return pem.Encode(pemFile, pemBlock)
 }
 func main(){
     // Example Usage
     privateKey, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
      if err != nil {
         panic(err)
     }
     err = saveECDSAPrivateKey(privateKey, "ecdsa_private.pem")
     if err != nil {
         panic(err)
     }
 }

```



### Read ECDSA Private Key from file

```go
 import (
     "crypto/ecdsa"
     "crypto/x509"
     "encoding/pem"
     "os"
     "io/ioutil"
 )
 func readECDSAPrivateKey(filename string) (*ecdsa.PrivateKey, error) {
     pemFile, err := os.Open(filename)
     if err != nil {
         return nil, err
     }
     defer pemFile.Close()
     pemBytes, err := ioutil.ReadAll(pemFile)
     if err != nil {
         return nil, err
     }
     pemBlock, _ := pem.Decode(pemBytes)
     if pemBlock == nil || pemBlock.Type != "EC PRIVATE KEY" {
         return nil, err
     }
     key, err := x509.ParseECPrivateKey(pemBlock.Bytes)
     if err != nil {
         return nil, err
     }
     return key, nil
 }

 func main(){
     // Example Usage
     privateKey, err := readECDSAPrivateKey("ecdsa_private.pem")
     if err != nil {
         panic(err)
     }
     println("ECDSA Private Key read successfully", privateKey.X)
 }

```





## Public Key

### Write Public Key to file

```go
package main

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"os"
)

func main() {
    // Generate RSA Key
	rsaPublicKey, err := generateRSAPublicKey()
	if err != nil {
		fmt.Println("Error generating RSA key:", err)
		return
	}

	// Generate ECDSA Key
	ecdsaPublicKey, err := generateECDSAPublicKey()
	if err != nil {
		fmt.Println("Error generating ECDSA key:", err)
		return
	}

	// Save RSA Public Key to File
	err = savePublicKeyToFile("rsa_public_key.pem", rsaPublicKey)
	if err != nil {
		fmt.Println("Error saving RSA public key:", err)
		return
	}

	// Save ECDSA Public Key to File
	err = savePublicKeyToFile("ecdsa_public_key.pem", ecdsaPublicKey)
	if err != nil {
		fmt.Println("Error saving ECDSA public key:", err)
		return
	}
	fmt.Println("Public keys saved to files.")
}

func generateRSAPublicKey() (*rsa.PublicKey, error) {
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		return nil, err
	}
	return &privateKey.PublicKey, nil
}

func generateECDSAPublicKey() (*ecdsa.PublicKey, error) {
	privateKey, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		return nil, err
	}
	return &privateKey.PublicKey, nil
}

func savePublicKeyToFile(filename string, publicKey interface{}) error {
    publicKeyBytes, err := x509.MarshalPKIXPublicKey(publicKey)
    if err != nil {
        return err
    }
	pemBlock := &pem.Block{
		Type:  "PUBLIC KEY",
		Bytes: publicKeyBytes,
	}

	file, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	return pem.Encode(file, pemBlock)
}

```

### Read Public Key from file

```go
package main

import (
	"crypto/ecdsa"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
    // Read RSA Public Key from File
	rsaPublicKey, err := readPublicKeyFromFile("rsa_public_key.pem")
	if err != nil {
		fmt.Println("Error reading RSA public key:", err)
		return
	}
	fmt.Printf("RSA Public Key: %+v\n", rsaPublicKey)

    // Read ECDSA Public Key from File
	ecdsaPublicKey, err := readPublicKeyFromFile("ecdsa_public_key.pem")
	if err != nil {
		fmt.Println("Error reading ECDSA public key:", err)
		return
	}
	fmt.Printf("ECDSA Public Key: %+v\n", ecdsaPublicKey)
}

func readPublicKeyFromFile(filename string) (interface{}, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	pemData, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	pemBlock, _ := pem.Decode(pemData)
	if pemBlock == nil {
		return nil, fmt.Errorf("PEM decode failed")
	}

	publicKey, err := x509.ParsePKIXPublicKey(pemBlock.Bytes)
	if err != nil {
		return nil, err
	}
	return publicKey, nil
}

```
