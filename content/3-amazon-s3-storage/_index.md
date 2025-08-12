---
title : "Amazon S3 - File Storage & Management"
date : "2025-01-11"
weight : 3
chapter : false
pre : " <b> 3. </b> "
---

# Amazon S3 - File Storage & Management

#### Overview
Trong phần này, chúng ta sẽ thiết lập và cấu hình Amazon S3 để quản lý file storage cho e-learning platform. Bạn sẽ học cách tạo S3 buckets, cấu hình security, và tích hợp với ứng dụng Spring Boot để upload/download files. Đặc biệt, chúng ta sẽ tích hợp S3 với CloudFront để tối ưu hóa performance và giảm chi phí.

#### Section Contents

##### 3.1 S3 Bucket Setup & Configuration
Thiết lập Amazon S3 buckets và cấu hình cơ bản:
- **Bucket Creation**: Tạo và cấu hình S3 buckets với naming convention
- **Bucket Policies**: Cấu hình access policies và permissions
- **CORS Configuration**: Cross-Origin Resource Sharing setup
- **Versioning & Lifecycle**: File versioning và lifecycle management
- **Encryption**: Server-side encryption configuration

[Explore S3 Bucket Setup →](3.1-s3-bucket-setup/)

##### 3.2 Spring Boot S3 Integration
Tích hợp Amazon S3 với Spring Boot application:
- **AWS SDK Configuration**: Cấu hình AWS SDK cho Java
- **S3Service Implementation**: Service để upload files lên S3
- **FileController**: REST API endpoints cho file operations
- **File Management**: CRUD operations cho files
- **Error Handling**: Xử lý lỗi và retry mechanisms

[Explore Spring Boot Integration →](3.2-springboot-integration/)

##### 3.3 CloudFront CDN Integration
Tích hợp CloudFront với S3 để tối ưu hóa delivery:
- **CloudFront Distribution**: Tạo và cấu hình CDN distribution
- **Origin Configuration**: Cấu hình S3 origin cho CloudFront
- **Cache Policies**: Tối ưu hóa caching strategies
- **Security**: Origin access control và SSL/TLS
- **Performance Monitoring**: CloudFront metrics và analytics

[Explore CloudFront Integration →](3.3-cloudfront-integration/)

#### S3 Overview

##### Amazon S3 Benefits
**Object Storage Service**
- **Scalability**: Unlimited storage capacity
- **Durability**: 99.999999999% (11 9's) durability
- **Availability**: 99.99% availability SLA
- **Security**: Built-in security và compliance features
- **Cost-Effective**: Pay only for storage used

**Use Cases for E-Learning**
- **Course Content**: Video lectures, documents, presentations
- **User Uploads**: Assignment submissions, profile pictures
- **Backup Storage**: Database backups, system snapshots
- **Static Assets**: Images, CSS, JavaScript files
- **Media Files**: Audio, video, interactive content

#### S3 Storage Classes

##### Storage Class Selection
**Standard Storage**
- **Use Case**: Frequently accessed data
- **Availability**: 99.99%
- **Durability**: 99.999999999%
- **Cost**: Most expensive
- **Access Time**: Milliseconds

**Intelligent Tiering**
- **Use Case**: Data with unknown access patterns
- **Availability**: 99.9%
- **Durability**: 99.999999999%
- **Cost**: Automatic cost optimization
- **Access Time**: Milliseconds to hours

**Standard-IA (Infrequent Access)**
- **Use Case**: Infrequently accessed data
- **Availability**: 99.9%
- **Durability**: 99.999999999%
- **Cost**: 40% cheaper than Standard
- **Access Time**: Milliseconds

**Glacier Storage**
- **Use Case**: Long-term archival data
- **Availability**: 99.9%
- **Durability**: 99.999999999%
- **Cost**: 90% cheaper than Standard
- **Access Time**: Minutes to hours

#### S3 Security Features

##### Access Control
**IAM Policies**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::elearning-uploads-*/*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalTag/Role": "E-Learning-User"
                }
            }
        }
    ]
}
```

**Bucket Policies**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetBucketObjects",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::elearning-uploads-*/*",
            "Condition": {
                "StringEquals": {
                    "s3:ResourceType": "object"
                }
            }
        }
    ]
}
```

##### Encryption
**Server-Side Encryption**
```yaml
Default encryption: Enable
Encryption type: Amazon S3-managed keys (SSE-S3)
  - OR -
