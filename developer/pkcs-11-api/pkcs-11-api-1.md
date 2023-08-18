# PKCS#11 API-강좌1

## PKCS#11 API-강좌1

PKCS#11 Module은 HSM(Hardware Security Module), Smart Card, Crypto Tokens(예를들면, USB Token)과 같은 Crypto Hardware를 Access하기 위한 API를 가지고 있는 Module이며, H/W Vendor가 제공하는 S/W Library 입니다.  Cryptoki Module이라고도 불리는데, Cryptoki는 Cryptographic Token Interface를 줄여서 만든 글자라고 합니다.&#x20;

​정리하면, PKCS#11 Module이란 PKCS#11 API를 가지고 있는 Module입니다.

PKCS#11 API 란 HSM 장비를 Call 하기 위해 만든 표준 I/F 중의 하나로, RSA사에서 표준화를 하여 제공하였으며(Ver2.2 와 Ver2.3 Draft), 지금은 표준화 작업이 OASIS community로 넘어간 상태입니다. HSM 장비를 제공하는 Vendor들은 Ver.2.2 를 기준으로 구현된 Provider(제공하는 S/W Library를 Provider라고 부름, HSM장비를 Access하기 위한  Agent S/W라고도 부름)를 제공하고 있기 때문에, Ver2.2를 기준으로 설명하고자 합니다.&#x20;

​이 문서에는 PKCS#11 API 를 Cryptoki 로 표현하고 있으므로, Cryptoki 란 용어를 사용하여 설명하고자 합니다. Cryptoki 는 ANSI C type을 기준으로 기술되어 있습니다.

기본적인 개념(용어)을 중심으로 설명하고자 합니다.



### Token 과 Slot

Cryptoki를 처음 디자인 할 때, Private-Key 와 같은 중요한 Cryptographic 정보를 Smart Card와 같이 이동이 가능한 Token(Cryptographic Token을 줄여서 Token이라 함)에 저장하는 것을 고려 하였기 때문에, Slot 이란 개념이 함께 생겼습니다. Smart Card(암호정보를 보관하는 Token의 한 종류)를 사용하려면, Smart Card Reader라는 장치에 Smart Card를 집어넣어 사용해야 합니다. Smart Card Reader 장치와 같은 역할을 하는 것을 Slot 이라고 부릅니다. 즉 Cryptoki 가 Token을 Access하려면, Slot에 Token이 장착되어 있어야 합니다. HSM 장비는 Token이 Slot에 장착된 장비라고 보면 됩니다. 즉 영문으로는 표현하면 “Slot with token present” 가 됩니다.  HSM 장비 기준으로 보면 Slot과 Token이 1대1로 mapping이 되므로, Token이 곧 바로 Slot이 됩니다. 따라서 Cryptoki 에서는 HSM 장비를 Slot으로 보고 Access합니다.  즉 Cryptoki 관점에서 보면, HSM 장비는 한 개의 Slot 입니다. 여러 개의 Slot이 사용될 수 있으므로, Cryptoki는 Slot 번호로 Slot을 선택하여 사용합니다. 참고로, 당사에서 제공하는 KeyperPlus 장비는 하나의 장비에 최대 150개까지 Slot을 Define 할 수 있습니다. 대부분의 어플리케이션에서는 KeyperPlus를 하나의 Slot 으로만 사용한다고 합니다.

