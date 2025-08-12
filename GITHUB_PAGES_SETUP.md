# Hướng dẫn tạo GitHub Pages cho Hugo Site

## Bước 1: Kích hoạt GitHub Pages

1. Vào repository của bạn trên GitHub
2. Click vào tab **Settings**
3. Trong sidebar bên trái, click **Pages**
4. Trong phần **Source**, chọn **GitHub Actions**

## Bước 2: Push code lên GitHub

```bash
git add .
git commit -m "Add GitHub Pages workflow"
git push origin main
```

## Bước 3: Kiểm tra deployment

1. Vào tab **Actions** trên GitHub repository
2. Bạn sẽ thấy workflow "Deploy Hugo site to Pages" đang chạy
3. Đợi workflow hoàn thành (khoảng 2-3 phút)

## Bước 4: Truy cập website

Sau khi deployment thành công, website của bạn sẽ có URL dạng:
`https://[username].github.io/[repository-name]`

## Lưu ý quan trọng

- **Branch**: Workflow sẽ chạy khi bạn push lên branch `main`
- **Hugo version**: Sử dụng Hugo extended version để hỗ trợ đầy đủ tính năng
- **Base URL**: Tự động được cấu hình cho GitHub Pages
- **Build output**: Files được build vào thư mục `public/`

## Troubleshooting

### Nếu workflow bị lỗi:
1. Kiểm tra tab **Actions** để xem lỗi cụ thể
2. Đảm bảo repository có quyền truy cập GitHub Pages
3. Kiểm tra file `config.toml` có cấu hình đúng không

### Nếu website không hiển thị:
1. Đợi 5-10 phút sau khi deployment thành công
2. Kiểm tra URL có đúng không
3. Xóa cache browser và thử lại

## Cập nhật website

Mỗi khi bạn push code mới lên branch `main`, website sẽ tự động được cập nhật thông qua GitHub Actions. 