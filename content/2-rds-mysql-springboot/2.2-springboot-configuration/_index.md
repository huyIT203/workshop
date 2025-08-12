---
title : "Spring Boot Database Configuration"
date : "2025-01-11"
weight : 2
chapter : false
pre : " <b> 2.2 </b> "
---

# Spring Boot Database Configuration

#### Overview
Trong phần này, chúng ta sẽ cấu hình Spring Boot application để kết nối với Amazon RDS MySQL instance. Bạn sẽ học cách thiết lập database connection, cấu hình Flyway cho migration, và tối ưu hóa connection pooling với Hikari.

#### Prerequisites

##### Project Setup
**Required Dependencies**
- **Spring Boot 3.4.5**: Core framework
- **Spring Data JPA**: Database access layer
- **MySQL Driver**: MySQL connector for Java
- **Flyway**: Database migration tool
- **HikariCP**: Connection pooling

**Maven Dependencies**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>

<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>

<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-mysql</artifactId>
</dependency>
```

---

#### Step 1: Database Connection Configuration

##### Application Properties
**Database Configuration**
```properties
# Database Configuration - RDS MySQL
spring.datasource.url=jdbc:mysql://[RDS_ENDPOINT]:3306/elearning?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=[YOUR_USERNAME]
spring.datasource.password=[YOUR_PASSWORD]
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
```


**Connection Parameters Explanation**
```yaml
createDatabaseIfNotExist=true:
  - Tự động tạo database nếu chưa tồn tại
  - Hữu ích cho development environment
  - Không nên dùng trong production

useSSL=false:
  - Tắt SSL connection cho development
  - Production nên enable SSL
  - Cần cấu hình SSL certificates

allowPublicKeyRetrieval=true:
  - Cho phép MySQL server gửi public key
  - Cần thiết cho MySQL 8.0+
  - Security consideration
```


---

#### Step 2: Flyway Configuration

##### Flyway Setup
**Flyway Configuration Properties**
```properties
# Flyway Configuration
spring.flyway.enabled=true
spring.flyway.baseline-on-migrate=true
spring.flyway.baseline-version=0
spring.flyway.baseline-description=Initial baseline
spring.flyway.locations=classpath:db/migration
spring.flyway.table=flyway_schema_history
spring.flyway.validate-on-migrate=false
spring.flyway.clean-disabled=true
spring.flyway.out-of-order=true
spring.flyway.mixed=true
```





##### Migration Scripts Structure
**File Naming Convention**
```yaml
Migration Script Format:
  - V1__Create_users_table.sql
  - V2__Add_email_index.sql
  - V3__Create_courses_table.sql
  - V4__Add_enrollment_relationship.sql

Version Numbering:
  - V1, V2, V3... (Sequential)
  - V1.1, V1.2... (Minor versions)
  - V20240101__Initial_schema.sql (Date-based)
```

---

#### Step 3: Connection Pooling Configuration

##### Hikari Connection Pool
**Hikari Configuration**
```properties
# Hikari Connection Pool
spring.datasource.hikari.connection-timeout=20000
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.idle-timeout=300000
spring.datasource.hikari.max-lifetime=1200000
spring.datasource.hikari.leak-detection-threshold=60000

# Additional JPA Settings
spring.jpa.properties.hibernate.jdbc.time_zone=UTC
spring.jpa.open-in-view=false
```




---

#### Step 4: JPA and Hibernate Configuration

##### Entity Configuration
**JPA Entity Example**
```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(name = "first_name")
    private String firstName;
    
    @Column(name = "last_name")
    private String lastName;
    
    @Enumerated(EnumType.STRING)
    private UserRole role;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // Constructors, getters, setters
}
```







#### Next Steps

Với Spring Boot configuration đã được thiết lập, chúng ta có thể:
- Tạo và quản lý migration scripts với Flyway
- Implement database entities và repositories
- Thiết lập testing environment
- Monitor database performance

#### Key Takeaways

- **Database configuration** cần được tối ưu hóa cho từng môi trường
- **Flyway integration** cung cấp automated database migration
- **Connection pooling** với Hikari tối ưu hóa performance
- **Profile-based configuration** cho phép quản lý multiple environments
- **Health checks** cần thiết cho production monitoring
- **Testing configuration** đảm bảo code quality và reliability 