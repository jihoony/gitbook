# Serverless Architecture

## Intro

Serverless는 개발자가 서버를 관리할 필요 없이 애플리케이션을 빌드하고 실행할 수 있도록 하는 클라우드 네이티브 개발 모델이다. 사용자는 기본 인프라를 걱정하지 않고 코드를 작성하고 배포할 수 있다. 클라우드 컴퓨팅 실행 모델의 하나로, 클라우드 제공자는 동적으로 머신 자원의 할당을 관리한다.

서버리스 컴퓨팅은 여전히 서버가 필요하므로 부적절한 명칭이지만, 그 명칭이 사용된 이유는 서버 관리 및 용적 계획 결정이 완전히 개발자나 운영자로부터 숨겨져 있기 때문이다.

> 서버리스는 "서버가 없다"는 뜻이 아니다. "서버를 직접 관리할 필요가 없다"는 뜻이다.

### 소프트웨어 아키텍처의 미래

클라우드 컴퓨팅 환경은 끊임없이 진화하고 있으며, 인프라를 유지하고, 배포를 관리하고, 코드를 실행할 수 있는 다양한 방법을 제공한다. 분명히, IaaS, PaaS 및 서버리스 아키텍처가 다른 시기에 출시됨에 따라 클라우드 인프라의 역사에 놀라운 변화가 있었다.

#### 클라우드 인프라의 진화

![](https://www.einfochips.com/blog/wp-content/uploads/2018/05/a-brief-history-of-cloud.jpg)

위의 다이어그램에서 언급했듯이, 그것은 모두 데이터 센터에서 시작하여 AWS가 출시된 후 IaaS로 이동했다. AWS는 기본적으로 IaaS(서비스로서의 인프라)이다. IaaS에서는 API 호출에서 인프라를 시작하고 프로비저닝하거나 AWS 콘솔을 사용할 수 있다. 그러나 프로비저닝된 서버, 운영 체제 및 OS 패치를 유지해야 한다.

IaaS 이후, AWS는 Elastic Beanstalk 측면에서 PaaS(서비스로서의 플랫폼)를 출시했다. PaaS에서는 애플리케이션을 업로드하기만 하면 AWS는 애플리케이션을 기반으로 인프라를 만듭니다. PaaS에서도 인프라를 유지해야 한다.

PaaS 이후, AWS는 서버리스 인프라를 출시했다. 그것은 인프라 공급 측면에서 완전한 혁명이다. 서버리스 인프라를 사용하면 컨테이너가 기본 OS와 서버 확장을 관리하기 때문에 IaaS와 PaaS에 대해 걱정할 필요가 없다.

참고: https://www.einfochips.com/blog/serverless-architecture-the-future-of-software-architecture/

## Serverless 아키텍처의 구현 방식

Serverless의 구현은 크게 BaaS와 FaaS로 구현할 수 있다.

### BaaS(Backend as a Service)

데이터 저장이나 다른 기기에서의 접근 및 공유를 위해서는 Backend가 필수 적이다. 서버의 확장, 보안성 등도 고려해야 한다. 가장 대표적인 서비스는 Firebase가 있다. 앱개발시에 필요한 데이터베이스나 소셜 서비스 연동, 파일 시스템 API 등을 제공해주고 서버개발을 하지 않아도 기능을 쉽고 빠르게 구축할 수 있다.

### FaaS(Function as a Service)

서버 기능을 여러개의 함수로 쪼개서 함수를 플랫폼에 등록하고 함수 단위로 실행하는 방식. 가장 대표적인 서비스는 AWS Lambda가 있다. 함수가 호출된 만큼만 비용이 부과되므로 비용을 많이 절약할 수 있다.

## Serverless 아키텍처의 장단점

### 장점

* 대용량 서버를 쉽게 만들수 있다. -> 비즈니스 로직만 작성하면 되고 나머지는 플랫폼 제공자가 제공해 준다.
* 개발기간이 단축된다.
* 안정성이 높다. -> 플랫폼이 보장해 준다.
* 서버 소스 프로그램이 크게 단순화 된다. -> 프레임워크에 의존하지 않아서 소스코드에서만 오류의 원인을 찾을수 있다. 유지보수 용이하다.
* 저렴하다. 사용료가 IaaS보다 훨씬 저렴하다. -> 평소에 슬립상태에서 요청이 올때만 깨어나서 실제로 처리가 이뤄진 시간 만큼만 요금이 부과된다.

### 단점

* 클라우드 플랫폼에 심하게 종속적이다. -> 이를 해결하기 위한 서버리스 아키텍처 표준이 필요하다.
* 클라우드 플랫폼 인프라 자체의 문제가 생길경우 컨트롤 할 수 없다.
* 슬립상태에서 깨어나는 시간에 상당한 딜레이가 발생(Cold Start)할 수 있다. -> 긴급한 응답을 요하는 서비스는 사용할 수 없었다. WebAssembly가 이러한 단점을 개선될 가능성을 보여주고 있다.
* 긴시간을 요하는 작업에 불리하다.

## Appendix

### 응용 사례

* Netflix
* REA Group

### 참고

* [9 Killer Use Cases for AWS Lambda](https://www.contino.io/insights/aws-lambda-use-cases)
* [Who's Using AWS Lambda](https://www.contino.io/insights/whos-using-aws-lambda-1)
* [AWS 서버리스 고객 성공 사례](https://aws.amazon.com/ko/serverless/customers/)

### 서버리스 프레임워크

* Kubless
* Fission
* Funktion
* Nuclio
* OpenFaas
* Oracle Fn

### 플랫폼 제공업체

* Amazon: AWS Lambda
* Microsoft: Azure Function
* Google: GCF
* CloudFlare: Workers
* Naver Cloud: Cloud Functions
