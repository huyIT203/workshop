# 🚀 **AWS Integration Guide - E-learning Backend**

## 📋 **Tổng quan**
Hướng dẫn tích hợp các dịch vụ AWS cơ bản vào dự án E-learning Backend:
- ✅ **RDS MySQL** - Database chính
- ✅ **S3** - File storage
- ✅ **CloudFront** - CDN cho S3 kết hợp 

---

## 🗄️ **1. AWS RDS MySQL**

### **1.1 Tạo RDS MySQL Instance**
1. **AWS Console** → **RDS** → **Create database**
2. **Engine type**: MySQL
3. **Template**: Free tier
4. **DB instance identifier**: `elearning-mysql`
5. **Master username**: `admin`
6. **Master password**: `Lolijolpp123!`
7. **VPC**: Default VPC
8. **Public access**: Yes (để test local)
9. **Security group**: Mở inbound 3306 từ IP của bạn

### **1.2 Cập nhật cấu hình Database**
Thay thế trong `src/main/resources/application.properties`:

```properties
# Database Configuration - RDS MySQL
spring.datasource.url=jdbc:mysql://mydb.c3e48io2ul8u.ap-southeast-2.rds.amazonaws.com:3306/elearning?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=admin
spring.datasource.password=Lolijolpp123!
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect

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

# Hikari Connection Pool
spring.datasource.hikari.connection-timeout=20000
spring.datasource.hikari.maximum-pool-size=10
spring.jpa.properties.hibernate.jdbc.time_zone=UTC
spring.jpa.open-in-view=false
```

### **1.3 Test kết nối RDS**
```bash
# Build và chạy app
mvn clean package -DskipTests
java -jar target/elearning-backend-0.0.1-SNAPSHOT.jar

# Kiểm tra log: phải thấy kết nối RDS thành công
# Kiểm tra database: MySQL Workbench → connect RDS endpoint
```

---

## ☁️ **2. AWS S3 (File Storage)**

### **2.1 Tạo S3 Bucket**
1. **AWS Console** → **S3** → **Create bucket**
2. **Bucket name**: `elearning-uploads-ap-southeast-1`
3. **Region**: `ap-southeast-1` (Singapore)
4. **Block Public Access**: Bỏ tick tất cả (để public read)
5. **Bucket Versioning**: Disabled
6. **Tags**: `Environment=development`, `Project=elearning`

### **2.2 Cấu hình S3 Bucket Policy**
Vào **Bucket** → **Permissions** → **Bucket Policy**:

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
    }
  ]
}
```

### **2.3 Cấu hình CORS (nếu cần)**
Vào **Bucket** → **Permissions** → **CORS**:

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST"],
    "AllowedOrigins": ["*"],
    "ExposeHeaders": ["ETag"]
  }
]
```

### **2.4 Thêm AWS SDK S3 dependency**
Thêm vào `pom.xml`:

```xml
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>s3</artifactId>
</dependency>
```

### **2.5 Tạo S3Config**
Tạo file `src/main/java/com/elearning/elearning_backend/Config/S3config.java`:

```java
package com.elearning.elearning_backend.Config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;

@Configuration
public class S3config {
    @Bean
    public S3Client s3Client() {
        return S3Client.builder()
                .region(Region.AP_SOUTHEAST_1)
                .credentialsProvider(StaticCredentialsProvider.create(
                        AwsBasicCredentials.create("YOUR_ACCESS_KEY", "YOUR_SECRET_KEY")
                ))
                .build();
    }
}
```

### **2.6 Tạo S3Service**
Tạo file `src/main/java/com/elearning/elearning_backend/Service/S3Service.java`:

```java
package com.elearning.elearning_backend.Service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;

@Service
public class S3Service {
    private final S3Client s3Client;
    private final String bucketName = "elearning-uploads-ap-southeast-1";

    public S3Service(S3Client s3Client) {
        this.s3Client = s3Client;
    }

    public String uploadFile(MultipartFile file) throws IOException {
        String keyName = file.getOriginalFilename();

        s3Client.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(keyName)
                        .build(),
                software.amazon.awssdk.core.sync.RequestBody.fromBytes(file.getBytes())
        );

        return "https://" + bucketName + ".s3.amazonaws.com/" + keyName;
    }
}
```

### **2.7 Tạo FileController**
Tạo file `src/main/java/com/elearning/elearning_backend/Controller/FileController.java`:

```java
package com.elearning.elearning_backend.Controller;

import com.elearning.elearning_backend.Service.S3Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/files")
public class FileController {
    private final S3Service s3Service;

    public FileController(S3Service s3Service) {
        this.s3Service = s3Service;
    }

    @PostMapping("/upload")
    public String uploadFile(@RequestParam("file") MultipartFile file) throws Exception {
        return s3Service.uploadFile(file);
    }
}
```

### **2.8 Cập nhật cấu hình S3**
Thêm vào `application.properties`:

```properties
# AWS S3 Configuration
cloud.aws.region.static=ap-southeast-1
cloud.aws.s3.bucket-name=elearning-uploads-ap-southeast-1
cloud.aws.credentials.access-key=YOUR_ACCESS_KEY
cloud.aws.credentials.secret-key=YOUR_SECRET_KEY

# File Upload Configuration
spring.servlet.multipart.max-file-size=5MB
spring.servlet.multipart.max-request-size=5MB
spring.servlet.multipart.enabled=true
```

