---
title : "Workshop"
date : "2025-01-11"
weight : 1
chapter : false
---

# Workshop

#### Overview
Chào mừng bạn đến với workshop về Esoclusty E-Learning Platform! Đây là một nền tảng học tập trực tuyến toàn diện được xây dựng với Spring Boot, tích hợp cả MySQL và MongoDB để cung cấp trải nghiệm học tập tốt nhất.

#### Platform Features
- **Multi-Role User Management**: Hệ thống quản lý người dùng với 3 vai trò (Admin, Teacher, Student)
- **Comprehensive Course Management**: Quản lý khóa học toàn diện với nội dung đa phương tiện
- **Real-time Communication**: Tính năng giao tiếp thời gian thực với WebSocket
- **Advanced Assessment System**: Hệ thống đánh giá và theo dõi tiến độ học tập
- **Hybrid Database Architecture**: Kiến trúc cơ sở dữ liệu kết hợp MySQL và MongoDB
- **Automated Migration System**: Hệ thống tự động hóa database migration

#### Technology Stack
- **Backend**: Spring Boot 3.4.5, Java 17, Spring Framework 6
- **Databases**: MySQL 8.0+, MongoDB 4.4+
- **Security**: Spring Security 6 với JWT authentication
- **Real-time**: WebSocket với STOMP protocol
- **Frontend**: Thymeleaf templates
- **Build Tool**: Maven 3.9+
- **Cloud Services**: AWS RDS, S3, MongoDB Atlas

#### Workshop Structure

##### 1. Technology Overview
Tìm hiểu về công nghệ và kiến trúc của platform:
- **Backend Framework**: Spring Boot, Java, Spring Framework
- **Database Technologies**: MySQL, MongoDB, hybrid strategy
- **Third-Party Dependencies**: Security, content processing, monitoring

[Explore Technology Overview →](1-technology-overview/)

##### 2. RDS với MySQL - Spring Boot Integration
Thiết lập Amazon RDS với MySQL và tích hợp Spring Boot:
- **RDS Instance Setup**: Tạo và cấu hình RDS instance
- **Spring Boot Configuration**: Cấu hình kết nối database
- **Database Migration**: Quản lý schema và migration

[Explore RDS MySQL Integration →](2-rds-mysql-springboot/)

##### 3. Amazon S3 - File Storage & Management
Thiết lập Amazon S3 cho file storage:
- **S3 Bucket Setup**: Tạo và cấu hình S3 buckets
- **Spring Boot Integration**: Tích hợp S3 với ứng dụng
- **Advanced Features**: CloudFront, monitoring, cost optimization

[Explore S3 Storage →](3-amazon-s3-storage/)

##### 4. MongoDB Atlas - Cloud Database Service
Thiết lập MongoDB Atlas cho document storage:
- **Atlas Setup**: Tạo cluster và cấu hình
- **Spring Boot Integration**: Tích hợp MongoDB với ứng dụng
- **Advanced Features**: Search, analytics, global clusters

[Explore MongoDB Atlas →](4-mongodb-atlas/)

#### Prerequisites
Trước khi bắt đầu workshop, bạn cần:
- **Java Development Kit**: JDK 17 hoặc cao hơn
- **Maven**: Version 3.9+ để quản lý dependencies
- **IDE**: IntelliJ IDEA, Eclipse, hoặc VS Code
- **AWS Account**: Để sử dụng RDS và S3 services
- **MongoDB Atlas Account**: Để sử dụng cloud database service
- **Git**: Để clone repository và quản lý code

#### Expected Outcomes
Sau khi hoàn thành workshop, bạn sẽ có thể:
- **Thiết lập và cấu hình** RDS MySQL instance trên AWS
- **Tạo và quản lý** S3 buckets cho file storage
- **Thiết lập MongoDB Atlas** cluster cho document storage
- **Tích hợp tất cả services** với Spring Boot application
- **Hiểu rõ kiến trúc** hybrid database của platform
- **Thực hiện database migration** một cách an toàn
- **Tối ưu hóa performance** và cost cho production

#### Getting Started
1. **Clone Repository**: `git clone https://github.com/huyIT203/e-learning.git`
2. **Navigate to Backend**: `cd e-learning/elearning-backend`
3. **Review Documentation**: Đọc README.md và docs/vi/
4. **Follow Workshop Sections**: Bắt đầu với Technology Overview
5. **Practice Hands-on**: Thực hành từng bước theo hướng dẫn

#### Support and Resources
- **GitHub Repository**: [https://github.com/huyIT203/e-learning](https://github.com/huyIT203/e-learning)
- **Documentation**: Xem thư mục `docs/vi/` cho tài liệu tiếng Việt
- **Issues**: Báo cáo vấn đề trên GitHub Issues
- **Discussions**: Tham gia thảo luận trên GitHub Discussions

#### Next Steps
Bắt đầu workshop bằng cách khám phá [Technology Overview](1-technology-overview/) để hiểu rõ về kiến trúc và công nghệ của platform. Sau đó, tiếp tục với các phần thiết lập cloud services để xây dựng môi trường production-ready.

Chúc bạn có một trải nghiệm học tập tuyệt vời với Esoclusty E-Learning Platform!
