# static factory methods common naming conventions

This list is far from exhaustive:

| naming                      | meaning                                                                                                                                  | example                                                       |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `from`                      | A _type-conversion method_ that takes a single parameter and returns a corresponding instance of this type.                              | `Date d = Date.from(instant);`                                |
| `of`                        | An `aggregation method` that takes multiple parameters and returns an instance of this type that incorporates them.                      | `Set\<Rank\> faceCards = EnumSet.of(JACK, QUEEN, KING);`      |
| `valueOf`                   | A more verbose alternative to `from` and `of`                                                                                            | `BigInteger prime = BigInteger.valueOf(Integer.MAX_VALUE);`   |
| `instance` or `getInstance` | Returns an instance that is described by its parameters (if any) but cannot be said to have the same value.                              | `StackWalker luke = StackWalker.getInstance(options);`        |
| `create` or `newInstance`   | Like `instance` or `getInstance`, except that the method guarantees that each call returns a new instance.                               | `Object newArray = Array.newInstance(classObject, arrayLen);` |
| `get`_Type_                 | Like `getInstance`, but used if the factory method is in a different class. _Type_ is the type of object returned by the factory method. | `FileStore fs = Files.getFileStore(path);`                    |
| `new`_Type_                 | Line `newInstance`, but used if the factory method is in a different class. _Type_ is the type of object returned by the factory method. | `BufferedReader br = Files.newBufferedReader(path);`          |
| `type`                      | A concise alternative to `get`_Type_ and `new`_Type_.                                                                                    | `List\<Complaint\> litany = Collections.list(legacyLitany);`  |
