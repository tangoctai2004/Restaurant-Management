# 🍽️ HAH Restaurant - Hệ Thống Quản Lý Nhà Hàng

[![Java](https://img.shields.io/badge/Java-17+-orange.svg)](https://www.oracle.com/java/)
[![JSP](https://img.shields.io/badge/JSP-3.0-blue.svg)](https://jakarta.ee/specifications/servlet/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-red.svg)](https://www.microsoft.com/sql-server)

Hệ thống quản lý nhà hàng toàn diện được xây dựng bằng Java JSP/Servlet, hỗ trợ quản lý đơn hàng, đặt bàn, thanh toán trực tuyến và nhiều tính năng khác.

## 📋 Mục Lục

- [Tính năng](#-tính-năng)
- [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
- [Yêu cầu hệ thống](#-yêu-cầu-hệ-thống)
- [Cài đặt](#-cài-đặt)
- [Cấu hình](#-cấu-hình)
- [Sử dụng](#-sử-dụng)
- [Tài liệu](#-tài-liệu)

## ✨ Tính năng

### 👥 Khách hàng
- Đăng ký/Đăng nhập với password hashing
- Xem thực đơn và đặt món
- Thanh toán VNPay
- Đặt bàn với thanh toán tiền cọc
- Lịch sử đơn hàng và đặt bàn
- Quản lý hồ sơ cá nhân

### 👨‍💼 Admin/Staff
- Dashboard thống kê doanh thu
- Quản lý đơn hàng, đặt bàn, bàn ăn
- Quản lý món ăn, danh mục, nguyên liệu
- Quản lý khuyến mãi, tài khoản, vai trò
- Quản lý bài viết và thiết lập nhà hàng

### 🔐 Bảo mật
- Password hashing với SHA-256 + salt
- Hệ thống phân quyền RBAC
- Credentials lưu trong file config (không hardcode)
- Session management với timeout

## 🛠️ Công nghệ

- **Backend**: Java, JSP/Servlet, Jakarta EE 6.0
- **Database**: Microsoft SQL Server, JDBC
- **Frontend**: HTML5/CSS3, JavaScript, JSP
- **Payment**: VNPay integration
- **Build**: Apache Ant (NetBeans)

## 💻 Yêu cầu

- **JDK** 17+
- **Apache Tomcat** 10.x+
- **SQL Server** 2019+
- **NetBeans IDE** (khuyến nghị)

## 🚀 Cài đặt

### 1. Clone repository

```bash
git clone https://github.com/tangoctai2004/HAH-Restaurant.git
cd HAH-Restaurant
```

### 2. Tạo Database

1. Mở **SQL Server Management Studio**
2. Chạy script: `web/sql/CreateTable.sql` (tạo database và bảng)
3. Chạy script: `web/sql/InsertData.sql` (dữ liệu mẫu - tùy chọn)

### 3. Cấu hình Database

1. Copy file example:
   ```bash
   cp src/java/config/database.properties.example src/java/config/database.properties
   ```

2. Mở `src/java/config/database.properties` và điền thông tin:
   ```properties
   db.url=jdbc:sqlserver://localhost:1433;databaseName=QLNhaHang;encrypt=true;trustServerCertificate=true
   db.user=sa
   db.password=your_password_here
   ```

### 4. Cấu hình VNPay (Tùy chọn)

1. Copy file example:
   ```bash
   cp src/java/config/vnpay.properties.example src/java/config/vnpay.properties
   ```

2. Mở `src/java/config/vnpay.properties` và điền thông tin VNPay của bạn

### 5. Build và Deploy

**NetBeans:**
1. Mở project → Clean and Build
2. Run (tự động deploy lên Tomcat)

**Command Line:**
```bash
ant dist
cp dist/HAH-Restaurant.war $CATALINA_HOME/webapps/
```

### 6. Khởi động

1. Khởi động **Tomcat** và **SQL Server**
2. Truy cập: `http://localhost:8080/HAH-Restaurant`

## ⚙️ Cấu hình

### Database Connection
- File: `src/java/config/database.properties`
- Tự động load khi khởi động ứng dụng
- Nếu không tìm thấy file, sẽ dùng giá trị mặc định (có warning)

### VNPay Payment
- File: `src/java/config/vnpay.properties`
- Tự động load khi khởi động ứng dụng

### Session Timeout
- Mặc định: 30 phút (cấu hình trong `web.xml`)

### Password Security
- Tất cả password mới được hash tự động (SHA-256 + salt)
- Password cũ (plaintext) vẫn hoạt động để tương thích
- Xem chi tiết: [SECURITY_FIXES.md](SECURITY_FIXES.md)

## 📖 Sử dụng

### Tài khoản mẫu
Sau khi chạy `InsertData.sql`:
- **Admin**: `admin` / `123`
- **Staff**: `nhanvien1` / `123`
- **Customer**: `khachhang` / `123`

**⚠️ Lưu ý**: Nên đổi mật khẩu sau lần đăng nhập đầu tiên.

### Quy trình cơ bản

**Khách hàng đặt bàn:**
1. Truy cập `/reservation`
2. Điền thông tin và thanh toán tiền cọc 100,000 VNĐ
3. Admin/Staff sẽ nhận bàn và gán bàn

**Khách hàng đặt món:**
1. Xem thực đơn → Thêm vào giỏ hàng
2. Xem giỏ hàng → Áp dụng mã khuyến mãi (nếu có)
3. Thanh toán qua VNPay
4. Xem lịch sử đơn hàng

**Admin quản lý:**
1. Đăng nhập → Dashboard
2. Quản lý đơn hàng, đặt bàn, sản phẩm, tài khoản...

## 📚 Tài liệu

- **[Luồng hoạt động hệ thống](FLOW_DIAGRAM.md)** - Mô tả chi tiết các luồng xử lý
- **[Hướng dẫn nhận bàn](HUONG_DAN_NHAN_BAN.md)** - Hướng dẫn sử dụng chức năng nhận bàn

## 🎯 Tính năng nổi bật

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [Đóng góp](#-đóng-góp)
- [Giấy phép](#-giấy-phép)
### 👥 Dành cho Khách hàng
- ✅ **Đăng ký/Đăng nhập** - Quản lý tài khoản cá nhân
- ✅ **Xem thực đơn** - Duyệt món ăn theo danh mục
- ✅ **Đặt hàng** - Đặt món ăn và thanh toán trực tuyến
- ✅ **Đặt bàn** - Đặt bàn trước với thanh toán tiền cọc qua VNPay
- ✅ **Lịch sử đơn hàng** - Xem lại các đơn hàng đã đặt
- ✅ **Lịch sử đặt bàn** - Theo dõi các đặt bàn của mình
- ✅ **Hồ sơ cá nhân** - Cập nhật thông tin tài khoản
### 👨‍💼 Dành cho Admin/Staff
- ✅ **Dashboard** - Tổng quan thống kê doanh thu, đơn hàng, đặt bàn
- ✅ **Quản lý đơn hàng** - Xem, xử lý, in hóa đơn
- ✅ **Quản lý đặt bàn** - Xác nhận, gán bàn, hủy đặt bàn
- ✅ **Quản lý bàn** - Thêm, sửa, xóa bàn, xem trạng thái bàn
- ✅ **Quản lý món ăn** - CRUD món ăn, danh mục, nguyên liệu
- ✅ **Quản lý khuyến mãi** - Tạo và quản lý mã giảm giá
- ✅ **Quản lý tài khoản** - Quản lý user, staff, phân quyền
- ✅ **Quản lý vai trò** - Tạo vai trò và phân quyền chi tiết
- ✅ **Quản lý bài viết** - Đăng tin tức, sự kiện
- ✅ **Thiết lập nhà hàng** - Cấu hình thông tin nhà hàng
### 🔐 Bảo mật & Phân quyền
- ✅ Hệ thống phân quyền dựa trên Role-Based Access Control (RBAC)
- ✅ Quản lý permissions chi tiết cho từng vai trò
- ✅ Session management với timeout tự động
- ✅ Mã hóa mật khẩu (có thể nâng cấp lên BCrypt)
### 💳 Thanh toán
- ✅ Tích hợp VNPay - Thanh toán trực tuyến an toàn
- ✅ Hỗ trợ thanh toán tiền cọc cho đặt bàn
- ✅ Xác thực giao dịch tự động
## 🛠️ Công nghệ sử dụng
### Backend
- **Java** - Ngôn ngữ lập trình chính
- **JSP/Servlet** - Framework web
- **Jakarta Servlet API 6.0** - API servlet
- **JSTL** - JavaServer Pages Standard Tag Library
### Database
- **Microsoft SQL Server** - Hệ quản trị cơ sở dữ liệu
- **JDBC** - Kết nối database

### Frontend
- **HTML5/CSS3** - Cấu trúc và styling
- **JavaScript** - Tương tác người dùng
- **JSP** - Template engine

### Thư viện & Tools
- **SQL Server JDBC Driver** - Kết nối SQL Server
- **JAXB API** - Xử lý XML
- **Apache Ant** - Build tool (NetBeans)

### Payment Gateway
- **VNPay** - Cổng thanh toán trực tuyến

## 📁 Cấu trúc dự án

```
HAH-Restaurant/
├── src/
│   ├── java/
│   │   ├── controller/      # Các servlet xử lý request
│   │   │   ├── HomeServlet.java
│   │   │   ├── MenuServlet.java
│   │   │   ├── CartServlet.java
│   │   │   ├── PaymentServlet.java
│   │   │   ├── ReservationServlet.java
│   │   │   ├── AdminDashboardServlet.java
│   │   │   └── ... (37 controllers)
│   │   ├── dao/             # Data Access Object
│   │   │   ├── DBConnection.java
│   │   │   ├── AccountDAO.java
│   │   │   ├── ProductDAO.java
│   │   │   ├── OrderDAO.java
│   │   │   └── ... (15 DAOs)
│   │   ├── model/           # Các model/entity
│   │   │   ├── Account.java
│   │   │   ├── Product.java
│   │   │   ├── Order.java
│   │   │   └── ... (14 models)
│   │   └── util/            # Các utility class
│   │       ├── VNPayUtil.java
│   │       └── PermissionHelper.java
│   └── conf/                # Cấu hình
├── web/
│   ├── admin/               # Trang quản trị
│   │   ├── dashboard.jsp
│   │   ├── orders.jsp
│   │   ├── bookings.jsp
│   │   └── ... (20+ admin pages)
│   ├── css/                 # Stylesheet
│   │   ├── style.css
│   │   ├── admin.css
│   │   └── ...
│   ├── images/              # Hình ảnh
│   ├── includes/            # JSP includes
│   │   ├── footer.jsp
│   │   └── toast-notification.jsp
│   ├── sql/                 # Script SQL
│   │   ├── CreateTable.sql
│   │   └── InsertData.sql
│   ├── *.jsp                # Trang JSP cho user
│   └── WEB-INF/
│       ├── web.xml          # Cấu hình web app
│       └── lib/             # Thư viện JAR
│           ├── sqljdbc42.jar
│           ├── jakarta.servlet.jsp.jstl-*.jar
│           └── ...
├── build/                   # Thư mục build
├── dist/                    # File WAR để deploy
│   └── HAH-Restaurant.war
└── nbproject/               # Cấu hình NetBeans
```

## 💻 Yêu cầu hệ thống

### Phần mềm cần thiết
- **Java Development Kit (JDK)** 17 trở lên
- **Apache Tomcat** 10.x trở lên (hoặc tương thích Jakarta EE)
- **Microsoft SQL Server** 2019 trở lên
- **SQL Server Management Studio (SSMS)** - Để quản lý database
- **NetBeans IDE** (khuyến nghị) hoặc IDE Java khác (Eclipse, IntelliJ IDEA)

### Cấu hình tối thiểu
- **RAM**: 4GB trở lên
- **Ổ cứng**: 2GB trống
- **Hệ điều hành**: Windows, macOS, hoặc Linux
### Bước 1: Clone repository
### Bước 2: Tạo Database
1. Mở **SQL Server Management Studio (SSMS)**
2. Kết nối với SQL Server instance của bạn
3. Chạy script tạo database và bảng:
   ```sql
   -- Chạy file: web/sql/CreateTable.sql
   -- Script này sẽ tự động tạo database QLNhaHang nếu chưa tồn tại
   ```
4. Chèn dữ liệu mẫu (tùy chọn):
   ```sql
   -- Chạy file: web/sql/InsertData.sql
   -- File này chèn dữ liệu mẫu: roles, permissions, accounts, products, etc.
   ```
### Bước 3: Cấu hình Database Connection
Mở file `src/java/dao/DBConnection.java` và cập nhật thông tin kết nối:
```java
private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=QLNhaHang;encrypt=true;
trustServerCertificate=true";
private static final String USER = "sa";  // Thay đổi nếu cần
private static final String PASSWORD = "your_password";  // Thay đổi mật khẩu
```
**Lưu ý**: Đảm bảo SQL Server đang chạy và cho phép kết nối qua TCP/IP trên port 1433.
### Bước 4: Cấu hình VNPay (Tùy chọn)

Nếu muốn sử dụng thanh toán VNPay, cập nhật thông tin trong `src/java/util/VNPayUtil.java`:

```java
public static final String vnp_TmnCode = "YOUR_TMN_CODE";
public static final String vnp_HashSecret = "YOUR_HASH_SECRET";
public static final String vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
```
Để lấy thông tin VNPay:
1. Đăng ký tài khoản tại [VNPay](https://sandbox.vnpayment.vn/)
2. Lấy `TmnCode` và `HashSecret` từ merchant account
3. Sử dụng sandbox URL cho môi trường test
### Bước 5: Build và Deploy
#### Sử dụng NetBeans:
1. Mở project trong NetBeans IDE
2. Click chuột phải vào project → **Clean and Build**
3. Cấu hình Tomcat server trong NetBeans (nếu chưa có)
4. Click chuột phải → **Run** (sẽ tự động deploy lên Tomcat)
#### Sử dụng Command Line:
# Build WAR file

# File WAR sẽ được tạo tại: dist/HAH-Restaurant.war
# Copy file này vào thư mục webapps của Tomcat
#### Deploy thủ công:
1. Copy file `dist/HAH-Restaurant.war` vào thư mục `webapps` của Tomcat
2. Khởi động Tomcat server
3. Tomcat sẽ tự động extract WAR file

### Bước 6: Khởi động Server
1. Khởi động **Apache Tomcat**
2. Đảm bảo SQL Server đang chạy
3. Truy cập: `http://localhost:8080/HAH-Restaurant`
### Cấu hình Session Timeout

Trong `web/WEB-INF/web.xml`:
```xml
<session-config>
    <session-timeout>30</session-timeout> <!-- 30 phút -->
</session-config>
```

### Cấu hình Character Encoding

Filter tự động xử lý encoding UTF-8 cho tất cả request/response thông qua `CharacterEncodingFilter`.

### Cấu hình Error Pages
Error pages được cấu hình trong `web.xml`:
- **404**: `/error404.jsp`
- **500**: `/error500.jsp`
### Cấu hình Welcome Files
Trang mặc định khi truy cập root:
- `index.html` → Redirect đến `HomeServlet`
- `home` → Hiển thị trang chủ
### Tài khoản mặc định

Sau khi chạy `InsertData.sql`, bạn có thể đăng nhập với các tài khoản mẫu (xem trong file InsertData.sql để biết 
username/password).
**Lưu ý**: Nên thay đổi mật khẩu mặc định sau lần đăng nhập đầu tiên.
### Quy trình sử dụng cơ bản
#### 1. Khách hàng đặt bàn:
2. Điền thông tin đặt bàn (tên, SĐT, ngày, giờ, số người)
3. Thanh toán tiền cọc 100,000 VNĐ qua VNPay
4. Booking được tạo với status "Pending"
5. Admin/Staff sẽ nhận bàn và gán bàn cho booking

#### 2. Khách hàng đặt món:
1. Xem thực đơn tại `/menu`
2. Click "Đặt món" để thêm vào giỏ hàng
3. Xem giỏ hàng tại `/cart`
4. Áp dụng mã khuyến mãi (nếu có)
5. Thanh toán qua VNPay
6. Xem lịch sử đơn hàng tại `/order-history`

#### 3. Admin quản lý:
1. Đăng nhập với tài khoản Admin
2. Truy cập Dashboard để xem thống kê
3. Quản lý đơn hàng: Xem, xử lý, in hóa đơn
4. Quản lý đặt bàn: Xác nhận, gán bàn, hủy đặt bàn
5. Quản lý sản phẩm: Thêm, sửa, xóa món ăn
6. Quản lý tài khoản và phân quyền
### Hướng dẫn nhận bàn
Xem chi tiết tại [HUONG_DAN_NHAN_BAN.md](HUONG_DAN_NHAN_BAN.md)
- **[Luồng hoạt động hệ thống](FLOW_DIAGRAM.md)** - Mô tả chi tiết các luồng xử lý trong hệ thống
- **[Hướng dẫn nhận bàn](HUONG_DAN_NHAN_BAN.md)** - Hướng dẫn sử dụng chức năng nhận bàn cho Admin/Staff
- **[Sửa lỗi VNPay](VNPAY_FIX.md)** - Xử lý các vấn đề liên quan đến VNPay callback
- **[Hướng dẫn download ảnh](README_DOWNLOAD_IMAGES.md)** - Script Python để download ảnh món ăn


## 🎯 Tính năng nổi bật
### 1. Quản lý bàn thông minh
- Sơ đồ bàn trực quan với màu sắc theo trạng thái:
  - 🟢 **Xanh lá**: Trống (Available)
  - 🟡 **Vàng**: Đã đặt (Reserved)
  - 🔴 **Đỏ**: Đang dùng (Occupied)
  - ⚫ **Xám**: Bảo trì (Maintenance)
- Tự động cập nhật trạng thái bàn
- Gán nhiều bàn cho một đặt bàn lớn

### 2. Hệ thống phân quyền linh hoạt
- Tạo vai trò tùy chỉnh (Roles)
- Gán quyền chi tiết cho từng vai trò (Permissions)
- Kiểm soát truy cập theo từng chức năng
- Hỗ trợ nhiều cấp độ quyền: Admin, Staff, User

### 3. Thanh toán tích hợp VNPay
- Thanh toán an toàn qua VNPay
- Xác thực giao dịch tự động
- Hỗ trợ thanh toán tiền cọc cho đặt bàn
- Callback tự động sau khi thanh toán

### 4. Dashboard thống kê
- Thống kê doanh thu theo ngày/tháng
- Số lượng đơn hàng, đặt bàn
- Biểu đồ trực quan
- Top sản phẩm bán chạy

### 5. Quản lý khuyến mãi
- Tạo mã giảm giá theo phần trăm hoặc số tiền cố định
- Áp dụng cho đơn hàng tối thiểu
- Giới hạn số lần sử dụng
- Quản lý thời gian hiệu lực

## 🐛 Xử lý lỗi

### Lỗi kết nối Database
- Kiểm tra SQL Server đang chạy
- Kiểm tra file `database.properties` đã cấu hình đúng
- Xem console log để biết lỗi cụ thể

### Lỗi đăng ký
- Đảm bảo Roles table có role với `id = 1` (Khách hàng)
- Kiểm tra console log để xem lỗi SQL

### Lỗi VNPay
- Xem [VNPAY_FIX.md](VNPAY_FIX.md)

## 🤝 Đóng góp

1. Fork project
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📝 License

MIT License - Xem file `LICENSE` để biết thêm chi tiết.

## 👨‍💻 Tác giả

**Ta Ngoc Tai**

## 🙏 Lời cảm ơn

- VNPay - Cổng thanh toán trực tuyến
- Apache Tomcat - Application server
- Microsoft SQL Server - Database system

---

⭐ **Nếu project này hữu ích, hãy cho một star nhé!**

**Made with ❤️ by Ta Ngoc Tai**
