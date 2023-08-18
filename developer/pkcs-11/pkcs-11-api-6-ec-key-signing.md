# PKCS#11 API-강좌6(EC Key 생성 및 Signing)

## PKCS#11 API-강좌6(EC Key 생성 및 Signing)



### C 언어 Sample Code(ECCKeyGen.c)

지난 PKCS#11 API-강좌5(2016.10.11) 에서, C 언어로 작성된 Sample Code를 제시 하였습니다. 이번 강좌6 에서는 C 언어로 된, EC(ECDSA) Key Generation(생성) 및 Signing 하는 Sample Code를 제시하고자 합니다.

이번 강좌의 목적은 당사가 공급하는 HSM장비인 KeyperPlus를 가지고, ECDSA Key를 어떤 방식으로 생성하는 지, 그리고 어떻게 Signing 하는 지를 보여주고자 하는 것입니다.

Windows 와 LINUX 환경에서 동작되는 Source Code를 제공하기 위하여, `#define` 변수를 사용하여 OS별 차이점을 구별하였습니다.



### 실행 결과

EC Parameter로 secp256r1(P-256) curve를 선택한 경우, 결과는 아래와 같이 나옵니다.



{% code fullWidth="true" %}
```bash
C> ECCKeyGen  0  1234  PriTestKey  PubTestKey  3

--- Start to generate ECC Key Pair --------------

--- ECC Key Pair Generation Completed ----

--- ECC Private-Key Signing Test ----

--- Start ECC Signing--------------------

Signed Data : 64 bytes

 36  93  DE  71  A3  28  F6  1E  7C  DC  DF  A8  42  30  FB  7F  70  19  5E  7C

 88  9B  42  2D  DC  57  B5  17  17  E4  C9  5E  D3  63  4F  17  FC  BC  10  B0

 B9  AE  2D  C0  75  A1  B6  89  E9  07  93  8D  91  DB  9E  3E  27  77  61  A8

 A8  22  BE  6F
 
```
{% endcode %}

P-256 즉 P size가 256-bit 사용 시, Signed Size는 64-byte 가 됩니다. 참고로, P-512 사용 시, Signed Size는 136-byte 가 됩니다



### EC Parameter

ECDSA Key를 HSM에서 Generation하는 C\_GenerateKey() 함수를 call 할 때, EC Parameter 즉 CKA\_EC\_PARAMS 에 해당되는 값은, Public Key Object 에게만 입력해야 합니다. 이 때 EC Parameter는 해당 알고리즘을 나타내는 OID(Object Identifier) 값입니다. EC Parameter 외에 입력해야 하는 EC 관련 값은 없습니다.

EC를 만들 때, 타원곡선을 정의하는 Parameter인 “Domain Parameter”를 사용해야 하는 데, Domain Parameter를 만드는 작업은 시간이 많이 소요되고 까다로운 Curve상의 Point 연산이므로, 여러 표준 단체에서 각 Field Size에 맞는 타원곡선에 대한 Domain Parameter를 발표 하였습니다. 그리고 Domain Parameter는 2가지 방식으로 표현하도록 하였습니다. value(p,a,b,G,n,h) 또는 name(P-256 or secp256k1) 방식입니다. PKCS#11 API 에서는 name 방식을 사용합니다. 즉 name 애 대응되는 OID 값을 사용합니다.

아래는, Source Code에 들어 있는 내용으로, 각 EC Parameter는 타원곡선(Elliptic Curve)를 나타내는 OID 값입니다.

{% code fullWidth="true" %}
```c
/* OID(Object Identifier) value for ESDSA */

P192Params[10] = {0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x01 };

P224Params[7] = {0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x21};

P256Params[10] = {0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07 };

P384Params[7] = {0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x22 };

P521Params[7] = {0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x23 };

K256Params[7] = {0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x0a }; /* secp256k1 */
```
{% endcode %}



