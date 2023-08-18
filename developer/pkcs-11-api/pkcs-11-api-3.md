# PKCS#11 API-강좌3

## PKCS#11 API-강좌3



### PKCS11\_SampleCode

KeyperPlus 제품과 함께 제공되는 CD에 Sample Code로 PKCS11\_SampleCode.cpp 라는 C++ 언어로된 Example Source가 들어 있습니다. 거의 대부분의 API 를 Call하는 다양한 예제를 포함하고 있습니다만 내용이 많기에, 그 중에서 프로그램을 개발하는 데 뼈대가 되는 핵심적인 내용만을 뽑아서 설명하고자 합니다. 이를 위해 Symmetric Key인 AES Key를 HSM장비안에서 생성하고, 생성된 AES Key를 가지고 사용자 Data를 Encryption/Decryption 하는 예제를 가지고 설명하고자 합니다.

제공되는 CD에는 Linux/UNIX(Solaris) 및 Windows 환경에서 수행(Compile 및 Link)되도록 관련 makefile 및 Project-file이 있으므로, 사용하는 OS Platform에 맞게 사용하면 되며, 이 강좌에서는 Source Program에 대해서만 설명하고자 합니다.&#x20;



#### PKCS11\_SampleCode.cpp

HSM 장비인 Keyperlus를 Call하는 메인 프로그램입니다. HSM 장비의 User PIN 번호는 1234 임을 가정하고 있습니다. Slot도 첫 번째 Slot을 사용하는 것으로 가정하고 있습니다.



#### PKCS11\_SampleCode.h

PKCS11\_SampleCode 라는 Class가 정의되어 있고, 또한 Class내에서 사용되는 member 함수들이 정의되어 있습니다. 그냥 참조만 하면 됩니다.



#### Cryptoki.cpp

CCryptoki Class 의 생성함수가 들어 있습니다. 생성함수에는 동적 Library를 Load 하는 코드가 들어 있습니다. 또한 member 함수가 들어 있습니다. member 함수는, Cryptoki 에서 제공하는 API와 1대1로 매칭되는 함수이며, 기능은 함수 포인터를 얻어 실제 API에게 call하는 것입니다. 그냥 참조만 하면 됩니다

&#x20;

#### Cryptoki.h

CCryptoki라는 Class가 정의되어 있고, 또한 Class내에서 사용되는 member 함수들이 정의되어 있습니다. 그냥 참조만 하면 됩니다



### AES Key Generation and Encryption/Decryption 예제&#x20;

아래에 기술된 Source Code를 따라가기만 해도 이해가 되리라 생각합니다. HSM 장비안에 AES Key를 생성한 후에 Encryption/Decryption 기능을 수행하고, 그리고 HSM 장비에 저장되어 있는 Key를 사용하여 Encryption/Decryption 기능을 수행합니다. 프로그램에서 사용하는 Key 정보는  HSM안에 저장된 Key를 찾아가는 Handle 정보입니다.

HSM 장비에 저장된 Key는 Key Label(Key Label은 Key 생성시 Parameter로 부여함)을 가지고 찾습니다. Encryption/Decryption 암호 연산은 HSM 장비안에서 수행됩니다. 예제 프로그램은  128 bit AES key를 생성하며, 암호 연산 Mode는 CBC 모드를 사용하고 있습니다.. AES Key 생성시 Key에 대한 Policy(암호 키로 할 수 있는 기능 정의)를 정의하고 있음을 볼 수 있습니다.

테스트용 Data로 64-byte data를 HSM장비가 제공하는 "random number generator" 기능을 사용하여 생성하고 있습니다.



