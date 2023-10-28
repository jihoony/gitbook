# Spring Properties File Outside jar



By convention, Spring Boot looks for an externalized configuration file — _application.properties_ or _application.yml_ — in four predetermined locations in the following order of precedence:

* A _/config_ subdirectory of the current directory
* The current directory
* A classpath _/config_ package
* The classpath root

Therefore, **a property defined in **_**application.properties**_** and placed in the **_**/config**_** subdirectory of the current directory will be loaded.** This will also override properties in other locations in case of a collision.





{% embed url="https://www.baeldung.com/spring-properties-file-outside-jar" %}

{% embed url="https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#appendix.application-properties" %}