Encryption type: AWS KMS keys (SSE-KMS)
  - OR -
Encryption type: Customer-provided keys (SSE-C)
```

**Client-Side Encryption**
```java
// Encrypt data before uploading
EncryptionMaterials materials = new EncryptionMaterials(kmsKeyId);
AmazonS3EncryptionClient encryptionClient = new AmazonS3EncryptionClient(
    credentials, materials, cryptoConfig);
```

#### S3 Performance Optimization

##### Performance Features
**S3 Transfer Acceleration**
```yaml
Enable: Yes
Endpoint: s3-accelerate.amazonaws.com
Benefits:
  - Faster uploads from distant locations
  - Uses CloudFront edge locations
  - Automatic fallback to standard S3
```

**Multipart Upload**
```java
// For files larger than 100 MB
TransferManager transferManager = TransferManagerBuilder.standard()
    .withS3Client(s3Client)
    .build();

Upload upload = transferManager.upload(bucketName, key, file);
upload.waitForCompletion();
```

**Parallel Processing**
```java
// Upload multiple files in parallel
ExecutorService executor = Executors.newFixedThreadPool(10);
List<Future<UploadResult>> futures = new ArrayList<>();

for (File file : files) {
    futures.add(executor.submit(() -> uploadFile(file)));
}
```

#### S3 Data Management

##### Lifecycle Policies
**Automated Lifecycle Management**
```yaml
Lifecycle Rule: Course Content Management
Actions:
  - Transition to IA after 30 days
  - Transition to Glacier after 90 days
  - Delete after 2555 days (7 years)
Filters:
  - Prefix: courses/
  - Tags: content-type=course-material
```

**Versioning Configuration**
```yaml
Enable versioning: Yes
Benefits:
  - Protect against accidental deletion
  - Rollback to previous versions
  - Compliance requirements
  - Cost implications (pay for all versions)
```

##### Backup and Recovery
**Cross-Region Replication**
```yaml
Source bucket: ap-southeast-1
Destination bucket: ap-southeast-2
Replication rules:
  - Replicate all objects
  - Replicate delete markers
  - Replicate existing objects
```

**S3 Replication Configuration**
```json
{
    "Role": "arn:aws:iam::123456789012:role/s3-replication-role",
    "Rules": [
        {
            "Status": "Enabled",
            "Priority": 1,
            "DeleteMarkerReplication": { "Status": "Enabled" },
            "Destination": {
                "Bucket": "arn:aws:s3:::elearning-backup-bucket",
                "StorageClass": "STANDARD_IA"
            }
        }
    ]
}
```

#### CloudFront Integration Benefits

##### CDN Advantages
**Performance Improvement**
- **Global Edge Locations**: Content served from nearest location
- **Reduced Latency**: Faster file access worldwide
- **Bandwidth Optimization**: Reduced origin server load
- **Caching**: Intelligent caching strategies

**Cost Optimization**
- **Reduced Data Transfer**: Lower S3 data transfer costs
- **Edge Computing**: Lambda@Edge for custom logic
- **Compression**: Automatic content compression
- **Intelligent Routing**: Route 53 integration

#### Next Steps

Trong các phần tiếp theo, chúng ta sẽ:
- Thiết lập S3 buckets cụ thể với cấu hình thực tế
- Cấu hình Spring Boot integration với S3Service
- Thiết lập CloudFront distribution
- Implement advanced S3 features

#### Key Takeaways

- **Amazon S3** cung cấp scalable và durable object storage
- **Multiple storage classes** cho phép tối ưu hóa chi phí
- **Built-in security** với encryption và access control
- **Performance optimization** với transfer acceleration và multipart upload
- **CloudFront integration** tối ưu hóa content delivery
- **Cost optimization** cần thiết cho production workloads 