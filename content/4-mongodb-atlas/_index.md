---
title : "MongoDB Atlas - Cloud Database Service"
date : "2025-01-11"
weight : 4
chapter : false
pre : " <b> 4. </b> "
---

# MongoDB Atlas - Cloud Database Service

#### Overview
Trong phần này, chúng ta sẽ thiết lập và cấu hình MongoDB Atlas để sử dụng làm cloud database service cho e-learning platform. Bạn sẽ học cách tạo cluster, cấu hình security, và tích hợp với ứng dụng Spring Boot. MongoDB Atlas sẽ cung cấp managed MongoDB service với high availability và global distribution.

#### Section Contents

##### 4.1 MongoDB Atlas Setup & Configuration
Thiết lập MongoDB Atlas cluster và cấu hình cơ bản:
- **Cluster Creation**: Tạo và cấu hình MongoDB cluster
- **Network Access**: Cấu hình IP whitelist và VPC peering
- **Database Access**: Tạo database users và roles
- **Cluster Configuration**: Instance size và storage configuration
- **Backup & Monitoring**: Automated backup và monitoring setup

[Explore Atlas Setup →](4.1-atlas-setup/)

##### 4.2 Spring Boot MongoDB Integration
Tích hợp MongoDB Atlas với Spring Boot application:
- **MongoDB Driver Configuration**: Cấu hình MongoDB Java driver
- **Spring Data MongoDB**: Cấu hình Spring Data MongoDB
- **Connection Management**: Connection pooling và retry logic
- **Data Models**: MongoDB document models và repositories
- **Performance Optimization**: Indexing và query optimization

[Explore Spring Boot Integration →](4.2-springboot-integration/)

##### 4.3 MongoDB Data Management
Quản lý dữ liệu và performance với MongoDB:
- **Document Design**: Thiết kế MongoDB documents cho e-learning
- **Indexing Strategy**: Tối ưu hóa queries với indexes
- **Aggregation Pipeline**: Complex data processing
- **Data Validation**: Schema validation và data integrity
- **Performance Monitoring**: Query optimization và monitoring

[Explore Data Management →](4.3-data-management/)

#### MongoDB Atlas Overview

##### Cloud Database Benefits
**Managed MongoDB Service**
- **Automated Operations**: Atlas tự động quản lý database operations
- **Global Distribution**: Deploy clusters worldwide
- **Built-in Security**: Enterprise-grade security features
- **Scalability**: Auto-scaling và manual scaling options
- **Monitoring**: Real-time monitoring và alerting

**Use Cases for E-Learning**
- **User Profiles**: Flexible user data storage
- **Course Content**: Rich document storage
- **Learning Analytics**: Student progress tracking
- **Real-time Data**: Chat messages và notifications
- **Content Metadata**: Flexible content organization

#### Atlas Cluster Types

##### Shared Clusters (Free Tier)
**M0 Sandbox**
- **Use Case**: Development và testing
- **Storage**: 512 MB
- **RAM**: Shared
- **vCPU**: Shared
- **Cost**: Free
- **Limitations**: No dedicated resources

**M2/M5 Shared**
- **Use Case**: Small production workloads
- **Storage**: 2-5 GB
- **RAM**: Shared
- **vCPU**: Shared
- **Cost**: $9-25/month
- **Limitations**: Limited performance

##### Dedicated Clusters
**M10+ Dedicated**
- **Use Case**: Production workloads
- **Storage**: 10+ GB
- **RAM**: Dedicated
- **vCPU**: Dedicated
- **Cost**: $57+/month
- **Benefits**: Predictable performance

**M30+ Dedicated**
- **Use Case**: High-performance applications
- **Storage**: 30+ GB
- **RAM**: Dedicated
- **vCPU**: Dedicated
- **Cost**: $171+/month
- **Benefits**: High performance và reliability

#### Atlas Security Features

##### Network Security
**IP Access List**
```yaml
IP Addresses:
  - 192.168.1.0/24 (Office network)
  - 10.0.0.0/8 (VPC CIDR)
  - 0.0.0.0/0 (Public access - not recommended for production)

VPC Peering:
  - AWS VPC: vpc-12345678
  - Atlas VPC: vpc-atlas-87654321
  - Route tables: Configure routing
```

**Private Endpoint**
```yaml
AWS PrivateLink:
  - VPC Endpoint: vpce-12345678
  - Service: com.amazonaws.vpce.us-east-1.vpce-svc-12345678
  - Security Groups: [Your security group]
  - Subnets: [Private subnets]
```

##### Database Security
**Database Users**
```javascript
// Create application user
db.createUser({
  user: "elearning_user",
  pwd: "secure_password_123",
  roles: [
    { role: "readWrite", db: "elearning" },
    { role: "dbAdmin", db: "elearning" }
  ]
})

// Create read-only user for analytics
db.createUser({
  user: "analytics_user",
  pwd: "analytics_password_456",
  roles: [
    { role: "read", db: "elearning" }
  ]
})
```

