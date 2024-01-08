# Baeldung

### **1. Overview** <a href="#bd-overview" id="bd-overview"></a>

In this quick tutorial, we’ll explore Spring’s _@RequestParam_ annotation and its attributes.

**Simply put, we can use **_**@RequestParam**_** to extract query parameters, form parameters, and even files from the request.**

### **2. A Simple Mapping** <a href="#bd-a-simple-mapping" id="bd-a-simple-mapping"></a>

Let’s say that we have an endpoint _/api/foos_ that takes a query parameter called _id_:

```
@GetMapping("/api/foos")
@ResponseBody
public String getFoos(@RequestParam String id) {
    return "ID: " + id;
}
```

In this example, we used _@RequestParam_ to extract the _id_ query parameter.

A simple GET request would invoke _getFoos_:

```
http://localhost:8080/spring-mvc-basics/api/foos?id=abc
----
ID: abc
```

Next, **let’s have a look at the annotation’s attributes: **_**name**_**, **_**value**_**, **_**required**_**, and **_**defaultValue**_**.**

### **3. Specifying the Request Parameter Name** <a href="#bd-specifying-the-request-parameter-name" id="bd-specifying-the-request-parameter-name"></a>

In the previous example, both the variable name and the parameter name are the same.

**Sometimes we want these to be different, though.** Or, if we aren’t using Spring Boot, we may need to do special compile-time configuration or the parameter names won’t actually be in the bytecode.

Fortunately, **we can configure the **_**@RequestParam**_** name using the **_**name**_** attribute**:

```
@PostMapping("/api/foos")
@ResponseBody
public String addFoo(@RequestParam(name = "id") String fooId, @RequestParam String name) { 
    return "ID: " + fooId + " Name: " + name;
}
```

We can also do _@RequestParam(value = “id”)_ or just _@RequestParam(“id”)._

### **4. Optional Request Parameters** <a href="#bd-optional-request-parameters" id="bd-optional-request-parameters"></a>

Method parameters annotated with _@RequestParam_ are required by default.

This means that if the parameter isn’t present in the request, we’ll get an error:

```
GET /api/foos HTTP/1.1
-----
400 Bad Request
Required String parameter 'id' is not present
```

**We can configure our **_**@RequestParam**_** to be optional, though, with the **_**required**_** attribute:**

```
@GetMapping("/api/foos")
@ResponseBody
public String getFoos(@RequestParam(required = false) String id) { 
    return "ID: " + id;
}
```

In this case, both:

```
http://localhost:8080/spring-mvc-basics/api/foos?id=abc
----
ID: abc
```

and

```
http://localhost:8080/spring-mvc-basics/api/foos
----
ID: null
```

will correctly invoke the method.

**When the parameter isn’t specified, the method parameter is bound to **_**null**_**.**

#### 4.1. Using Java 8 _Optional_ <a href="#bd-1-using-java-8-optional" id="bd-1-using-java-8-optional"></a>

Alternatively, we can wrap the parameter in _Optional_:

```
@GetMapping("/api/foos")
@ResponseBody
public String getFoos(@RequestParam Optional<String> id){
    return "ID: " + id.orElseGet(() -> "not provided");
}
```

In this case, **we don’t need to specify the **_**required**_** attribute.**

And the default value will be used if the request parameter is not provided:

```
http://localhost:8080/spring-mvc-basics/api/foos 
---- 
ID: not provided
```

### **5. A Default Value for the Request Parameter** <a href="#bd-a-default-value-for-the-request-parameter" id="bd-a-default-value-for-the-request-parameter"></a>

We can also set a default value to the _@RequestParam_ by using the _defaultValue_ attribute:

```
@GetMapping("/api/foos")
@ResponseBody
public String getFoos(@RequestParam(defaultValue = "test") String id) {
    return "ID: " + id;
}
```

**This is like **_**required=false,**_** in that the user no longer needs to supply the parameter**:

```
http://localhost:8080/spring-mvc-basics/api/foos
----
ID: test
```

Although, we are still okay to provide it:

```
http://localhost:8080/spring-mvc-basics/api/foos?id=abc
----
ID: abc
```

Note that when we set the _defaultValue_ attribute, _required_ is indeed set to _false_.

### **6. Mapping All Parameters** <a href="#bd-mapping-all-parameters" id="bd-mapping-all-parameters"></a>

**We can also have multiple parameters without defining their names** or count by just using a _Map_:

```
@PostMapping("/api/foos")
@ResponseBody
public String updateFoos(@RequestParam Map<String,String> allParams) {
    return "Parameters are " + allParams.entrySet();
}
```

which will then reflect back any parameters sent:

```
curl -X POST -F 'name=abc' -F 'id=123' http://localhost:8080/spring-mvc-basics/api/foos
-----
Parameters are {[name=abc], [id=123]}
```

### **7. Mapping a Multi-Value Parameter** <a href="#bd-mapping-a-multi-value-parameter" id="bd-mapping-a-multi-value-parameter"></a>

A single _@RequestParam_ can have multiple values:

```
@GetMapping("/api/foos")
@ResponseBody
public String getFoos(@RequestParam List<String> id) {
    return "IDs are " + id;
}
```

**And Spring MVC will map a comma-delimited **_**id**_** parameter**:

```
http://localhost:8080/spring-mvc-basics/api/foos?id=1,2,3
----
IDs are [1,2,3]
```

**or a list of separate **_**id**_** parameters**:

```
http://localhost:8080/spring-mvc-basics/api/foos?id=1&id=2
----
IDs are [1,2]
```

### **8. Conclusion** <a href="#bd-conclusion" id="bd-conclusion"></a>

In this article, we learned how to use _@RequestParam._

The full source code for the examples can be found in the [GitHub project](https://github.com/eugenp/tutorials/tree/master/spring-web-modules/spring-mvc-basics-5).
