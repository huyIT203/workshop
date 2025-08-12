---
title : "CloudFront CDN Integration"
date : "2025-01-11"
weight : 3
chapter : false
pre : " <b> 3.3 </b> "
---

# CloudFront CDN Integration

#### Overview
Trong phần này, chúng ta sẽ tích hợp Amazon CloudFront với S3 để tối ưu hóa content delivery. CloudFront sẽ hoạt động như một CDN (Content Delivery Network), giúp tăng tốc độ truy cập files từ S3 và giảm chi phí data transfer. Bạn sẽ học cách tạo CloudFront distribution, cấu hình origin access, và tích hợp với Spring Boot application.

#### Prerequisites

##### CloudFront Setup
**Required Services**
- **Amazon S3**: Source bucket đã được cấu hình
- **IAM Permissions**: Quyền tạo và quản lý CloudFront distributions
- **SSL Certificate**: Domain certificate (nếu sử dụng custom domain)

**IAM Permissions Required**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudfront:*",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": "*"
        }
    ]
}
```

---

#### Step 1: Create CloudFront Distribution

##### Distribution Configuration
**1. Navigate to CloudFront**
```bash
Bước 1 — Chuẩn bị S3 bucket
Bạn đã có S3 bucket chứa file ảnh rồi (ví dụ: my-project-bucket).

Vào S3 → chọn bucket → Properties → kiểm tra Block all public access đang ON.

Nếu muốn cho CloudFront truy cập, không cần bật public — ta sẽ dùng Origin Access Control (OAC).
```

![S3 Console](/images/03/cdf-2.png)

**2. Origin Configuration**
```yaml
Origin Domain: [Select S3 bucket]
  - Example: elearning-uploads-ap-southeast-1.s3.ap-southeast-1.amazonaws.com
  - Or use S3 bucket name: elearning-uploads-ap-southeast-1

Origin Path: [Leave empty]
  - Root path for all objects
  - Can specify subfolder if needed

Origin Access: Origin access control settings (recommended)
  - More secure than public bucket access
  - AWS manages access automatically
  - Better security control
```

![S3 Console](/images/03/cdf-3.png)

**3. Distribution Settings**
```yaml


Specify origin
```

![S3 Console](/images/03/cdf-5.png)

---





---


---

#### Step 3: Update S3Service for CloudFront

##### CloudFront Integration
**1. Update S3Service Configuration**
```java
@Service
public class S3Service {
    private final S3Client s3Client;
    private final String bucketName = "elearning-uploads-ap-southeast-1";
    
    @Value("${app.aws.cloudfront.domain:}")
    private String cloudfrontDomain;

    public S3Service(S3Client s3Client) {
        this.s3Client = s3Client;
    }

    public String uploadFile(MultipartFile file) throws IOException {
        String keyName = file.getOriginalFilename();
        String contentType = file.getContentType();

        // Upload to S3
        s3Client.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(keyName)
                        .contentType(contentType)
                        .build(),
                RequestBody.fromBytes(file.getBytes())
        );

        // Return CloudFront URL if available, otherwise S3 URL
        if (cloudfrontDomain != null && !cloudfrontDomain.isEmpty()) {
            return "https://" + cloudfrontDomain + "/" + keyName;
        } else {
            return "https://" + bucketName + ".s3.amazonaws.com/" + keyName;
        }
    }
}
```



**2. Application Properties Configuration**
```properties
# CloudFront Configuration
app.aws.cloudfront.domain=[YOUR_CLOUDFRONT_DOMAIN]
  - Example: d2ledyithr93sd.cloudfront.net
  - Get from CloudFront distribution details
  - Used for generating file URLs
```



---

#### Step 5: CloudFront Distribution Deployment

##### Distribution Status
**1. Wait for Deployment**
```yaml
Deployment Process:
  - Status: In Progress
  - Duration: 5-15 minutes
  - Regions: Global deployment
  - Edge Locations: 200+ locations worldwide
```



**2. Verify Deployment**
```yaml
Deployment Complete:
  - Status: Deployed
  - Domain Name: [Your CloudFront domain]
  - Edge Locations: Active
  - Origin: Connected to S3
