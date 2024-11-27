# Securing Spring Boot API With API Key and Secret

### 1. Overview <a href="#bd-overview" id="bd-overview"></a>

Security plays a vital role in REST API development. An insecure REST API can provide direct access to sensitive data on back-end systems. So, organizations need to pay attention to API Security. **Spring Security provides various mechanisms to secure our REST APIs. One of them is API keys. An API key is a token that a client provides when invoking API calls.** In this tutorial, we’ll discuss the implementation of API key-based authentication in Spring Security.

### 2. REST API Security <a href="#bd-rest-api-security" id="bd-rest-api-security"></a>

Spring Security can be used to secure REST APIs. **REST APIs are stateless. Thus, they shouldn’t use sessions or cookies. Instead, these should be secure using Basic authentication, API Keys, JWT, or OAuth2-based tokens**.

#### 2.1. Basic Authentication <a href="#bd-1-basic-authentication" id="bd-1-basic-authentication"></a>

Basic authentication is a simple authentication scheme. The client sends HTTP requests with the _Authorization_ header that contains the word _Basic_ followed by a space and a Base64-encoded string _username_:_password_. Basic authentication is only considered secure with other security mechanisms such as HTTPS/SSL.

#### 2.2. OAuth2 <a href="#bd-2-oauth2" id="bd-2-oauth2"></a>

OAuth2 is the de facto standard for REST APIs security. It’s an open authentication and authorization standard that allows resource owners to give clients delegated access to private data via an access token.

#### 2.3. API Keys <a href="#bd-3-api-keys" id="bd-3-api-keys"></a>

Some REST APIs use API keys for authentication. An API key is a token that identifies the API client to the API without referencing an actual user. The token can be sent in the query string or as a request header. Like Basic authentication, it’s possible to hide the key using SSL. In this tutorial, we focus on implementing API Keys authentication using Spring Security.

### 3. Securing REST APIs with API Keys <a href="#bd-securing-rest-apis-with-api-keys" id="bd-securing-rest-apis-with-api-keys"></a>

In this section, we’ll create a Spring Boot application and secure it using API key-based authentication.

#### 3.1. Maven Dependencies <a href="#bd-1-maven-dependencies" id="bd-1-maven-dependencies"></a>

