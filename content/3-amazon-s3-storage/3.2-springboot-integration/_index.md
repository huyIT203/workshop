---
title : "Spring Boot S3 Integration"
date : "2025-01-11"
weight : 2
chapter : false
pre : " <b> 3.2 </b> "
---


#### Overview
Trong phần này, chúng ta sẽ tích hợp Amazon S3 với Spring Boot application để quản lý file upload/download. Bạn sẽ học cách cấu hình AWS SDK, tạo S3Service, và implement FileController để xử lý file operations một cách hiệu quả và an toàn.

#### Prerequisites

##### Project Setup
**Required Dependencies**
- **Spring Boot 3.4.5**: Core framework
- **AWS SDK v2**: Modern AWS SDK for Java
- **Spring Web**: REST API support
- **Spring Boot Starter**: Auto-configuration

**Maven Dependencies**
```xml
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>s3</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

---

#### Step 1: AWS SDK Configuration

##### S3Config Class
**Configuration Setup**
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
                        AwsBasicCredentials.create("[YOUR_ACCESS_KEY]", "[YOUR_SECRET_KEY]")
                ))
                .build();
    }
}
```



**Environment Variables (Recommended)**
```properties
# AWS Configuration
aws.access.key.id=[YOUR_ACCESS_KEY]
aws.secret.access.key=[YOUR_SECRET_KEY]
aws.region=ap-southeast-1
aws.s3.bucket.name=elearning-uploads-ap-southeast-1
```



---

#### Step 2: S3Service Implementation

##### Service Interface
**S3Service Interface**
```java
package com.elearning.elearning_backend.Service;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;

public interface S3Service {
    String uploadFile(MultipartFile file) throws IOException;
    byte[] downloadFile(String fileName) throws IOException;
    void deleteFile(String fileName);
    String getFileUrl(String fileName);
}
```


##### Service Implementation
**S3Service Implementation**
```java
package com.elearning.elearning_backend.Service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.core.sync.RequestBody;

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
        String contentType = file.getContentType();

        s3Client.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(keyName)
                        .contentType(contentType)
                        .build(),
                RequestBody.fromBytes(file.getBytes())
        );

        return "https://" + bucketName + ".s3.amazonaws.com/" + keyName;
    }

    public byte[] downloadFile(String fileName) throws IOException {
        var objectResponse = s3Client.getObject(GetObjectRequest.builder()
                .bucket(bucketName)
                .key(fileName)
                .build());

        return objectResponse.readAllBytes();
    }

    public void deleteFile(String fileName) {
        s3Client.deleteObject(DeleteObjectRequest.builder()
                .bucket(bucketName)
                .key(fileName)
                .build());
    }

    public String getFileUrl(String fileName) {
        return "https://" + bucketName + ".s3.amazonaws.com/" + fileName;
    }
}
```



---

#### Step 3: FileController Implementation

##### REST API Endpoints
**FileController Class**
```java
package com.elearning.elearning_backend.Controller;

import com.elearning.elearning_backend.Service.S3Service;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

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

    @GetMapping("/download/{fileName}")
    public ResponseEntity<byte[]> downloadFile(@PathVariable String fileName) throws IOException {
        byte[] fileData = s3Service.downloadFile(fileName);
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", fileName);
        
        return ResponseEntity.ok()
                .headers(headers)
                .body(fileData);
    }

    @DeleteMapping("/{fileName}")
    public String deleteFile(@PathVariable String fileName) {
        s3Service.deleteFile(fileName);
        return "File " + fileName + " deleted successfully";
    }

    @GetMapping("/url/{fileName}")
    public String getFileUrl(@PathVariable String fileName) {
        return s3Service.getFileUrl(fileName);
    }
}
```



---

#### Step 4: File Upload Configuration

##### Multipart Configuration
**Application Properties**
```properties
# File Upload Configuration
spring.servlet.multipart.max-file-size=5MB
spring.servlet.multipart.max-request-size=5MB
spring.servlet.multipart.enabled=true

# AWS S3 Configuration
cloud.aws.region.static=ap-southeast-1
cloud.aws.s3.bucket-name=elearning-uploads-ap-southeast-1
cloud.aws.credentials.access-key=[YOUR_ACCESS_KEY]
cloud.aws.credentials.secret-key=[YOUR_SECRET_KEY]
```



