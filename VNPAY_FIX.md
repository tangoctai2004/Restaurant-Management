# 🔧 SỬA LỖI VNPAY CALLBACK

## Vấn đề
Sau khi thanh toán VNPay thành công, booking đã được tạo trong database với status "Pending" nhưng không redirect đúng hoặc không hiển thị thông báo thành công.

## Nguyên nhân
1. **Session có thể bị mất** khi redirect từ VNPay về
2. **Verify payment có thể sai** do cách xử lý hash
3. **Booking có thể được tạo 2 lần** nếu user refresh trang

## Giải pháp đã áp dụng

### 1. **Sửa VNPayUtil.verifyPayment()**
- Sửa logic verify để không encode lại giá trị (vì VNPay đã decode)
- Thêm logging để debug
- Sử dụng `equalsIgnoreCase` để so sánh hash

### 2. **Cải thiện VNPayReturnServlet**
- Thêm logging chi tiết để debug
- Kiểm tra bookingOrderId để tránh tạo duplicate
- Xử lý trường hợp session mất nhưng thanh toán thành công
- Hiển thị thông báo rõ ràng với mã giao dịch

### 3. **Cập nhật reservation.jsp**
- Thêm hiển thị `flashSuccess` từ session
- Tự động xóa flashSuccess sau khi hiển thị

## Cách test

1. **Đặt bàn và thanh toán:**
   - Điền form đặt bàn
   - Click "Thanh toán tiền cọc và đặt bàn"
   - Thanh toán trên VNPay sandbox
   - Kiểm tra console logs

2. **Kiểm tra logs:**
   ```
   === VNPay Return ===
   ResponseCode: 00
   TransactionStatus: 00
   Payment verification: true/false
   Booking created: true/false
   ```

3. **Kiểm tra database:**
   - Booking được tạo với status "Pending"
   - BookingTables có record tương ứng
   - RestaurantTables status được cập nhật thành "Reserved"

## Lưu ý

1. **Nếu booking đã được tạo:**
   - Có thể do user refresh trang hoặc callback được gọi 2 lần
   - Logic hiện tại sẽ kiểm tra bookingOrderId để tránh duplicate

2. **Nếu session mất:**
   - Vẫn hiển thị thông báo thành công với mã giao dịch
   - User có thể liên hệ hỗ trợ với mã này

3. **Verify payment:**
   - Nếu verify fail, kiểm tra HashSecret có đúng không
   - Kiểm tra logs để xem hashData có đúng format không

## Debug

Nếu vẫn gặp vấn đề, kiểm tra:
1. Console logs khi callback được gọi
2. Database xem booking có được tạo không
3. Session xem tempBooking có còn không
4. Hash verification có pass không