**Database Roles**
```javascript
// Custom role for course management
db.createRole({
  role: "course_manager",
  privileges: [
    {
      resource: { db: "elearning", collection: "courses" },
      actions: ["find", "insert", "update", "delete"]
    },
    {
      resource: { db: "elearning", collection: "lessons" },
      actions: ["find", "insert", "update", "delete"]
    }
  ],
  roles: []
})
```

#### Atlas Configuration

##### Cluster Configuration
**Instance Size Selection**
```yaml
Development Environment:
  - Instance Size: M0 (Free) hoặc M2 ($9/month)
  - Storage: 512 MB - 2 GB
  - RAM: Shared
  - vCPU: Shared

Production Environment:
  - Instance Size: M10+ ($57+/month)
  - Storage: 10+ GB
  - RAM: Dedicated
  - vCPU: Dedicated
  - Backup: Daily snapshots
```

**Storage Configuration**
```yaml
Storage Engine: WiredTiger
Storage Size: Auto-scaling enabled
  - Minimum: 10 GB
  - Maximum: 100 GB
  - Auto-scaling threshold: 80%

Backup Configuration:
  - Backup Frequency: Daily
  - Retention: 7 days
  - Point-in-time recovery: Enabled
```

##### Advanced Configuration
**Performance Advisor**
```yaml
Enable Performance Advisor: Yes
Monitoring:
  - Slow queries
  - Missing indexes
  - Schema suggestions
  - Performance recommendations

Index Suggestions:
  - Automatic index recommendations
  - Performance impact analysis
  - Index creation assistance
```

**Real-time Performance Panel**
```yaml
Metrics Displayed:
  - Operations per second
  - Query performance
  - Connection count
  - Memory usage
  - Storage usage
  - Network I/O
```

#### Spring Boot Integration

##### MongoDB Driver Configuration
**Maven Dependencies**
```xml
<dependency>
    <groupId>org.mongodb</groupId>
    <artifactId>mongodb-driver-sync</artifactId>
    <version>4.8.2</version>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-mongodb</artifactId>
</dependency>
```

**Application Properties**
```properties
# MongoDB Atlas Connection
spring.data.mongodb.uri=mongodb+srv://elearning_user:secure_password_123@cluster0.abc123.mongodb.net/elearning?retryWrites=true&w=majority

# Connection Pool Settings
spring.data.mongodb.connection-pool.max-size=100
spring.data.mongodb.connection-pool.min-size=5
spring.data.mongodb.connection-pool.max-wait-time=30000

# SSL Configuration
spring.data.mongodb.ssl.enabled=true
spring.data.mongodb.ssl.invalid-host-name-allowed=false
```

##### Spring Data MongoDB Configuration
**Configuration Class**
```java
@Configuration
@EnableMongoRepositories(basePackages = "com.elearning.repository")
public class MongoConfig extends AbstractMongoClientConfiguration {
    
    @Value("${spring.data.mongodb.uri}")
    private String mongoUri;
    
    @Override
    protected String getDatabaseName() {
        return "elearning";
    }
    
    @Override
    public MongoClient mongoClient() {
        return MongoClients.create(mongoUri);
    }
    
    @Bean
    public MongoTemplate mongoTemplate() throws Exception {
        return new MongoTemplate(mongoClient(), getDatabaseName());
    }
}
```

**Repository Configuration**
```java
@Repository
public interface UserRepository extends MongoRepository<User, String> {
    
    Optional<User> findByEmail(String email);
    
    List<User> findByRole(UserRole role);
    
    @Query("{ 'profile.firstName': { $regex: ?0, $options: 'i' } }")
    List<User> findByFirstNameContainingIgnoreCase(String firstName);
    
    @Query("{ 'createdAt': { $gte: ?0, $lte: ?1 } }")
    List<User> findByCreatedAtBetween(LocalDateTime start, LocalDateTime end);
}
```

#### Data Modeling

##### Document Structure
**User Document**
```javascript
{
  "_id": ObjectId("507f1f77bcf86cd799439011"),
  "email": "user@example.com",
  "passwordHash": "$2a$12$...",
  "role": "STUDENT",
  "profile": {
    "firstName": "John",
    "lastName": "Doe",
    "avatar": "https://s3.amazonaws.com/avatars/john-doe.jpg",
    "bio": "Student interested in programming",
    "preferences": {
      "language": "en",
      "timezone": "UTC",
      "notifications": true
    }
  },
  "enrollments": [
    {
      "courseId": ObjectId("507f1f77bcf86cd799439012"),
      "enrolledAt": ISODate("2025-01-11T10:00:00Z"),
      "progress": 0.75,
      "lastAccessed": ISODate("2025-01-11T15:30:00Z")
    }
  ],
  "createdAt": ISODate("2025-01-01T00:00:00Z"),
  "updatedAt": ISODate("2025-01-11T15:30:00Z")
}
```

