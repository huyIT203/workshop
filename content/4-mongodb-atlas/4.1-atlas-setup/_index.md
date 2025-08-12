---
title : "MongoDB Atlas Setup & Configuration"
date : "2025-01-11"
weight : 1
chapter : false
pre : " <b> 4.1 </b> "
---

# MongoDB Atlas Setup & Configuration

#### Overview
Trong phần này, chúng ta sẽ thiết lập MongoDB Atlas cluster từ đầu, cấu hình network access, database users, và thiết lập các tính năng cần thiết cho e-learning platform. Bạn sẽ học cách tạo cluster, cấu hình security, và thiết lập monitoring.

#### Prerequisites

##### MongoDB Atlas Account Setup
**Required Services**
- **MongoDB Atlas Account**: Active account với billing enabled
- **Cloud Provider**: AWS, Google Cloud, hoặc Azure
- **Network Access**: IP whitelist hoặc VPC peering
- **Database Access**: Users và roles configuration

**Account Requirements**
```yaml
Account Type: Free Tier hoặc Paid
Billing Method: Credit card hoặc invoice
Cloud Provider: AWS (recommended for integration)
Region: [Select closest to your application]
```

---

#### Step 1: Create MongoDB Atlas Account

##### Account Registration
**1. Navigate to MongoDB Atlas**
```bash
# Mở browser và truy cập
# https://cloud.mongodb.com
# Click "Try Free" hoặc "Sign Up"
```



**2. Account Creation**
```yaml
Email: [Your email address]
Password: [Strong password]
Account name: [Your organization name]
  - Example: Esoclusty E-Learning
  - Used for project organization
  - Can be changed later
```



**3. Email Verification**
```yaml
Verification Process:
  - Check email inbox
  - Click verification link
  - Complete account setup
  - Access Atlas dashboard
```


---

#### Step 2: Create Atlas Project

##### Project Setup
**1. Create New Project**
```yaml
Project Name: E-Learning Platform
  - Descriptive name for organization
  - Can contain multiple clusters
  - Used for resource grouping
  - Example: "Esoclusty E-Learning Platform"

Project Owner: [Your email]
  - Primary administrator
  - Can invite team members
  - Manages billing and access
```



**2. Project Configuration**
```yaml
Project Settings:
  - Name: E-Learning Platform
  - Description: MongoDB clusters for e-learning application
  - Tags: 
    - Environment: Production
    - Project: E-Learning
    - Team: Development
```



---

#### Step 3: Create MongoDB Cluster

##### Cluster Configuration
**1. Build a Database**
```yaml
Database Type: MongoDB
Version: 7.0 (Latest stable)
  - Latest features và security updates
  - Long-term support available
  - Compatibility with Spring Boot
```


**2. Cloud Provider & Region**
```yaml
Cloud Provider: AWS
  - Best integration with existing AWS services
  - VPC peering support
  - Consistent billing

Region Selection: [Select closest to your application]
  - Consider latency requirements
  - Consider compliance requirements
  - Consider cost differences
  - Example: US East (N. Virginia)
```


##### Cluster Tier Selection
**Free Tier (M0)**
```yaml
Cluster Tier: M0 Sandbox
  - Use Case: Development và testing
  - Storage: 512 MB
  - RAM: Shared
  - vCPU: Shared
  - Cost: Free
  - Limitations: No dedicated resources
```


**Paid Tiers (M2+)**
```yaml
Development Environment:
  - M2: $9/month, 2 GB storage
  - M5: $25/month, 5 GB storage

Production Environment:
  - M10: $57/month, 10 GB storage
  - M20: $114/month, 20 GB storage
  - M30: $171/month, 30 GB storage
```



##### Cluster Settings
**Cluster Name**
```yaml
Cluster Name: elearning-cluster-[env]
  - Example: elearning-cluster-prod
  - Descriptive và unique
  - Environment indicator
  - Easy identification
```



**Additional Settings**
```yaml
Cluster Settings:
  - Backup: Enabled (recommended)
  - Provider Settings: Default
  - Cluster Tier: [Selected tier]
  - Cloud Provider: AWS
  - Region: [Selected region]
```



---

#### Step 4: Configure Network Access

##### IP Access List
**1. Network Access Configuration**
```yaml
Access Method: IP Access List
  - Simple và straightforward
  - Good for development
  - Easy to manage
  - Suitable for small teams
```


**2. IP Address Configuration**
```yaml
IP Addresses:
  - Office Network: 192.168.1.0/24
  - Home Network: [Your home IP]/32
  - Development Server: [Server IP]/32
  - Public Access: 0.0.0.0/0 (not recommended for production)

Comment: [Description for each IP range]
  - Example: "Office network - Development team"
  - Example: "Home office - Personal development"
```



##### VPC Peering (Advanced)
**AWS VPC Peering**
```yaml
VPC Peering Setup:
  - AWS VPC: vpc-12345678
  - Atlas VPC: vpc-atlas-87654321
  - Route Tables: Configure routing
  - Security Groups: Allow MongoDB access
  - Benefits: Private, secure connection
```


---

#### Step 5: Configure Database Access

##### Database Users
**1. Create Database User**
```yaml
User Configuration:
  - Username: elearning_user
  - Password: [Strong password]
  - Database: admin
  - Roles: readWrite trên elearning database
  - Authentication Method: Password
```



