---
title : "Database Migration with Flyway"
date : "2025-01-11"
weight : 3
chapter : false
pre : " <b> 2.3 </b> "
---

# Database Migration with Flyway

#### Overview
Trong phần này, chúng ta sẽ học cách sử dụng Flyway để quản lý database migration một cách tự động và an toàn. Flyway sẽ giúp bạn version control database schema, tự động chạy migration scripts, và đảm bảo consistency giữa các môi trường development, staging, và production.

#### Prerequisites

##### Flyway Setup
**Required Dependencies**
- **Flyway Core**: Core migration engine
- **Flyway MySQL**: MySQL-specific support
- **Spring Boot Flyway**: Spring Boot integration

**Maven Dependencies**
```xml
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

#### Step 1: Flyway Configuration

##### Basic Configuration
**Application Properties**
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

{{% notice info %}}
**Console Screenshot**: Chụp màn hình Flyway configuration trong application.properties
{{% /notice %}}

**Configuration Parameters Explanation**
```yaml
enabled=true:
  - Kích hoạt Flyway migration
  - Tự động chạy khi application start

baseline-on-migrate=true:
  - Tự động tạo baseline nếu database đã có data
  - Hữu ích cho existing databases
  - Prevents migration errors

locations=classpath:db/migration:
  - Thư mục chứa migration scripts
  - Default: src/main/resources/db/migration
  - Có thể thêm multiple locations

table=flyway_schema_history:
  - Bảng lưu trữ migration history
  - Tracking tất cả migrations đã chạy
  - Không nên thay đổi tên bảng này
```


---

#### Step 2: Migration Scripts Structure

##### File Naming Convention
**Standard Naming Pattern**
```yaml
Migration Script Format:
  - V[version]__[description].sql
  - V1__Create_users_table.sql
  - V2__Add_email_index.sql
  - V3__Create_courses_table.sql
  - V4__Add_enrollment_relationship.sql

Version Numbering Strategies:
  - Sequential: V1, V2, V3...
  - Minor versions: V1.1, V1.2...
  - Date-based: V20240101__Initial_schema.sql
  - Semantic: V1.0.0__Initial_release.sql
```



**File Organization**
```yaml
Directory Structure:
  src/main/resources/
    └── db/
        └── migration/
            ├── V1__Create_users_table.sql
            ├── V2__Add_email_index.sql
            ├── V3__Create_courses_table.sql
            └── V4__Add_enrollment_relationship.sql

Alternative Locations:
  - classpath:db/migration
  - classpath:db/migration/mysql
  - filesystem:/path/to/migrations
  - s3://bucket/migrations
```



---

#### Step 3: Creating Migration Scripts

##### Initial Schema Migration
**V1__Create_users_table.sql**
```sql
-- Create users table
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'TEACHER', 'STUDENT') NOT NULL DEFAULT 'STUDENT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_users_email (email),
    INDEX idx_users_role (role),
    INDEX idx_users_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default admin user
INSERT INTO users (email, password_hash, first_name, last_name, role) 
VALUES ('admin@elearning.com', '$2a$12$...', 'Admin', 'User', 'ADMIN');
```



**V2__Add_email_index.sql**
```sql
-- Add unique constraint to email
ALTER TABLE users ADD CONSTRAINT uk_users_email UNIQUE (email);

