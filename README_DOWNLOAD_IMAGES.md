# 🖼️ Hướng dẫn tải ảnh cho món ăn

Script này sẽ tự động tải ảnh cho tất cả các món ăn Việt Nam từ Unsplash.

## 📋 Yêu cầu

- Python 3.6 trở lên
- Thư viện `requests`

## 🚀 Cách sử dụng

### Bước 1: Cài đặt thư viện

```bash
pip install -r requirements.txt
```

Hoặc nếu dùng pip3:

```bash
pip3 install -r requirements.txt
```

### Bước 2: Chạy script

```bash
python download_food_images.py
```

Hoặc:

```bash
python3 download_food_images.py
```

### Bước 3: Kiểm tra kết quả

Script sẽ tự động:
- Tải ảnh từ Unsplash
- Lưu vào thư mục `web/images/`
- Bỏ qua các ảnh đã tồn tại
- Hiển thị kết quả tải về

## 📁 Cấu trúc

```
HAH-Restaurant/
├── download_food_images.py    # Script chính
├── requirements.txt            # Thư viện cần thiết
└── web/
    └── images/                 # Thư mục lưu ảnh
        ├── pho-bo-tai.jpg
        ├── bun-cha.jpg
        ├── com-tam-suon.jpg
        └── ...
```

## 📊 Danh sách ảnh sẽ được tải

Script sẽ tải **58 ảnh** cho các món ăn:

- **Phở & Bún**: 8 ảnh
- **Cơm**: 6 ảnh
- **Gỏi & Nộm**: 5 ảnh
- **Bánh mì**: 5 ảnh
- **Chả giò & Chả cá**: 5 ảnh
- **Chè & Đồ ngọt**: 8 ảnh
- **Đồ uống**: 10 ảnh
- **Lẩu Việt Nam**: 5 ảnh

## ⚠️ Lưu ý

1. **Kết nối Internet**: Script cần kết nối internet để tải ảnh
2. **Thời gian**: Quá trình tải có thể mất vài phút tùy vào tốc độ mạng
3. **Ảnh đã tồn tại**: Script sẽ tự động bỏ qua các ảnh đã có sẵn
4. **Lỗi tải**: Nếu một số ảnh tải thất bại, bạn có thể:
   - Chạy lại script
   - Tải thủ công từ Unsplash: https://unsplash.com/s/photos/vietnamese-food
   - Sử dụng ảnh placeholder

## 🔧 Tùy chỉnh

Nếu muốn thay đổi URL ảnh hoặc thêm món ăn mới, chỉnh sửa dictionary `FOOD_IMAGES` trong file `download_food_images.py`.

## 📝 Ví dụ output

```
============================================================
🍜 SCRIPT TỰ ĐỘNG TẢI ẢNH CHO MÓN ĂN VIỆT NAM
============================================================

📁 Thư mục lưu ảnh: /path/to/web/images
📊 Tổng số ảnh cần tải: 58

   Đang tải: pho-bo-tai.jpg...
   ✅ Đã tải thành công: pho-bo-tai.jpg
   Đang tải: bun-cha.jpg...
   ✅ Đã tải thành công: bun-cha.jpg
   ...

============================================================
📊 KẾT QUẢ:
   ✅ Thành công: 55
   ⏭️  Đã tồn tại: 2
   ❌ Thất bại: 1
============================================================
```

## 🆘 Xử lý lỗi

Nếu gặp lỗi `ModuleNotFoundError: No module named 'requests'`:
```bash
pip install requests
```

Nếu gặp lỗi kết nối, kiểm tra:
- Kết nối internet
- Firewall/Proxy settings
- Thử chạy lại script