**File Size Validation**
```java
@Component
public class FileValidationService {
    
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final List<String> ALLOWED_EXTENSIONS = 
        Arrays.asList("jpg", "jpeg", "png", "gif", "pdf", "doc", "docx", "txt");
    
    public boolean isValidFile(MultipartFile file) {
        // Check file size
        if (file.getSize() > MAX_FILE_SIZE) {
            return false;
        }
        
        // Check file extension
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            return false;
        }
        
        String extension = originalFilename.substring(
            originalFilename.lastIndexOf(".") + 1).toLowerCase();
        
        return ALLOWED_EXTENSIONS.contains(extension);
    }
}
```



---

#### Step 5: Error Handling

##### Exception Handling
**S3Exception Class**
```java
package com.elearning.elearning_backend.Exception;

public class S3Exception extends RuntimeException {
    
    public S3Exception(String message) {
        super(message);
    }
    
    public S3Exception(String message, Throwable cause) {
        super(message, cause);
    }
}
```



**Global Exception Handler**
```java
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(S3Exception.class)
    public ResponseEntity<ErrorResponse> handleS3Exception(S3Exception ex) {
        ErrorResponse error = new ErrorResponse(
            "S3_ERROR", 
            ex.getMessage(), 
            LocalDateTime.now()
        );
        
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(error);
    }
    
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<ErrorResponse> handleMaxUploadSizeExceeded(
            MaxUploadSizeExceededException ex) {
        ErrorResponse error = new ErrorResponse(
            "FILE_TOO_LARGE", 
            "File size exceeds maximum allowed size", 
            LocalDateTime.now()
        );
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(error);
    }
}
```



---

#### Step 6: File Metadata Management

##### File Information Model
**FileInfo Entity**
```java
@Entity
@Table(name = "file_info")
public class FileInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String fileName;
    
    @Column(nullable = false)
    private String originalName;
    
    @Column(nullable = false)
    private String contentType;
    
    @Column(nullable = false)
    private Long fileSize;
    
    @Column(nullable = false)
    private String s3Key;
    
    @Column(nullable = false)
    private String s3Url;
    
    @Column(name = "uploaded_by")
    private Long uploadedBy;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // Constructors, getters, setters
}
```



**FileInfo Repository**
```java
@Repository
public interface FileInfoRepository extends JpaRepository<FileInfo, Long> {
    
    List<FileInfo> findByUploadedBy(Long userId);
    
    Optional<FileInfo> findByFileName(String fileName);
    
    List<FileInfo> findByContentTypeContaining(String contentType);
    
    @Query("SELECT f FROM FileInfo f WHERE f.createdAt >= :startDate")
    List<FileInfo> findFilesUploadedAfter(@Param("startDate") LocalDateTime startDate);
}
```


---

#### Step 7: Enhanced S3Service with Metadata

##### Updated S3Service
**Enhanced Upload Method**
```java
@Service
public class S3Service {
    private final S3Client s3Client;
    private final FileInfoRepository fileInfoRepository;
    private final String bucketName = "elearning-uploads-ap-southeast-1";
    
    public S3Service(S3Client s3Client, FileInfoRepository fileInfoRepository) {
        this.s3Client = s3Client;
        this.fileInfoRepository = fileInfoRepository;
    }
    
    public FileInfo uploadFile(MultipartFile file, Long uploadedBy) throws IOException {
        // Generate unique file name
        String originalFileName = file.getOriginalFilename();
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        
        // Upload to S3
        s3Client.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(uniqueFileName)
                        .contentType(file.getContentType())
                        .build(),
                RequestBody.fromBytes(file.getBytes())
        );
        
        // Save metadata to database
        FileInfo fileInfo = new FileInfo();
        fileInfo.setFileName(uniqueFileName);
        fileInfo.setOriginalName(originalFileName);
        fileInfo.setContentType(file.getContentType());
        fileInfo.setFileSize(file.getSize());
        fileInfo.setS3Key(uniqueFileName);
        fileInfo.setS3Url("https://" + bucketName + ".s3.amazonaws.com/" + uniqueFileName);
        fileInfo.setUploadedBy(uploadedBy);
        fileInfo.setCreatedAt(LocalDateTime.now());
        
        return fileInfoRepository.save(fileInfo);
    }
}
```