FIPS 186-3 에서는 5개의 Prime Field를 recommend하고 있는 데, P size가 192-bit , 224-bit , 256-bit , 384-bit , 521-bit인 5개입니다. P-256 은 secp256r1 로 표시하기도 합니다. secp256k1은 비트코인 시스템에서 사용하고 있는 ECDSA의 parameter 입니다.

참고로, secp256r1 이 무엇을 의미하는 지를 보다 자세히 알기 위해서는, 본 블로그 “비트코인에서 사용하는 타원곡선암호기술” 기사를 참조하시기 바랍니다



### KeyperPlus의 FIPS mode

당사가 공급하는, FIPS 140-2 Level 4 인증을 받은 HSM 장비인, KeyperPlus는 암호키 사용 시, FIPS mode 와 non-FIPS mode를 함께 지원하고 있습니다. HSM 장비 설정에서 지정하여 사용합니다.

FIPS mode는 FIPS 에서 인증받은 암호 알고리즘만 지원합니다. non-FIPS mode는 KeyperPlus에서 지원하는 모든 알고리즘을 지원합니다.

secp256k1은 FIPS mode에서 지원하지 않고 있기 때문에, secp256k1를 사용하려면, non-FIPS mode를 설정해서 사용해야 합니다. FIPS mode에서 secp256k1를 사용하면, 0x121A 라는 Error Code를 return합니다.



#### ECCKeyGen.c file 내용

