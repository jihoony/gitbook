# PKCS#11 API-강좌5(C 언어로 된 Sample Code)

## PKCS#11 API-강좌5(C 언어로 된 Sample Code)



### C 언어 Sample Code

PKCS#11 API-강좌3에서 기술하였듯이, KeyperPlus 제품과 함께 제공되는 CD에 있는 Sample Code는 C++ 언어로 되어 있습니다. PKCS#11 API 자체는 C 언어로 되어 있지만, Sample Code는 C++ 언어로 되어 있어서, C 언어 Sample Code를 필요로 하시는 분들을 위해서, 일부를 C 언어 규칙에 맞게 수정한 Sample Code를 제시하고자 합니다. &#x20;

강좌3에서 기술한 예제 Source Code를 가지고 C 언어로 작성하였습니다. 이번 강좌의 목적이 C++ 언어로 된 Sample Code를 C 언어로 변환하는 것이기 때문에  “Retrieve AES Key from HSM by FindObject()” 부분은 제외하였습니다. &#x20;

Windows 와 LINUX 환경에서 동작되는 Source Code를 제공하기 위하여, 아래와 같은 #define 변수를 사용하여 OS별 차이점을 구별하였습니다.



{% code fullWidth="false" %}
```c
#ifdef WIN32   
  lm = LoadLibrary( libraryPath );
#elif defined(LINUX32)
  lm = dlopen( libraryPath, RTLD_LAZY | RTLD_LOCAL );
#else
  #error OS not defined.
#endif
```
{% endcode %}



CD에서 제공되는 Source Program 인 PKCS11\_SampleCode.cpp, Cryptoki.cpp, PKCS11\_SampleCode.h, Cryptoki.h 대신에 강좌에서 제공하는 CCodeSample.c 만 사용하시면 됩니다. 제공되는 기본적인 header file 인 pkcs11.h, pkcs11f.h, pkcs11t.h 은 그대로 사용하시면 됩니다.

\


&#x20;

### C++ 언어를 C 언어로 변환

기본적인 골격은 C 언어를 기준으로 되어 있기 때문에, 사용자가 추가 기능을 구현하고자 하면서, C++ Sample Code를 참조하고자 할 때, 변환해야 하는 부분만 기술하고자 합니다.&#x20;



1\.  C++ 언어에서는 reference 변수를 지원하지만, C 언어에서는 지원하지 않으므로, reference변수를 사용하여 함수를 call 하는 부분은, 변수의 Address를 parameter로 넘기도록 수정 하였고,  받는 함수에서는 Pointer 변수로 받아서 구현 하였습니다.

2\.  C++ 언어에서는 new 와 delete 라는 keyword를 지원하지만, C 언어에서는 지원하지 않으므로 malloc() 과 free() 함수를 사용하여 수정 하였습니다.

3\.  C++ 언어 에서는 변수를 아무데서나 선언 할 수 있지만, C 언어 에서는 앞부분에 선언 해야 하므로, 변수를 앞 부분으로 이동 하였습니다.

4\.  C++ 언어에서는 간단한 주석 처리를 위하여, “ // “로 시작되는 라인을 지원하나 C 언어에서는 지원하지 않기 때문에 “/\*  \*/ “ 형식으로 수정 하였습니다.

5\.  C++ 언어에서 사용한 예외 처리 기능(try, catch, throw)을 삭제 하였습니다.

6\.  C 언어와는 관계 없지만, PKCS#11 API 함수를 call 할 때, Original 이름을 그대로 사용하도록 수정하였습니다.

#### CCodeSample.c file 내용

