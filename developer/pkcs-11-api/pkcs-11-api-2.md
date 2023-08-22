# PKCS#11 API-강좌2

## PKCS#11 API-강좌2



### 지원하는 Security 기능

Private-Key 와 같은 중요한 Cryptographic 정보가 HSM 장비에 저장되기 때문에, Security를 보장하기 위하여 지원하는 기능은 먼저 Token에 Access시 PIN 번호를 입력하도록 하여 PIN 번호를 알고 있는 사용자에게만  Access 권한을 부여하도록 하고 있으며, 또한 Private-Key나 Secret-Key를 생성시 “sensitive” 나 “unextractable” 과 같은 Key Policy를 지정하여 생성토록 하고 있습니다. Sensitive Key는 Plain-Text 형태로 Token 외부로 나오지 못하며, Unextractable Key는 Token 외부로 나오는 것 자체가 불가능 합니다.(Encryption 시켜도 Export가 불가능 하다라는 의미입니다)

> 참고로, 당사가 공급하는 KeyperPlus 장비에서는, 장비 자체에서 API 레벨로 Key Policy를 지정하게 하는 기능도 제공합니다. 예를 들면, Key Delete API 기능을 disable 시키면, PKCS#11 API로 Key를 delete할 수 없습니다, 또 Signing API기능을 disable 시키면, PKCS#11 API로 signing을 할 수 없습니다. Signing이 아주 중요한 업무인 경우는, 필요시에만, Signing API를 enable시켜서 사용하는 정책을 사용하면, HSM 장비를 Access하는 어플리케이션 서버를 해커가 장악하더라도, Signing을 못하게 할 수 있습니다. 물론 HSM 장비를 사용시에만 LAN선을 연결하고(또는 On-Line으로 설정), 평상시에는 LAN선을 연결하지 않는 정책(Policy)을 사용해도 동일한 효과를 얻을 수 있습니다. 하지만 HSM을 사용하는 기업의 목적과 상황이 다르기 때문에, 해당 기업에 맞게 정책(Policy)를 정해 놓고 준수하면 됩니다.



### C 나 C++ 을 사용하는 Platform이나 Compiler 에 따른 고려사항&#x20;

Cryptoki API는 C (or C++) 언어를 사용하여 구현하였고,  Cryptoki에서 사용하는 Data 형식은 API와 함께 제공되는 Header file에 define되어 있습니다. 일부 Data 형식은 사용하는 Platform OS (Windows, UNIX, Linux) 나 Platform에서 지원하는 C Compiler 버전에 따라 다를 수 있으므로, Header file 보다 앞에서 preprocessor directives로 처리하고 있습니다. 따라서 Cryptoki API를 사용하는 Source file에서 preprocessor directives를 기술해야 합니다.

> HSM 벤더에서 함께 제공하는 Sample Code에 다 구현되어 있으므로, 그냥 사용하면 됩니다(KeyperPlus에서는 C++ Sample Code를 제공하고 있습니다)



### General data types&#x20;

Cryptoki API를 call 하는 Application은 pkcs11.h 를 include 해야 합니다.&#x20;

pkcs11.h file은 pkcs11t.h 와 pkcs11f.h 를 include하고 있습니다.

Cryptoki 가 사용하고 있는 data type의 종류와 정보는, 아래 참고자료를 보시면 자세히 나와있고, 실제 코딩시에 필요한 정보이므로, 여기서는 생략합니다.

&#x20;

### Objects

Cryptoki 에서는 Object를 다루고 있으며, Object는 자신의 Object에 설정된 Attribute(속성)의 집합을 가지고 있는 데, CKA\_CLASS 속성에 정의된 값에 따라 Type(object class라고도 부름)이 결정됩니다.&#x20;

CK\_OBJECT\_CLASS 는 Class Type을 identify하는 data type 입니다.

&#x20;

실제 Source에서 사용하고 있는 예는 아래와 같습니다.

`CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY ;`



Object는 생성할 때, 지정한 attribute 값을 가지고 생성하며, 지정하지 않은 attribute는 default 값을 가진 상태로 생성됩니다.&#x20;

강좌1에서는 “Cryptoki 는 Object를 3가지 종류로 분류합니다: Data Object, Key Object, Certificate Object” 라고 기술하였습니다. 하지만, 속성에 따라 다음과 같은 Object가 더 사용되어지고 있습니다: Hardware Feature Object, Storage Object, Domain Parameter Object, Mechanism Object (관심이 있는 독자는 참고자료를 보시기 바랍니다)

Cryptoki 에서 사용하고 있는 값들은 CK\_xxx, CKA\_xxx, CKF\_xxx, CKK\_xxx, CKO\_xxx, CKR\_xxx 로 표현하고 있는 데, 이들의 의미는 아래와 같습니다.

&#x20;          CK\_xxx : 단순한 value를 의미합니다.

&#x20;          CKA\_xxx : attribute(속성) 값을 의미합니다.

&#x20;          CKF\_xxx : flag 값을 의미합니다.

