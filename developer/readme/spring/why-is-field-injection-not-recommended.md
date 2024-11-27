# Why Is Field Injection Not Recommended?

### 1. Overview <a href="#bd-overview" id="bd-overview"></a>

When we run the code analysis tool in the IDE, it may issue the “_Field injection is not recommended_” warning for fields with the _@Autowired_ annotation.

In this tutorial, we’ll explore why field injection isn’t recommended and what alternative approaches we can use.

### 2. Dependency Injection <a href="#bd-dependency-injection" id="bd-dependency-injection"></a>

The process where objects use their dependent objects without a need to define or create them is called dependency injection. It’s one of the core functionalities of the Spring framework.

We can inject dependent objects in three ways, using:

* Constructor injection
* Setter injection
* Field injection

The third approach here involves injecting dependencies directly into the class using the _@Autowired_ annotation. Although it may be the simplest approach, we must understand that there are potential issues it might cause.

What’s more, even the [official Spring documentation](https://docs.spring.io/spring-framework/reference/core/beans/dependencies/factory-collaborators.html) doesn’t provide field injection as one of the DI options anymore.

### 3. Null-Safety <a href="#bd-null-safety" id="bd-null-safety"></a>

**Field injection creates a risk of&#x20;**_**NullPointerException**_**&#x20;if dependencies aren’t correctly initialized.**

Let’s define the _EmailService_ class and add the _EmailValidator_ dependency using the field injection:

```
@Service
public class EmailService {

    @Autowired
    private EmailValidator emailValidator;
}
```

Now, let’s add the _process()_ method:

```
public void process(String email) {
    if(!emailValidator.isValid(email)){
        throw new IllegalArgumentException(INVALID_EMAIL);
    }
    // ...
}
```

The _EmailService_ works properly only if we provide the _EmailValidator_ dependency. **However, using the field injection, we didn’t provide a direct way of instantiating the&#x20;**_**EmailService**_**&#x20;with required dependencies.**

Moreover, we are able to create the _EmailService_ instance using the default constructor:

```
EmailService emailService = new EmailService();
emailService.process("[email protected]");
```

Executing the code above would cause _NullPointerException_ since we didn’t provide its mandatory dependency, _EmailValidator_.

Now, we can **reduce the risk of&#x20;**_**NullPointerException**_**&#x20;using the constructor injection**:

```
private final EmailValidator emailValidator;

public EmailService(final EmailValidator emailValidator) {
   this.emailValidator = emailValidator;
}
```

With this approach, we exposed the required dependencies publicly. Additionally, we now require clients to provide the mandatory dependencies. In other words, there’s no way to create a new instance of the _EmailService_ without providing the _EmailValidator_ instance.

### 4. Immutability <a href="#bd-immutability" id="bd-immutability"></a>

**Using the field injection, we are unable to create immutable classes.**

We need to instantiate the final fields when they’re declared or through the constructor. **Furthermore, Spring performs autowiring once the constructors have been called.** Therefore, it’s impossible to autowire the final fields using field injection.

Since the dependencies are mutable, there’s no way we can ensure they will remain unchanged once they’re initialized. Furthermore, reassigning non-final fields can cause unexpected side effects when running the application.

Alternatively, we can use constructor injection for mandatory dependencies and setter injection for optional ones. This way, we can ensure the required dependencies will remain unchanged.

### 5. Design Problems <a href="#bd-design-problems" id="bd-design-problems"></a>

Now, let’s discuss some possible design problems when it comes to field injection.

#### 5.1. Single Responsibility Violation <a href="#bd-1-single-responsibility-violation" id="bd-1-single-responsibility-violation"></a>

Being part of the SOLID principles, the Single responsibility principle states each class should have only one responsibility. To put it differently, one class should be responsible for only one action and, thus, have only one reason to change.

When we use field injection, we may end up violating the single responsibility principle. **We can easily add more dependencies than necessary and create a class that’s doing more than one job.**

On the other hand, if we’re using constructor injection, we’d notice we might have a design problem if a constructor has more than a few dependencies. Furthermore, even the IDE would issue a warning if there are more than seven parameters in the constructor.

#### 5.2. Circular Dependencies <a href="#bd-2-circular-dependencies" id="bd-2-circular-dependencies"></a>

Simply put, circular dependencies occur when two or more classes depend on each other. Because of these dependencies, it’s impossible to construct objects, and the execution can end up with runtime errors or infinite loops.

The use of field injection can result in circular dependencies going unnoticed:

```
@Component
public class DependencyA {

   @Autowired
   private DependencyB dependencyB;
}

@Component
public class DependencyB {

   @Autowired
   private DependencyA dependencyA;
}
```

**Since the dependencies are injected when needed and not on the context load, Spring won’t throw&#x20;**_**BeanCurrentlyInCreationException**_**.**

With constructor injection, it’s possible to detect circular dependencies at compile time since they would create unresolvable errors.

Moreover, if we have circular dependencies in our code, it might be a sign something is wrong with our design. Therefore, we should consider redesigning our application if possible.

**However, since Spring Boot 2.6. version** [**circular dependencies are no longer allowed**](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.6-Release-Notes#circular-references-prohibited-by-default) **by default.**

### 6. Testing <a href="#bd-testing" id="bd-testing"></a>

Unit testing reveals one of the major drawbacks of the field injection approach.

Suppose we’d like to write a unit test to check whether the _process()_ method defined in the _EmailService_ is working properly.

Firstly, we’d like to mock the _EmailValidation_ object. However, since we inserted the _EmailValidator_ using field injection, we can’t directly replace it with a mocked version:

```
EmailValidator validator = Mockito.mock(EmailValidator.class);
EmailService emailService = new EmailService();
```

Furthermore, providing the setter method in the _EmailService_ class would introduce an additional vulnerability as other classes, not just the test class, could call the method.

**However, we can instantiate our class through reflection.** For instance, we can use Mockito:

```
@Mock
private EmailValidator emailValidator;

@InjectMocks
private EmailService emailService;

@BeforeEach
public void setup() {
   MockitoAnnotations.openMocks(this);
}
```

Here, Mockito will try to inject mocks using the _@InjectMocks_ annotation. **However, if the field injection strategy fails, Mockito won’t report the failure.**

On the other hand, using constructor injection, we can provide the required dependencies without reflection:

```
private EmailValidator emailValidator;

private EmailService emailService;

@BeforeEach
public void setup() {
   this.emailValidator = Mockito.mock(EmailValidator.class);
   this.emailService = new EmailService(emailValidator);
}
```

### 7. Conclusion <a href="#bd-conclusion" id="bd-conclusion"></a>

In this article, we learned about the reasons why field injection isn’t recommended.

To sum up, instead of the field injection, we could use constructor injection for required and setter injection for optional dependencies.

As always, the source code of this article is available [over on GitHub](https://github.com/eugenp/tutorials/tree/master/spring-di-4).



{% embed url="https://www.baeldung.com/java-spring-field-injection-cons" %}
