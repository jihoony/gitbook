# Spring Properties File Outside jar



By convention, Spring Boot looks for an externalized configuration file — _application.properties_ or _application.yml_ — in four predetermined locations in the following order of precedence:

* A _/config_ subdirectory of the current directory
* The current directory
* A classpath _/config_ package
* The classpath root

Therefore, **a property defined in&#x20;**_**application.properties**_**&#x20;and placed in the&#x20;**_**/config**_**&#x20;subdirectory of the current directory will be loaded.** This will also override properties in other locations in case of a collision.





{% embed url="https://www.baeldung.com/spring-properties-file-outside-jar" %}

{% embed url="https://www.baeldung.com/properties-with-spring" %}

{% embed url="https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#appendix.application-properties" %}

