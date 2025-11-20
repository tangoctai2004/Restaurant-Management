# 🔒 HƯỚNG DẪN CẤU HÌNH BẢO MẬT

Sau khi fix các lỗ hổng bảo mật, bạn cần cấu hình lại các file sau:

## 📋 CÁC THAY ĐỔI ĐÃ THỰC HIỆN

### ✅ 1. Password Hashing
- Đã tạo `PasswordUtil.java` sử dụng SHA-256 + salt
- Tất cả password mới sẽ được hash tự động
- Hỗ trợ password cũ (plaintext) để tương thích

### ✅ 2. Database Credentials
- Đã tách credentials ra file `config/database.properties`
- File này đã được thêm vào `.gitignore`

### ✅ 3. VNPay Credentials
- Đã tách credentials ra file `config/vnpay.properties`
- File này đã được thêm vào `.gitignore`

---

## 🔧 CÁCH CẤU HÌNH

### Bước 1: Cấu hình Database

1. Copy file example:
   ```bash
   cp src/java/config/database.properties.example src/java/config/database.properties
   ```

2. Mở file `src/java/config/database.properties` và điền thông tin:
   ```properties
   db.url=jdbc:sqlserver://localhost:1433;databaseName=QLNhaHang;encrypt=true;trustServerCertificate=true
   db.user=sa
   db.password=your_actual_password_here
   ```

### Bước 2: Cấu hình VNPay

1. Copy file example:
   ```bash
   cp src/java/config/vnpay.properties.example src/java/config/vnpay.properties
   ```

2. Mở file `src/java/config/vnpay.properties` và điền thông tin:
   ```properties
   vnpay.version=2.1.0
   vnpay.command=pay
   vnpay.tmncode=your_actual_tmn_code
   vnpay.hashsecret=your_actual_hash_secret
   vnpay.url=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
   vnpay.returnurl=http://localhost:8080/HAH-Restaurant/vnpay-return
   ```

### Bước 3: Rebuild Project

1. Clean and Build project trong NetBeans
2. Đảm bảo các file `.properties` được copy vào `build/web/WEB-INF/classes/config/`

---

## 🔄 MIGRATION PASSWORD CŨ

Nếu bạn có password cũ (plaintext) trong database, có 2 cách:

### Cách 1: Để user tự đổi password
- User đăng nhập với password cũ (hệ thống vẫn hỗ trợ)
- User đổi password → password mới sẽ được hash

### Cách 2: Script migration (khuyến nghị)

Tạo script SQL để hash lại tất cả password:

```sql
-- Script này cần chạy bằng Java vì cần dùng PasswordUtil
-- Hoặc tạo một servlet tạm để chạy migration
```

Hoặc tạo một servlet migration tạm:

```java
@WebServlet("/migrate-passwords")
public class PasswordMigrationServlet extends HttpServlet {
    // Code để hash lại tất cả password trong database
}
```

---

## ⚠️ LƯU Ý QUAN TRỌNG

1. **KHÔNG commit file `.properties` lên Git!**
   - File đã được thêm vào `.gitignore`
   - Chỉ commit file `.example`

2. **File properties phải ở đúng vị trí:**
   - `src/java/config/database.properties`
   - `src/java/config/vnpay.properties`
   - Sau khi build, file sẽ ở: `build/web/WEB-INF/classes/config/`

3. **Nếu không tìm thấy file config:**
   - Hệ thống sẽ dùng giá trị mặc định (fallback)
   - Sẽ có warning trong console
   - Cần cấu hình lại ngay!

4. **Password cũ vẫn hoạt động:**
   - Hệ thống hỗ trợ cả plaintext và hash
   - Password mới sẽ tự động được hash
   - Khuyến nghị: yêu cầu user đổi password

---

## ✅ KIỂM TRA

Sau khi cấu hình:

1. **Test đăng ký tài khoản mới:**
   - Password mới sẽ được hash trong database
   - Format: `salt:hash` (base64)

2. **Test đăng nhập:**
   - Password cũ (plaintext) vẫn hoạt động
   - Password mới (hash) hoạt động bình thường

3. **Test đổi password:**
   - Password mới sẽ được hash

4. **Kiểm tra console:**
   - Không có warning về missing config files
   - Database connection thành công

---

## 🚀 NÂNG CẤP LÊN BCrypt (Tùy chọn)

Nếu muốn dùng BCrypt (an toàn hơn SHA-256):

1. Download `jbcrypt-0.4.jar` từ Maven Central
2. Đặt vào `web/WEB-INF/lib/`
3. Sửa `PasswordUtil.java` để dùng BCrypt thay vì SHA-256

---

**Chúc bạn cấu hình thành công! 🔒**

