---
title : "RDS với MySQL - Spring Boot Integration"
date : "2025-01-11"
weight : 2
chapter : false
pre : " <b> 2. </b> "
---

# RDS với MySQL - Spring Boot Integration

#### Overview
Trong phần này, chúng ta sẽ thiết lập và cấu hình Amazon RDS với MySQL để tích hợp với ứng dụng Spring Boot. Bạn sẽ học cách tạo RDS instance, cấu hình kết nối, và tích hợp với ứng dụng e-learning platform. Đặc biệt, chúng ta sẽ sử dụng Flyway để quản lý database migration một cách tự động và an toàn.

#### Section Contents

##### 2.1 RDS Instance Setup
Thiết lập Amazon RDS instance với MySQL:
- **RDS Instance Creation**: Tạo và cấu hình RDS instance
- **Security Group Configuration**: Cấu hình bảo mật và network access
- **Database Configuration**: Thiết lập database parameters và options
- **Backup and Maintenance**: Cấu hình backup và maintenance windows
- **Monitoring and Alerts**: Thiết lập CloudWatch monitoring

[Explore RDS Instance Setup →](2.1-rds-instance-setup/)

##### 2.2 Spring Boot Database Configuration
Cấu hình Spring Boot để kết nối với RDS:
- **Database Connection**: Cấu hình kết nối database với RDS
- **Flyway Integration**: Thiết lập Flyway cho database migration
- **JPA Configuration**: Cấu hình Hibernate và JPA
- **Connection Pooling**: Tối ưu hóa Hikari connection pool
- **Environment Configuration**: Quản lý cấu hình cho các môi trường khác nhau

[Explore Spring Boot Configuration →](2.2-springboot-configuration/)

##### 2.3 Database Migration with Flyway
Quản lý schema và migration với Flyway:
- **Flyway Setup**: Cấu hình Flyway trong Spring Boot
- **Migration Scripts**: Tạo và quản lý SQL migration scripts
- **Schema Versioning**: Quản lý version của database schema
- **Rollback Procedures**: Quy trình rollback khi cần thiết
- **Testing Strategies**: Chiến lược testing cho database changes

[Explore Database Migration →](2.3-database-migration/)

#### RDS Overview

##### Amazon RDS Benefits
**Managed Database Service**
- **Automated Management**: AWS tự động quản lý database administration
- **High Availability**: Multi-AZ deployment cho high availability
- **Scalability**: Easy scaling up/down theo nhu cầu
- **Security**: Built-in security features và encryption
- **Backup**: Automated backup và point-in-time recovery

**MySQL on RDS**
- **Version Support**: Hỗ trợ MySQL 5.7, 8.0, và các version mới nhất
- **Performance**: Optimized cho performance và reliability
- **Compatibility**: Tương thích 100% với MySQL community edition
- **Monitoring**: Detailed monitoring và performance insights

#### RDS Instance Types

##### Instance Class Selection
**General Purpose (M5, M6g)**
- **Use Case**: Development, testing, và small production workloads
- **Memory**: 2-384 GB RAM
- **vCPU**: 2-128 vCPUs
- **Storage**: Up to 64 TB
- **Network**: Up to 25 Gbps

**Memory Optimized (R5, R6g)**
- **Use Case**: High-performance database workloads
- **Memory**: 16-768 GB RAM
- **vCPU**: 2-96 vCPUs
- **Storage**: Up to 64 TB
- **Network**: Up to 25 Gbps

**Burstable Performance (T3)**
- **Use Case**: Development và light production workloads
- **Memory**: 0.5-16 GB RAM
- **vCPU**: 2-8 vCPUs
- **Storage**: Up to 16 TB
- **Network**: Up to 5 Gbps

#### Storage Options

##### Storage Types
**General Purpose SSD (gp2)**
- **Performance**: 3 IOPS per GB, up to 16,000 IOPS
- **Use Case**: Most workloads
- **Cost**: Most cost-effective
- **Size**: 20 GB to 64 TB

**Provisioned IOPS SSD (io1)**
- **Performance**: Up to 64,000 IOPS
- **Use Case**: High-performance workloads
- **Cost**: Higher cost for high IOPS
- **Size**: 100 GB to 64 TB

**Magnetic Storage**
- **Performance**: 100-200 IOPS
- **Use Case**: Legacy applications
- **Cost**: Lowest cost
- **Size**: 20 GB to 1 TB

#### Security Features

##### Network Security
**VPC Configuration**
- **Private Subnets**: RDS instance trong private subnets
- **Security Groups**: Restrict access to specific IP ranges
- **Network ACLs**: Additional network layer security
- **VPC Endpoints**: Private connection to AWS services

**Encryption**
- **Encryption at Rest**: AES-256 encryption cho data storage
- **Encryption in Transit**: SSL/TLS encryption cho connections
- **Key Management**: AWS KMS integration
- **Certificate Management**: Automated certificate rotation

#### Monitoring and Maintenance

##### CloudWatch Integration
**Metrics Available**
- **Database Metrics**: CPU, memory, storage, connections
- **Network Metrics**: Network throughput và latency
- **Storage Metrics**: IOPS, storage space, read/write operations
- **Custom Metrics**: Application-specific metrics

**Alarms and Notifications**
- **CPU Utilization**: Alert khi CPU usage cao
- **Memory Usage**: Monitor memory consumption
- **Storage Space**: Alert khi storage gần đầy
- **Connection Count**: Monitor active connections

##### Maintenance Windows
**Automated Maintenance**
- **Security Updates**: Automated security patches
- **Engine Updates**: Minor version updates
- **System Updates**: OS và infrastructure updates
- **Scheduling**: Configurable maintenance windows

#### Cost Optimization

##### Pricing Factors
**Instance Pricing**
- **On-Demand**: Pay per hour, no commitment
- **Reserved Instances**: 1-3 year commitment, significant savings
- **Spot Instances**: Not available for RDS
- **Multi-AZ**: Additional cost for high availability

**Storage Pricing**
- **Provisioned Storage**: Pay for allocated storage
- **IOPS**: Additional cost for provisioned IOPS
- **Backup Storage**: Free storage up to 100% of database size
- **Data Transfer**: Charges for data transfer out of AWS

#### Flyway Integration Benefits

##### Database Migration Management
**Automated Schema Management**
- **Version Control**: Mỗi thay đổi database được version control
- **Repeatable**: Migration scripts có thể chạy lại trên môi trường khác
- **Rollback Support**: Hỗ trợ rollback về version trước
- **Team Collaboration**: Multiple developers có thể làm việc cùng lúc

**Production Benefits**
- **Zero Downtime**: Migration có thể thực hiện với minimal downtime
- **Audit Trail**: Lịch sử thay đổi database được ghi lại đầy đủ
- **Environment Consistency**: Đảm bảo tất cả môi trường có cùng schema
- **Automated Deployment**: Tích hợp với CI/CD pipeline

#### Next Steps

Trong các phần tiếp theo, chúng ta sẽ:
- Thiết lập RDS instance cụ thể với cấu hình thực tế
- Cấu hình Spring Boot application với Flyway integration
- Implement database migration strategies
- Thiết lập monitoring và alerting

#### Key Takeaways

- **Amazon RDS** cung cấp managed MySQL service với high availability
- **Multiple instance types** phù hợp với các workload khác nhau
- **Built-in security** với encryption và network isolation
- **Automated management** giảm thiểu administrative overhead
- **Flyway integration** cung cấp database migration automation
- **Cost optimization** với reserved instances và storage optimization 