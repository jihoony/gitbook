# PKCS#11 API-강좌4

## PKCS#11 API-강좌4



### RSA Key Generation and Encryption/Decryption 과 Sign/Verify 예제&#x20;

강좌3 에서는 AES Key를 사용하는 예제를 보여 주었습니다. 강좌4 에서는 Asymmetric Key인 RSA 2048 bit Key를 생성하여, 테스트 데이타로 생성된 64-byte data를 Encryption/Decryption 하고, SHA256으로 Hash 하여 32-byte Digest를 만들고, 이 Digest를 Sign/Verify 하는 기능을 수행하는 예제입니다.  또 이번 예제에서는 생성되어, HSM에 저장된 Key를 삭제하는 C\_DistroyObject() 함수도 사용하였습니다.

Asymmetric Key이기 때문에 Private Key 와 Public Key 두 개가 생성됩니다. Key Label은 RSA5Key 를 사용하였습니다.  Encryption/Decryption 암호 연산과 Sign/Verify 연산 모두 HSM 장비안에서 수행됩니다.&#x20;

강좌3 에서 제시한 소스와 유사하므로,  다른 부분만 기술하였습니다.



{% code overflow="wrap" fullWidth="true" %}
```c
// *** HEADER FILES ***

      . . . . . . . .
static CK_OBJECT_CLASS PublicKeyClass = CKO_PUBLIC_KEY;
static CK_OBJECT_CLASS PrivateKeyClass = CKO_PRIVATE_KEY;
static CK_KEY_TYPE RSAKeyType = CKK_RSA;

 
// *** MAIN ***************************************************************************************

int main(int argc, char* argv[])
{

             ………….

                  
                     //4. Generate RSA Key and Encryption/Decryption & Sign/Verify test
                          rc = PKCS11_SampleCode::RSASamples(hSession);
                          if ( rc != CKR_OK ) throw buffer ;

                          
             ………..

}

// *** end of MAIN ********************************************************************************

 
// *** RSA SAMPLE CODE ****************************************************************************
CK_RV PKCS11_SampleCode::RSASamples(CK_SESSION_HANDLE hSession)
{

    printf("\n\n~~~ RSA Key Generation, Encryption/Decryption, Signing/Verify ~~~~~~~~~~~~~~~~~~~~~~~~\n");

             // NOTES:
             // Key Generation:    Mechanism CKM_RSA_PKCS_KEY_PAIR_GEN is supported to generate keys
             //                                                                A 2048 bit key pair is generated in this example.
             // Encrypt/Decrypt:    Mechanisms  CKM_RSA_PKCS is used in this example
             //
             // Digest:                            Mechanisms CKM_SHA_256 is used in this example
             //                                                               
             // Sign/Verify:                       Mechanisms CKM_RSA_PKCS is used in this example.
             //                                                               

             CK_RV rc;
    try
    {
                           // generate some data
                           CK_BYTE data[64];
                           CK_ULONG dataLen = sizeof(data);
                           int          i;
 
                           rc = pkcs11.GenerateRandom(hSession, data, dataLen);

                          printf("\r\nOriginal  Data : ") ;
                           for ( i = 0 ; i  < 64 ; i++ ) {
                                        printf(" %02X ",data[i]) ;
                           }             


                           // generate a key pair
                           CK_OBJECT_HANDLE hPubKey;
                           CK_OBJECT_HANDLE hPrivKey;
                           CK_ULONG ModulusBits = 2048 ; // for RSA 2048
                           CK_CHAR label[] = "RSA5Key";

                           rc = PKCS11_SampleCode::generateRSAKeyPair(hSession, hPubKey, hPrivKey, ModulusBits,label);
                           if ( rc != CKR_OK ) return rc ;
      

                          // encrypt/decrypt
                           rc = PKCS11_SampleCode::RSAEncryptDecrypt(hSession, hPubKey, hPrivKey, data, dataLen);
                           if ( rc != CKR_OK )
                                        {
                                         // tidy up
                                        pkcs11.DestroyObject(hSession, hPubKey);
                                        pkcs11.DestroyObject(hSession, hPrivKey);
                                        return rc  ;
                                        }


                           // digest
                           CK_BYTE hash[32] = {0};
                           CK_ULONG hashLen = sizeof(hash);
                           rc = PKCS11_SampleCode::sha256Hash(hSession, data, dataLen, hash, &hashLen);
    
                           // sign/verify
                           rc = PKCS11_SampleCode::RSASignVerify(hSession, hPubKey, hPrivKey, hash, hashLen);                        

                           // tidy up
                           pkcs11.DestroyObject(hSession, hPubKey);                          
                           pkcs11.DestroyObject(hSession, hPrivKey);

    }
             catch (char* e)
    {
                 printf(e);
    }
    catch (...){}

    return rc;
}


// ___ GENERATE AN RSA KEY PAIR _______________________________________________
CK_RV PKCS11_SampleCode::generateRSAKeyPair(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE& hPubKey, CK_OBJECT_HANDLE& hPrivKey, CK_ULONG ModulusBits, CK_CHAR_PTR label)
{
    printf("\n\n--- Generate RSA Key Pair --------------\n");

             CK_RV rc;
    try
    {
                           // get an RSA Key Generation mechanism
                          CK_MECHANISM genMech = {CKM_RSA_PKCS_KEY_PAIR_GEN, NULL_PTR, 0};

                           // declare a Public Exponent
                           CK_BYTE PublicExponent[] = {0,0,0,0x03};

 
                           // generate the RSA Public Template
        CK_ATTRIBUTE pubKeyTemplate[]  =
        {
            {CKA_CLASS, &PublicKeyClass, sizeof(PublicKeyClass)},
            {CKA_TOKEN, &bTrue, sizeof(bTrue)},
            {CKA_PRIVATE, &bTrue, sizeof(bTrue)},
            {CKA_MODIFIABLE, &bFalse, sizeof(bFalse)},             
            {CKA_ENCRYPT, &bTrue, sizeof(bTrue)}, 
            {CKA_VERIFY, &bTrue, sizeof(bTrue)},   
            {CKA_WRAP, &bTrue, sizeof(bTrue)},                               
            {CKA_KEY_TYPE, &RSAKeyType, sizeof(RSAKeyType)},
            {CKA_MODULUS_BITS, &ModulusBits, sizeof(ModulusBits)},
            {CKA_PUBLIC_EXPONENT, &PublicExponent, sizeof(PublicExponent)}
        };


                           // generate the RSA Private Template
        CK_ATTRIBUTE privKeyTemplate[]  =
        {
            {CKA_CLASS, &PrivateKeyClass, sizeof(PrivateKeyClass)},
            {CKA_TOKEN, &bTrue, sizeof(bTrue)},
            {CKA_PRIVATE, &bTrue, sizeof(bTrue)},
            {CKA_LABEL, label, strlen((char*)label)},
            {CKA_MODIFIABLE, &bFalse, sizeof(bFalse)},
            {CKA_KEY_TYPE, &RSAKeyType, sizeof(RSAKeyType)},
            {CKA_DECRYPT, &bTrue, sizeof(bTrue)},
            {CKA_SIGN, &bTrue, sizeof(bTrue)},
            {CKA_UNWRAP, &bTrue, sizeof(bTrue)}, 
            {CKA_SENSITIVE, &bTrue, sizeof(bTrue)},     
            {CKA_EXTRACTABLE, &bFalse, sizeof(bFalse)}
        };

 
                           // reset the RSA Key handles
            hPubKey = 0;
            hPrivKey = 0;

 
                           // generate the RSA Key Pair
        rc = pkcs11.GenerateKeyPair( hSession, &genMech,
                                                     pubKeyTemplate, sizeof(pubKeyTemplate)/sizeof(CK_ATTRIBUTE),
                                                     privKeyTemplate, sizeof(privKeyTemplate)/sizeof(CK_ATTRIBUTE),
                                                     &hPubKey, &hPrivKey );
 

    }
             catch (char* e)
    {
                 printf(e);
    }
    catch (...){}

    return rc;
}

 

// ___ RSA ENCRYPT/DECRYPT ____________________________________________________
CK_RV PKCS11_SampleCode::RSAEncryptDecrypt(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE hPubKey,CK_OBJECT_HANDLE hPriKey, const CK_BYTE_PTR data, const CK_ULONG dataLen)
{
    printf("\n\n--- RSA Encrypt/Decrypt ----------------\n");


    CK_RV rc;
    try
    {
                           // declare variables
                           CK_ULONG realDataLen = 256 ;  //  Max Size for 2048 bit key
                           CK_BYTE_PTR encData = new CK_BYTE[realDataLen]; 
                           CK_BYTE_PTR decData = new CK_BYTE[realDataLen]; 
                           CK_ULONG encLen = realDataLen;
                           CK_ULONG decLen = realDataLen;
                           CK_ULONG i ;


                           // set up the RSA encrypt/decrypt mechanism (dependent upon the bit length)
              
                          CK_MECHANISM encDecMech = { CKM_RSA_PKCS, NULL_PTR, 0 } ;

                           // encrypt the data
                          rc = pkcs11.EncryptInit(hSession, &encDecMech, hPubKey);
                          rc = pkcs11.Encrypt(hSession, data, dataLen, encData, &encLen);

                           printf("\r\nEncrypted Data : ") ;
                           for ( i = 0 ; i  < encLen  ; i++ ) {
                                        printf(" %02X ",encData[i]) ;
                           }
                           printf("\r\n") ;

                           // decrypt the data
                           rc = pkcs11.DecryptInit(hSession, &encDecMech, hPriKey);
                           rc = pkcs11.Decrypt(hSession, encData, encLen, decData, &decLen);

                           printf("\r\nDecrypted Data : ") ;
                           for ( i = 0 ; i  < decLen  ; i++ ) {
                                        printf(" %02X ",decData[i]) ;
                           }
                           printf("\r\n") ;

                           // tidy up
                         delete [] encData;
                         delete [] decData;
    }
             catch (char* e)
    {
                 printf(e);
    }
    catch (...) {}

    return rc;
}

 

 

// *** SHA256 HASH **********************************************************************************

CK_RV PKCS11_SampleCode::sha256Hash(CK_SESSION_HANDLE hSession, CK_BYTE* data, CK_ULONG dataLen, CK_BYTE* hash, CK_ULONG* hashLen) 
{ 
             printf("\n\n--- SHA256 Hash --------------------------\n"); 
    CK_RV rc;
 
    try 
    { 
                           CK_ULONG hLength , i ;
 
                           // declare the hashing mechanism 
                          CK_MECHANISM hashMech = {CKM_SHA256, NULL_PTR, 0};
 
                           // perform a digest 
                           rc = pkcs11.DigestInit(hSession, &hashMech); 
                           rc = pkcs11.Digest(hSession, data, dataLen, hash, hashLen); 
                           hLength = *hashLen ;
 
                           printf("\r\nHashed  Data : %d bytes \r\n", hLength ) ; 
                           for ( i = 0 ; i  < hLength  ; i++ ) { 
                                        printf(" %02X ",hash[i]) ; 
                           } 
                           printf("\r\n") ; 

             } 
             catch (char* e) 
    { 
                 printf(e); 
    } 
    catch (...) {}
 
    return rc; 
}

  

// ___ RSA SIGN/VERIFY ________________________________________________________ 
CK_RV PKCS11_SampleCode::RSASignVerify(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE hPubKey, CK_OBJECT_HANDLE hPrivKey, const CK_BYTE_PTR data, const CK_ULONG dataLen) 
{ 
    printf("\n\n--- RSA Sign/Verify --------------------\n");
 
             CK_RV rc; 
    try 
             { 
                           // declare a signature buffer 
                           unsigned char signature[512]; 
                           CK_ULONG signatureLen = sizeof(signature); 
                           CK_ULONG i ;

                           // get an RSA sign/verify mechanism 
                           CK_MECHANISM signVerifyMech = { CKM_RSA_PKCS, NULL_PTR, 0 };

                           // sign the data    
                           rc = pkcs11.SignInit(hSession, &signVerifyMech, hPrivKey);   
                           rc = pkcs11.Sign(hSession, data, dataLen, signature, &signatureLen);

                           printf("\r\nSigned Data : %d bytes \r\n",signatureLen ) ; 
                           for ( i = 0 ; i  < signatureLen  ; i++ ) { 
                                        printf(" %02X ",signature[i]) ; 
                           } 
                           printf("\r\n") ;

                           // verify the signature 
                           rc = pkcs11.VerifyInit(hSession, &signVerifyMech, hPubKey); 
                           rc = pkcs11.Verify(hSession, data, dataLen,  signature, signatureLen); 
                           if ( rc == CKR_OK )  printf("\r\n--Verification is OK----\r\n"); 
                           else printf("\r\n--Verification is  Fail ----\r\n"); 
             } 
             catch (char* e) 
    { 
                 printf(e); 
    } 
             catch(...) {} 
  
             return rc; 
}
```
{% endcode %}