**Course Document**
```javascript
{
  "_id": ObjectId("507f1f77bcf86cd799439012"),
  "title": "Introduction to Spring Boot",
  "description": "Learn Spring Boot fundamentals",
  "category": "PROGRAMMING",
  "difficulty": "BEGINNER",
  "estimatedHours": 20,
  "price": 99.99,
  "teacher": {
    "id": ObjectId("507f1f77bcf86cd799439013"),
    "name": "Jane Smith",
    "email": "jane@example.com"
  },
  "modules": [
    {
      "id": ObjectId("507f1f77bcf86cd799439014"),
      "title": "Getting Started",
      "order": 1,
      "lessons": [
        {
          "id": ObjectId("507f1f77bcf86cd799439015"),
          "title": "Spring Boot Overview",
          "content": "Introduction to Spring Boot...",
          "duration": 30,
          "type": "VIDEO"
        }
      ]
    }
  ],
  "tags": ["spring", "java", "backend"],
  "status": "PUBLISHED",
  "createdAt": ISODate("2025-01-01T00:00:00Z"),
  "updatedAt": ISODate("2025-01-11T10:00:00Z")
}
```

#### Performance Optimization

##### Indexing Strategy
**Single Field Indexes**
```javascript
// Email index for user lookup
db.users.createIndex({ "email": 1 }, { unique: true })

// Role index for role-based queries
db.users.createIndex({ "role": 1 })

// Created date index for time-based queries
db.users.createIndex({ "createdAt": -1 })
```

**Compound Indexes**
```javascript
// Course search index
db.courses.createIndex({ 
  "category": 1, 
  "difficulty": 1, 
  "status": 1 
})

// User enrollment index
db.users.createIndex({ 
  "enrollments.courseId": 1, 
  "enrollments.progress": -1 
})
```

**Text Indexes**
```javascript
// Full-text search on course content
db.courses.createIndex({
  "title": "text",
  "description": "text",
  "tags": "text"
}, {
  weights: {
    title: 10,
    description: 5,
    tags: 3
  }
})
```

##### Query Optimization
**Efficient Queries**
```javascript
// Use projection to limit returned fields
db.users.find(
  { "role": "STUDENT" },
  { "email": 1, "profile.firstName": 1, "profile.lastName": 1 }
)

// Use aggregation for complex queries
db.courses.aggregate([
  { $match: { "status": "PUBLISHED" } },
  { $group: { 
    _id: "$category", 
    count: { $sum: 1 },
    avgPrice: { $avg: "$price" }
  }},
  { $sort: { "count": -1 } }
])
```

#### Monitoring and Analytics

##### Atlas Monitoring
**Performance Metrics**
```yaml
Database Metrics:
  - Operations per second
  - Query performance
  - Connection count
  - Memory usage
  - Storage usage

Cluster Metrics:
  - CPU usage
  - Memory usage
  - Network I/O
  - Disk I/O
  - Replication lag
```

**Alerting Configuration**
```yaml
CPU Usage Alert:
  - Metric: CPU Usage
  - Threshold: 80%
  - Duration: 5 minutes
  - Action: Email notification

Memory Usage Alert:
  - Metric: Memory Usage
  - Threshold: 85%
  - Duration: 5 minutes
  - Action: Slack notification

Connection Count Alert:
  - Metric: Connection Count
  - Threshold: 90% of max connections
  - Duration: 2 minutes
  - Action: PagerDuty alert
```

#### Cost Optimization

##### Pricing Structure
**Cluster Pricing**
```yaml
Shared Clusters:
  - M0: Free
  - M2: $9/month
  - M5: $25/month

Dedicated Clusters:
  - M10: $57/month
  - M20: $114/month
  - M30: $171/month
  - M40: $228/month
```

**Cost Optimization Strategies**
```yaml
Resource Optimization:
  - Right-size instances
  - Use auto-scaling
  - Monitor resource usage
  - Clean up unused data

Storage Optimization:
  - Enable compression
  - Use appropriate indexes
  - Archive old data
  - Regular data cleanup
```

#### Next Steps

Trong các phần tiếp theo, chúng ta sẽ:
- Thiết lập MongoDB Atlas cluster cụ thể
- Cấu hình Spring Boot integration
- Implement data models và repositories
- Thiết lập monitoring và optimization

#### Key Takeaways

- **MongoDB Atlas** cung cấp managed MongoDB service với global distribution
- **Multiple cluster types** phù hợp với các workload khác nhau
- **Built-in security** với network access control và database authentication
- **Performance optimization** với indexing và query optimization
- **Monitoring và alerting** cung cấp real-time insights
- **Cost optimization** cần thiết cho production workloads 