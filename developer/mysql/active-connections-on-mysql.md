# Active Connections on MySQL

## Using a command

### Option1

```sql
show status where variable_name = 'threads_connected';
```

Columns

* **Variable\_name**: Name of the variable shown
* **Value**: Number of active connections

Rows

* **One row**: only one row is displayed

### Option2

```sql
show processlist;
```

Columns

* **Id**: The connection identifier
* **User**: The MySQL user who issued the statement
* **Host**: Host name and client port of the client issuing the statement
* **db**: The default database (schema), if one is selected, otherwise NULL
* **Command**: The type of command the thread is executing
* **Time**: The time in seconds that the thread has been in its current state
* **State**: An action, event, or state that indicates what the thread is doing
* **Info**: The statement the thread is executing, or NULL if it is not executing any statement

## Using Query

### Option3

```sql
select id,
       user,
       host,
       db,
       command,
       time,
       state,
       info
from information_schema.processlist;
```

Columns

* **Id** - The connection identifier
* **User** - The MySQL user who issued the statement
* **Host** - Host name and client port of the client issuing the statement
* **db** - The default database (schema), if one is selected, otherwise NULL
* **Command** - The type of command the thread is executing
* **Time** - The time in seconds that the thread has been in its current state
* **State** - An action, event, or state that indicates what the thread is doing
* **Info** - The statement the thread is executing, or NULL if it is not executing any statement

Rows

* **One row:** represents one active connection
* **Scope of rows:** total of active connections

## Reference

https://dataedo.com/kb/query/mysql/list-database-sessions