![](https://mblogthumb-phinf.pstatic.net/20160705\_195/aepkoreanet\_1467720976084wWvBT\_JPEG/slot.jpg?type=w2)

또한 다수의 Application이 다수의 Slot을 서로 공유하기도 하고 경쟁하기도 할 수 있으므로 Cryptoki Module의 개념은 아래 그림과 같습니다.

![](https://mblogthumb-phinf.pstatic.net/20160705\_15/aepkoreanet\_1467721001838I2eXl\_JPEG/cryptoki1.jpg?type=w2)



### Token 과 Object

Cryptoki 관점에서 보면 Token은 Object를 저장하고 암호연산을 수행하는 디바이스입니다. Cryptoki는 Object를 3가지 종류로 분류합니다: Data Object, Key Object, Certificate Object

![](https://mblogthumb-phinf.pstatic.net/20160705\_129/aepkoreanet\_1467721023730SNAdD\_JPEG/object.jpg?type=w2)



또 Object는 Life Time 과 Visibility에 따라 Token Object와 Session Object 2가지로 분류 됩니다.

Token Object는 Token 즉 HSM 장비에 저장되는 Object이며, Session Object는 Session 동안만 존재하는 Object 입니다. Session Object는 Cryptoki를 사용하는 서버의 메모리 어딘가에 일시적으로 존재하다가 Session이 Close 되면서 함께 사라지는 Object 입니다. Session Object는 해당 Session을 Create한 Application에서만 visible합니다.

Access 권리에 따라, Private Object와 Public Object로 나누어 집니다. 즉 Private Object는 인가된 사용자만 Access할 수 있습니다.

당사가 제공하는 KeyperPlus에서는 Key Object 중, Private-Key와 Secrete Key만 HSM 장비안에 저장하고, 나머지 Object(Public-Key Object, Certificate Object, Data Object)는 Cryptoki가 있는 서버의 특정 영역에 암호화되어 저장됩니다.(기술적으로 Public-Key Object에 대한 정보는  KeyperPlus내에 Private-Key와 함께 저장됩니다만, Public-Key는 보호하는 Key가 아니므로 Private-Key만 저장되어 있다고 표현하고 있습니다). HSM 장비 안에 저장되는 Key를 Application Key라고 부릅니다.

KeyperPlus에서 Key가 생성될 때(Generation 또는 Import), “Key Policy” 를 정해 주어야 합니다. Key Policy에는 Key로 무엇을 할 수 있는 지(Sign, Encrypt,  Decrypt 등), Export는 어떻게 되는 지(No Export, Wrapped only Export, Plain text Export 등)를 정해 주어야 합니다. Key가 생성되고 난 후에는 “Key Policy”는 변경 될 수 없습니다.

&#x20;

### Session

Cryptoki와 Slot은 Session으로 연결됩니다. Cryptoki가 Token을 Access하기 위해서는 먼저 Token과 Session을 맺어야 합니다. 한 개 이상의 Session을 맺을 수 있습니다.  Session이란 Cryptoki 와Token의 logical connection입니다.&#x20;

Read/Write(R/W) Session이 있고, Read-Only Session이 있는 데, Token Object를 Access할 때의 기능을 정의하는 것입니다. 특별한 용도가 아니면, Token Object에 R/W 기능을 수행할 수 있는 R/W Session을 사용하신다고 보면 됩니다.

HSM 장비를 Access 하기 위해 Session을 Open할 때 C\_OpenSession() 함수를 Call하는데, flag변수로 “CKF\_SERIAL\_SESSION|CKF\_RW\_SESSION” 값만 사용하면 됩니다. CKF\_SERIAL\_SESSION은 호환성을 유지하기 위하여 사용해야 한다고 합니다.

표준으로 제공하는 문서에 보면 자세하게 설명을 하고 있고 내용도 많지만, KeyperPlus와 같은 HSM 장비를 Access하는 Application을 cording하는 데는, 기본적인 개념만 이해하고 나머지는 무시를 해도 어려움이 없기 때문에 생략을 하고자 합니다(Session의 개념을 디자인한 분에게는 죄송스럽지만, 디자인하신 분의 의도를 정확히 안다고 해도, Cryptoki Coding을 더 잘 할 수 있는 것도 아니고, Session의 자세한 기능을 모른다고 해도 Cryptoki Coding을 하는 데 특별한 어려움이  없기 때문입니다). 하지만, Session의 다양한 기능을 필요로 하는 Application을 개발하시는 분들은  표준 문서에 기술된 내용을 자세히 이해하실 필요가 있다고 생각합니다.



### Users : SO(Security Officer) 와 Normal User

Cryptoki는 두 가지 종류의 사용자를 인식합니다. Normal User만이 Token에 저장된 Object를 Access할 수 있습니다. 물론 Access하기 전에 적법한 사용자인지 Authentication(인증) 과정을 거칩니다. SO는 Token을 초기화 시키거나 Normal User의 PIN 번호를 지정하는 역할을 수행 합니다. 따라서 Token을 초기화 시키는 경우나 PIN 번호를 변경하는 경우가 아니면 SO는 필요하지 않습니다.

당사가 제공하는 KeyperPlus에서는 InitToken 이라는 Utility를 사용하여, 장비를 초기화 시킬 때, SO 와 Normal User에게 PIN 번호를 부여 합니다. 추후 Application에서 사용시는 Normal User의 PIN번호만 사용합니다.



### Application

Cryptoki 관점에서 보면,  하나의 Application은 Single Address Space로 구성되어 지며, Single Process 입니다.  한 Application내에서는 다수의 Thread가 수행 가능합니다.

Application은 C\_Initialize()를 Call함으로 Cryptoki Application이 되며, 암호 관련 연산을 수행 한 후, C\_Finalize()를 Call함으로 일반 Application으로 돌아옵니다.&#x20;

Application이 multi-threaded fashion으로 동작할 경우는, C\_Initialize() 할 때, 4가지 방식의 multi-thread 방식 중 하나를 지정할 수 있습니다(자세한 내용은 참고자료).

C Language에서 File을 Access할 때, Handle을 가지고 다루듯이, Cryptoki 에서도 Session과 Object를 다룰 때 Handle을 사용합니다.  Session Handle이란 Session을 identify하는 value이며, Object Handle 이란 Object를 identify하는 value 입니다.&#x20;



### Cryptoki API&#x20;

General Purpose functions :&#x20;

&#x20;            C\_Initialize :      initializes Cryptoki

&#x20;            C\_Finalize  :    clean up miscellaneous Cryptokiassociated resources

&#x20;            C\_GetInfo  :    obtains general information aboutCryptoki

&#x20;            C\_GetFunctionList :       obtains entry points of Cryptoki libraryfunctions



Slot and token management functions :

&#x20;            C\_GetSlotList :              obtains a list of slots in the system

&#x20;            C\_GetSlotInfo :                           obtains information about a particular slot

&#x20;            C\_GetTokenInfo :          obtains information about a particular token

&#x20;            C\_WaitForSlotEvent :    waits for a slot event (token insertion, removal, etc.) to occur

&#x20;            C\_GetMechanismList :   obtains a list of mechanisms supported by a token

&#x20;            C\_GetMechanismInfo :              obtains information about a particular mechanism

&#x20;            C\_InitToken :                 initializes a token

&#x20;            C\_InitPIN :                     initializes the normal user’s PIN

&#x20;            C\_SetPIN :                     modifies the PIN of the current user&#x20;



Session management functions :&#x20;

&#x20;            C\_OpenSession :            opens a connection between an application and a particular token or sets up an application callback for token insertion

&#x20;            C\_CloseSession :            closes a session

&#x20;            C\_CloseAllSessions :      closes all sessions with a token

&#x20;            C\_GetSessionInfo :        obtains information about the session

&#x20;            C\_GetOperationState :   obtains the cryptographic operations state of a session

&#x20;            C\_SetOperationState :    sets the cryptographic operations state of a session

&#x20;            C\_Login :                        logs into a token

&#x20;            C\_Logout :                     logs out from a token



Object management functions

&#x20;            C\_CreateObject :            creates an object

&#x20;            C\_CopyObject               :            creates a copy of an object

&#x20;            C\_DestroyObject :         destroys an object

&#x20;            C\_GetObjectSize :          obtains the size of an object in bytes

&#x20;            C\_GetAttributeValue :   obtains an attribute value of an object

&#x20;            C\_SetAttributeValue :    modifies an attribute value of an object

&#x20;            C\_FindObjectsInit :        initializes an object search operation

&#x20;            C\_FindObjects              :            continues an object search operation

&#x20;            C\_FindObjectsFinal :    finishes an object search operation



Encryption functions&#x20;

&#x20;            C\_EncryptInit :            initializes an encryption operation

&#x20;            C\_Encrypt        :            encrypts single-part data

&#x20;            C\_EncryptUpdate :        continues a multiple-part encryption operation

&#x20;            C\_EncryptFinal  :         finishes a multiple-part encryption operation



Decryption functions

&#x20;            C\_DecryptInit :            initializes a decryption operation

&#x20;            C\_Decrypt        :            decrypts single-part encrypted data

&#x20;            C\_DecryptUpdate :        continues a multiple-part decryption operation

&#x20;            C\_DecryptFinal :            finishes a multiple-part decryption operation



Message digesting functions

&#x20;            C\_DigestInit      :            initializes a message-digesting operation

&#x20;            C\_Digest          :            digests single-part data

&#x20;            C\_DigestUpdate             :          continues a multiple-part digesting operation

&#x20;            C\_DigestKey    :            digests a key

&#x20;            C\_DigestFinal :            finishes a multiple-part digesting operation



Signing and MACing functions

&#x20;            C\_SignInit         :            initializes a signature operation

&#x20;            C\_Sign signs     :            single-part data

&#x20;            C\_SignUpdate :            continues a multiple-part signature operation

&#x20;            C\_SignFinal      :            finishes a multiple-part signature operation

&#x20;            C\_SignRecoverInit :       initializes a signature operation, where the data can be recovered from the signature

&#x20;            C\_SignRecover signs :   single-part data, where the data can be recovered from the signature



Functions for verifying signatures and MACs

&#x20;            C\_VerifyInit     :            initializes a verification operation

&#x20;            C\_Verify          :            verifies a signature on single-part data

&#x20;            C\_VerifyUpdate :           continues a multiple-part verification operation

&#x20;            C\_VerifyFinal  :          finishes a multiple-part verification operation

&#x20;            C\_VerifyRecoverInit :    initializes a verification operation where the data is recovered from the signature

&#x20;            C\_VerifyRecover :         verifies a signature on single-part data, where the data is recovered from the signature



Dual-purpose cryptographic function

&#x20;            C\_DigestEncryptUpdate :           continues simultaneous multiple-part digesting and encryption operations

&#x20;            C\_DecryptDigestUpdate :           continues simultaneous multiple-part decryption and digesting operations

&#x20;            C\_SignEncryptUpdate   :            continues simultaneous multiple-part signature and encryption operations

&#x20;            C\_DecryptVerifyUpdate :           continues simultaneous multiple-part decryption and verification operations



Key management functions

&#x20;            C\_GenerateKey             :            generates a secret key

&#x20;            C\_GenerateKeyPair       :            generates a public-key/private-key pair

&#x20;            C\_WrapKey                   :            wraps (encrypts) a key

&#x20;            C\_UnwrapKey                            :            unwraps (decrypts) a key

&#x20;            C\_DeriveKey                 :            derives a key from a base key



Random number generation functions

&#x20;            C\_SeedRandom            :            mixes in additional seed material to the random number generator

&#x20;            C\_GenerateRandom      :            generates random data&#x20;



Parallel function management functions

&#x20;            C\_GetFunctionStatus    :            legacy function which always returns CKR\_FUNCTION\_NOT\_PARALLEL

&#x20;            C\_CancelFunction         :            legacy function which always returns CKR\_FUNCTION\_NOT\_PARALLEL



Callback function

&#x20;                  application-supplied function to process notifications from Cryptoki

&#x20;
