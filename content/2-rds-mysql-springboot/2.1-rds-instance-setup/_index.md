---
title : "RDS Instance Setup"
date : "2025-01-11"
weight : 1
chapter : false
pre : " <b> 2.1 </b> "
---

# RDS Instance Setup

#### Overview
Trong phần này, chúng ta sẽ thiết lập Amazon RDS instance với MySQL từ đầu. Bạn sẽ học cách tạo RDS instance, cấu hình security groups, và thiết lập các thông số cần thiết cho ứng dụng e-learning platform.

#### Prerequisites

##### AWS Account Setup
**Required Services**
- **AWS Account**: Active AWS account với billing enabled
- **IAM Permissions**: Quyền tạo và quản lý RDS resources
- **VPC Setup**: Virtual Private Cloud với public và private subnets
- **Security Groups**: Network security configuration

**IAM Permissions Required**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds:*",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "kms:ListKeys",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
```

---

#### Step 1: Create RDS Instance

##### AWS Console Setup
**1. Navigate to RDS Service**
```bash
# Mở AWS Console
# Tìm kiếm "RDS" service
# Click "Create database"
```


![RDS Console](/workshop/images/02/rds_1.png)


**2. Choose Database Creation Method**
- **Standard create**: Full control over configuration
- **Easy create**: AWS recommended settings
- **Select "Standard create"** for custom configuration

![RDS Console](/workshop/images/02/rds-2.png)

**3. Engine Options**
```yaml
Engine type: MySQL
Version: MySQL 8.0.28 (Recommended)
Templates: Production (Multi-AZ)
```


##### Instance Configuration
**Basic Settings**
```yaml
DB instance identifier: [tên ]
Master username: admin
Master password: [Strong password with 8+ characters]
Confirm password: [Same password]
```

![RDS Console](/workshop/images/02/rds-4.png)

**Instance Configuration**
```yaml
DB instance class: db.t3.micro (Free tier) / db.m5.large (Production)
Instance type: Burstable classes (includes previous generation)
Storage type: General Purpose SSD (gp2)
Allocated storage: 20 GB
Storage autoscaling: Enable
Maximum storage threshold: 1000 GB
```

![RDS Console](/workshop/images/02/rds-3.png)
![RDS Console](/workshop/images/02/rds-4.png)
![RDS Console](/workshop/images/02/rds-5.png)
---

#### Step 2: Network Configuration

##### VPC and Subnet Configuration




##### Security Group Configuration
**Create Security Group**
```yaml
Security group name: cái mà mình vừa tạo
Description: Security group for e-learning database

```

![RDS Console](/workshop/images/02/rds-6.png)

**Inbound Rules**
```yaml
Type: MySQL/Aurora
Protocol: TCP
Port: 3306
Source: [Your application security group] / [Specific IP ranges]
Description: MySQL access from application
```

![RDS Console](/workshop/images/02/rds-7.png)



#### Step 3: Database Configuration

##### Additional Configuration
**Database Options**
```yaml
Database name: [Default]
Database port: 3306
DB parameter group: [Default]
Option group: [Default]
hostname:[your-endpoints]
password:[password you set]

hãy test connection nếu thành công thì rds của bạn đã được tạo và kết nối với dblocal 
Hãy chạy và test thử
```

![RDS Console](/workshop/images/02/rds-8.png)







#### Step 8: Monitoring Setup

##### CloudWatch Alarms
**Create Basic Alarms**
```yaml
CPU Utilization Alarm:
  - Metric: CPUUtilization
  - Threshold: 80%
  - Period: 5 minutes
  - Actions: Send notification

Free Storage Space Alarm:
  - Metric: FreeStorageSpace
  - Threshold: 2 GB
  - Period: 5 minutes
  - Actions: Send notification

Database Connections Alarm:
  - Metric: DatabaseConnections
  - Threshold: 80% of max_connections
  - Period: 5 minutes
  - Actions: Send notification
```


##### Dashboard Creation
**Create RDS Dashboard**
```yaml
Dashboard name: E-Learning Database Dashboard
Widgets:
  - CPU Utilization
  - Memory Usage
  - Storage Space
  - Active Connections
  - Read/Write IOPS
  - Network Throughput
```


---

#### Troubleshooting

##### Common Issues
**Connection Problems**
```bash
# Check security group rules
aws ec2 describe-security-groups --group-ids [sg-xxxxx]

# Verify VPC configuration
aws ec2 describe-vpcs --vpc-ids [vpc-xxxxx]

# Test network connectivity
telnet [RDS_ENDPOINT] 3306
```


**Performance Issues**
```sql
-- Check slow queries
SHOW VARIABLES LIKE 'slow_query_log';
SHOW VARIABLES LIKE 'long_query_time';

-- Analyze table statistics
ANALYZE TABLE [table_name];

-- Check index usage
SHOW INDEX FROM [table_name];
```



#### Next Steps

Với RDS instance đã được thiết lập, chúng ta có thể:
- Cấu hình Spring Boot application để kết nối
- Thiết lập database migration strategies
- Implement monitoring và alerting
- Tối ưu hóa performance

#### Key Takeaways

- **RDS instance setup** yêu cầu careful planning cho production use
- **Security groups** phải được cấu hình đúng để cho phép application access
- **Parameter groups** cho phép tối ưu hóa database performance
- **Monitoring và alerting** cần thiết cho production environments
- **SSL/TLS** nên được enable cho secure connections
- **Backup và maintenance** windows cần được cấu hình phù hợp 