Let’s start by declaring the [_spring-boot-starter-security_](https://central.sonatype.com/artifact/org.springframework.boot/spring-boot-starter-security/3.0.6) dependency in our _pom.xml_:

```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

#### 3.2. Creating Custom Filter <a href="#bd-2-creating-custom-filter" id="bd-2-creating-custom-filter"></a>

**The idea is to get the HTTP API Key header from the request and then check the secret with our configuration**. **In this case, we need to add a custom Filter in the Spring Security configuration** **class**. We’ll start by implementing the [_GenericFilterBean_](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/filter/GenericFilterBean.html). The _GenericFilterBean_ is a simple _javax.servlet.Filter_ implementation that is Spring-aware. Let’s create the _AuthenticationFilter_ class:

```
public class AuthenticationFilter extends GenericFilterBean {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain)
      throws IOException, ServletException {
        try {
            Authentication authentication = AuthenticationService.getAuthentication((HttpServletRequest) request);
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (Exception exp) {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            httpResponse.setContentType(MediaType.APPLICATION_JSON_VALUE);
            PrintWriter writer = httpResponse.getWriter();
            writer.print(exp.getMessage());
            writer.flush();
            writer.close();
        }

        filterChain.doFilter(request, response);
    }
}
```

We only need to implement a _doFilter()_ method. In this method, we evaluate the API Key header and set the resulting _Authentication_ object into the current _SecurityContext_ instance. Then, the request is passed to the remaining filters for processing and then routed to _DispatcherServlet_ and finally to our controller. We delegate the evaluation of the API Key and constructing the _Authentication_ object to the _AuthenticationService_ class:

```
public class AuthenticationService {

    private static final String AUTH_TOKEN_HEADER_NAME = "X-API-KEY";
    private static final String AUTH_TOKEN = "Baeldung";

    public static Authentication getAuthentication(HttpServletRequest request) {
        String apiKey = request.getHeader(AUTH_TOKEN_HEADER_NAME);
        if (apiKey == null || !apiKey.equals(AUTH_TOKEN)) {
            throw new BadCredentialsException("Invalid API Key");
        }

        return new ApiKeyAuthentication(apiKey, AuthorityUtils.NO_AUTHORITIES);
    }
}
```

Here, we check whether the request contains the API Key header with a secret or not. If the header is _null_ or isn’t equal to secret, we throw a _BadCredentialsException_. If the request has the header, it performs the authentication, adds the secret to the security context, and then passes the call to the next security filter. Our _getAuthentication_ method is quite simple – we just compare the API Key header and secret with a static value. To construct the _Authentication_ object, we must use the same approach Spring Security typically uses to build the object on a standard authentication. So, let’s extend the _AbstractAuthenticationToken_ class and manually trigger authentication.

#### 3.3. Extending _AbstractAuthenticationToken_ <a href="#bd-3-extending-abstractauthenticationtoken" id="bd-3-extending-abstractauthenticationtoken"></a>

**To successfully implement authentication for our application, we need to convert the incoming API Key to an&#x20;**_**Authentication**_**&#x20;object such as an&#x20;**_**AbstractAuthenticationToken**._ The _AbstractAuthenticationToken_ class implements the _Authentication_ interface, representing the secret/principal for an authenticated request. Let’s create the _ApiKeyAuthentication_ class:

```
public class ApiKeyAuthentication extends AbstractAuthenticationToken {
    private final String apiKey;

    public ApiKeyAuthentication(String apiKey, Collection<? extends GrantedAuthority> authorities) {
        super(authorities);
        this.apiKey = apiKey;
        setAuthenticated(true);
    }

    @Override
    public Object getCredentials() {
        return null;
    }

    @Override
    public Object getPrincipal() {
        return apiKey;
    }
}
```

The _ApiKeyAuthentication_ class is a type of _AbstractAuthenticationToken_ object with the _apiKey_ information obtained from the HTTP request. We use the _setAuthenticated(true)_ method in the construction. As a result, the _Authentication_ object contains _apiKey_ and _authenticated_ fields:

####

#### 3.4. Security Config <a href="#bd-4-security-config" id="bd-4-security-config"></a>

We can register our custom filter programmatically by creating a _SecurityFilterChain_ bean. In this case, **we need to add the&#x20;**_**AuthenticationFilter**_**&#x20;before the&#x20;**_**UsernamePasswordAuthenticationFilter**_**&#x20;class using the&#x20;**_**addFilterBefore()**_**&#x20;method on an&#x20;**_**HttpSecurity**_**&#x20;instance**. Let’s create the _SecurityConfig_ class:

```
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
      http.csrf(AbstractHttpConfigurer::disable)
          .authorizeHttpRequests(authorizationManagerRequestMatcherRegistry -> authorizationManagerRequestMatcherRegistry.requestMatchers("/**").authenticated())
          .httpBasic(Customizer.withDefaults())
          .sessionManagement(httpSecuritySessionManagementConfigurer -> httpSecuritySessionManagementConfigurer.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
          .addFilterBefore(new AuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

}
```

Also, the session policy is set to _STATELESS_ because we’ll use REST endpoints.

#### 3.5. _ResourceController_ <a href="#bd-5-resourcecontroller" id="bd-5-resourcecontroller"></a>

Last, we’ll create the _ResourceController_ with a _/home_ mapping:

```
@RestController
public class ResourceController {
    @GetMapping("/home")
    public String homeEndpoint() {
        return "Baeldung !";
    }
}
```

#### 3.6. Disabling the Default Auto-Configuration <a href="#bd-6-disabling-the-default-auto-configuration" id="bd-6-disabling-the-default-auto-configuration"></a>

We need to discard the security auto-configuration. To do this, we exclude the _SecurityAutoConfiguration_ and _UserDetailsServiceAutoConfiguration_ classes:

```
@SpringBootApplication(exclude = {SecurityAutoConfiguration.class, UserDetailsServiceAutoConfiguration.class})
public class ApiKeySecretAuthApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiKeySecretAuthApplication.class, args);
    }
}
```

Now, the application is ready to test.

### 4. Testing <a href="#bd-testing" id="bd-testing"></a>

We can use the curl command to consume the secured application. First, let’s try to request the _/home_ without providing any security credentials:

```
curl --location --request GET 'http://localhost:8080/home'
```

We get back the expected _401 Unauthorized_. Now let’s request the same resource, but provide the API Key and secret to access it as well:

```
curl --location --request GET 'http://localhost:8080/home' \
--header 'X-API-KEY: Baeldung'
```

As a result, the response from the server is _200 OK_.

### 5. Conclusion <a href="#bd-conclusion" id="bd-conclusion"></a>

In this tutorial, we discussed the REST API security mechanisms. Then, we implemented Spring Security in our Spring Boot application to secure our REST API using the API Keys authentication mechanism. As always, code samples can be found [over on GitHub](https://github.com/eugenp/tutorials/tree/master/spring-security-modules/spring-security-web-boot-4).



{% embed url="https://www.baeldung.com/spring-boot-api-key-secret" %}
