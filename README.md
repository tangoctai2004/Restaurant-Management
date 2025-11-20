<div align="center">

# 🍽️ HAH Restaurant

### Hệ Thống Quản Lý Nhà Hàng Toàn Diện

[![Java](https://img.shields.io/badge/Java-17+-orange?style=for-the-badge&logo=openjdk)](https://www.oracle.com/java/)
[![JSP](https://img.shields.io/badge/JSP-3.0-blue?style=for-the-badge&logo=java)](https://jakarta.ee/specifications/servlet/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-red?style=for-the-badge&logo=microsoft-sql-server)](https://www.microsoft.com/sql-server)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-tangoctai2004-black?style=for-the-badge&logo=github)](https://github.com/tangoctai2004)

> 🎯 Hệ thống quản lý nhà hàng toàn diện được xây dựng bằng Java JSP/Servlet, hỗ trợ quản lý đơn hàng, đặt bàn, thanh toán trực tuyến và nhiều tính năng khác.

[🚀 Bắt đầu](#-cài-đặt) • [📖 Tài liệu](#-tài-liệu) • [🐛 Báo lỗi](https://github.com/tangoctai2004/HAH-Restaurant/issues) • [💡 Đóng góp](#-đóng-góp)

---

</div>

## 📋 Mục Lục

- [✨ Tính năng](#-tính-năng)
- [🛠️ Công nghệ](#️-công-nghệ)
- [💻 Yêu cầu](#-yêu-cầu)
- [🚀 Cài đặt](#-cài-đặt)
- [⚙️ Cấu hình](#️-cấu-hình)
- [📖 Sử dụng](#-sử-dụng)
- [🎯 Tính năng nổi bật](#-tính-năng-nổi-bật)
- [📚 Tài liệu](#-tài-liệu)
- [🐛 Xử lý lỗi](#-xử-lý-lỗi)

---

## ✨ Tính năng

### 👥 Dành cho Khách hàng

| Tính năng | Mô tả |
|-----------|-------|
| 🔐 **Đăng ký/Đăng nhập** | Quản lý tài khoản với password hashing bảo mật |
| 📋 **Xem thực đơn** | Duyệt món ăn theo danh mục, tìm kiếm dễ dàng |
| 🛒 **Giỏ hàng** | Thêm, sửa, xóa món ăn trong giỏ hàng |
| 💳 **Thanh toán VNPay** | Thanh toán trực tuyến an toàn qua VNPay |
| 🪑 **Đặt bàn** | Đặt bàn trước với thanh toán tiền cọc |
| 📜 **Lịch sử** | Xem lịch sử đơn hàng và đặt bàn |
| 👤 **Hồ sơ** | Quản lý thông tin cá nhân |

### 👨‍💼 Dành cho Admin/Staff

| Tính năng | Mô tả |
|-----------|-------|
| 📊 **Dashboard** | Thống kê doanh thu, đơn hàng, đặt bàn trực quan |
| 📦 **Quản lý đơn hàng** | Xem, xử lý, in hóa đơn chi tiết |
| 🪑 **Quản lý đặt bàn** | Xác nhận, gán bàn, hủy đặt bàn |
| 🪑 **Quản lý bàn** | Sơ đồ bàn trực quan, quản lý trạng thái |
| 🍽️ **Quản lý món ăn** | CRUD món ăn, danh mục, nguyên liệu |
| 🎁 **Quản lý khuyến mãi** | Tạo và quản lý mã giảm giá |
| 👥 **Quản lý tài khoản** | Quản lý user, staff, phân quyền |
| 🔑 **Quản lý vai trò** | Tạo vai trò và gán quyền chi tiết |
| 📝 **Quản lý bài viết** | Đăng tin tức, sự kiện |
| ⚙️ **Thiết lập** | Cấu hình thông tin nhà hàng |

### 🔐 Bảo mật & Phân quyền

<div align="center">

| Tính năng | Trạng thái |
|:---------:|:----------:|
| 🔒 Password Hashing (SHA-256 + salt) | ✅ |
| 🛡️ Hệ thống phân quyền RBAC | ✅ |
| 🔐 Credentials trong file config | ✅ |
| ⏱️ Session management | ✅ |

</div>

---

## 🛠️ Công nghệ

<div align="center">

### 🎨 Tech Stack

| Category | Technology |
|:--------:|:----------:|
| **🌐 Backend** | Java, JSP/Servlet, Jakarta EE 6.0 |
| **💾 Database** | Microsoft SQL Server, JDBC |
| **🎨 Frontend** | HTML5, CSS3, JavaScript, JSP |
| **💳 Payment** | VNPay Integration |
| **🔧 Build** | Apache Ant (NetBeans) |

</div>

---

## 💻 Yêu cầu

### 📦 Phần mềm cần thiết

- ☕ **JDK** 17 trở lên
- 🐱 **Apache Tomcat** 10.x trở lên
- 🗄️ **SQL Server** 2019 trở lên
- 🔧 **NetBeans IDE** (khuyến nghị)

### 💻 Cấu hình tối thiểu

- 💾 **RAM**: 4GB+
- 💿 **Ổ cứng**: 2GB trống
- 🖥️ **OS**: Windows, macOS, hoặc Linux

---

## 🚀 Cài đặt

### 📥 Bước 1: Clone repository

```bash
git clone https://github.com/tangoctai2004/HAH-Restaurant.git
cd HAH-Restaurant
```

### 🗄️ Bước 2: Tạo Database

1. Mở **SQL Server Management Studio**
2. Chạy script: `web/sql/CreateTable.sql` 
   - ✨ Tự động tạo database `QLNhaHang` và các bảng
3. Chạy script: `web/sql/InsertData.sql` (tùy chọn)
   - 📊 Chèn dữ liệu mẫu: roles, permissions, accounts, products...

### ⚙️ Bước 3: Cấu hình Database

1. **Copy file example:**
   ```bash
   cp src/java/config/database.properties.example src/java/config/database.properties
   ```

2. **Mở file** `src/java/config/database.properties` và điền thông tin:
   ```properties
   db.url=jdbc:sqlserver://localhost:1433;databaseName=QLNhaHang;encrypt=true;trustServerCertificate=true
   db.user=sa
   db.password=your_password_here
   ```

> ⚠️ **Lưu ý**: Đảm bảo SQL Server đang chạy và cho phép kết nối TCP/IP trên port 1433.

### 💳 Bước 4: Cấu hình VNPay (Tùy chọn)

1. **Copy file example:**
   ```bash
   cp src/java/config/vnpay.properties.example src/java/config/vnpay.properties
   ```

2. **Mở file** `src/java/config/vnpay.properties` và điền thông tin VNPay:
   ```properties
   vnpay.tmncode=your_tmn_code
   vnpay.hashsecret=your_hash_secret
   vnpay.returnurl=http://localhost:8080/HAH-Restaurant/vnpay-return
   ```

> 💡 **Tip**: Đăng ký tài khoản tại [VNPay Sandbox](https://sandbox.vnpayment.vn/) để lấy credentials.

### 🔨 Bước 5: Build và Deploy

#### 🎯 Sử dụng NetBeans:

1. Mở project trong NetBeans IDE
2. Click chuột phải → **Clean and Build**
3. Click chuột phải → **Run** (tự động deploy lên Tomcat)

#### 💻 Sử dụng Command Line:

```bash
# Build WAR file
ant dist

# Deploy
cp dist/HAH-Restaurant.war $CATALINA_HOME/webapps/
```

### 🎉 Bước 6: Khởi động

1. ✅ Khởi động **Apache Tomcat**
2. ✅ Khởi động **SQL Server**
3. 🌐 Truy cập: `http://localhost:8080/HAH-Restaurant`

---

## ⚙️ Cấu hình

### 🔌 Database Connection

| Thuộc tính | Giá trị |
|:----------:|:-------:|
| **File** | `src/java/config/database.properties` |
| **Load** | Tự động khi khởi động ứng dụng |
| **Fallback** | Giá trị mặc định (có warning) |

### 💳 VNPay Payment

| Thuộc tính | Giá trị |
|:----------:|:-------:|
| **File** | `src/java/config/vnpay.properties` |
| **Load** | Tự động khi khởi động ứng dụng |

### ⏱️ Session Timeout

- **Mặc định**: 30 phút
- **Cấu hình**: `web/WEB-INF/web.xml`

### 🔒 Password Security

- ✅ Tất cả password mới được hash tự động (SHA-256 + salt)
- ✅ Password cũ (plaintext) vẫn hoạt động để tương thích
- 📖 Xem chi tiết: [SECURITY_FIXES.md](SECURITY_FIXES.md)

---

## 📖 Sử dụng

### 🔑 Tài khoản mẫu

Sau khi chạy `InsertData.sql`, bạn có thể đăng nhập với:

| Vai trò | Username | Password |
|:------:|:--------:|:--------:|
| 👑 **Admin** | `admin` | `123` |
| 👨‍💼 **Staff** | `nhanvien1` | `123` |
| 👤 **Customer** | `khachhang` | `123` |

> ⚠️ **Lưu ý**: Nên đổi mật khẩu sau lần đăng nhập đầu tiên!

### 📝 Quy trình sử dụng

#### 🪑 Khách hàng đặt bàn:

```
1. Truy cập /reservation
   ↓
2. Điền thông tin đặt bàn
   ↓
3. Thanh toán tiền cọc 100,000 VNĐ
   ↓
4. Admin/Staff nhận bàn và gán bàn
```

#### 🍽️ Khách hàng đặt món:

```
1. Xem thực đơn → Thêm vào giỏ hàng
   ↓
2. Xem giỏ hàng → Áp dụng mã khuyến mãi
   ↓
3. Thanh toán qua VNPay
   ↓
4. Xem lịch sử đơn hàng
```

#### 👑 Admin quản lý:

```
1. Đăng nhập → Dashboard
   ↓
2. Quản lý đơn hàng, đặt bàn, sản phẩm...
   ↓
3. Xem thống kê và báo cáo
```

---

## 🎯 Tính năng nổi bật

<div align="center">

### 🌟 Highlights

</div>

| Tính năng | Mô tả |
|:---------:|:------|
| 🪑 **Quản lý bàn thông minh** | Sơ đồ bàn trực quan với màu sắc theo trạng thái:<br>🟢 Trống • 🟡 Đã đặt • 🔴 Đang dùng • ⚫ Bảo trì |
| 🔑 **Phân quyền RBAC** | Tạo vai trò tùy chỉnh và gán quyền chi tiết |
| 💳 **Thanh toán VNPay** | Tích hợp thanh toán trực tuyến an toàn |
| 📊 **Dashboard thống kê** | Doanh thu, đơn hàng, top sản phẩm với biểu đồ trực quan |
| 🔒 **Password Security** | Hash password với SHA-256 + salt |

---

## 📚 Tài liệu

<div align="center">

| 📄 Tài liệu | 📝 Mô tả |
|:-----------:|:--------|
| [🔄 Luồng hoạt động hệ thống](FLOW_DIAGRAM.md) | Mô tả chi tiết các luồng xử lý trong hệ thống |
| [🪑 Hướng dẫn nhận bàn](HUONG_DAN_NHAN_BAN.md) | Hướng dẫn sử dụng chức năng nhận bàn cho Admin/Staff |
| [🔒 Cấu hình bảo mật](SECURITY_FIXES.md) | Hướng dẫn cấu hình password hashing và credentials |
| [💳 Sửa lỗi VNPay](VNPAY_FIX.md) | Xử lý các vấn đề VNPay callback |

</div>

---

## 🐛 Xử lý lỗi

### ❌ Lỗi kết nối Database

<details>
<summary>🔍 <b>Nguyên nhân & Giải pháp</b></summary>

- ✅ Kiểm tra SQL Server đang chạy
- ✅ Kiểm tra file `database.properties` đã cấu hình đúng
- ✅ Xem console log để biết lỗi cụ thể
- ✅ Đảm bảo SQL Server cho phép kết nối TCP/IP

</details>

### ❌ Lỗi đăng ký

<details>
<summary>🔍 <b>Nguyên nhân & Giải pháp</b></summary>

- ✅ Đảm bảo Roles table có role với `id = 1` (Khách hàng)
- ✅ Kiểm tra console log để xem lỗi SQL
- ✅ Kiểm tra foreign key constraints

</details>

### ❌ Lỗi VNPay

<details>
<summary>🔍 <b>Xem chi tiết</b></summary>

Xem [VNPAY_FIX.md](VNPAY_FIX.md) để biết cách xử lý các lỗi liên quan đến VNPay.

</details>

---

## 🤝 Đóng góp

Chúng tôi rất hoan nghênh mọi đóng góp! 🎉

1. 🍴 **Fork** project
2. 🌿 Tạo **feature branch** (`git checkout -b feature/AmazingFeature`)
3. 💾 **Commit** changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 **Push** to branch (`git push origin feature/AmazingFeature`)
5. 🔀 Mở **Pull Request**

### 📋 Quy tắc đóng góp

- ✅ Tuân thủ coding style hiện tại
- ✅ Viết comment rõ ràng cho code phức tạp
- ✅ Test kỹ trước khi commit
- ✅ Cập nhật tài liệu nếu cần

---

## 📝 License

<div align="center">

**MIT License**

Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

</div>

---

## 👨‍💻 Tác giả

<div align="center">

**Ta Ngoc Tai**

[![GitHub](https://img.shields.io/badge/GitHub-tangoctai2004-black?style=flat-square&logo=github)](https://github.com/tangoctai2004)

</div>

---

## 🙏 Lời cảm ơn

<div align="center">

| Công cụ | Mô tả |
|:-------:|:------|
| [VNPay](https://sandbox.vnpayment.vn/) | 💳 Cổng thanh toán trực tuyến |
| [Apache Tomcat](https://tomcat.apache.org/) | 🐱 Application server |
| [Microsoft SQL Server](https://www.microsoft.com/sql-server) | 🗄️ Database system |
| [NetBeans](https://netbeans.apache.org/) | 🔧 IDE hỗ trợ phát triển |

</div>

---

<div align="center">

### ⭐ Nếu project này hữu ích, hãy cho một star nhé!

**Made with ❤️ by Ta Ngoc Tai**

![GitHub stars](https://img.shields.io/github/stars/tangoctai2004/HAH-Restaurant?style=social)
![GitHub forks](https://img.shields.io/github/forks/tangoctai2004/HAH-Restaurant?style=social)

</div>
