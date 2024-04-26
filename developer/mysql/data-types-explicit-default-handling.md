# Data Types Explicit Default Handling

The default value specified in a `DEFAULT` clause can be a literal constant or an expression. With one exception, enclose expression default values within parentheses to distinguish them from literal constant default values. Examples:

```sql
CREATE TABLE t1 (
  -- literal defaults
  i INT         DEFAULT 0,
  c VARCHAR(10) DEFAULT '',
  -- expression defaults
  f FLOAT       DEFAULT (RAND() * RAND()),
  b BINARY(16)  DEFAULT (UUID_TO_BIN(UUID())),
  d DATE        DEFAULT (CURRENT_DATE + INTERVAL 1 YEAR),
  p POINT       DEFAULT (Point(0,0)),
  j JSON        DEFAULT (JSON_ARRAY())
);
```

The exception is that, for [`TIMESTAMP`](https://dev.mysql.com/doc/refman/8.3/en/datetime.html) and [`DATETIME`](https://dev.mysql.com/doc/refman/8.3/en/datetime.html) columns, you can specify the [`CURRENT_TIMESTAMP`](https://dev.mysql.com/doc/refman/8.3/en/date-and-time-functions.html#function\_current-timestamp) function as the default, without enclosing parentheses. See[Section 13.2.5, “Automatic Initialization and Updating for TIMESTAMP and DATETIME”](https://dev.mysql.com/doc/refman/8.3/en/timestamp-initialization.html).



The [`BLOB`](https://dev.mysql.com/doc/refman/8.3/en/blob.html), [`TEXT`](https://dev.mysql.com/doc/refman/8.3/en/blob.html), `GEOMETRY`, and [`JSON`](https://dev.mysql.com/doc/refman/8.3/en/json.html) data types can be assigned a default value only if the value is written as an expression, even if the expression value is a literal:

*   This is permitted (literal default specified as expression):

    ```sql
    CREATE TABLE t2 (b BLOB DEFAULT ('abc'));
    ```
*   This produces an error (literal default not specified as expression):

    ```sql
    CREATE TABLE t2 (b BLOB DEFAULT 'abc');
    ```



{% embed url="https://dev.mysql.com/doc/refman/8.3/en/data-type-defaults.html#data-type-defaults-explicit" %}
