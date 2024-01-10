# Passing JVM Options from Gradle bootRun

### 1. Overview <a href="#bd-overview" id="bd-overview"></a>

Gradle is a multi-purpose automation build tool to develop, compile, and test software packages. It supports a wide range of languages, but primarily, we use it for Java-based languages like Kotlin, Groovy, and Scala.

While working with Java, we might need to customize the JVM arguments in a Java application. As we are using Gradle to build a Java application, we can also customize the JVM arguments of the application by tuning the Gradle configuration.

In this tutorial, we’ll learn to pass the JVM arguments from the Gradle _bootRun_ to a Spring Boot Java application.

### 2. Understanding _bootRun_ <a href="#bd-understanding-bootrun" id="bd-understanding-bootrun"></a>

**Gradle **_**bootRun**_** is a gradle-specified task that comes with the default Spring Boot Gradle Plugin. It helps us to run the Spring Boot application from Gradle itself directly.** Executing the _bootRun_ command starts our application in a development environment, which is very useful for testing and development purposes. Primarily, it is used for iterative development as it doesn’t need any separate build or deployment purposes.

**In short, it provides a simplified way to build an application in a dev environment and execute tasks related to spring boot development.**

### 3. Using _jvmArgs_ in _build.gradle_ File <a href="#bd-using-jvmargs-in-buildgradle-file" id="bd-using-jvmargs-in-buildgradle-file"></a>

Gradle provides a straightforward way to add JVM args to the _bootRun_ command using the _build.gradle_ file. To illustrate, let’s look at the command to add JVM args to a spring boot application using the _bootRun_ command:

```
bootRun {
    jvmArgs([
        "-Xms256m",
        "-Xmx512m"
    ])
}
```

As we can see, the _max/min_ heap of the springboot application is modified using the _jvmArgs_ option. Now, let’s verify the JVM changes to the spring boot application using the _ps_ command:

```
$ ps -ef | grep java | grep spring
502  7870  7254   0  8:07PM ??  0:03.89 /Library/Java/JavaVirtualMachines/jdk-14.0.2.jdk/Contents/Home/bin/java
-XX:TieredStopAtLevel=1 -Xms256m -Xmx512m -Dfile.encoding=UTF-8 -Duser.country=IN 
-Duser.language=en com.example.demo.DemoApplication
```

In the above _bootRun_ task, we changed the _max_ and _min_ heap of the Spring Boot application using the _jvmArgs_ option. **This way, the JVM parameter will be attached to the Spring Boot application dynamically. Furthermore, we can also add customized properties to the **_**bootRun**_** using the **_**-D**_** option.** To demonstrate, let’s take a look at the _bootRun_ task:

```
bootRun {
    jvmArgs(['-Dbaeldung=test', '-Xmx512m'])
}
```

This way, we can pass both the JVM options and custom property attributes. To illustrate, let’s verify the custom value with the _jvm_ arguments:

```
$ ps -ef | grep java | grep spring
502  8423  7254   0  8:16PM ??  0:00.62 /Library/Java/JavaVirtualMachines/jdk-14.0.2.jdk/Contents/Home/bin/java 
-XX:TieredStopAtLevel=1  -Dbaeldung=test -Xms256m -Xmx512m -Dfile.encoding=UTF-8 -Duser.country=IN 
-Duser.language=en com.example.demo.DemoApplication
```

In addition, we can also put these properties files into _gradle.properties_ and then use them in the _build.gradle_:

```
baeldung=test
max.heap.size=512m
```

Now, we can use it in the _bootRun_ command:

```
bootRun {
    jvmArgs([
        "-Dbaeldung=${project.findProperty('baeldung')}",
	"-Xmx${project.findProperty('max.heap.size')}"
    ])
}
```

Using the above way we can separate the configuration file from the main _build.gradle_ file.

### 4. Using Command-Line Arguments <a href="#bd-using-command-line-arguments" id="bd-using-command-line-arguments"></a>

We can also provide JVM options directly to the ._/gradlew bootRun_ command. In Gradle, system properties can be specified with the _-D_ flag, and JVM options can be specified using _-X_:

```
$ ./gradlew bootRun --args='--spring-boot.run.jvmArguments="-Xmx512m" --baeldung=test'
```

**We can use this command to supply JVM options dynamically at runtime without modifying the Gradle build file.** To demonstrate, let’s verify the JVM arguments using the _ps_ command:

```
$ ps -ef | grep java | grep spring 
 502 58504 90399   0  7:21AM ?? 0:02.95 /Library/Java/JavaVirtualMachines/jdk-14.0.2.jdk/Contents/Home/bin/java 
 -XX:TieredStopAtLevel=1 -Xms256m -Xmx512m -Dfile.encoding=UTF-8 -Duser.country=IN -Duser.language=en 
 com.example.demo.DemoApplication --spring-boot.run.jvmArguments=-Xmx512m --baeldung=test
```

The above command directly sets the _jvm_ arguments using the _./gradlew bootRun_ command.

### 5. Conclusion <a href="#bd-conclusion" id="bd-conclusion"></a>

In this article, we learned different ways to pass the JVM options to the _bootRun_ command.

First, we learned the importance and basic usage of _bootRun_. We then explored the use of command line arguments and the _build.gradle_ file to supply the JVM options to _bootRun_.





{% embed url="https://www.baeldung.com/java-gradle-bootrun-pass-jvm-options" %}
