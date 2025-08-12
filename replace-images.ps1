# Script PowerShell để thay ảnh trong dự án Hugo Workshop
# Chạy script này trong thư mục Workshop-template

param(
    [string]$ImageSource = "",
    [string]$Chapter = "1"
)

Write-Host "=== SCRIPT THAY ẢNH HUGO WORKSHOP ===" -ForegroundColor Green
Write-Host ""

# Kiểm tra thư mục hiện tại
if (-not (Test-Path "static/images")) {
    Write-Host "Lỗi: Không tìm thấy thư mục static/images" -ForegroundColor Red
    Write-Host "Hãy chạy script này trong thư mục Workshop-template" -ForegroundColor Yellow
    exit 1
}

# Hiển thị cấu trúc ảnh hiện tại
Write-Host "Cấu trúc ảnh hiện tại:" -ForegroundColor Cyan
Get-ChildItem "static/images" -Directory | ForEach-Object {
    Write-Host "  - $($_.Name)/" -ForegroundColor White
}

Write-Host ""

# Chọn chương nếu không được chỉ định
if (-not $Chapter) {
    Write-Host "Chọn chương để thay ảnh:" -ForegroundColor Yellow
    Write-Host "1. Tạo tài khoản AWS" -ForegroundColor White
    Write-Host "2. RDS MySQL Spring Boot" -ForegroundColor White
    Write-Host "3. Amazon S3 Storage" -ForegroundColor White
    Write-Host "4. MongoDB Atlas" -ForegroundColor White
    
    $Chapter = Read-Host "Nhập số chương (1-4)"
}

# Kiểm tra chương hợp lệ
if ($Chapter -notin @("1", "2", "3", "4")) {
    Write-Host "Lỗi: Chương không hợp lệ. Chọn từ 1-4" -ForegroundColor Red
    exit 1
}

$ImagePath = "static/images/$Chapter"
if (-not (Test-Path $ImagePath)) {
    Write-Host "Lỗi: Không tìm thấy thư mục $ImagePath" -ForegroundColor Red
    exit 1
}

Write-Host "Đã chọn chương $Chapter" -ForegroundColor Green
Write-Host ""

# Hiển thị ảnh hiện tại trong chương
Write-Host "Ảnh hiện tại trong chương $Chapter:" -ForegroundColor Cyan
$CurrentImages = Get-ChildItem $ImagePath -File | Where-Object { $_.Extension -match "\.(png|jpg|jpeg|svg)$" }
$CurrentImages | ForEach-Object {
    Write-Host "  - $($_.Name)" -ForegroundColor White
}

Write-Host ""

# Hướng dẫn thay ảnh
Write-Host "=== HƯỚNG DẪN THAY ẢNH ===" -ForegroundColor Green
Write-Host ""

Write-Host "Cách 1: Thay trực tiếp (Đơn giản nhất)" -ForegroundColor Yellow
Write-Host "1. Copy ảnh mới vào thư mục: $ImagePath" -ForegroundColor White
Write-Host "2. Đặt tên giống ảnh cũ (ví dụ: 0001.png)" -ForegroundColor White
Write-Host "3. Ghi đè ảnh cũ" -ForegroundColor White
Write-Host ""

Write-Host "Cách 2: Tạo ảnh mới" -ForegroundColor Yellow
Write-Host "1. Tạo thư mục mới trong static/images/" -ForegroundColor White
Write-Host "2. Đặt ảnh mới vào thư mục này" -ForegroundColor White
Write-Host "3. Cập nhật đường dẫn trong file markdown" -ForegroundColor White
Write-Host ""

# Mở thư mục ảnh
Write-Host "Mở thư mục ảnh..." -ForegroundColor Cyan
Start-Process "explorer.exe" -ArgumentList $ImagePath

Write-Host ""
Write-Host "=== LƯU Ý QUAN TRỌNG ===" -ForegroundColor Green
Write-Host "1. Giữ nguyên tên file để không phải sửa code" -ForegroundColor White
Write-Host "2. Kiểm tra kích thước ảnh mới phù hợp" -ForegroundColor White
Write-Host "3. Backup ảnh cũ trước khi thay thế" -ForegroundColor White
Write-Host "4. Test trang web sau khi thay ảnh" -ForegroundColor White

Write-Host ""
Write-Host "=== KIỂM TRA SAU KHI THAY ẢNH ===" -ForegroundColor Green
Write-Host "1. Chạy: hugo server" -ForegroundColor White
Write-Host "2. Mở: http://localhost:1313" -ForegroundColor White
Write-Host "3. Kiểm tra các trang có ảnh đã thay" -ForegroundColor White

Write-Host ""
Write-Host "=== CHUẨN BỊ CHO GITHUB PAGES ===" -ForegroundColor Green
Write-Host "1. git add . && git commit -m 'Update images'" -ForegroundColor White
Write-Host "2. git push origin main" -ForegroundColor White
Write-Host "3. Bật GitHub Pages trong repository settings" -ForegroundColor White

Write-Host ""
Write-Host "Script hoàn thành! Thư mục ảnh đã được mở." -ForegroundColor Green 