---
title : "S3 Bucket Setup & Configuration"
date : "2025-01-11"
weight : 1
chapter : false
pre : " <b> 3.1 </b> "
---

# S3 Bucket Setup & Configuration

#### Overview
Trong phần này, chúng ta sẽ thiết lập Amazon S3 buckets từ đầu, cấu hình security, và thiết lập các tính năng cần thiết cho e-learning platform. Bạn sẽ học cách tạo buckets, cấu hình access policies, và thiết lập lifecycle management.

#### Prerequisites

##### AWS Account Setup
**Required Services**
- **AWS Account**: Active AWS account với billing enabled
- **IAM Permissions**: Quyền tạo và quản lý S3 resources
- **VPC Setup**: Virtual Private Cloud (nếu sử dụng VPC endpoints)
- **IAM Users/Roles**: Để cấu hình access policies

**IAM Permissions Required**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
    ]
}
```

---

#### Step 1: Create S3 Buckets
##### Create Main Content Bucket
**1. Navigate to S3 Service**
```bash
# Mở AWS Console
# Tìm kiếm "S3" service
# Click "Create bucket"
```

![S3 Console](/images/03/s3-1.png)



**2. Basic Bucket Configuration**
```yaml
Bucket name: elearning-content-[region]-[env]
  - Example: elearning-content-us-east-1-prod
  - Must be globally unique
  - Use lowercase letters, numbers, hyphens
  - Avoid underscores and periods

AWS Region: [Select your preferred region]
  - Consider latency to your application
  - Consider compliance requirements
  - Consider cost differences
  **Public Access Settings**
```yaml
Block all public access: Enabled
  - Block public access through bucket policies
  - Block public access through ACLs
  - Block public access through any access control lists
  - Block public access through bucket policies

Override settings: Disabled
  - Maintain consistent security across account
  - Prevent accidental public access
  - Follow security best practices
```

![S3 Console](/images/03/s3-2.png)

---

#### Step 2: Configure Bucket Settings

##### Object Ownership
**ACLs Configuration**
```yaml
ACLs: Disabled (Recommended)
  - Prevents accidental public access
  - Better security control
  - Use bucket policies instead

Object Ownership: Bucket owner enforced
  - Simplifies access control
  - Prevents ACL conflicts
  - Better security management
```

![S3 Console](/images/03/s3-3.png)



#### Step 3: Tạo user IAM cho S3

```yaml
Vào IAM → Users → Add users.

Nhập tên: elearning-s3-user.

Chọn Access key - Programmatic access (để Spring Boot dùng).

Attach policy: chọn AmazonS3FullAccess hoặc custom chỉ cho 1 bucket.

Tạo xong, lưu lại Access Key ID và Secret Access Key (chỉ hiển thị 1 lần).

Benefits:
  - Centralized key management
  - Detailed access logging
  - Integration with IAM policies
  - Compliance requirements
```

![S3 Console](/images/03/S3-4.png)

```yaml
Bước 1 — Đặt tên & quyền truy cập
Bạn đã đặt tên elearning-s3-user → OK.

Không cần tick "Provide user access to the AWS Management Console" vì bạn chỉ cần programmatic access (dùng Access Key cho code).

Nhấn Next.

Bước 2 — Set permissions
Chọn Attach policies directly.

Tìm AmazonS3FullAccess (nếu muốn dễ test ban đầu) hoặc tạo Custom Policy giới hạn trong 1 bucket cho bảo mật.

Tick chọn policy → Next.

Bước 3 — Tạo user & lưu Access Key
Review thông tin → Create user.

AWS sẽ hiển thị Access key ID và Secret access key → lưu ngay, vì Secret Key chỉ hiện một lần.

Sau này bạn dùng thông tin này để cấu hình trong application.properties Spring Boot.
Thành công tạo user IAM
``` 
![S3 Console](/images/03/s3-5.png)
![S3 Console](/images/03/s3-6.png)

---


```yaml
tạo Access Key:

Vào AWS Console → Tìm dịch vụ IAM (Identity and Access Management).

Trong Users, chọn user bạn đang dùng (hoặc tạo user mới với quyền S3).

Chọn tab Security credentials → Create access key.

AWS sẽ cho bạn Access Key ID và Secret Access Key → tải file .csv hoặc copy lại ngay (vì Secret chỉ hiện một lần).

Lưu cặp key này vào AWS CLI, hoặc trong file .env / biến môi trường để Spring Boot đọc.

⚠ Lưu ý bảo mật: Không commit Access Key vào GitHub.

```
![S3 Console](/images/03/s3-8.png)
#### Step 5: Configure Access Control

##### Bucket Policies
**Access Control Policies**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::elearning-uploads-ap-southeast-1/*"
        },
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::elearning-uploads-ap-southeast-1/*",
            "Condition": {
                "ArnLike": {
                    "AWS:SourceArn": [
                        "arn:aws:cloudfront::470840853649:distribution/E2TAEJ7I6RYQ78",
                        "arn:aws:cloudfront::470840853649:distribution/E3QCNLF25XUK0R"
                    ]
                }
            }
        }
    ]
}
```



##### IAM Policies
**User and Role Access**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::elearning-content-*",
                "arn:aws:s3:::elearning-content-*/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalTag/Role": "E-Learning-User"
                }
            }
        }
    ]
}
```



#### Step 6: Configure CORS

##### Cross-Origin Resource Sharing
**CORS Configuration**
```json
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "PUT",
            "POST"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": [
            "ETag"
        ]
    }
]
```



##### CORS Use Cases
**Common Scenarios**
```yaml
Web Application:
  - Allow uploads from web interface
  - Enable direct browser access
  - Support drag-and-drop functionality
  - Handle preflight requests

Mobile Application:
  - Allow mobile app access
  - Support offline sync
  - Handle authentication tokens
  - Manage session cookies
```

---





#### Next Steps

Với S3 buckets đã được thiết lập, chúng ta có thể:
- Cấu hình Spring Boot integration
- Implement file upload/download services
- Thiết lập CloudFront CDN
- Configure advanced monitoring và analytics

#### Key Takeaways

- **S3 bucket setup** yêu cầu careful planning cho security và cost
- **Access control** phải được cấu hình đúng để bảo vệ data
- **Lifecycle policies** giúp tối ưu hóa chi phí storage
- **Monitoring và analytics** cần thiết cho production environments
- **CORS configuration** cần thiết cho web application access
- **Cost optimization** cần được monitor và adjust regularly 