&#x20;          CKK\_xxx : Key 종류&#x20;

&#x20;          CKO\_xxx : Object 값을 의미합니다.

&#x20;          CKR\_xxx : return 값을 의미합니다.

&#x20;

### Functions

강좌1의 마지막에 function 즉 제공하는 API 를 종류별로 기술하였습니다. 각 Function의 기능과  Function을 Source Code 에서 구현하는 example code는 참고자료에 자세히 설명되어 있으므로 여기서는 생략을 하고자 합니다.



### Source Code Example

지금까지 개념적인 내용을 위주로 설명하였는 데, 이는 나무를 보기 전에 멀리서 숲을 보고자 하는 목적 이었습니다. 전체적인 개념을 잡고 있으면, 실무에 적용하는 작업을 보다 쉽게 할 수 있기 때문입니다.

> KeyperPlus에서 제공하는 Sample Code를 위주로 큰 뼈대만 구현한 Source Code를 가지고 설명을 드리고자 합니다.

Cryptoki 는 동적 Library(Linux에서는 Shared Library, Windows에는 Dynamic Linking Library로 부름) 형태로 제공되므로, 이 동적 Library를 사용하는 개념을 먼저 살펴보고자 합니다. 개념은, Library를 먼저 Load 한 후, Library속에 있는 Function의 address를 얻은 후에, 그 Function의 address로 call하는 방식입니다.&#x20;

#### Windows OS 사용시

아래 코드는 Example.dll 라는 곳에 있는 AddNumbers API를 call 하는 예제입니다.

```c
        // DLL 파일 불러오기
          HINSTANCE hinstLib = LoadLibrary("Example.dll");
          if (hinstLib == NULL) {
                     printf("오류: DLL을 불러올 수 없습니다\n");
                     return 1;
          }
 
          // 함수 포인터 얻기
          addNumbers = (importFunction)GetProcAddress(hinstLib, "AddNumbers");
          if (addNumbers == NULL) {
                     printf("오류: AddNumbers 함수를 찾을 수 없습니다\n");
                FreeLibrary(hinstLib);
                     return 1;
          }
 
          // 함수에 call 하기
          result = addNumbers(1, 2);
 
          // DLL 파일의 로드를 해제한다
          FreeLibrary(hinstLib);
```

\


#### Linux OS 사용시

아래 코드는 example.so 라는 곳에 있는 AddNumbers API를 call 하는 예제입니다.

```c
        // 동적 Library 불러오기
        handle = dlopen ("example.so", RTLD_LAZY);
        if (!handle) {
            fputs (dlerror(), stderr);
            exit(1);
        }
 
        // 함수 포인터 얻기
        addNumbers = dlsym(handle, "AddNumbers");
        if ((error = dlerror()) != NULL)  {
            fputs(error, stderr);
            exit(1);
        }
 
        // 함수에 call 하기
        result = (*addNumbers)(2.0));
        dlclose(handle);
```



위와 같은 방식으로 동적 Library에 있는 API를 Call 하는 것은, Sample Program 으로 제공되는  Cryptoki.cpp 에 이미 구현되어 있으므로 그대로 사용하시면 됩니다. Cryptoki.cpp 에는 CCryptoki라는 Class가 정의되어 있고, 또한 Class내에서 사용되는 member 함수들이 정의되어 있습니다. member 함수는, Cryptoki 에서 제공하는 API와 1대1로 매칭되는 함수이며, 기능은 함수 포인터를 얻어 실제 API에게 call하는 것입니다. 또한 CCryptoki Class 의 생성함수에 동적 Library를 Load 하는 코드가 들어 있습니다.

Sample Program으로 제공되는 PKCS11\_SampleCode.cpp에 main() 함수가 있으며, global 변수로 static  CCryptoki  pkcs11;  가 정의 되어 있기 때문에, PKCS11\_SampleCode 실행시 CCryptoki 라는 Object가 만들어지면서 동적 Library가 Load되어 집니다(C++ 언어의 기본 동작 기능이므로 C++언어를 아시면 쉽게 이해가 되지만, 그렇지 못한 분은 그냥 넘어가시기 바랍니다). 그리고 실제 API를 call하기 위해서는 pkcs11 의 member 함수를 call 하면 됩니다. 예를들면,  pkcs11.Initialize(…)로 call 하면 됩니다.&#x20;

요약하면, Application에서는 Cryptoki의 API인 C\_xxxxxx 를 call 하지 않고, pkcs11.xxxxx 로 Call 하기만 하면 됩니다.

제공되는 Sample Program이 동작되는 전체적인 구조를 파악 했으므로, 이제는 실제로 동작하는 Program인 PKCS11\_SampleCode.cpp 를 보고자 합니다. PKCS11\_SampleCode.cpp 에는 다양한 예제를 포함하고 있기 때문에, 다음 강좌(마지막 강좌)에서는 한 가지 기능만 수행하는 일부분만 설명하고 마무리 하고자 합니다.

&#x20;

&#x20;

&#x20;

\
\
