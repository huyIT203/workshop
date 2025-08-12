# Hướng Dẫn Thay Ảnh Trong Dự Án Hugo Workshop

## Cấu Trúc Ảnh Hiện Tại

Dự án sử dụng cấu trúc ảnh như sau:
```
Workshop-template/
├── static/
│   └── images/
│       ├── 1/           # Ảnh cho chương 1: Tạo tài khoản AWS
│       ├── 2/           # Ảnh cho chương 2: RDS MySQL Spring Boot
│       ├── 3/           # Ảnh cho chương 3: Amazon S3 Storage
│       └── 4/           # Ảnh cho chương 4: MongoDB Atlas
```

## Cách Thay Ảnh

### Bước 1: Chuẩn Bị Ảnh Mới
- **Định dạng**: PNG, JPG, SVG (khuyến nghị PNG)
- **Kích thước**: Tương tự ảnh cũ (khoảng 800x600px hoặc lớn hơn)
- **Tên file**: Giữ nguyên tên file cũ hoặc đặt tên mới

### Bước 2: Thay Thế Ảnh

#### Phương Pháp A: Thay Trực Tiếp
1. Copy ảnh mới vào thư mục tương ứng
2. Đặt tên giống ảnh cũ (ví dụ: `0001.png`, `0002.png`)
3. Ghi đè ảnh cũ

#### Phương Pháp B: Tạo Ảnh Mới
1. Tạo thư mục mới trong `static/images/` (ví dụ: `my-images/`)
2. Đặt ảnh mới vào thư mục này
3. Cập nhật đường dẫn trong file markdown

### Bước 3: Cập Nhật Nội Dung

Trong file markdown, ảnh được gọi như sau:
```markdown
![Mô tả ảnh](/images/1/0001.png?featherlight=false&width=90pc)
```

**Các tham số:**
- `featherlight=false`: Tắt lightbox
- `width=90pc`: Chiều rộng ảnh (90% màn hình)

## Ví Dụ Cụ Thể

### Thay Ảnh Chương 1
1. Vào thư mục `Workshop-template/static/images/1/`
2. Thay thế các file:
   - `0001.png` - Ảnh trang chủ AWS
   - `0002.png` - Ảnh nhập thông tin email
   - `0003.png` - Ảnh hoàn thành thông tin
   - `0004.png` - Ảnh xác nhận email
   - `0005.png` - Ảnh xác nhận code
   - `0006.png` - Ảnh xác nhận thành công
   - `0007.png` - Ảnh hoàn thành thông tin tài khoản
   - `0008.png` - Ảnh thông tin tài khoản
   - `0009.png` - Ảnh chọn loại tài khoản
   - `00010.png` - Ảnh thêm phương thức thanh toán
   - `00011.png` - Ảnh xác minh số điện thoại

### Thay Ảnh Chương Khác
Tương tự cho các chương 2, 3, 4:
- Chương 2: `Workshop-template/static/images/2/`
- Chương 3: `Workshop-template/static/images/3/`
- Chương 4: `Workshop-template/static/images/4/`

## Lưu Ý Quan Trọng

1. **Giữ nguyên tên file** để không phải sửa code
2. **Kiểm tra kích thước** ảnh mới phù hợp
3. **Test trang web** sau khi thay ảnh
4. **Backup ảnh cũ** trước khi thay thế

## Kiểm Tra Kết Quả

Sau khi thay ảnh:
1. Chạy lệnh: `hugo server` trong thư mục `Workshop-template/`
2. Mở trình duyệt: `http://localhost:1313`
3. Kiểm tra các trang có ảnh đã thay

## Chuẩn Bị Cho GitHub Pages

Sau khi thay ảnh xong:
1. Commit thay đổi: `git add . && git commit -m "Update images"`
2. Push lên GitHub: `git push origin main`
3. Bật GitHub Pages trong repository settings
4. Chọn source là branch `main` và folder `/docs` hoặc `/public`

## Lệnh Hữu Ích

```bash
# Build trang web
cd Workshop-template
hugo

# Chạy server local để test
hugo server

# Build cho production
hugo --minify
```

## Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra đường dẫn ảnh trong markdown
2. Đảm bảo ảnh có trong thư mục `static/images/`
3. Kiểm tra quyền file ảnh
4. Xem log Hugo để debug 