# ReflectionTestUtils

using `ReflectionTestUtils` for inject field in Object

```java
import org.junit.jupitor.api.BeforeEach;
import org.springframework.test.util.ReflectionTestUtils;

class ServiceTest{
    private MyService myService;
    
    @BeforeEach
    void setUp(){
        myService = new MyServiceImpl();
        ReflectionTestUtils.setField(myService, "enable", true);
        ReflectionTestUtils.setField(myService, "url", "https://www.example/com");
    }
}
```
