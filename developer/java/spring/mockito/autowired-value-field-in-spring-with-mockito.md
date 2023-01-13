# Autowired @Value field in Spring with Mockito

```java
import org.springframework.test.util.ReflectionTestUtils;

class ServiceTest{
	@InjectMocks
	private MyService service;
  
  @Mock
  private MyClient client;

	@BeforeEach
  void setUp(){
    MockitoAnnotations.openMocks(this);
    ReflectionTestUtils.setField(service, "secret", "my_secret");
  }
	
}


```
