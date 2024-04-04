# FOUND\_ROWS



> **Note**
>
> The `SQL_CALC_FOUND_ROWS` query modifier and accompanying [`FOUND_ROWS()`](https://dev.mysql.com/doc/refman/8.3/en/information-functions.html#function\_found-rows) function are deprecated; expect them to be removed in a future version of MySQL. Execute the query with `LIMIT`, and then a second query with [`COUNT(*)`](https://dev.mysql.com/doc/refman/8.3/en/aggregate-functions.html#function\_count) and without `LIMIT` to determine whether there are additional rows. For example, instead of these queries:
>
> ```sql
> SELECT SQL_CALC_FOUND_ROWS * FROM tbl_name WHERE id > 100 LIMIT 10;
> SELECT FOUND_ROWS();
> ```
>
> Use these queries instead:
>
> ```sql
> SELECT * FROM tbl_name WHERE id > 100 LIMIT 10;
> SELECT COUNT(*) FROM tbl_name WHERE id > 100;
> ```
>
> [`COUNT(*)`](https://dev.mysql.com/doc/refman/8.3/en/aggregate-functions.html#function\_count) is subject to certain optimizations. `SQL_CALC_FOUND_ROWS` causes some optimizations to be disabled.



A [`SELECT`](https://dev.mysql.com/doc/refman/8.3/en/select.html) statement may include a `LIMIT` clause to restrict the number of rows the server returns to the client. In some cases, it is desirable to know how many rows the statement would have returned without the `LIMIT`, but without running the statement again. To obtain this row count, include an `SQL_CALC_FOUND_ROWS` option in the [`SELECT`](https://dev.mysql.com/doc/refman/8.3/en/select.html) statement, and then invoke [`FOUND_ROWS()`](https://dev.mysql.com/doc/refman/8.3/en/information-functions.html#function\_found-rows) afterward:



```bash
mysql> SELECT SQL_CALC_FOUND_ROWS * FROM tbl_name
    -> WHERE id > 100 LIMIT 10;
mysql> SELECT FOUND_ROWS();
```



The second [`SELECT`](https://dev.mysql.com/doc/refman/8.3/en/select.html) returns a number indicating how many rows the first [`SELECT`](https://dev.mysql.com/doc/refman/8.3/en/select.html) would have returned had it been written without the `LIMIT` clause.

In the absence of the `SQL_CALC_FOUND_ROWS` option in the most recent successful [`SELECT`](https://dev.mysql.com/doc/refman/8.3/en/select.html) statement, [`FOUND_ROWS()`](https://dev.mysql.com/doc/refman/8.3/en/information-functions.html#function\_found-rows) returns the number of rows in the result set returned by that statement. If the statement includes a `LIMIT` clause, [`FOUND_ROWS()`](https://dev.mysql.com/doc/refman/8.3/en/information-functions.html#function\_found-rows) returns the number of rows up to the limit. For example, [`FOUND_ROWS()`](https://dev.mysql.com/doc/refman/8.3/en/information-functions.html#function\_found-rows) returns 10 or 60, respectively, if the statement includes `LIMIT 10` or `LIMIT 50, 10`.





{% embed url="https://dev.mysql.com/doc/refman/8.3/en/information-functions.html#function_found-rows" %}
