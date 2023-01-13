# Parameterized Test

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

class ServiceTest{
  
  @ParameterizedTest
  @ValueSource(strings = {"123", "234", "asdf", "qwer"})
  void paramTest(String code){
    
  }
}
```

`@ValueSource`에서는 다양한 Parameter들을 지원한다.

* shorts
* bytes
* ints
* longs
* floats
* doubles
* chars
* booleans
* strings
* classes

## Appendix

https://www.baeldung.com/parameterized-tests-junit-5
