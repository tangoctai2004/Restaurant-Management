# 📋 HƯỚNG DẪN NHẬN BÀN

Chức năng nhận bàn cho phép Admin/Staff gán bàn cho các đặt bàn đã được khách hàng thanh toán tiền cọc.

---

## 🚀 QUY TRÌNH NHẬN BÀN

### Bước 1: Vào trang quản lý đặt bàn

1. Đăng nhập với tài khoản **Admin** hoặc **Staff**
2. Click menu **"Đặt bàn"** trong sidebar
3. Tìm booking có trạng thái **"Chờ xác nhận"** (màu vàng)

### Bước 2: Nhận bàn

1. Click nút **"Nhận bàn"** ở cột "Thao tác"
2. Xem sơ đồ bàn và chọn bàn:
   - 🟢 **Xanh lá**: Trống - **CÓ THỂ CHỌN**
   - 🟡 **Vàng**: Đã đặt
   - 🔴 **Đỏ**: Đang dùng
   - ⚫ **Xám**: Bảo trì
3. Click vào các bàn màu xanh lá để chọn (có thể chọn nhiều bàn)
4. Click **"Xác nhận nhận bàn"**

### Bước 3: Kết quả

- ✅ Booking chuyển sang **"Đã xác nhận"** (màu xanh dương)
- ✅ Tên các bàn đã gán hiển thị trong cột "Bàn"
- ✅ Có thể click **"Sửa bàn"** để thay đổi bàn nếu cần

---

## 🔄 SỬA BÀN ĐÃ GÁN

1. Tìm booking có status **"Đã xác nhận"**
2. Click nút **"Sửa bàn"**
3. Bỏ chọn bàn cũ, chọn bàn mới
4. Click **"Xác nhận nhận bàn"**

---

## ⚠️ LƯU Ý

- ✅ Chỉ chọn được bàn màu **xanh lá** (trống)
- ✅ Phải chọn **ít nhất 1 bàn** mới có thể xác nhận
- ✅ Bàn đã gán sẽ chuyển sang "Reserved" và không thể chọn cho booking khác
- ✅ Chỉ Admin và Staff mới có quyền nhận bàn

---

## 🐛 XỬ LÝ LỖI

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| "Không tìm thấy thông tin đặt bàn" | BookingId không hợp lệ | Kiểm tra lại URL |
| "Bạn không có quyền truy cập" | Tài khoản không phải Admin/Staff | Đăng nhập với tài khoản đúng |
| "Vui lòng chọn ít nhất một bàn" | Chưa chọn bàn | Chọn ít nhất 1 bàn màu xanh lá |
| Không thấy bàn nào màu xanh lá | Tất cả bàn đã được đặt | Kiểm tra database hoặc cập nhật status bàn |

---

**Chúc bạn sử dụng thành công! 🎉**