**2. User Roles Configuration**
```yaml
Built-in Roles:
  - readWrite: Read và write access
  - dbAdmin: Database administration
  - userAdmin: User management
  - clusterAdmin: Cluster management (admin only)

Custom Roles:
  - course_manager: Course management only
  - analytics_user: Read-only access
  - backup_user: Backup operations
```




##### Database Creation
**1. Create Application Database**
```javascript
// Connect to MongoDB Atlas
mongosh "mongodb+srv://elearning_user:password@cluster0.abc123.mongodb.net/"

// Create application database
use elearning

// Create initial collections
db.createCollection("users")
db.createCollection("courses")
db.createCollection("enrollments")
db.createCollection("lessons")
```


---

#### Step 6: Configure Backup & Monitoring

##### Backup Configuration
**1. Backup Settings**
```yaml
Backup Configuration:
  - Enable: Yes
  - Frequency: Daily
  - Retention: 7 days (free tier) / 30 days (paid)
  - Point-in-time recovery: Enabled
  - Cloud Provider: Same as cluster
```




**2. Backup Schedule**
```yaml
Backup Schedule:
  - Time: [Select low-traffic time]
  - Frequency: Daily
  - Retention Policy: 7 days
  - Point-in-time Recovery: Enabled
  - Cloud Provider Snapshots: Enabled
```



##### Monitoring Configuration
**1. Performance Advisor**
```yaml
Performance Advisor:
  - Enable: Yes
  - Monitoring: Slow queries
  - Index suggestions: Enabled
  - Schema recommendations: Enabled
  - Performance insights: Enabled
```


**2. Real-time Performance Panel**
```yaml
Performance Metrics:
  - Operations per second
  - Query performance
  - Connection count
  - Memory usage
  - Storage usage
  - Network I/O
```




---

#### Step 7: Configure Alerts

##### Alert Configuration
**1. Create Basic Alerts**
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



**2. Alert Channels**
```yaml
Notification Methods:
  - Email: [Your email address]
  - Slack: [Slack webhook URL]
  - PagerDuty: [PagerDuty integration]
  - Webhook: [Custom webhook URL]
  - SMS: [Phone number]
```


---

#### Step 8: Test Connection

##### Connection String
**1. Get Connection String**
```yaml
Connection Information:
  - Username: elearning_user
  - Password: [Your password]
  - Cluster: elearning-cluster-[env]
  - Database: elearning
  - Connection String: mongodb+srv://username:password@cluster.mongodb.net/
```


**2. Test Connection**
```bash
# Test with MongoDB Compass
# Test with mongosh CLI
mongosh "mongodb+srv://elearning_user:password@cluster0.abc123.mongodb.net/elearning"

# Test with Spring Boot application
# Verify connection in application logs
```

{{% notice info %}}
**Terminal Screenshot**: Chụp màn hình test connection thành công
{{% /notice %}}

{{% notice info %}}
**Application Screenshot**: Chụp màn hình Spring Boot logs kết nối thành công
{{% /notice %}}

---

#### Step 9: Security Hardening

##### Security Settings
**1. Security Configuration**
```yaml
Security Features:
  - TLS/SSL: Enabled (required)
  - Authentication: Username/password
  - Network Access: IP whitelist
  - Database Access: Role-based
  - Audit Logging: Enabled
```



**2. Advanced Security**
```yaml
Advanced Security:
  - Private Endpoint: [Configure if needed]
  - Encryption: At rest và in transit
  - Compliance: SOC2, GDPR, HIPAA
  - Data Residency: [Select region]
  - Backup Encryption: Enabled
```


---

#### Step 10: Cost Optimization

##### Resource Optimization
**1. Cluster Sizing**
```yaml
Right-sizing Strategy:
  - Start with smaller instances
  - Monitor resource usage
  - Scale up based on demand
  - Use auto-scaling when available
  - Regular performance review
```



**2. Cost Monitoring**
```yaml
Cost Management:
  - Enable billing alerts
  - Monitor usage patterns
  - Review monthly costs
  - Optimize storage usage
  - Use reserved instances (if available)
```



---

#### Troubleshooting

##### Common Issues
**Connection Problems**
```bash
# Check IP whitelist
# Verify username/password
# Check network connectivity
# Verify cluster status

# Test with mongosh
mongosh "mongodb+srv://username:password@cluster.mongodb.net/"
```



**Performance Issues**
```javascript
// Check slow queries
db.getProfilingStatus()
db.setProfilingLevel(1, 100)

// Check index usage
db.users.getIndexes()
db.courses.getIndexes()

// Analyze query performance
db.users.find({email: "user@example.com"}).explain("executionStats")
```



---

#### Next Steps

Với MongoDB Atlas cluster đã được thiết lập, chúng ta có thể:
- Cấu hình Spring Boot integration
- Implement data models và repositories
- Thiết lập advanced monitoring
- Configure backup và recovery procedures

#### Key Takeaways

- **MongoDB Atlas setup** yêu cầu careful planning cho production use
- **Network access** phải được cấu hình đúng để cho phép application access
- **Database users và roles** cần được thiết lập với minimal privileges
- **Monitoring và alerting** cần thiết cho production environments
- **Backup configuration** quan trọng cho data protection
- **Security hardening** cần được implement từ đầu 