```



---

#### Step 6: Test CloudFront Integration

##### File Access Testing
**1. Test CloudFront URL**
```bash
# Test CloudFront access
curl -I "https://[CLOUDFRONT_DOMAIN]/[FILENAME]"

# Compare with S3 direct access
curl -I "https://[BUCKET_NAME].s3.amazonaws.com/[FILENAME]"

# Check response headers
curl -v "https://[CLOUDFRONT_DOMAIN]/[FILENAME]"
```



**2. Performance Comparison**
```yaml
Performance Metrics:
  - S3 Direct Access: Higher latency
  - CloudFront Access: Lower latency
  - Cache Hit: Faster response
  - Cache Miss: S3 fallback
```



---

#### Step 7: Advanced CloudFront Features

##### Lambda@Edge Integration
**1. Lambda Function Setup**
```javascript
// Lambda@Edge function for custom headers
exports.handler = async (event) => {
    const response = event.Records[0].cf.response;
    
    // Add custom headers
    response.headers['x-powered-by'] = [{
        key: 'x-powered-by',
        value: 'E-Learning Platform'
    }];
    
    // Add CORS headers
    response.headers['access-control-allow-origin'] = [{
        key: 'access-control-allow-origin',
        value: '*'
    }];
    
    return response;
};
```


**2. Lambda@Edge Configuration**
```yaml
Function Configuration:
  - Runtime: Node.js 18.x
  - Handler: index.handler
  - Memory: 128 MB
  - Timeout: 5 seconds
  - Trigger: Origin Response
```


---

#### Step 8: Monitoring and Analytics

##### CloudWatch Integration
**1. CloudFront Metrics**
```yaml
Available Metrics:
  - Requests: Total number of requests
  - Bytes Downloaded: Data transfer volume
  - Cache Hit Ratio: Cache effectiveness
  - Error Rate: 4xx and 5xx errors
  - Latency: Response time metrics
```



**2. Real-time Monitoring**
```yaml
Monitoring Dashboard:
  - Request Count: Real-time request volume
  - Cache Performance: Hit/miss ratios
  - Geographic Distribution: User locations
  - Error Tracking: Failed requests
  - Cost Analysis: Data transfer costs
```



---

#### Step 9: Security Configuration

##### Security Features
**1. Geo-Restriction**
```yaml
Geo-Restriction Settings:
  - Type: Allow List
  - Countries: [Select allowed countries]
  - Use Case: Compliance requirements
  - Example: Only allow access from specific regions
```



**2. Field-Level Encryption**
```yaml
Encryption Configuration:
  - Field: sensitive-data
  - Encryption: AES-256
  - Key: AWS KMS managed key
  - Use Case: PCI DSS compliance
```



---

#### Step 10: Cost Optimization

##### Cost Management
**1. Price Class Optimization**
```yaml
Price Class Options:
  - Use Only North America and Europe: $0.085 per GB
  - Use All Edge Locations: $0.100 per GB
  - Use All Edge Locations (Best Performance): $0.120 per GB

Recommendation:
  - Development: Use Only North America and Europe
  - Production: Evaluate user distribution
  - Global Users: Consider All Edge Locations
```



**2. Data Transfer Optimization**
```yaml
Optimization Strategies:
  - Enable Compression: Reduce data transfer
  - Use Appropriate Cache Policies: Reduce origin requests
  - Monitor Usage: Track data transfer costs
  - Set Alerts: Cost threshold notifications
```



---



#### Next Steps

Với CloudFront CDN đã được tích hợp, chúng ta có thể:
- Monitor performance metrics
- Optimize cache policies
- Implement custom behaviors với Lambda@Edge
- Scale globally với edge locations

#### Key Takeaways

- **CloudFront CDN** tối ưu hóa content delivery worldwide
- **Origin Access Control** cung cấp security cho S3 bucket
- **Cache Policies** ảnh hưởng đến performance và cost
- **Lambda@Edge** cho phép custom logic tại edge locations
- **Monitoring** cần thiết cho performance optimization
- **Cost optimization** với price class và data transfer management 