{% code overflow="wrap" fullWidth="true" %}
```c
#ifdef WIN32
  #include <windows.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <memory.h>
#elif defined (LINUX32)
  #include <memory.h>
  #include <stdio.h>
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
#elif defined(LINUX32)
  static char const libraryPath[] = "pkcs11.so" ;
  static void     *lm ;
#else
  #error OS not defined.
#endif

static CK_BYTE UserPin[] = "1234";  /* It depends on actual User Pin Number */
static CK_BBOOL bTrue = TRUE;
static CK_BBOOL bFalse = FALSE;
static CK_OBJECT_CLASS SecretKeyClass = CKO_SECRET_KEY;

void        CloseLibModule(void) ;
CK_RV   LoadPKCS11Module(void) ;
CK_RV   getSlot(CK_SLOT_ID *) ;
CK_RV   AESSamples(CK_SESSION_HANDLE) ;
CK_RV   generateAESKey(CK_SESSION_HANDLE, CK_OBJECT_HANDLE *, int , CK_CHAR_PTR) ;
CK_RV   AESEncryptDecrypt(CK_SESSION_HANDLE, CK_OBJECT_HANDLE, int , const CK_BYTE_PTR, const CK_ULONG) ;

 
/* *** MAIN *************************************************************************************** */
int main(int argc, char* argv[])
{
             CK_RV rc = 0;
             CK_BBOOL bInitialized = FALSE;
             char buffer[256] = {0};

             CK_C_INITIALIZE_ARGS args = {0};
             CK_SLOT_ID slotID = -1 ;
             CK_SESSION_HANDLE hSession = -1 ;

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

                           /* 2. Get the 1st SlotID  */
                /* When you already know the SlotID, there is no need to call getSlot() : SlotID information is in the machine file . For example, CK_SLOT_ID slotID = n */                                 
                             rc = getSlot(&slotID);
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
                              rc = pkcs11->C_Login(hSession, CKU_USER, UserPin, strlen((char*) UserPin));
                              if ( rc != CKR_OK )
                                            {
                                            printf("\n\n--- Incorrect User PIN number-----------\n");
                                            CloseLibModule() ;
                                            return rc ;
                                            }

                           /* 4. Generate AES Key and Encryption & Decryption test  */
                               rc = AESSamples(hSessio
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
            #elif defined(LINUX32)
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
            #elif defined(LINUX32)
                  pFunction = (CK_RV (*)())dlsym(lm,"C_GetFunctionList") ;
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
            #elif defined(LINUX32)
              dlclose(lm);
            #else
              #error OS not defined.
             #endif
}

 

/* *** GET the 1st SLOT ********************************************************************************* */
CK_RV getSlot(CK_SLOT_ID *pSlotID)
{ 
        CK_RV rc; 
        CK_SLOT_ID_PTR pSlotList ;
 
             /* see if there are slots with tokens */ 
        CK_ULONG numSlots;

        rc = pkcs11->C_GetSlotList(TRUE, NULL, &numSlots); 
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
 
            *pSlotID = pSlotList[0]; /* Get the 1st slot ID */
 
                 /* tidy up */ 
            free(pSlotList) ;  
           }
 
             return rc; 
}

  
/* *** AES SAMPLE CODE **************************************************************************** */ 
CK_RV AESSamples(CK_SESSION_HANDLE hSession) 
{ 
                CK_RV rc; 
                char buffer[256] = {0}; 
                CK_BYTE data[64]; 
                CK_ULONG dataLen = sizeof(data); 
                int   i ; 
                CK_OBJECT_HANDLE hAESKey; 
                 int ByteLength = 16;  // 128 bit key :  16 byte = 128 bit   
                 CK_CHAR label[] = "AES2Key";
 
                           printf("\n\n~~~ AES Key Generation & Encryption & Decryption Test ~~~~~~~~~~~\n");
 
                     /*  generate some 64-byte data  for test */ 
                           rc = pkcs11->C_GenerateRandom(hSession, data, dataLen);
 
                           printf("\r\nOriginal  Data : ") ; 
                           for ( i = 0 ; i  < 64 ; i++ ) { 
                                        printf(" %02X ",data[i]) ; 
                           }
 
                    /* generate a AES key */                
                           rc = generateAESKey(hSession, &hAESKey, ByteLength, label);  
                           if ( rc != CKR_OK ) return rc ;
 
                    /* encrypt/decrypt */ 
                           rc = AESEncryptDecrypt(hSession, hAESKey, ByteLength, data, dataLen);
 
    return rc; 
}

 

/* ___GENERATE A AES KEY ______________________________________________________ */ 
CK_RV generateAESKey(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE *phAESKey, int ByteLength, CK_CHAR_PTR label) 
{ 
             CK_RV rc; 
             CK_ULONG KeySize=0;  
             CK_KEY_TYPE KeyType; 
             CK_MECHANISM genMech; 
             KeyType = CKK_AES; 
             KeySize=ByteLength;
 
             printf("\n\n--- Generate AES Key -------------------\n");
 
                           /* get the AES Key Generation mechanism */          
                           genMech.mechanism = CKM_AES_KEY_GEN; 
                           genMech.pParameter = 0; 
                           genMech.ulParameterLen = 0;
 
               /* reset the AES Key handle */ 
            *phAESKey = 0;
 
                           /* set up the AES Key template */ 
                       CK_ATTRIBUTE AESKeyTemplate[]  =  
                       { 
                                    {CKA_CLASS, &SecretKeyClass, sizeof(SecretKeyClass)}, 
                                    {CKA_KEY_TYPE, &KeyType, sizeof(KeyType)}, 
                                    {CKA_LABEL, label, strlen((char*)label)}, 
                                    {CKA_TOKEN, &bTrue, sizeof(bTrue)}, 
                                    {CKA_EXTRACTABLE, &bTrue, sizeof(bTrue)}, 
                                    {CKA_SIGN, &bTrue, sizeof(bTrue)}, 
                                    {CKA_VERIFY, &bTrue, sizeof(bTrue)}, 
                                    {CKA_ENCRYPT, &bTrue, sizeof(bTrue)}, 
                                    {CKA_DECRYPT, &bTrue, sizeof(bTrue)}, 
                                    {CKA_WRAP, &bTrue, sizeof(bTrue)}, 
                                    {CKA_UNWRAP, &bTrue, sizeof(bTrue)}, 
                                    {CKA_VALUE_LEN, &KeySize, sizeof(KeySize)} 
                        };
 
                           /* generate the AES Key */ 
                           rc = pkcs11->C_GenerateKey(hSession, &genMech, AESKeyTemplate, sizeof(AESKeyTemplate)/sizeof(AESKeyTemplate[0]), phAESKey);
 
    return rc; 
}

 
 
/* ___ AES ENCRYPT/DECRYPT ____________________________________________________ */ 
CK_RV AESEncryptDecrypt(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE hAESKey, int ByteLength, const CK_BYTE_PTR data, const CK_ULONG dataLen) 
{     
             CK_RV rc;      
             CK_ULONG realDataLen ; 
             CK_BYTE_PTR encData ;  
             CK_BYTE_PTR decData ;   
             CK_ULONG encLen ; 
             CK_ULONG decLen ; 
             unsigned char IV[16] =  {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 }; 
             CK_ULONG i ; 
             CK_MECHANISM encDecMech;
 
             printf("\n\n--- AES Encrypt/Decrypt ----------------\n");
 
             realDataLen = dataLen + 8; 
             encData = (CK_BYTE_PTR)malloc(realDataLen); 
             if ( encData == NULL ) 
                           { /* Memory Full */ 
                           printf(" Memory Full \n") ; 
                           return !CKR_OK; 
                           }
 
             decData = (CK_BYTE_PTR)malloc(realDataLen); 
             if ( decData == NULL ) 
                           { /* Memory Full */ 
                           printf(" Memory Full \n") ; 
                           free(encData) ; 
                           return !CKR_OK; 
                           }
 
             encLen = realDataLen; 
             decLen = realDataLen;
 
                           /* set up the AES encrypt/decrypt mechanism (dependent upon the bit length) */ 
                           encDecMech.mechanism = CKM_AES_CBC; 
                           encDecMech.pParameter = IV; 
                           encDecMech.ulParameterLen = 16;
 
                           /* encrypt the data */ 
                          rc = pkcs11->C_EncryptInit(hSession, &encDecMech, hAESKey); 
                          rc = pkcs11->C_Encrypt(hSession, data, dataLen, encData, &encLen);
 
                           printf("\r\nEncrypted Data : ") ; 
                           for ( i = 0 ; i  < encLen  ; i++ ) { 
                                        printf(" %02X ",encData[i]) ; 
                           } 
                           printf("\r\n") ;
 
                           /* decrypt the data */ 
                           rc = pkcs11->C_DecryptInit(hSession, &encDecMech, hAESKey); 
                           rc = pkcs11->C_Decrypt(hSession, encData, encLen, decData, &decLen);
 
                           printf("\r\nDecrypted Data : ") ; 
                           for ( i = 0 ; i  < decLen  ; i++ ) { 
                                        printf(" %02X ",decData[i]) ; 
                           } 
                           printf("\r\n") ;
 
                           /* tidy up */ 
                         free(encData) ; 
                         free(decData) ;
 
            return rc; 
}
```
{% endcode %}
