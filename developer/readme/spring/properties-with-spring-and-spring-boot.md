# Properties with Spring and Spring Boot

### **1. Overview** <a href="#bd-overview" id="bd-overview"></a>

This tutorial will show **how to set up and use properties in Spring** via Java configuration and _@PropertySource._

**We’ll also see how properties work in Spring Boot.**



### **2. Register a Properties File via Annotations** <a href="#bd-java" id="bd-java"></a>

Spring 3.1 also introduces **the new **_**@PropertySource**_** annotation** as a convenient mechanism for adding property sources to the environment.

We can use this annotation in conjunction with the _@Configuration_ annotation:

```
@Configuration
@PropertySource("classpath:foo.properties")
public class PropertiesWithJavaConfig {
    //...
}
```

Another very useful way to register a new properties file is using a placeholder, which allows us to **dynamically select the right file at runtime**:

```
@PropertySource({ 
  "classpath:persistence-${envTarget:mysql}.properties"
})
...
```

#### 2.1. Defining Multiple Property Locations <a href="#bd-1-defining-multiple-property-locations" id="bd-1-defining-multiple-property-locations"></a>

The _@PropertySource_ annotation is repeatable [according to Java 8 conventions](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html). Therefore, if we’re using Java 8 or higher, we can use this annotation to define multiple property locations:

```
@PropertySource("classpath:foo.properties")
@PropertySource("classpath:bar.properties")
public class PropertiesWithJavaConfig {
    //...
}
```

Of course, **we can also use the **_**@PropertySources**_** annotation and specify an array of **_**@PropertySource**_**.** This works in any supported Java version, not just in Java 8 or higher:

```
@PropertySources({
    @PropertySource("classpath:foo.properties"),
    @PropertySource("classpath:bar.properties")
})
public class PropertiesWithJavaConfig {
    //...
}
```

In either case, it’s worth noting that in the event of a property name collision, the last source read takes precedence.

### **3. Using/Injecting Properties** <a href="#bd-usage" id="bd-usage"></a>

**Injecting a property with the **_**@Value**_** annotation** is straightforward:

```
@Value( "${jdbc.url}" )
private String jdbcUrl;
```

**We can also specify a default value for the property:**

```
@Value( "${jdbc.url:aDefaultUrl}" )
private String jdbcUrl;
```

The new _PropertySourcesPlaceholderConfigurer_ added in Spring 3.1 **resolve ${…} placeholders within bean definition property values and **_**@Value**_** annotations**.

Finally, we can **obtain the value of a property using the **_**Environment**_** API**:

```
@Autowired
private Environment env;
...
dataSource.setUrl(env.getProperty("jdbc.url"));
```

Before we go into more advanced configuration options for properties, let’s spend some time looking at the new properties support in Spring Boot.

Generally speaking, **this new support involves less configuration compared to standard Spring**, which is of course one of the main goals of Boot.

#### **4.1. **_**application.properties:**_** the Default Property File** <a href="#bd-1-applicationproperties-the-default-property-file" id="bd-1-applicationproperties-the-default-property-file"></a>

Boot applies its typical convention over configuration approach to property files. This means that **we can simply put an **_**application.properties**_** file in our **_**src/main/resources**_** directory, and it will be auto-detected**. We can then inject any loaded properties from it as normal.

So, by using this default file, we don’t have to explicitly register a _PropertySource_ or even provide a path to a property file.

We can also configure a different file at runtime if we need to, using an environment property:

```
java -jar app.jar --spring.config.location=classpath:/another-location.properties
```