---

#### Step 8: Testing S3 Integration

##### Unit Tests
**S3Service Test**
```java
@ExtendWith(MockitoExtension.class)
class S3ServiceTest {
    
    @Mock
    private S3Client s3Client;
    
    @Mock
    private FileInfoRepository fileInfoRepository;
    
    @InjectMocks
    private S3Service s3Service;
    
    @Test
    void shouldUploadFileSuccessfully() throws IOException {
        // Given
        MultipartFile file = mock(MultipartFile.class);
        when(file.getOriginalFilename()).thenReturn("test.jpg");
        when(file.getContentType()).thenReturn("image/jpeg");
        when(file.getBytes()).thenReturn("test content".getBytes());
        when(file.getSize()).thenReturn(12L);
        
        // When
        FileInfo result = s3Service.uploadFile(file, 1L);
        
        // Then
        assertThat(result).isNotNull();
        assertThat(result.getOriginalName()).isEqualTo("test.jpg");
        assertThat(result.getContentType()).isEqualTo("image/jpeg");
        verify(s3Client).putObject(any(PutObjectRequest.class), any(RequestBody.class));
        verify(fileInfoRepository).save(any(FileInfo.class));
    }
}
```



**Integration Test**
```java
@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class FileControllerIntegrationTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void shouldUploadFileViaAPI() {
        // Given
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("file", new ByteArrayResource("test content".getBytes()) {
            @Override
            public String getFilename() {
                return "test.txt";
            }
        });
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        
        HttpEntity<MultiValueMap<String, Object>> requestEntity = 
            new HttpEntity<>(body, headers);
        
        // When
        ResponseEntity<String> response = restTemplate.postForEntity(
            "/files/upload", requestEntity, String.class);
        
        // Then
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).contains("s3.amazonaws.com");
    }
}
```



---

#### Step 8: Performance Optimization

##### Async File Processing
**Async Configuration**
```java
@Configuration
@EnableAsync
public class AsyncConfig {
    
    @Bean(name = "fileProcessingExecutor")
    public Executor fileProcessingExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(10);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("FileProcessing-");
        executor.initialize();
        return executor;
    }
}
```



**Async File Upload**
```java
@Service
public class S3Service {
    
    @Async("fileProcessingExecutor")
    public CompletableFuture<FileInfo> uploadFileAsync(MultipartFile file, Long uploadedBy) {
        try {
            FileInfo result = uploadFile(file, uploadedBy);
            return CompletableFuture.completedFuture(result);
        } catch (Exception e) {
            CompletableFuture<FileInfo> future = new CompletableFuture<>();
            future.completeExceptionally(e);
            return future;
        }
    }
}
```


---

#### Troubleshooting

##### Common Issues
**Access Denied Errors**
```bash
# Check IAM permissions
aws iam get-user
aws iam list-attached-user-policies --user-name [username]

# Verify bucket policy
aws s3api get-bucket-policy --bucket elearning-uploads-ap-southeast-1

# Test S3 access
aws s3 ls s3://elearning-uploads-ap-southeast-1/
```



**File Upload Issues**
```yaml
Common Problems:
  - File size too large
  - Invalid file type
  - Network timeout
  - Insufficient permissions
  - Bucket not found

Solutions:
  - Check file size limits
  - Validate file types
  - Increase timeout values
  - Verify IAM permissions
  - Check bucket name
```



---

#### Next Steps

Với S3 integration đã được thiết lập, chúng ta có thể:
- Tích hợp với CloudFront CDN
- Implement file versioning
- Add file compression
- Set up automated backups

#### Key Takeaways

- **AWS SDK v2** cung cấp modern Java API cho S3
- **S3Service** đóng gói tất cả S3 operations
- **FileController** cung cấp REST API endpoints
- **Error handling** cần thiết cho production use
- **File metadata** giúp quản lý files hiệu quả
- **Async processing** tối ưu hóa performance 