---

## 🌐 **3. AWS CloudFront (CDN)**

### **3.1 Tạo CloudFront Distribution**
1. **AWS Console** → **CloudFront** → **Create Distribution**
2. **Origin Domain**: Chọn S3 bucket `elearning-uploads-ap-southeast-1`
3. **Origin Path**: để trống
4. **Origin Access**: Chọn **Origin access control settings (recommended)**
5. **Viewer Protocol Policy**: **Redirect HTTP to HTTPS**
6. **Cache Policy**: Chọn **CachingOptimized**
7. **Price Class**: Chọn **Use Only North America and Europe** (rẻ nhất)
8. **Alternate Domain Names (CNAMEs)**: để trống
9. **Default Root Object**: để trống
10. Click **Create Distribution**

### **3.2 Cập nhật S3 Bucket Policy cho CloudFront**
Sau khi tạo CloudFront, AWS sẽ yêu cầu cập nhật S3 bucket policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::elearning-uploads-ap-southeast-1/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::YOUR_ACCOUNT_ID:distribution/YOUR_DISTRIBUTION_ID"
                }
            }
        }
    ]
}
```

### **3.3 Cập nhật S3Service để dùng CloudFront**
Sửa `S3Service.java`:

```java
package com.elearning.elearning_backend.Service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import org.springframework.beans.factory.annotation.Value;

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
                software.amazon.awssdk.core.sync.RequestBody.fromBytes(file.getBytes())
        );

        // Sử dụng CloudFront URL nếu có, không thì dùng S3 URL
        if (cloudfrontDomain != null && !cloudfrontDomain.isEmpty()) {
            return "https://" + cloudfrontDomain + "/" + keyName;
        } else {
            return "https://" + bucketName + ".s3.amazonaws.com/" + keyName;
        }
    }
}
```

### **3.4 Thêm cấu hình CloudFront**
Thêm vào `application.properties`:

```properties
# CloudFront Configuration
app.aws.cloudfront.domain=d2ledyithr93sd.cloudfront.net
```

---

## 🧪 **4. Test Integration**

### **4.1 Build và chạy app**
```bash
# Clean và build
mvn clean package -DskipTests

# Chạy app
java -jar target/elearning-backend-0.0.1-SNAPSHOT.jar
```

### **4.2 Test S3 Upload**
1. **Postman**: POST `http://localhost:8081/files/upload`
2. **Body**: form-data
   - Key: `file`
   - Value: Chọn file (PNG, JPG...)
3. **Response**: URL S3 hoặc CloudFront

### **4.3 Test Database Connection**
1. **MySQL Workbench**: Connect RDS endpoint
2. **Database**: `elearning`
3. **Tables**: Kiểm tra `flyway_schema_history`, `migration_records`

---

## 🔧 **5. Troubleshooting**

### **5.1 S3 Upload lỗi**
- **Access Denied**: Kiểm tra bucket policy và block public access
- **Invalid credentials**: Kiểm tra AWS_ACCESS_KEY, AWS_SECRET_KEY
- **Region mismatch**: Đảm bảo region S3 và S3Client khớp nhau

### **5.2 RDS Connection lỗi**
- **Connection refused**: Kiểm tra Security Group inbound 3306
- **Access denied**: Kiểm tra username/password
- **SSL error**: Đã set `useSSL=false`

### **5.3 CloudFront không hoạt động**
- **Status**: Đợi "Deployed" (5-15 phút)
- **Origin access**: Kiểm tra S3 bucket policy
- **Cache**: Clear cache nếu cần

---

## 📊 **6. Monitoring và Logs**

### **6.1 CloudWatch Logs**
- **RDS**: Tự động gửi logs
- **S3**: Access logs (cần enable)
- **Application**: Spring Boot logs

### **6.2 Metrics quan trọng**
- **RDS**: CPU, Memory, Connections
- **S3**: Request count, Error rate
- **CloudFront**: Request count, Cache hit ratio

---

## 🚀 **7. Next Steps**

### **7.1 Production Deployment**
- **Elastic Beanstalk**: Deploy Spring Boot app
- **Secrets Manager**: Quản lý credentials
- **Backup**: RDS automated backup

### **7.2 Security Enhancement**
- **IAM Roles**: Thay thế access keys
- **VPC**: Private subnets cho RDS
- **SSL**: Enable SSL cho RDS

### **7.3 Performance Optimization**
- **RDS Read Replicas**: Cho read-heavy workloads
- **S3 Lifecycle**: Archive old files
- **CloudFront**: Edge locations optimization

---

## 📝 **8. Tổng kết**

### **Dịch vụ đã tích hợp:**
✅ **RDS MySQL** - Database chính  
✅ **S3** - File storage  
✅ **CloudFront** - CDN cho S3  

### **Lợi ích đạt được:**
- **Scalability**: Database và storage tự động scale
- **Performance**: CDN tăng tốc độ truy cập file
- **Reliability**: AWS managed services
- **Cost**: Free tier cho development

### **Code changes:**
- Thêm AWS SDK dependencies
- Tạo S3Service và FileController
- Cập nhật application.properties
- Cấu hình S3 và CloudFront

---

**🎉 Chúc mừng! Bạn đã tích hợp thành công 3 dịch vụ AWS cơ bản vào dự án E-learning!** 