# SpringBoot Hybernate application.yml

### MySQL

```yaml
spring:
    jpa:
        database-platform: org.hibernate.dialect.MySQL8Dialect
        hibernate:
            ddl-auto: create
    datasource:
            driverClassName: com.mysql.cj.jdbc.Driver
            url: jdbc:mysql://127.0.0.1:3306/my-database
            username: my-user
            password: my-secret-pw
            hikari:
              maximum-pool-size: 25
              minimum-idle: 1
```



### H2

```yaml
spring:
    h2:
        console:
            enabled: true
    jpa:
        database-platform: org.hibernate.dialect.H2Dialect
        hibernate:
            ddl-auto: create
    datasource:
        driverClassName: org.h2.Driver
        url: jdbc:h2:file~/data/my-database;DB_CLOSE_ON_EXIT=FALSE;AUTO_SERVER=true
        username: sa
        hikari:
            maximum-pool-size: 25
            minimum-idle: 1
```