As of [Spring Boot 2.3](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.3-Release-Notes#support-of-wildcard-locations-for-configuration-files), **we can also specify wildcard locations for configuration files**.

For example, we can set the _spring.config.location_ property to _config/\*/_:

```
java -jar app.jar --spring.config.location=config/*/
```

This way, Spring Boot will look for configuration files matching the _config/\*/_ directory pattern outside of our jar file. This comes in handy when we have multiple sources of configuration properties.

Since version _2.4.0_, **Spring Boot supports using multi-document properties files**, similarly [as YAML does](https://yaml.org/spec/1.2/spec.html#id2760395) by design:

```
baeldung.customProperty=defaultValue
#---
baeldung.customProperty=overriddenValue
```

Note that for properties files, the three-dashes notation is preceded by a comment character (_#_).

#### **4.2. Environment-Specific Properties File** <a href="#bd-2-environment-specific-properties-file" id="bd-2-environment-specific-properties-file"></a>

If we need to target different environments, there’s a built-in mechanism for that in Boot.

**We can simply define an **_**application-environment.properties**_** file in the **_**src/main/resources**_** directory, and then set a Spring profile with the same environment name.**

For example, if we define a “staging” environment, that means we’ll have to define a _staging_ profile and then _application-staging.properties_.

This env file will be loaded and **will take precedence over the default property file.** Note that the default file will still be loaded, it’s just that when there is a property collision, the environment-specific property file takes precedence.

#### **4.3. Test-Specific Properties File** <a href="#bd-3-test-specific-properties-file" id="bd-3-test-specific-properties-file"></a>

We might also have a requirement to use different property values when our application is under test.

**Spring Boot handles this for us by looking in our **_**src/test/resources**_** directory during a test run**. Again, default properties will still be injectable as normal but will be overridden by these if there is a collision.

#### **4.4. The **_**@TestPropertySource**_** Annotation** <a href="#bd-4-the-testpropertysource-annotation" id="bd-4-the-testpropertysource-annotation"></a>

If we need more granular control over test properties, then we can use the [_@TestPropertySource_](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/test/context/TestPropertySource.html) annotation.

**This allows us to set test properties for a specific test context, taking precedence over the default property sources:**

```
@RunWith(SpringRunner.class)
@TestPropertySource("/foo.properties")
public class FilePropertyInjectionUnitTest {

    @Value("${foo}")
    private String foo;

    @Test
    public void whenFilePropertyProvided_thenProperlyInjected() {
        assertThat(foo).isEqualTo("bar");
    }
}
```

If we don’t want to use a file, we can specify names and values directly:

```
@RunWith(SpringRunner.class)
@TestPropertySource(properties = {"foo=bar"})
public class PropertyInjectionUnitTest {

    @Value("${foo}")
    private String foo;

    @Test
    public void whenPropertyProvided_thenProperlyInjected() {
        assertThat(foo).isEqualTo("bar");
    }
}
```

**We can also achieve a similar effect using the **_**properties**_** argument of the** [_**@SpringBootTest**_](http://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/test/context/SpringBootTest.html) **annotation:**

```
@RunWith(SpringRunner.class)
@SpringBootTest(
  properties = {"foo=bar"}, classes = SpringBootPropertiesTestApplication.class)
public class SpringBootPropertyInjectionIntegrationTest {

    @Value("${foo}")
    private String foo;

    @Test
    public void whenSpringBootPropertyProvided_thenProperlyInjected() {
        assertThat(foo).isEqualTo("bar");
    }
}
```

#### **4.5. Hierarchical Properties** <a href="#bd-5-hierarchical-properties" id="bd-5-hierarchical-properties"></a>

If we have properties that are grouped together, we can make use of the [_@ConfigurationProperties_](http://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/context/properties/ConfigurationProperties.html) annotation, which will map these property hierarchies into Java objects graphs.

Let’s take some properties used to configure a database connection:

```
database.url=jdbc:postgresql:/localhost:5432/instance
database.username=foo
database.password=bar
```

And then let’s use the annotation to map them to a database object:

```
@ConfigurationProperties(prefix = "database")
public class Database {
    String url;
    String username;
    String password;

    // standard getters and setters
}
```

Spring Boot applies it’s convention over configuration approach again, automatically mapping between property names and their corresponding fields. All that we need to supply is the property prefix.

If you want to dig deeper into configuration properties, have a look at our in-depth article.

#### **4.6. Alternative: YAML Files** <a href="#bd-6-alternative-yaml-files" id="bd-6-alternative-yaml-files"></a>

Spring also supports YAML files.

All the same naming rules apply for test-specific, environment-specific, and default property files. The only difference is the file extension and a dependency on the [SnakeYAML](https://bitbucket.org/snakeyaml/snakeyaml/src) library being on our classpath.

**YAML is particularly good for hierarchical property storage**; the following property file:

```
database.url=jdbc:postgresql:/localhost:5432/instance
database.username=foo
database.password=bar
secret: foo
```

is synonymous with the following YAML file:

```
database:
  url: jdbc:postgresql:/localhost:5432/instance
  username: foo
  password: bar
secret: foo
```

It’s also worth mentioning that YAML files do not support the _@PropertySource_ annotation, so if we need to use this annotation, it would constrain us to using a properties file.

Another remarkable point is that in version 2.4.0 Spring Boot changed the way in which properties are loaded from multi-document YAML files. Previously, the order in which they were added was based on the profile activation order. With the new version, however, the framework follows the same ordering rules that we indicated earlier for _.properties_ files; properties declared lower in the file will simply override those higher up.

Additionally, in this version profiles can no longer be activated from profile-specific documents, making the outcome clearer and more predictable.

#### **4.7. Importing Additional Configuration Files** <a href="#bd-7-importing-additional-configuration-files" id="bd-7-importing-additional-configuration-files"></a>

Prior to version 2.4.0, Spring Boot allowed including additional configuration files using the _spring.config.location_ and _spring.config.additional-location_ properties, but they had certain limitations. For instance, they had to be defined before starting the application (as environment or system properties, or using command-line arguments) as they were used early in the process.

In the mentioned version, **we can use the **_**spring.config.import**_** property within the **_**application.properties**_** or **_**application.yml**_** file to easily include additional files.** This property supports some interesting features:

* adding several files or directories
* the files can be loaded either from the classpath or from an external directory
* indicating if the startup process should fail if a file is not found, or if it’s an optional file
* importing extensionless files

Let’s see a valid example:

```
spring.config.import=classpath:additional-application.properties,
  classpath:additional-application[.yml],
  optional:file:./external.properties,
  classpath:additional-application-properties/
```

Note: here we formatted this property using line breaks just for clarity.

Spring will treat imports as a new document inserted immediately below the import declaration.

#### **4.8. Properties From Command Line Arguments** <a href="#bd-8-properties-from-command-line-arguments" id="bd-8-properties-from-command-line-arguments"></a>

Besides using files, we can pass properties directly on the command line:

```
java -jar app.jar --property="value"
```

We can also do this via system properties, which are provided before the _-jar_ command rather than after it:

```
java -Dproperty.name="value" -jar app.jar
```

#### **4.9. Properties From Environment Variables** <a href="#bd-9-properties-from-environment-variables" id="bd-9-properties-from-environment-variables"></a>

Spring Boot will also detect environment variables, treating them as properties:

```
export name=value
java -jar app.jar
```

#### **4.10. Randomization of Property Values** <a href="#bd-10-randomization-of-property-values" id="bd-10-randomization-of-property-values"></a>

If we don’t want determinist property values, we can use [_RandomValuePropertySource_](https://docs.spring.io/spring-boot/docs/1.5.7.RELEASE/api/org/springframework/boot/context/config/RandomValuePropertySource.html) to randomize the values of properties:

```
random.number=${random.int}
random.long=${random.long}
random.uuid=${random.uuid}
```

#### **4.11. Additional Types of Property Sources** <a href="#bd-11-additional-types-of-property-sources" id="bd-11-additional-types-of-property-sources"></a>

Spring Boot supports a multitude of property sources, implementing a well-thought-out ordering to allow sensible overriding. It’s worth consulting the [official documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html), which goes further than the scope of this article.

### **5. Configuration Using Raw Beans — the **_**PropertySourcesPlaceholderConfigurer**_ <a href="#bd-raw3_1" id="bd-raw3_1"></a>

Besides the convenient methods of getting properties into Spring, we can also define and regiter the property configuration bean manually.

**Working with the **_**PropertySourcesPlaceholderConfigurer**_** gives us full control over the configuration, with the downside of being more verbose and most of the time, unnecessary.**

Let’s see how we can define this bean using Java configuration:

```
@Bean
public static PropertySourcesPlaceholderConfigurer properties(){
    PropertySourcesPlaceholderConfigurer pspc
      = new PropertySourcesPlaceholderConfigurer();
    Resource[] resources = new ClassPathResource[ ]
      { new ClassPathResource( "foo.properties" ) };
    pspc.setLocations( resources );
    pspc.setIgnoreUnresolvablePlaceholders( true );
    return pspc;
}
```

### **6. Properties in Parent-Child Contexts** <a href="#bd-parent-child" id="bd-parent-child"></a>

This question comes up again and again: What happens when our **web application has a parent and a child context**? The parent context may have some common core functionality and beans, and then one (or multiple) child contexts, maybe containing servlet-specific beans.

In that case, what’s the best way to define properties files and include them in these contexts? And how to best retrieve these properties from Spring?

We’ll give a simple breakdown.

If the file is **defined in the Parent context**:

* _@Value_ works in **Child context**: YES
* _@Value_ works in **Parent context**: YES
* _environment.getProperty_ in **Child context**: YES
* _environment.getProperty_ in **Parent context**: YES

If the file is **defined in the Child context**:

* _@Value_ works in **Child context**: YES
* _@Value_ works in **Parent context**: NO
* _environment.getProperty_ in **Child context**: YES
* _environment.getProperty_ in **Parent context**: NO

### **7. Conclusion** <a href="#bd-conclusion" id="bd-conclusion"></a>

This article showed several examples of working with properties and properties files in Spring.

As always, the entire code backing the article is available [over on GitHub](https://github.com/eugenp/tutorials/tree/master/spring-boot-modules/spring-boot-properties).



{% embed url="https://www.baeldung.com/properties-with-spring" %}
