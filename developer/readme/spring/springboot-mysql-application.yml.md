# SpringBoot MySQL application.yml

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
