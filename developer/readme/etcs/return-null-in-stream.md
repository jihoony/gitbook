# Return null in stream



{% code overflow="wrap" %}
```java
list.stream()
    .map(i->someFunction(i))
    .filter(out -> out != null)
    .collect(Collectors.toList());
```
{% endcode %}

or

```java
list.stream()
    .map(i -> someFunction(i))
    .filter(Objects::nonNull)
    .collect(Collectors.toList());
```

or

```java
list.stream()
    .map(i -> someFunction(i))
    .filter(out -> true)
    .collect(Collectors.toList());
```

