# Logging with Lombok

Lombok 사용시 `@Sl4j` Annotation을 통해 로그 출력을 할 수 있다. 이때 기본 로거를 세팅해 주어야 하는데, `pom.xml`에 다음의 dependency를 추가하여 편리하게 설정 할 수 있다.



```xml
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.2.3</version>
</dependency>
```