{% code overflow="wrap" lineNumbers="true" fullWidth="true" %}
```c
// *** HEADER FILES ***


// Windows Specific
#ifdef WIN32
#include "windows.h"
#include "process.h"
#include <fstream>
using namespace std;
// Solaris Specific
#elif defined (SOLARIS) 
#include <memory.h>
#include <stdio.h>
#include <unistd.h>
#include <fstream>
// Linux Specific
#elif defined (LINUX32)
#include <memory.h>
#include <stdio.h>
#include <unistd.h>
// Other OS Specific
#else
#error OS Specific defined required
#endif


// Common to all Platforms
#include “PKCS11_SampleCode.h"  
#include "pkcs11x.h"
#include "Cryptoki.h"


// *** DECLARE/INITIALIZE GLOBAL VARIABLES ***
static CCryptoki pkcs11;
static CK_BYTE UserPin[] = "1234";
static CK_BBOOL bTrue = TRUE;
static CK_BBOOL bFalse = FALSE;
static CK_OBJECT_CLASS SecretKeyClass = CKO_SECRET_KEY;
static CK_KEY_TYPE AESKeyType = CKK_AES;
static CK_OBJECT_HANDLE hAESkey= 0 ; // AES Key Handle for AES Encryption/Decryption Test


 
// *** MAIN ***************************************************************************************


int main(int argc, char* argv[])
{
             CK_RV rc = 0;
             CK_BBOOL bInitialized = false;
             char buffer[256] = {0};


    try
    {
                           //1. Initialize the pkcs#11 library ...
                               CK_C_INITIALIZE_ARGS args = {0};
                               rc = pkcs11.Initialize(&args);
                               if ( rc != CKR_OK ) return rc ;
                               bInitialized = true;


 
                           //2. Get the 1st SlotID
                        // When you already know the SlotID, there is no need to call getSlot() : SlotID information is in the machine file . For example, CK_SLOT_ID slotID = n ;                                     
                               CK_SLOT_ID slotID(-1);
                               rc = PKCS11_SampleCode::getSlot(slotID); 
                               if ( rc != CKR_OK ) throw buffer ;


                                    
                           //3. Then open a session and login as a User ...
                                        // open session (must be serial/rw)
                             CK_SESSION_HANDLE hSession(-1) ;
                             rc = pkcs11.OpenSession(slotID, CKF_SERIAL_SESSION | CKF_RW_SESSION, NULL, NULL, &hSession);
                               if ( rc != CKR_OK ) throw bufer ;
                               // login as a User
                              rc = pkcs11.Login(hSession, CKU_USER, UserPin, strlen((char*) UserPin));
                              if ( rc != CKR_OK ) 
                                        {
                                        printf("\n\n--- Incorrect User PIN number-----------\n");
                                        throw buffer ;
                                        }


                           //4. Generate AES Key and Encryption & Decryption test
                               rc = PKCS11_SampleCode::AESSamples(hSession);
                               if ( rc != CKR_OK ) throw buffer ;


                           
                           //5. When we have completed the Crypto Operations, we must tidy up ...
                               // logout
                              rc = pkcs11.Logout(hSession);
                               // close session
                              rc = pkcs11.CloseSession(hSession);




                           //6. The last Cryptoki call - always finalize the library (if it has been initialised)!
                              if (bInitialized)
                                        {             
                                        rc = pkcs11.Finalize(NULL_PTR); 
                                        }
    }
    catch (char* e)
    {
                             printf(e);                  
                             if (bInitialized)
                                        {
                                        try{rc = pkcs11.Finalize(NULL_PTR);}
                                        catch(...){}
                                        }
    }
    catch (...)
    {
                           printf("FATAL ERROR\n");
                           if (bInitialized)
                                        {
                                        try{rc = pkcs11.Finalize(NULL_PTR);}
                                        catch(...){}
                                        }
    }        
    return rc;
}


// *** end of MAIN ********************************************************************************


 


 
// *** GET the 1st SLOT *********************************************************************************


CK_RV PKCS11_SampleCode::getSlot(CK_SLOT_ID &slotID)
{
             CK_RV rc;
    try
    {                     
             // see if there are slots with tokens
        CK_ULONG numSlots;
        rc = pkcs11.GetSlotList(TRUE, NULL, &numSlots);
        if (numSlots)  // we've got one or more
        {
            // call pkcs11.GetSlotList() again with a correctly sized buffer
            CK_SLOT_ID_PTR pSlotList = new CK_SLOT_ID[numSlots];
            memset(pSlotList, 0xFF, sizeof(CK_SLOT_ID)*numSlots);
            rc = pkcs11.GetSlotList(TRUE, pSlotList, &numSlots);


    
            // save the slot for use later
            slotID = pSlotList[0]; // 1st slot ID


               // tidy up
            delete [] pSlotList;
            pSlotList = NULL;
        }
    }
             catch (char* e)
    {
                 printf(e);
    }
    catch (...){}


     return rc;
}


 


 
// *** AES SAMPLE CODE ****************************************************************************


CK_RV PKCS11_SampleCode::AESSamples(CK_SESSION_HANDLE hSession)
{
    printf("\n\n~~~ AES Key Generation & Encryption & Decryption Test ~~~~~~~~~~~\n");
             
             CK_RV rc;
             char buffer[256] = {0};


    try
    {
                   // generate some 64-byte data  for test
                           CK_BYTE data[64];
                           CK_ULONG dataLen = sizeof(data);
                           int          i ;


                           rc = pkcs11.GenerateRandom(hSession, data, dataLen);


                           printf("\r\nOriginal  Data : ") ;
                           for ( i = 0 ; i  < 64 ; i++ ) {
                                        printf(" %02X ",data[i]) ;
                           }


                // generate a AES key
                           CK_OBJECT_HANDLE hAESKey;
                           int ByteLength = 16;  // 128 bit key :  16 byte = 128 bit  
                           CK_CHAR label[] = "AES1Key";
                           rc = PKCS11_SampleCode::generateAESKey(hSession, hAESKey, ByteLength, label); 
                           if ( rc != CKR_OK ) return rc ;


                           // encrypt/decrypt
                           rc = PKCS11_SampleCode::AESEncryptDecrypt(hSession, hAESKey, ByteLength, data, dataLen); 
                           if ( rc != CKR_OK ) return rc  ;


                // Retrieve AES Key from HSM by FindObject() 
                           CK_OBJECT_HANDLE hNewKey= 0 ;
                           CK_CHAR newlabel[] = "AES1Key" ;
                           printf("\n\n--- Find Key Object By Label from HSM ------------------\n");


                           // declare variables  
                         CK_ULONG count = 0;
                           // declare the find object Template
                         CK_ATTRIBUTE objTemplate[] =   {
                                        {CKA_TOKEN, &bTrue, sizeof(bTrue)},
                                        {CKA_LABEL, newlabel, strlen((char*)newlabel)}};


                           // find the object by its label
                         rc = pkcs11.FindObjectsInit(hSession, objTemplate, 2);
                         if (rc == CKR_OK)
                                       {
                                      rc = pkcs11.FindObjects(hSession, &hNewKey, 1, &count);
                                      pkcs11.FindObjectsFinal(hSession);
                                       }
                           else        return rc ;


                           if ( hNewKey == 0 ) 
                                        {
                                        printf("\n\n--- There is no AES key with given label in HSM-----\n");
                                        return rc ;
                                        }; 


                // encrypt/decrypt again with retrieved Key
                           rc = PKCS11_SampleCode::AESEncryptDecrypt(hSession, hNewKey, ByteLength, data, dataLen); 
             }
             catch (char* e)
    {
                 printf(e);
    }
    catch (...){}


    return rc;
}


 


 
// ___GENERATE A AES KEY ______________________________________________________


CK_RV PKCS11_SampleCode::generateAESKey(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE& hAESKey, int ByteLength, CK_CHAR_PTR label)
{
            printf("\n\n--- Generate AES Key -------------------\n");


             CK_RV rc;
             CK_ULONG KeySize=0; 


    try
    {
                           // get the AES Key Generation mechanism
                          CK_KEY_TYPE KeyType;
                          CK_MECHANISM genMech;


                           genMech.mechanism = CKM_AES_KEY_GEN;
                           KeyType = CKK_AES;
                           KeySize=ByteLength;


                           // set the parameter
                           genMech.pParameter = 0;
                           genMech.ulParameterLen = 0;


                           // reset the AES Key handle
                          hAESKey = 0;


                           // set up the AES Key template 
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


                           // generate the AES Key
                           rc = pkcs11.GenerateKey(hSession, &genMech, AESKeyTemplate, sizeof(AESKeyTemplate)/sizeof(AESKeyTemplate[0]), &hAESKey);


           
    }
             catch (char* e)
    {
                 printf(e);
    }
    catch (...) {}


    return rc;
}


 


// ___ AES ENCRYPT/DECRYPT ____________________________________________________


CK_RV PKCS11_SampleCode::AESEncryptDecrypt(CK_SESSION_HANDLE hSession, CK_OBJECT_HANDLE hAESKey, int ByteLength, const CK_BYTE_PTR data, const CK_ULONG dataLen)
{
    printf("\n\n--- AES Encrypt/Decrypt ----------------\n");


    CK_RV rc;


    try
    {
                           // declare variables
                           CK_ULONG realDataLen = dataLen + 8;
                           CK_BYTE_PTR encData = new CK_BYTE[realDataLen];  
                           CK_BYTE_PTR decData = new CK_BYTE[realDataLen];  
                           CK_ULONG encLen = realDataLen;
                           CK_ULONG decLen = realDataLen;
                           unsigned char IV[16] =  {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
                           CK_ULONG i ;


                           // set up the AES encrypt/decrypt mechanism (dependent upon the bit length)
                           CK_MECHANISM encDecMech;
                           encDecMech.mechanism = CKM_AES_CBC;


                           // set up parameter
                           encDecMech.pParameter = IV;
                           encDecMech.ulParameterLen = 16;


                           // encrypt the data
                          rc = pkcs11.EncryptInit(hSession, &encDecMech, hAESKey);
                          rc = pkcs11.Encrypt(hSession, data, dataLen, encData, &encLen);


                           printf("\r\nEncrypted Data : ") ;
                           for ( i = 0 ; i  < encLen  ; i++ ) {
                                        printf(" %02X ",encData[i]) ;
                           }
                           printf("\r\n") ;


                           // decrypt the data
                           rc = pkcs11.DecryptInit(hSession, &encDecMech, hAESKey);
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
             catch (char* 
    {
                 printf(e);
    }
    catch (...) {}


    return rc;
}
```
{% endcode %}