{% code overflow="wrap" fullWidth="true" %}
```c
#ifdef WIN32 

  #include <windows.h>

  #include <stdio.h>

  #include <string.h>

  #include <stdlib.h>

  #include <memory.h>

#elif defined (LINUX)

  #include <memory.h>

  #include <stdio.h>

  #include <string.h>

  #include <stdlib.h>

  #include <unistd.h>

  #include <dlfcn.h>

#else

  #error OS Specific defined required

#endif

 

 

#include "pkcs11.h"

 

 

/* *** DECLARE/INITIALIZE GLOBAL VARIABLES *** */

CK_FUNCTION_LIST  *pkcs11;

 

 

#ifdef WIN32

#ifdef WIN64

  static char const libraryPath[] = "ap220w64HSM.dll";

  static HINSTANCE lm ;

#else

  static char const libraryPath[] = "bp201w32hsm.dll";

  static HINSTANCE lm ;

#endif

#elif defined(LINUX)

  static char const libraryPath[] = "pkcs11.so" ;

  static void     *lm ;

#else

  #error OS not defined.

#endif

 

 

static CK_CHAR PriLabel[20] ;

static CK_CHAR PubLabel[20] ;

static CK_BYTE UserPin[20] ;

static CK_BBOOL bTrue = TRUE;

static CK_BBOOL bFalse = FALSE;

static CK_KEY_TYPE ECCKeyType = CKK_EC;

static CK_OBJECT_CLASS PublicKeyClass = CKO_PUBLIC_KEY;

static CK_OBJECT_CLASS PrivateKeyClass = CKO_PRIVATE_KEY;

 

void        CloseLibModule(void) ;

CK_RV   LoadPKCS11Module(void) ;

CK_RV   checkSlot(CK_SLOT_ID) ;

CK_RV   ECCaction(CK_SESSION_HANDLE, int) ;

CK_RV   generateECCKeyPair(CK_SESSION_HANDLE, CK_OBJECT_HANDLE *, CK_CHAR_PTR, CK_CHAR_PTR, CK_CHAR_PTR, CK_ULONG) ;

CK_RV   ECCSigningTest(CK_SESSION_HANDLE, CK_OBJECT_HANDLE) ;

 

 

/* *** MAIN *************************************************************************************** */

int main(int argc, char* argv[])

{

             CK_RV rc = 0;

             CK_BBOOL bInitialized = FALSE;

             char buffer[256] = {0};

 

        CK_C_INITIALIZE_ARGS args = {0};

             CK_SLOT_ID slotID =  0; 

 

             CK_SESSION_HANDLE hSession =  0;

 

             char        *pPath = NULL ;

             size_t      len = 0 ;

             int          keylengthID ;

 

             if ( argc != 6 )

                           {

                       printf("\n\n-------Invalid parameteres--------\n");

                       printf("Usage : C>RSAKeyGen  Slot_id  User_PIN  Private_KeyLabel Public_KeyLabel KeyLength_ID\n");

                       printf("      Slot_id : Slot Number  : ex) 0 \n");

                       printf("      User_PIN: User PIN number : ex) 1234 \n");

                       printf("      Private_KeyLabel: Private Key Label String : ex) PriTestKey \n");

                       printf("      Public_KeyLabel : Public Key Label String : ex) PubTestKey \n");

                          printf("      KeyLength_ID : ECC Key Length ID : ex) 1  \n");

                       printf("           1: P192, 2: P224, 3: P256,  4: P384,  5: P521, 6: 256k1\n");

                           return !CKR_OK ;

                           }

 

 

             

#ifdef WIN32

                           strcpy_s(libraryPath,sizeof(libraryPath),KeyperLibrary) ; /* PKCS11 Library */

#elif defined(LINUX)

                           strcpy(libraryPath,KeyperLibrary) ; /* PKCS11 Library */

#else

  #error OS not defined.

#endif

                           

             

 

             

        slotID = atoi(argv[1]) ;

#ifdef WIN32

        strcpy_s(UserPin,sizeof(UserPin),argv[2]) ; /* User PIN Number  */

        strcpy_s(PriLabel,sizeof(PriLabel),argv[3]) ; /* Private Key Label  */

        strcpy_s(PubLabel,sizeof(PubLabel),argv[4]) ; /* Public Key Label  */            

#elif defined(LINUX)

             strcpy((char *)UserPin,argv[2]) ; /* User PIN Number  */

        strcpy((char *)PriLabel,argv[3]) ; /* Private Key Label  */              

        strcpy((char *)PubLabel,argv[4]) ; /* Public Key Label  */             

#else

                             #error OS not defined.

#endif

             keylengthID = atoi(argv[5]) ;

             if ( keylengthID < 1  ||  keylengthID > 6 )

                           {

                           printf("----- KeyLength_ID  should be between 1 and 6 ----- \n");

                           return !CKR_OK ;

                           }

                           

 

             if ( strcmp(PriLabel,PubLabel) == 0 )

                           {

                            printf("----- Private KeyLabel and Public KeyLabel should be different ----- \n");

                           return !CKR_OK ;

                           }

 

             rc = LoadPKCS11Module() ;

             if ( rc != CKR_OK ) return rc ;

                           

    

                            /* 1. Initialize the pkcs#11 library ... */       

                               rc = pkcs11->C_Initialize(&args);

                               if ( rc != CKR_OK ) 

                                                     {

                                                     CloseLibModule() ;

                                                return rc ;

                                                     }

                               bInitialized = TRUE;

 

                           /* 2. Check the slot_id  */                                                   

                   rc = checkSlot(slotID); 

                   if ( rc != CKR_OK ) 

                                                     {

                                                     CloseLibModule() ;

                                                     return rc ;

                                                     } 

                                        

                           /* 3. Then open a session and login as a User ... */

                /* open session (must be serial/rw) */   

                              rc = pkcs11->C_OpenSession(slotID, CKF_SERIAL_SESSION | CKF_RW_SESSION, NULL, NULL, &hSession);

                              if ( rc != CKR_OK )

                                                     {

                                printf("\n\n---There is no HSM or HSM is not ON-Line ----\n");

                                                     CloseLibModule() ;

                                                     return rc ;

                                                     } 

                                        

                              /* login as a User   */

                              rc = pkcs11->C_Login(hSession, CKU_USER, (CK_UTF8CHAR_PTR)UserPin, strlen((char*) UserPin));

                              if ( rc != CKR_OK ) 

                                                     {

                                printf("\n\n--- Incorrect User PIN number-----------\n");

                                                     CloseLibModule() ;

                                                     return rc ;

                                                     }

 

                           /* 4. Generate ECC Key */

                               rc = ECCaction(hSession,keylengthID);

                    if ( rc != CKR_OK ) 

                                {

                                                     CloseLibModule() ;

                                                     return rc ;

                                                     } 

                           

                           /* 5. When we have completed the Crypto Operations, we must tidy up ... */

                               /* logout  */

                               rc = pkcs11->C_Logout(hSession);

                               /* close session */

                              rc = pkcs11->C_CloseSession(hSession);

 

                           /* 6. The last Cryptoki call - always finalize the library (if it has been initialised)!  */

                             if (bInitialized)

                                        {             

                                        rc = pkcs11->C_Finalize(NULL_PTR); 

                                        }

    

 

             CloseLibModule() ;

 

 

            return rc;

 

}

/* *** end of MAIN ******************************************************************************** */

 

 

CK_RV LoadPKCS11Module(void)

{

             CK_RV           rc;

             CK_RV           (*pFunction)();

 

             

            #ifdef WIN32    

              lm = LoadLibrary( libraryPath );

            #elif defined(LINUX)

              lm = dlopen( libraryPath, RTLD_LAZY | RTLD_LOCAL );

            #else

              #error OS not defined.

             #endif

 

              if ( lm == NULL ) 

                           {

                printf("There is no PKCS11 Module : %s\n",libraryPath); 

                return !CKR_OK ;

                          }

 

 

            #ifdef WIN32    

          pFunction = (CK_RV (*)())GetProcAddress(lm,"C_GetFunctionList");

            #elif defined(LINUX)

              pFunction = (CK_RV (*)())dlsym(lm,"C_GetFunctionList");

            #else

              #error OS not defined.

             #endif

              

 

             if (pFunction == NULL )

                           {

                          printf("There is no C_GetFunctionList()\n");  

                CloseLibModule() ;

                          return !CKR_OK;

                          }

 

             rc = pFunction(&pkcs11);

 

             if (rc != CKR_OK) 

                           {

                           printf("C_GetFunctionList() Error \n"); 

                           CloseLibModule() ;

                         return !CKR_OK;

                          }

 

   return CKR_OK;

 

}

 

 

 

void        CloseLibModule(void)

{

 

            #ifdef WIN32    

              FreeLibrary(lm);

            #elif defined(LINUX)

              dlclose(lm);

            #else

              #error OS not defined.

             #endif

 

}

 

 

/* *** Check the SLOT ID ********************************************************************************* */

CK_RV checkSlot(CK_SLOT_ID sID)

{

             CK_RV rc;

        CK_SLOT_ID_PTR pSlotList ;

             CK_ULONG numSlots, i ;

                          

             /* see if there are slots with tokens */

 

        rc = pkcs11->C_GetSlotList(TRUE, NULL, &numSlots);

        if ( rc != CKR_OK ) 

                           {

                           printf(" GetSlotList Error \n") ;

                           return rc ;

                           }

        if (numSlots)  

            { /* we've got one or more */

              /* call pkcs11->C_GetSlotList() again with a correctly sized buffer */

            pSlotList = (CK_SLOT_ID_PTR)malloc(sizeof(CK_SLOT_ID)*numSlots);

                 if ( pSlotList == NULL )

                                        { /* Memory Full */

                                        printf(" Memory Full \n") ;

                                        return !CKR_OK;

                                        }                          

            memset(pSlotList, 0xFF, sizeof(CK_SLOT_ID)*numSlots);

            rc = pkcs11->C_GetSlotList(TRUE, pSlotList, &numSlots);

                 if ( rc != CKR_OK ) 

                           {

                           printf(" GetSlotList Error2 \n") ;

                free(pSlotList) ; /* tidy up */

                           return rc ;

                           }

    

            for ( i = 0 ; i < numSlots ; i++ )

                           {

                           if ( pSlotList[i] == sID ) 

                                        { /* Slot exists */

                        free(pSlotList) ; /* tidy up */

                                        return rc ;

                                        }

                           }

 

            printf("There is no Slot-Id : %d \n",sID) ;

                 /* tidy up */

            free(pSlotList) ; 

           }

   

             return !CKR_OK;

}

 

 

/* *** ECC Action CODE **************************************************************************** */

CK_RV ECCaction(CK_SESSION_HANDLE hSession, int keylengthID)

{

                                       

             CK_RV rc;

          

             CK_OBJECT_HANDLE hPriKey;

        CK_ULONG count = 0;

             CK_OBJECT_HANDLE newhandle = 0 ;

                           

             CK_ATTRIBUTE objPriTemplate[] =   {

                           {CKA_TOKEN, &bTrue, sizeof(bTrue)},

                           {CKA_LABEL, PriLabel, strlen((char*)PriLabel)}};

 

             CK_ATTRIBUTE objPubTemplate[] =   {

                           {CKA_TOKEN, &bTrue, sizeof(bTrue)},

                           {CKA_LABEL, PubLabel, strlen((char*)PubLabel)}};

 

             CK_BYTE encodedParams[10] ;

             CK_ULONG            encodePlength ;

 

             /* OID(Object Identifier) value for ESDSA */

             CK_BYTE P192Params[10] = {0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x01 };

             CK_BYTE P224Params[7] = {0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x21};

             CK_BYTE P256Params[10] = {0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07 };

             CK_BYTE P384Params[7] = {0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x22 };

             CK_BYTE P521Params[7] = {0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x23 };

             CK_BYTE K256Params[7] = {0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x0a }; /* secp256k1 */

 

 

             switch(keylengthID) {

                           case 1 :

                                        memcpy(encodedParams,P192Params,10) ;

                                        encodePlength = 10 ;

                                        break ;

                           case 2 :

                                        memcpy(encodedParams,P224Params,7) ;

                                        encodePlength = 7 ;

                                        break ;

                           case 3 :

                                        memcpy(encodedParams,P256Params,10) ;

                                        encodePlength = 10 ;

                                        break ;

                           case 4 :

                                        memcpy(encodedParams,P384Params,7) ;

                                        encodePlength = 7 ;

                                        break ;

                           case 5 :

                                        memcpy(encodedParams,P521Params,7) ;

                                        encodePlength = 7 ;

                                        break ;

                           case 6 :

                                        memcpy(encodedParams,K256Params,7) ;

                                        encodePlength = 7 ;

                                        break ;

                           default :

                                        printf("\nInvalid ECC key length \n");

                                        /* error Recovery routine */

                                        memcpy(encodedParams,P192Params,10) ;

                                        encodePlength = 10 ;

                                        break ;

                           }             

 

 

        /* Generate ECC  Key pair */                   

             rc = generateECCKeyPair(hSession, &hPriKey, PriLabel, PubLabel,encodedParams, encodePlength); 

             if ( rc != CKR_OK ) return rc ;

             

        printf("\n\n--- ECC Private-Key Signing Test ----\n");

 

             /* ECC  Private-Key Signing Test */

             rc = ECCSigningTest(hSession, hPriKey); 

                           

            return rc;

}

 

 

/* ___ GENERATE ECC KEY PAIR _______________________________________________*/

CK_RV generateECCKeyPair(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE *hPrivKey, CK_CHAR_PTR PriLabel, CK_CHAR_PTR PubLabel, CK_CHAR_PTR pencodedParams , CK_ULONG encodePlength )

{

             

             CK_RV rc;

             CK_OBJECT_HANDLE hPubKey ;

             

 

                // get the ECC Key Generation mechanism

             CK_MECHANISM eccGenMech = {CKM_EC_KEY_PAIR_GEN, NULL_PTR, 0};

 

 

                           // generate the EC Public Template

          CK_ATTRIBUTE pubKeyTemplate[] = {

                           {CKA_CLASS, &PublicKeyClass, sizeof(PublicKeyClass)},

                           {CKA_TOKEN, &bTrue, sizeof(bTrue)},

                           {CKA_MODIFIABLE, &bFalse, sizeof(bFalse)},

                           {CKA_VERIFY, &bTrue, sizeof(bTrue)},

                           {CKA_DERIVE, &bTrue, sizeof(bTrue)},

                           {CKA_KEY_TYPE, &ECCKeyType, sizeof(ECCKeyType)},

                           {CKA_EC_PARAMS, pencodedParams, encodePlength },

                           {CKA_LABEL, PubLabel, strlen((char*)PubLabel)}

                };

        

                           // generate the EC Private Template

         CK_ATTRIBUTE privKeyTemplate[] ={

                           {CKA_CLASS, &PrivateKeyClass, sizeof(PrivateKeyClass)},

                           {CKA_TOKEN, &bTrue, sizeof(bTrue)},

                           {CKA_PRIVATE, &bTrue, sizeof(bTrue)},

                           {CKA_MODIFIABLE, &bFalse, sizeof(bFalse)},

                           {CKA_LABEL, PriLabel, strlen((char*)PriLabel)},

                           {CKA_KEY_TYPE, &ECCKeyType, sizeof(ECCKeyType)},

                           {CKA_SIGN, &bTrue, sizeof(bTrue)},

                           {CKA_SENSITIVE, &bTrue, sizeof(bTrue)}, 

                        {CKA_DERIVE, &bTrue, sizeof(bTrue)}

                };

 

             printf("\n\n--- Start to generate ECC Key Pair --------------\n");

 

 

                           // reset the ECC Key handles

            hPubKey = 0;

          *hPrivKey = 0;

 

                           // generate the ECC Key Pair

          rc = pkcs11->C_GenerateKeyPair(hSession, &eccGenMech,

                                                     pubKeyTemplate, sizeof(pubKeyTemplate)/sizeof(CK_ATTRIBUTE),

                                                     privKeyTemplate, sizeof(privKeyTemplate)/sizeof(CK_ATTRIBUTE),

                                                     &hPubKey, hPrivKey );

 

        

             if ( rc == CKR_OK ) printf("\n\n--- ECC Key Pair Generation Completed ----\n");

             else printf("\n\n--- ECC Key Generation  Fail !!!!!   Error Code : %08X-----------\n",rc);

    

         return rc;

}

 

 

 

/* ___ ECC Signing Test ___________________________________________________ */

CK_RV ECCSigningTest(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE hPriKey)

{    

             CK_RV rc;

             CK_BYTE data[64] = { /* just Test Data */

                          0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,

                          0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,

                          0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,

                          0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,

                          0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,

                          0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,

                          0x60, 0x61, 0x62, 0x63 } ;

             CK_ULONG dataLen = sizeof(data);

             unsigned char signature[1024];

             CK_ULONG signatureLen = sizeof(signature);

             CK_ULONG i ;

 

 

                                       // get a ECDSA sign/verify mechanism

             CK_MECHANISM signVerifyMech = { CKM_ECDSA, NULL_PTR, 0 };

 

             printf("\n\n--- Start ECC Signing--------------------\n");

 

                           // sign the data   

             rc = pkcs11->C_SignInit(hSession, &signVerifyMech, hPriKey);  

             rc = pkcs11->C_Sign(hSession, data, dataLen, signature, &signatureLen);

             if ( rc == CKR_OK ) 

                           {

                           printf("\r\nSigned Data : %d bytes \r\n",signatureLen ) ;

                           for ( i = 0 ; i  < signatureLen  ; i++ ) {

                                        printf(" %02X ",signature[i]) ;

                                        }

                            printf("\r\n") ;

                           }

             else        printf("\n\n--- ECC  Sign  Fail !!!!!  -------------------\n");

 

            return rc;

}
```
{% endcode %}

