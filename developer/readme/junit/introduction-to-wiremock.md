# Introduction to WireMock

### **1. Overview** <a href="#bd-overview" id="bd-overview"></a>

**WireMock** is a library for stubbing and mocking web services. It constructs an HTTP server that we can connect to as we would to an actual web service.

When a [WireMock](http://wiremock.org/) server is in action, we can set up expectations, call the service and then verify its behaviors.

### **2. Maven Dependencies** <a href="#bd-maven" id="bd-maven"></a>

In order to take advantage of the WireMock library, we need to include this dependency in the POM:

```
<dependency>
    <groupId>org.wiremock</groupId>
    <artifactId>wiremock</artifactId>
    <version>3.3.1</version>
    <scope>test</scope>
</dependency>
```

### **3. Programmatically Managed Server** <a href="#bd-programmatically" id="bd-programmatically"></a>

This section will cover how to manually configure a WireMock server, i.e., without the support of JUnit auto-configuration. We demonstrate the usage with a very simple stub.

#### **3.1. Server Setup** <a href="#bd-1-server-setup" id="bd-1-server-setup"></a>

First, we instantiate a WireMock server:

```
WireMockServer wireMockServer = new WireMockServer(String host, int port);
```

In case no arguments are provided, the server host defaults to _localhost_ and the server port to _8080_.

Then we can start and stop the server using two simple methods:

```
wireMockServer.start();
```

and:

```
wireMockServer.stop();
```

#### **3.2. Basic Usage** <a href="#bd-2-basic-usage" id="bd-2-basic-usage"></a>

We’ll first demonstrate the WireMock library with a basic usage, where a stub for an exact URL without any further configuration is provided.

Let’s create a server instance:

```
WireMockServer wireMockServer = new WireMockServer();
```

The WireMock server must be running before the client connects to it:

```
wireMockServer.start();
```

The web service is then stubbed:

```
configureFor("localhost", 8080);
stubFor(get(urlEqualTo("/baeldung")).willReturn(aResponse().withBody("Welcome to Baeldung!")));
```

This tutorial makes use of the Apache HttpClient API to represent a client connecting to the server:

```
CloseableHttpClient httpClient = HttpClients.createDefault();
```

A request is executed, and a response is returned afterwards:

```
HttpGet request = new HttpGet("http://localhost:8080/baeldung");
HttpResponse httpResponse = httpClient.execute(request);
```

We will convert the _httpResponse_ variable to a _String_ using a helper method:

```
String responseString = convertResponseToString(httpResponse);
```

Here is the implementation of that conversion helper method:

```
private String convertResponseToString(HttpResponse response) throws IOException {
    InputStream responseStream = response.getEntity().getContent();
    Scanner scanner = new Scanner(responseStream, "UTF-8");
    String responseString = scanner.useDelimiter("\\Z").next();
    scanner.close();
    return responseString;
}
```

The following code verifies that the server has got a request to the expected URL and the response arriving at the client is exactly what was sent:

```
verify(getRequestedFor(urlEqualTo("/baeldung")));
assertEquals("Welcome to Baeldung!", stringResponse);
```

Finally, we should stop the WireMock server to release system resources:

```
wireMockServer.stop();
```

### **4. JUnit Managed Server** <a href="#bd-managed" id="bd-managed"></a>

In contrast to Section 3, this section illustrates the usage of a WireMock server with the help of JUnit _Rule_.

#### **4.1. Server Setup** <a href="#bd-1-server-setup-1" id="bd-1-server-setup-1"></a>

We can integrate a WireMock server into JUnit test cases by using the _@Rule_ annotation. This allows JUnit to manage the life cycle, starting the server prior to each test method and stopping it after the method returns.

Similar to the programmatically managed server, a JUnit managed WireMock server can be created as a Java object with the given port number:

```
@Rule
public WireMockRule wireMockRule = new WireMockRule(int port);
```

If no arguments are supplied, server port will take the default value, _8080_. Server host, defaulting to _localhost_, and other configurations may be specified using the _Options_ interface.

#### **4.2. URL Matching** <a href="#bd-2-url-matching" id="bd-2-url-matching"></a>

After setting up a _WireMockRule_ instance, the next step is to configure a stub.

In this subsection, we will provide a REST stub for a service endpoint using regular expression:

```
stubFor(get(urlPathMatching("/baeldung/.*"))
  .willReturn(aResponse()
  .withStatus(200)
  .withHeader("Content-Type", "application/json")
  .withBody("\"testing-library\": \"WireMock\"")));
```

Let’s move on to creating an HTTP client, executing a request and receive a response:

```
CloseableHttpClient httpClient = HttpClients.createDefault();
HttpGet request = new HttpGet("http://localhost:8080/baeldung/wiremock");
HttpResponse httpResponse = httpClient.execute(request);
String stringResponse = convertHttpResponseToString(httpResponse);
```

The above code snippet takes advantage of a conversion helper method:

```
private String convertHttpResponseToString(HttpResponse httpResponse) throws IOException {
    InputStream inputStream = httpResponse.getEntity().getContent();
    return convertInputStreamToString(inputStream);
}
```

This in turn makes use of another private method:

```
private String convertInputStreamToString(InputStream inputStream) {
    Scanner scanner = new Scanner(inputStream, "UTF-8");
    String string = scanner.useDelimiter("\\Z").next();
    scanner.close();
    return string;
}
```

The stub’s operations are verified by the testing code below:

```
verify(getRequestedFor(urlEqualTo("/baeldung/wiremock")));
assertEquals(200, httpResponse.getStatusLine().getStatusCode());
assertEquals("application/json", httpResponse.getFirstHeader("Content-Type").getValue());
assertEquals("\"testing-library\": \"WireMock\"", stringResponse);
```

Now we will demonstrate how to stub a REST API with the matching of headers.

Let’s start with the stub configuration:

```
stubFor(get(urlPathEqualTo("/baeldung/wiremock"))
  .withHeader("Accept", matching("text/.*"))
  .willReturn(aResponse()
  .withStatus(503)
  .withHeader("Content-Type", "text/html")
  .withBody("!!! Service Unavailable !!!")));
```

Similar to the preceding subsection, we illustrate HTTP interaction using the HttpClient API, with help from the same helper methods:

```
CloseableHttpClient httpClient = HttpClients.createDefault();
HttpGet request = new HttpGet("http://localhost:8080/baeldung/wiremock");
request.addHeader("Accept", "text/html");
HttpResponse httpResponse = httpClient.execute(request);
String stringResponse = convertHttpResponseToString(httpResponse);
```

The following verification and assertions confirm functions of the stub we created before:

```
verify(getRequestedFor(urlEqualTo("/baeldung/wiremock")));
assertEquals(503, httpResponse.getStatusLine().getStatusCode());
assertEquals("text/html", httpResponse.getFirstHeader("Content-Type").getValue());
assertEquals("!!! Service Unavailable !!!", stringResponse);
```

#### **4.4. Request Body Matching** <a href="#bd-4-request-body-matching" id="bd-4-request-body-matching"></a>

We can also use the WireMock library to stub a REST API with body matching.

Here is the configuration for a stub of this kind:

```
stubFor(post(urlEqualTo("/baeldung/wiremock"))
  .withHeader("Content-Type", equalTo("application/json"))
  .withRequestBody(containing("\"testing-library\": \"WireMock\""))
  .withRequestBody(containing("\"creator\": \"Tom Akehurst\""))
  .withRequestBody(containing("\"website\": \"wiremock.org\""))
  .willReturn(aResponse()
  .withStatus(200)));
```

Now it’s time to create a _StringEntity_ object that will be used as the body of a request:

```
InputStream jsonInputStream 
  = this.getClass().getClassLoader().getResourceAsStream("wiremock_intro.json");
String jsonString = convertInputStreamToString(jsonInputStream);
StringEntity entity = new StringEntity(jsonString);
```

The code above uses one of the conversion helper methods defined before, _convertInputStreamToString_.

Here is content of the _wiremock\_intro.json_ file on the classpath:

```
{
    "testing-library": "WireMock",
    "creator": "Tom Akehurst",
    "website": "wiremock.org"
}
```

And we can configure and run HTTP requests and responses:

```
CloseableHttpClient httpClient = HttpClients.createDefault();
HttpPost request = new HttpPost("http://localhost:8080/baeldung/wiremock");
request.addHeader("Content-Type", "application/json");
request.setEntity(entity);
HttpResponse response = httpClient.execute(request);
```

This is the testing code used to validate the stub:

```
verify(postRequestedFor(urlEqualTo("/baeldung/wiremock"))
  .withHeader("Content-Type", equalTo("application/json")));
assertEquals(200, response.getStatusLine().getStatusCode());
```

#### **4.5. Stub Priority** <a href="#bd-5-stub-priority" id="bd-5-stub-priority"></a>

The previous subsections deal with situations where an HTTP request matches only a single stub.

It’s more complicated if there is more than a match for a request. By default, the most recently added stub will take precedence in such a case.

However, users can customize that behavior to take more control of WireMock stubs.

We will demonstrate operations of a WireMock server when a coming request matches two different stubs, with and without setting the priority level, at the same time.

Both scenarios will use the following private helper method:

```
private HttpResponse generateClientAndReceiveResponseForPriorityTests() throws IOException {
    CloseableHttpClient httpClient = HttpClients.createDefault();
    HttpGet request = new HttpGet("http://localhost:8080/baeldung/wiremock");
    request.addHeader("Accept", "text/xml");
    return httpClient.execute(request);
}
```

First, we configure two stubs without consideration of the priority level:

```
stubFor(get(urlPathMatching("/baeldung/.*"))
  .willReturn(aResponse()
  .withStatus(200)));
stubFor(get(urlPathEqualTo("/baeldung/wiremock"))
  .withHeader("Accept", matching("text/.*"))
  .willReturn(aResponse()
  .withStatus(503)));
```

Next, we create an HTTP client and execute a request using the helper method:

```
HttpResponse httpResponse = generateClientAndReceiveResponseForPriorityTests();
```

The following code snippet verifies that the last configured stub is applied regardless of the one defined before when a request matches both of them:

```
verify(getRequestedFor(urlEqualTo("/baeldung/wiremock")));
assertEquals(503, httpResponse.getStatusLine().getStatusCode());
```

Let’s move on to stubs with priority levels being set, where a lower number represents a higher priority:

```
stubFor(get(urlPathMatching("/baeldung/.*"))
  .atPriority(1)
  .willReturn(aResponse()
  .withStatus(200)));
stubFor(get(urlPathEqualTo("/baeldung/wiremock"))
  .atPriority(2)
  .withHeader("Accept", matching("text/.*"))
  .willReturn(aResponse()
  .withStatus(503)));
```

Now we’ll carry out the creation and execution of an HTTP request:

```
HttpResponse httpResponse = generateClientAndReceiveResponseForPriorityTests();
```

The following code validates the effect of priority levels, where the first configured stub is applied instead of the last:

```
verify(getRequestedFor(urlEqualTo("/baeldung/wiremock")));
assertEquals(200, httpResponse.getStatusLine().getStatusCode());
```

### **5. Conclusion** <a href="#bd-conclusion" id="bd-conclusion"></a>

This article introduced WireMock and how to set up as well as configure this library for testing of REST APIs using various techniques, including matching of URL, request headers and body.

The implementation of all the examples and code snippets can be found in [the GitHub project](https://github.com/eugenp/tutorials/tree/master/testing-modules/rest-testing).





{% embed url="https://www.baeldung.com/introduction-to-wiremock" %}