&#x20;

예제 프로그램 수행 결과 값

위 프로그램을 수행한 결과 값은 아래와 같이 나옵니다. 즉 첫 번째 Encryption/Decryption 결과 값과 두 번째 Encryption/Decryption 결과 값이 동일하므로, HSM장비안에 저장된 Key는 Key Label만 알면 언제든지 사용할 수 있다는 것을 나타냅니다.

\


&#x20;

{% code overflow="wrap" fullWidth="true" %}
```bash
~~~ AES Key Generation & Encryption & Decryption Test ~~~~~~~~~~~

Original  Data :  BC  62  98  D7  21  0E  32  D7  6B  42  73  6A  74  FF  C6  CD  ED  6A  14  F4  8B  66  0F  26  3C  B2  D0  1F  A2  0E  D1  36  82  FB  0C  E9  82  4A  D8  24  97  01  8C  3D  B0  74  03  00  5D  9B  1C  1A  84  86  83  42  0B  F5  8E  47  0A  C2  37  FD 

--- Generate AES Key -------------------
 
--- AES Encrypt/Decrypt ----------------

Encrypted Data :  8B  1F  80  11  B8  1A  F9  7B  37  12  CB  F9  E7  89  AC  CC  FE  4A  A0  35  92  DF  92  7C  F6  42  A3  C2  51  4F  CF  9B  7B  1A  80  7F  2E  82  7C  7F  62  63  1C  B0  22  0B  99  5D  56  E2  81  B1  79  96  19  2C  CE  9A  24  4A  A1  D5  10  F7 

Decrypted Data :  BC  62  98  D7  21  0E  32  D7  6B  42  73  6A  74  FF  C6  CD  ED  6A  14  F4  8B  66  0F  26  3C  B2  D0  1F  A2  0E  D1  36  82  FB  0C  E9  82  4A  D8  24  97  01  8C  3D  B0  74  03  00  5D  9B  1C  1A  84  86  83  42  0B  F5  8E  47  0A  C2  37  FD 

--- Find Key Object By Label from HSM ------------------
 
--- AES Encrypt/Decrypt ----------------

Encrypted Data :  8B  1F  80  11  B8  1A  F9  7B  37  12  CB  F9  E7  89  AC  CC  FE  4A  A0  35  92  DF  92  7C  F6  42  A3  C2  51  4F  CF  9B  7B  1A  80  7F  2E  82  7C  7F  62  63  1C  B0  22  0B  99  5D  56  E2  81  B1  79  96  19  2C  CE  9A  24  4A  A1  D5  10  F7 

Decrypted Data :  BC  62  98  D7  21  0E  32  D7  6B  42  73  6A  74  FF  C6  CD  ED  6A  14  F4  8B  66  0F  26  3C  B2  D0  1F  A2  0E  D1  36  82  FB  0C  E9  82  4A  D8  24  97  01  8C  3D  B0  74  03  00  5D  9B  1C  1A  84  86  83  42  0B  F5  8E  47  0A  C2  37  FD
```
{% endcode %}

\
