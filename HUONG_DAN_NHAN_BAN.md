# 📋 HƯỚNG DẪN SỬ DỤNG CHỨC NĂNG NHẬN BÀN

## 🎯 Tổng quan
Chức năng nhận bàn cho phép Admin/Staff gán bàn cho các đặt bàn đã được khách hàng thanh toán tiền cọc.

---

## 📝 QUY TRÌNH ĐẦY ĐỦ

### BƯỚC 1: Khách hàng đặt bàn (Tạo booking)

1. **Khách hàng truy cập trang đặt bàn:**
   - URL: `http://localhost:8080/HAH-Restaurant/reservation`
   - Hoặc click menu "Đặt bàn" trên website

2. **Điền thông tin đặt bàn:**
   - ✅ Họ và tên
   - ✅ Số điện thoại
   - ✅ Ngày đặt (chọn từ calendar)
   - ✅ Giờ đặt (chọn thời gian)
   - ✅ Số người (nhập số)
   - ⚪ Ghi chú (tùy chọn)

3. **Thanh toán tiền cọc:**
   - Click nút "Thanh toán tiền cọc và đặt bàn"
   - Thanh toán 100,000 VNĐ qua VNPay
   - Sau khi thanh toán thành công, booking được tạo với:
     - Status: **"Pending"** (Chờ xác nhận)
     - Chưa có bàn được gán

---

### BƯỚC 2: Admin/Staff đăng nhập và vào trang quản lý đặt bàn

1. **Đăng nhập với tài khoản Admin hoặc Staff:**
   - URL: `http://localhost:8080/HAH-Restaurant/login`
   - Đăng nhập với tài khoản có `role = 1` (Admin) hoặc `role = 2` (Staff)

2. **Truy cập trang Quản lý đặt bàn:**
   - Click menu **"Đặt bàn"** trong sidebar bên trái
   - Hoặc truy cập trực tiếp: `http://localhost:8080/HAH-Restaurant/admin/bookings`
   - Trang sẽ hiển thị danh sách tất cả các booking

3. **Tìm booking cần nhận bàn:**
   - Tìm các booking có cột "Trạng thái" = **"Chờ xác nhận"** (màu vàng)
   - Cột "Bàn" sẽ hiển thị **"Chưa có bàn"** (màu xám, in nghiêng)

---

### BƯỚC 3: Nhận bàn (Gán bàn cho booking)

1. **Click nút "Nhận bàn":**
   - Tìm booking có status "Chờ xác nhận"
   - Click nút **"Nhận bàn"** (màu vàng, icon ghế) ở cột "Thao tác"
   - URL sẽ chuyển đến: `http://localhost:8080/HAH-Restaurant/admin/assign-table?bookingId=X`

2. **Xem thông tin booking:**
   - Trang sẽ hiển thị thông tin chi tiết của booking:
     - Mã đặt bàn
     - Khách hàng
     - Số điện thoại
     - Ngày đặt
     - Giờ đặt
     - Số người
     - Ghi chú (nếu có)

3. **Xem sơ đồ bàn:**
   - Sơ đồ hiển thị tất cả các bàn trong nhà hàng
   - Mỗi bàn có màu sắc theo trạng thái:
     - 🟢 **Xanh lá cây**: Trống (Available) - **CÓ THỂ CHỌN**
     - 🟡 **Vàng**: Đã đặt (Reserved) - Đã được gán cho booking khác
     - 🔴 **Đỏ**: Đang dùng (Occupied) - Khách đang ngồi ăn
     - ⚫ **Xám**: Bảo trì (Maintenance) - Đang sửa chữa

4. **Chọn bàn:**
   - Click vào các bàn màu **xanh lá cây** để chọn
   - Có thể chọn **nhiều bàn** nếu số người lớn
   - Bàn đã chọn sẽ có:
     - Viền màu xanh dương đậm
     - Checkbox được đánh dấu ✓
   - Số lượng bàn đã chọn sẽ hiển thị ở dưới sơ đồ

5. **Xác nhận nhận bàn:**
   - Kiểm tra lại các bàn đã chọn
   - Click nút **"Xác nhận nhận bàn"** (màu xanh lá)
   - ⚠️ **Lưu ý**: Phải chọn ít nhất 1 bàn mới có thể xác nhận

---

### BƯỚC 4: Kết quả

1. **Sau khi xác nhận thành công:**
   - Hệ thống sẽ:
     - ✅ Gán các bàn đã chọn cho booking
     - ✅ Cập nhật status bàn thành "Reserved"
     - ✅ Cập nhật status booking thành "Confirmed"
     - ✅ Hiển thị thông báo: "Nhận bàn thành công! Đã gán X bàn cho đặt bàn #Y"

2. **Quay về trang Quản lý đặt bàn:**
   - Booking đã chuyển sang status **"Đã xác nhận"** (màu xanh dương)
   - Cột "Bàn" hiển thị tên các bàn đã gán (ví dụ: "Bàn 1", "Bàn 2")
   - Có thể click nút **"Sửa bàn"** (màu xanh dương) để thay đổi bàn nếu cần

---

## 🔄 CHỨC NĂNG SỬA BÀN

Nếu cần thay đổi bàn đã gán:

1. Tìm booking có status **"Đã xác nhận"**
2. Click nút **"Sửa bàn"** (màu xanh dương)
3. Trang sơ đồ bàn sẽ hiển thị với các bàn đã chọn được đánh dấu
4. Bỏ chọn bàn cũ và chọn bàn mới
5. Click "Xác nhận nhận bàn"
6. Hệ thống sẽ cập nhật lại bàn cho booking

---

## ⚠️ LƯU Ý QUAN TRỌNG

1. **Chỉ chọn được bàn trống:**
   - Chỉ có thể chọn các bàn có status "Available" (màu xanh lá)
   - Bàn "Occupied" (đỏ) và "Maintenance" (xám) không thể chọn

2. **Phải chọn ít nhất 1 bàn:**
   - Nếu không chọn bàn nào, hệ thống sẽ báo lỗi khi submit

3. **Bàn đã gán sẽ bị reserved:**
   - Sau khi gán bàn, status bàn sẽ chuyển thành "Reserved"
   - Bàn này sẽ không thể chọn cho booking khác cho đến khi booking hoàn thành

4. **Quyền truy cập:**
   - Chỉ Admin (role = 1) và Staff (role = 2) mới có thể nhận bàn
   - User thường (role = 0) không thể truy cập trang admin

---

## 🧪 CÁCH TEST NHANH

### Test Case 1: Nhận bàn cho booking mới

1. **Tạo booking test:**
   ```sql
   INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, status)
   VALUES (N'Nguyễn Văn A', '0123456789', '2025-01-20', '18:00:00', 4, 'Pending');
   ```

2. **Đăng nhập admin:**
   - URL: `http://localhost:8080/HAH-Restaurant/login`
   - Username/Password của admin

3. **Vào trang đặt bàn:**
   - Click "Đặt bàn" trong sidebar
   - Tìm booking vừa tạo (status = "Chờ xác nhận")

4. **Nhận bàn:**
   - Click "Nhận bàn"
   - Chọn 1-2 bàn màu xanh lá
   - Click "Xác nhận nhận bàn"

5. **Kiểm tra kết quả:**
   - Booking chuyển sang "Đã xác nhận"
   - Bàn đã gán hiển thị trong cột "Bàn"
   - Status bàn trong database = "Reserved"

### Test Case 2: Sửa bàn đã gán

1. Tìm booking có status "Đã xác nhận"
2. Click "Sửa bàn"
3. Bỏ chọn bàn cũ, chọn bàn mới
4. Xác nhận
5. Kiểm tra bàn đã được cập nhật

---

## 🐛 XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi: "Không tìm thấy thông tin đặt bàn"
- **Nguyên nhân**: BookingId không hợp lệ hoặc booking không tồn tại
- **Giải pháp**: Kiểm tra lại bookingId trong URL

### Lỗi: "Bạn không có quyền truy cập"
- **Nguyên nhân**: Tài khoản không phải Admin/Staff
- **Giải pháp**: Đăng nhập với tài khoản có role = 1 hoặc 2

### Lỗi: "Vui lòng chọn ít nhất một bàn"
- **Nguyên nhân**: Chưa chọn bàn nào trước khi submit
- **Giải pháp**: Chọn ít nhất 1 bàn màu xanh lá

### Không thấy bàn nào màu xanh lá
- **Nguyên nhân**: Tất cả bàn đã được đặt hoặc đang dùng
- **Giải pháp**: 
  - Kiểm tra lại dữ liệu bàn trong database
  - Hoặc cập nhật status bàn thành "Available" trong database

---

## 📊 KIỂM TRA DATABASE

### Kiểm tra booking đã được gán bàn:

```sql
-- Xem booking và bàn đã gán
SELECT b.id, b.customer_name, b.status, 
       t.id as table_id, t.name as table_name, t.status as table_status
FROM Bookings b
LEFT JOIN BookingTables bt ON b.id = bt.booking_id
LEFT JOIN RestaurantTables t ON bt.table_id = t.id
WHERE b.id = [BOOKING_ID];
```

### Kiểm tra status bàn:

```sql
-- Xem tất cả bàn và status
SELECT id, name, capacity, status 
FROM RestaurantTables 
ORDER BY id;
```

### Reset bàn về trạng thái trống:

```sql
-- Đặt lại bàn về Available (nếu cần test)
UPDATE RestaurantTables 
SET status = 'Available' 
WHERE id = [TABLE_ID];
```

---

## ✅ CHECKLIST TRƯỚC KHI SỬ DỤNG

- [ ] Đã có booking với status "Pending" trong database
- [ ] Đã có ít nhất 1 bàn với status "Available"
- [ ] Đã đăng nhập với tài khoản Admin/Staff
- [ ] Đã truy cập đúng URL: `/admin/bookings`
- [ ] Đã thấy nút "Nhận bàn" cho booking Pending

---

## 📞 HỖ TRỢ

Nếu gặp vấn đề, kiểm tra:
1. Console log của server (xem có lỗi không)
2. Database connection (kiểm tra DBConnection)
3. Session (đảm bảo đã đăng nhập)
4. Quyền truy cập (role của account)

---

**Chúc bạn sử dụng thành công! 🎉**

