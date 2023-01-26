# MariaDB-Galera

### About

MariaDB Galera Cluster is a virtually synchronous multi-primary cluster for MariaDB. Is is available on Linux only, and only supports the InnoDB storage engine (although there is experimental support for MyISAM and, from MariaDB 10.6, Aria. See the wsrep\_replicate\_myisam system variable, or, from MariaDB 10.6, the wsrep\_mode system variable).

{% embed url="https://mariadb.com/kb/en/what-is-mariadb-galera-cluster/" %}

{% embed url="https://artifacthub.io/packages/helm/bitnami/mariadb-galera" %}

### Group Replication Requirements

Server instances that you want to use for Group Replication must satisfy the satisfy the following requirements.

#### **Infrastructure**

*   **InnoDB Storage Engine**.  Data must be stored in the [`InnoDB`](https://dev.mysql.com/doc/refman/5.7/en/innodb-storage-engine.html) transactional storage engine. Transactions are executed optimistically and then, at commit time, are checked for conflicts. If there are conflicts, in order to maintain consistency across the group, some transactions are rolled back. This means that a transactional storage engine is required. Moreover, [`InnoDB`](https://dev.mysql.com/doc/refman/5.7/en/innodb-storage-engine.html) provides some additional functionality that enables better management and handling of conflicts when operating together with Group Replication. The use of other storage engines, including the temporary [`MEMORY`](https://dev.mysql.com/doc/refman/5.7/en/memory-storage-engine.html) storage engine, might cause errors in Group Replication. Convert any tables in other storage engines to use [`InnoDB`](https://dev.mysql.com/doc/refman/5.7/en/innodb-storage-engine.html) before using the instance with Group Replication. You can prevent the use of other storage engines by setting the[`disabled_storage_engines`](https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar\_disabled\_storage\_engines) system variable on group members, for example:

    ```ini
    disabled_storage_engines="MyISAM,BLACKHOLE,FEDERATED,ARCHIVE,MEMORY"
    ```
* **Primary Keys**.  Every table that is to be replicated by the group must have a defined primary key, or primary key equivalent where the equivalent is a non-null unique key. Such keys are required as a unique identifier for every row within a table, enabling the system to determine which transactions conflict by identifying exactly which rows each transaction has modified.
* **IPv4 Network**.  The group communication engine used by MySQL Group Replication only supports IPv4. Therefore, Group Replication requires an IPv4 network infrastructure.
* **Network Performance**.  MySQL Group Replication is designed to be deployed in a cluster environment where server instances are very close to each other. The performance and stabiity of a group can be impacted by both network latency and network bandwidth. Bi-directional communication must be maintained at all times between all group members. If either inbound or outbound communication is blocked for a server instance (for example, by a firewall, or by connectivity issues), the member cannot function in the group, and the group members (including the member with issues) might not be able to report the correct member status for the affected server instance.

{% embed url="https://dev.mysql.com/doc/refman/5.7/en/group-replication-requirements.html" %}
