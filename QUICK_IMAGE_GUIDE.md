# 🖼️ HƯỚNG DẪN NHANH THAY ẢNH

## 📁 Cấu Trúc Thư Mục Ảnh

```
Workshop-template/static/images/
├── 1/     ← Chương 1: Tạo tài khoản AWS
├── 2/     ← Chương 2: RDS MySQL Spring Boot  
├── 3/     ← Chương 3: Amazon S3 Storage
└── 4/     ← Chương 4: MongoDB Atlas
```

## 🚀 Cách Thay Ảnh (3 Bước)

### Bước 1: Copy Ảnh Mới
- Copy ảnh mới từ máy của bạn
- Paste vào thư mục tương ứng (ví dụ: `static/images/1/`)

### Bước 2: Đặt Tên File
- **QUAN TRỌNG**: Giữ nguyên tên file cũ
- Ví dụ: `0001.png`, `0002.png`, `0003.png`...

### Bước 3: Ghi Đè
- Ghi đè ảnh cũ bằng ảnh mới
- Không cần sửa code!

## 📋 Danh Sách Ảnh Cần Thay

### Chương 1: Tạo tài khoản AWS
- `0001.png` - Trang chủ AWS
- `0002.png` - Nhập email và tên tài khoản
- `0003.png` - Hoàn thành thông tin
- `0004.png` - Xác nhận email
- `0005.png` - Xác nhận code
- `0006.png` - Xác nhận thành công
- `0007.png` - Hoàn thành thông tin tài khoản
- `0008.png` - Thông tin tài khoản
- `0009.png` - Chọn loại tài khoản
- `00010.png` - Thêm phương thức thanh toán
- `00011.png` - Xác minh số điện thoại

## ✅ Kiểm Tra Kết Quả

```bash
# Vào thư mục dự án
cd Workshop-template

# Chạy server local
hugo server

# Mở trình duyệt: http://localhost:1313
```

## 🚀 Up Lên GitHub

```bash
# Commit thay đổi
git add .
git commit -m "Update /images"

# Push lên GitHub
git push origin main

# Bật GitHub Pages trong repository settings
```

## 💡 Lưu Ý

- ✅ Giữ nguyên tên file
- ✅ Ảnh PNG/JPG/SVG
- ✅ Kích thước phù hợp (800x600px trở lên)
- ✅ Backup ảnh cũ trước khi thay

## 🆘 Cần Giúp Đỡ?

Chạy script: `.\replace-/images.ps1` trong PowerShell 