### 예제 프로그램 수행 결과 값

위 프로그램을 수행한 결과 값은 아래와 같이 나옵니다. 2048 Bit RSA Key를 사용하였기 때문에, Encryption 및 Signing 결과 값이 256 byte 입니다. 참고로 CKM\_RSA\_PKCS Mechanism을 사용할 시, Input Data의 최대 크기는 245(256 – 11) byte 가 되며, Output Data는 256 Byte 가 됩니다. 256 Byte인 이유는 2048 Bit 이기 때문입니다(RSA Encryption에서 결과치는 Key Length와 동일하고, Input Data 최대치는 Key Length – 11 byte 입니다)

{% code overflow="wrap" fullWidth="true" %}
```bash
~~~ RSA Key Generation, Encryption/Decryption, Signing/Verify ~~~~~~~~~~~~~~~~~~~~~~~~

Original  Data :  EB  79  BC  3D  3E  24  66  F5  C9  06  75  F4  49  E6  36  6D  48  7C  67  D7  52  B4  01  90  64  2F  79  CF  60  9C  41  A6  1B  7F  01  54  58  E9  90  01  D1  B3  BF  60  53  1B  E6  FC  7F  B3  87  09  80  79  A7  C8  83  C4  78  6A  8D  95  06  05

--- Generate RSA Key Pair --------------

--- RSA Encrypt/Decrypt ----------------

Encrypted Data :  0C  79  9B  EE  AB  32  10  A2  82  E3  83  00  E9  C3  9A  DA  9D  F3  13  35  24  92  80  EF  4A  0E  43  66  CB  3C  5E  A2  30  24  8B  5A  F7  F4  A2  0B  C6  1C  BB  A2  50  4C  5E  DB  34  C4  58  2A  0F  6E  B0  9D  65  59  35  82  38  83  93  FC  5F  B9  FC  FC  2C  DE  F1  3C  3C  96  55  79  C4  21  C8  4D  A2  A1  C6  2A  5D  84  84  F3  60  E1  3F  3C  61  45  6D  37  A0  C5  65  B0  A4  FD  3F  AF  7A  77  66  3B  0D  4B  9F  1D  1E  55  5F  4E  DC  29  1C  57  6F  B4  22  A8  C9  09  BB  FC  B4  34  8C  22  5C  16  4F  72  9C  E4  75  6E  5D  68  68  30  19  27  30  1C  DD  A9  D1  BF  81  61  26  CD  D9  2A  54  C4  A5  1A  5D  47  D7  9C  2D  DB  EE  4C  D4  7A  D1  CF  3E  E4  F3  43  9F  6E  62  84  95  E1  33  E7  44  46  57  DB  A8  53  DD  31  D7  68  AB  71  A5  26  F0  26  65  F7  7A  72  5F  B3  1A  0D  F1  92  2C  1B  22  06  EE  97  76  82  17  4C  51  5E  1B  3D  7C  8B  97  4F  5B  0F  29  F4  E9  0E  6C  D7  DD  2C  AD  6E  94  A3  B2  B8  A2  2E  52  16  34  9C  1E  02  F6  A9

Decrypted Data :  EB  79  BC  3D  3E  24  66  F5  C9  06  75  F4  49  E6  36  6D  48  7C  67  D7  52  B4  01  90  64  2F  79  CF  60  9C  41  A6  1B  7F  01  54  58  E9  90  01  D1  B3  BF  60  53  1B  E6  FC  7F  B3  87  09  80  79  A7  C8  83  C4  78  6A  8D  95  06  05


--- SHA256 Hash --------------------------

Hashed  Data : 32 bytes

3D  20  CB  8F  E2  93  A9  D3  6C  84  03  D2  8D  3A  C9  14  45  36  D5  F1  58  F7  82  8E  F8  B6  93  1A  B1  AF  F1  37

 
--- RSA Sign/Verify --------------------

Signed Data : 256 bytes

48  6D  75  AE  50  BF  70  A5  F3  92  0C  03  AE  A4  FD  DC  3F  D7  20  C7  E9  88  ED  09  25  F4  D9  AB  3E  44  4A  02  1A  E6  53  49  78  8D  6E  29  15  64  7E  39  94  DE  30  E8  00  0E  27  7B  19  60  02  C6  54  43  A0  61  F8  19  2A  A0  C6  E8  19  BD  B9  47  F4  0C  68  E1  44  70  25  BE  31  B6  C6  3A  23  01  F3  13  63  D5  E4  CE  07  CA  35  E7  ED  7A  14  3E  53  E0  D7  4A  36  C0  C6  AE  50  8B  AE  CE  4D  C8  8D  76  4B  72  B7  D5  AD  B2  CC  1C  D4  81  66  3E  ED  06  B0  E3  D2  83  DA  C5  28  CB  CE  F9  4C  7A  23  F7  EE  52  62  61  F3  AE  FF  C9  FE  58  C3  87  A8  EB  7A  5C  DA  C1  90  3B  49  A2  5E  DA  47  B6  A8  19  08  82  92  C7  29  4C  CF  5A  DE  AB  D5  B2  21  52  47  95  B0  43  AD  33  E3  F3  AB  D5  44  DB  25  03  4B  D8  9C  82  0F  A4  C0  E7  81  7B  C3  7D  93  EA  AA  FE  91  2F  DC  F0  3C  C9  07  CF  BA  CF  D4  19  77  9B  77  CF  BF  B5  EA  69  A0  ED  16  F4  BC  94  86  F9  7D  36  06  46  20  D0  FB  28  4C  2E  30  FA  5E  71


--Verification is OK----

```
{% endcode %}