-- Add additional indexes for performance
CREATE INDEX idx_users_role_created_at ON users(role, created_at);
CREATE INDEX idx_users_first_name_last_name ON users(first_name, last_name);
```



**V3__Create_courses_table.sql**
```sql
-- Create courses table
CREATE TABLE courses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    difficulty ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') DEFAULT 'BEGINNER',
    estimated_hours INT DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('DRAFT', 'PUBLISHED', 'ARCHIVED') DEFAULT 'DRAFT',
    teacher_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_courses_title (title),
    INDEX idx_courses_category (category),
    INDEX idx_courses_status (status),
    INDEX idx_courses_teacher_id (teacher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```



---

#### Step 4: Advanced Migration Scripts

##### Data Migration Scripts
**V4__Seed_initial_data.sql**
```sql
-- Insert sample courses
INSERT INTO courses (title, description, category, difficulty, estimated_hours, price, status, teacher_id) VALUES
('Introduction to Spring Boot', 'Learn Spring Boot fundamentals', 'PROGRAMMING', 'BEGINNER', 20, 99.99, 'PUBLISHED', 1),
('Advanced Java Development', 'Master Java programming', 'PROGRAMMING', 'ADVANCED', 40, 199.99, 'PUBLISHED', 1),
('Web Development Basics', 'HTML, CSS, JavaScript fundamentals', 'WEB_DEVELOPMENT', 'BEGINNER', 30, 149.99, 'PUBLISHED', 1);

-- Insert sample users
INSERT INTO users (email, password_hash, first_name, last_name, role) VALUES
('teacher1@elearning.com', '$2a$12$...', 'Jane', 'Smith', 'TEACHER'),
('student1@elearning.com', '$2a$12$...', 'John', 'Doe', 'STUDENT'),
('student2@elearning.com', '$2a$12$...', 'Alice', 'Johnson', 'STUDENT');
```



**V5__Add_enrollment_table.sql**
```sql
-- Create enrollments table
CREATE TABLE enrollments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress DECIMAL(5,2) DEFAULT 0.00,
    status ENUM('ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'ACTIVE',
    completed_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_course (user_id, course_id),
    INDEX idx_enrollments_user_id (user_id),
    INDEX idx_enrollments_course_id (course_id),
    INDEX idx_enrollments_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```


---

#### Step 5: Running Migrations

##### Automatic Migration
**Application Startup**
```yaml
Migration Process:
  - Application starts
  - Flyway checks database schema
  - Compares with migration scripts
  - Runs pending migrations automatically
  - Updates flyway_schema_history table
  - Application continues startup
```



**Manual Migration Commands**
```bash
# Check migration status
mvn flyway:info

# Run migrations manually
mvn flyway:migrate

# Validate migrations
mvn flyway:validate

# Repair migrations if needed
mvn flyway:repair

# Clean database (development only)
mvn flyway:clean
```


---

#### Step 6: Migration Management

##### Version Control Integration
**Git Workflow**
```yaml
Development Process:
  1. Create feature branch
  2. Write migration script
  3. Test migration locally
  4. Commit migration script
  5. Push to remote branch
  6. Create pull request
  7. Code review
  8. Merge to main branch
  9. Deploy to production
```


**Migration Script Review**
```yaml
Review Checklist:
  - Naming convention follows standard
  - SQL syntax is correct
  - Indexes are appropriate
  - Foreign keys are properly defined
  - Data types are suitable
  - Default values are reasonable
  - Rollback strategy is considered
```



---

#### Step 7: Rollback Strategies

##### Rollback Approaches
**Version-based Rollback**
```sql
-- Create rollback script V5.1__Rollback_enrollment_table.sql
DROP TABLE IF EXISTS enrollments;

-- Or create V6__Remove_enrollment_table.sql
DROP TABLE enrollments;
```



**Data Preservation**
```sql
-- Before dropping table, backup data
CREATE TABLE enrollments_backup AS SELECT * FROM enrollments;

-- Or export to file
SELECT * FROM enrollments INTO OUTFILE '/tmp/enrollments_backup.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```



---

#### Step 8: Testing Migrations

##### Test Environment Setup
**Test Database Configuration**
```properties
# application-test.properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
```



**Migration Testing**
```java
@SpringBootTest
@ActiveProfiles("test")
class FlywayMigrationTest {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @Test
    void shouldCreateUsersTable() {
        // Given
        String sql = "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'users'";
        
        // When
        int count = jdbcTemplate.queryForObject(sql, Integer.class);
        
        // Then
        assertThat(count).isEqualTo(1);
    }
    
    @Test
    void shouldHaveCorrectUserColumns() {
        // Given
        String sql = "SELECT column_name FROM information_schema.columns WHERE table_name = 'users' ORDER BY ordinal_position";
        
        // When
        List<String> columns = jdbcTemplate.queryForList(sql, String.class);
        
        // Then
        assertThat(columns).contains("id", "email", "password_hash", "first_name", "last_name", "role");
    }
}
```


---

#### Step 9: Production Deployment

##### Production Considerations
**Migration Safety**
```yaml
Production Guidelines:
  - Always backup database before migration
  - Test migrations on staging environment
  - Use maintenance window for major changes
  - Monitor migration execution
  - Have rollback plan ready
  - Document all changes
```



**Deployment Process**
```bash
# Production deployment steps
1. Backup production database
2. Deploy application with new migrations
3. Monitor migration execution
4. Verify database schema
5. Run smoke tests
6. Monitor application health
7. Rollback if issues occur
```



---

#### Step 10: Monitoring and Maintenance

##### Migration History
**Schema History Table**
```sql
-- Check migration history
SELECT * FROM flyway_schema_history ORDER BY installed_rank DESC;

-- Check current schema version
SELECT version FROM flyway_schema_history 
WHERE installed_rank = (SELECT MAX(installed_rank) FROM flyway_schema_history);
```



**Performance Monitoring**
```yaml
Monitoring Metrics:
  - Migration execution time
  - Number of pending migrations
  - Migration success rate
  - Database schema changes
  - Rollback frequency
```



---

#### Troubleshooting

##### Common Issues
**Migration Failures**
```bash
# Check migration status
mvn flyway:info

# View detailed error logs
tail -f application.log | grep -i flyway

# Repair corrupted migrations
mvn flyway:repair

# Check database connectivity
mysql -h [RDS_ENDPOINT] -u [USERNAME] -p
```



**Version Conflicts**
```yaml
Common Issues:
  - Duplicate version numbers
  - Missing migration scripts
  - Database schema mismatch
  - Permission issues
  - Network connectivity problems

Solutions:
  - Check migration script naming
  - Verify database permissions
  - Test connectivity
  - Review error logs
```


---

#### Next Steps

Với Flyway migration đã được thiết lập, chúng ta có thể:
- Tạo và quản lý complex migration scripts
- Implement automated deployment pipeline
- Monitor migration performance
- Handle production rollbacks

#### Key Takeaways

- **Flyway migration** cung cấp automated database schema management
- **Version control** cho database changes đảm bảo consistency
- **Rollback strategies** cần thiết cho production safety
- **Testing migrations** đảm bảo reliability
- **Production deployment** cần careful planning và monitoring
- **Migration history** cung cấp audit trail cho database changes 