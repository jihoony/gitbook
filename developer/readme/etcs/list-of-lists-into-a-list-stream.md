# List of Lists into a List (Stream)

## Required

> Stream Support Since Java 1.8



## Use FlatMap

Use `FlatMap` to flatten the internal lists into a single Stream, and the collect the result into a list:

```java
List<List<Object>> list = .....
List<Object> flat = list.stream().flatMap(List::stream).collect(Collectors.toList());
```



{% embed url="https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#flatMap-java.util.function.Function-" %}
