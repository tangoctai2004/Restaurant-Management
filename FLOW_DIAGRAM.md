# 🔄 LUỒNG HOẠT ĐỘNG HỆ THỐNG HAH RESTAURANT

Tài liệu này mô tả chi tiết các luồng hoạt động chính của hệ thống quản lý nhà hàng HAH Restaurant.

## 📋 Mục Lục

1. [Kiến trúc tổng quan](#kiến-trúc-tổng-quan)
2. [Luồng xử lý request](#luồng-xử-lý-request)
3. [Luồng đăng nhập/đăng ký](#luồng-đăng-nhậpđăng-ký)
4. [Luồng xem thực đơn và đặt món](#luồng-xem-thực-đơn-và-đặt-món)
5. [Luồng đặt bàn](#luồng-đặt-bàn)
6. [Luồng thanh toán](#luồng-thanh-toán)
7. [Luồng quản lý (Admin/Staff)](#luồng-quản-lý-adminstaff)
8. [Luồng phân quyền](#luồng-phân-quyền)

---

## 🏗️ Kiến trúc tổng quan

```
┌─────────────┐
│   Client    │ (Browser)
│  (User)     │
└──────┬──────┘
       │ HTTP Request
       ▼
┌─────────────────────────────────┐
│      Apache Tomcat Server       │
│  ┌───────────────────────────┐  │
│  │   CharacterEncodingFilter │  │ (Xử lý UTF-8)
│  └───────────┬───────────────┘  │
│              ▼                   │
│  ┌───────────────────────────┐  │
│  │      Servlet Container    │  │
│  │  ┌─────────────────────┐  │  │
│  │  │   Controller Layer   │  │  │ (37 Servlets)
│  │  └──────────┬──────────┘  │  │
│  └─────────────┼──────────────┘  │
└────────────────┼─────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│      DAO Layer (Data Access)    │
│  ┌───────────────────────────┐  │
│  │   AccountDAO              │  │
│  │   ProductDAO              │  │
│  │   OrderDAO                │  │
│  │   BookingDAO              │  │
│  │   ... (15 DAOs)           │  │
│  └───────────┬───────────────┘  │
└──────────────┼──────────────────┘
               │ JDBC
               ▼
┌─────────────────────────────────┐
│   Microsoft SQL Server Database  │
│         (QLNhaHang)              │
└─────────────────────────────────┘
```

### Các thành phần chính:

1. **Client Layer**: Trình duyệt web (Chrome, Firefox, Safari...)
2. **Web Server**: Apache Tomcat 10.x
3. **Filter Layer**: `CharacterEncodingFilter` - Xử lý encoding UTF-8
4. **Controller Layer**: 37 Servlets xử lý các request
5. **DAO Layer**: 15 Data Access Objects truy cập database
6. **Database**: Microsoft SQL Server với database `QLNhaHang`

---

## 🔀 Luồng xử lý request

### Request Flow Diagram

```
User Request
    │
    ▼
┌─────────────────────┐
│ CharacterEncoding   │ ← Filter: Set UTF-8 encoding
│ Filter              │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Servlet Container │
│   (Tomcat)          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  URL Pattern Match  │ ← Tìm servlet phù hợp
│  (web.xml/@WebServlet)│
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Controller Servlet│ ← Xử lý business logic
│   (doGet/doPost)    │
└──────────┬──────────┘
           │
           ├─→ Session Check (nếu cần)
           ├─→ Permission Check (nếu cần)
           ├─→ Validation
           │
           ▼
┌─────────────────────┐
│   DAO Layer         │ ← Truy vấn database
│   (Database Access) │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   SQL Server        │
│   (QLNhaHang DB)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Process Data      │ ← Xử lý dữ liệu
│   Set Attributes    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Forward/Redirect  │
│   to JSP            │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   JSP Rendering     │ ← Render HTML
└──────────┬──────────┘
           │
           ▼
    HTTP Response
    (HTML/CSS/JS)
```

### Ví dụ cụ thể: Request đến `/home`

```
1. User truy cập: http://localhost:8080/HAH-Restaurant/home
   │
   ▼
2. CharacterEncodingFilter xử lý encoding UTF-8
   │
   ▼
3. Tomcat tìm servlet mapping cho "/home"
   │
   ▼
4. HomeServlet.doGet() được gọi
   │
   ├─→ CategoryDAO.getAll() → Query: SELECT * FROM Categories
   ├─→ ProductDAO.getAllActive() → Query: SELECT * FROM Products WHERE is_active=1
   ├─→ RestaurantSettingsDAO.getSettingsByPage() → Query: SELECT * FROM RestaurantSettings
   │
   ▼
5. Set attributes vào request:
   - categoryList
   - productList
   - productsByCategory
   - homeSettings
   │
   ▼
6. Forward đến home.jsp
   │
   ▼
7. JSP render HTML với dữ liệu
   │
   ▼
8. Response trả về browser
```

---

## 🔐 Luồng đăng nhập/đăng ký

### 1. Đăng nhập (Login)

```
┌──────────────┐
│ User truy    │
│ cập /login   │
└──────┬───────┘
       │
       ▼
┌─────────────────────┐
│ LoginServlet.doGet()│
│ → Hiển thị login.jsp│
└──────┬──────────────┘
       │
       │ User nhập username/password
       │ Click "Đăng nhập"
       │
       ▼
┌─────────────────────┐
│ LoginServlet.doPost()│
│                     │
│ 1. Validate input   │
│ 2. AccountDAO.login()│
│    └─→ SELECT * FROM Accounts 
│        WHERE username=? AND password=?
│                     │
└──────┬──────────────┘
       │
       ├─→ Nếu thành công:
       │   │
       │   ├─→ Lưu Account vào Session
       │   │
       │   ├─→ Kiểm tra role:
       │   │   │
       │   │   ├─→ Role = 1 (Admin) hoặc 2 (Staff):
       │   │   │   │
       │   │   │   ├─→ PermissionHelper.loadPermissionsToSession()
       │   │   │   │   └─→ Load permissions từ database
       │   │   │   │
       │   │   │   ├─→ PermissionHelper.getFirstAllowedPage()
       │   │   │   │   └─→ Tìm trang đầu tiên có quyền
       │   │   │   │
       │   │   │   └─→ Redirect → admin/dashboard (hoặc trang có quyền)
       │   │   │
       │   │   └─→ Role = 0 (User):
       │   │       └─→ Redirect → home
       │   │
       │   └─→ Nếu thất bại:
       │       └─→ Set error message
       │       └─→ Forward → login.jsp
       │
       ▼
   Response
```

**Code Flow:**
```java
// LoginServlet.java
doPost() {
    // 1. Validate
    if (username == null || password == null) {
        // Show error
        return;
    }
    
    // 2. Login
    Account account = accountDAO.login(username, password);
    
    if (account != null) {
        session.setAttribute("account", account);
        
        // 3. Check role
        if (account.getRole() == 1 || account.getRole() == 2) {
            // Load permissions
            PermissionHelper.loadPermissionsToSession(session, account.getId());
            
            // Redirect to first allowed page
            String redirectUrl = PermissionHelper.getFirstAllowedPage(session);
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("home");
        }
    } else {
        // Show error
    }
}
```

### 2. Đăng ký (Register)

```
┌──────────────┐
│ User truy    │
│ cập /register│
└──────┬───────┘
       │
       ▼
┌─────────────────────┐
│RegisterServlet.doGet()│
│ → Hiển thị register.jsp│
└──────┬──────────────┘
       │
       │ User điền form
       │ Click "Đăng ký"
       │
       ▼
┌─────────────────────┐
│RegisterServlet.doPost()│
│                     │
│ 1. Validate input   │
│    - username       │
│    - password       │
│    - fullName       │
│    - password == repassword│
│                     │
│ 2. Check username exists│
│    AccountDAO.checkUsernameExists()│
│    └─→ SELECT COUNT(*) FROM Accounts 
│        WHERE username=?
│                     │
└──────┬──────────────┘
       │
       ├─→ Nếu username đã tồn tại:
       │   └─→ Set error → Forward register.jsp
       │
       └─→ Nếu hợp lệ:
           │
           ├─→ Tạo Account object
           │   - role = 0 (User)
           │   - is_active = 1
           │
           ├─→ AccountDAO.register(account)
           │   └─→ INSERT INTO Accounts (...)
           │
           ├─→ Set success message
           │
           └─→ Redirect → login
```

---

## 🍽️ Luồng xem thực đơn và đặt món

### 1. Xem trang chủ

```
User truy cập /home
    │
    ▼
HomeServlet.doGet()
    │
    ├─→ CategoryDAO.getAll()
    │   └─→ SELECT c.*, COUNT(p.id) as product_count
    │       FROM Categories c
    │       LEFT JOIN Products p ON c.id = p.category_id
    │       GROUP BY c.id
    │
    ├─→ ProductDAO.getAllActive()
    │   └─→ SELECT p.*, c.name as category_name
    │       FROM Products p
    │       LEFT JOIN Categories c ON p.category_id = c.id
    │       WHERE p.is_active = 1
    │
    ├─→ RestaurantSettingsDAO.getSettingsByPage()
    │   └─→ SELECT * FROM RestaurantSettings
    │       WHERE page = 'home'
    │
    └─→ Set attributes:
        - categoryList
        - productList
        - productsByCategory
        - homeSettings
    │
    ▼
Forward → home.jsp
    │
    ▼
Render HTML với danh mục và sản phẩm
```

### 2. Xem thực đơn

```
User truy cập /menu
    │
    ▼
MenuServlet.doGet()
    │
    ├─→ CategoryDAO.getAll() → categories
    ├─→ ProductDAO.getAll() → allProducts
    │
    ├─→ Kiểm tra Session cart
    │   └─→ hasActiveOrder = (cart != null && !cart.isEmpty())
    │
    └─→ Set attributes:
        - categories
        - allProducts
        - hasActiveOrder
    │
    ▼
Forward → menu.jsp
    │
    ▼
Hiển thị sidebar danh mục và grid sản phẩm
```

### 3. Thêm món vào giỏ hàng

```
User click "Đặt món" trên sản phẩm
    │
    ▼
Link: /orderitem?action=add&productId=123
    │
    ▼
OrderItemServlet.doGet()
    │
    ├─→ Lấy cart từ Session
    │   └─→ List<CartItem> cart = (List<CartItem>) session.getAttribute("cart")
    │
    ├─→ Nếu cart == null:
    │   └─→ Tạo cart mới: cart = new ArrayList<>()
    │
    ├─→ ProductDAO.getById(productId)
    │   └─→ SELECT * FROM Products WHERE id = ?
    │
    ├─→ Kiểm tra sản phẩm đã có trong cart chưa:
    │   │
    │   ├─→ Nếu có:
    │   │   └─→ Tăng quantity + 1
    │   │
    │   └─→ Nếu chưa:
    │       └─→ Thêm CartItem mới:
    │           - product
    │           - quantity = 1
    │           - total = product.price * quantity
    │
    ├─→ Lưu cart vào Session
    │   └─→ session.setAttribute("cart", cart)
    │
    ├─→ Set flashSuccess message
    │
    └─→ Redirect → menu
```

### 4. Xem giỏ hàng

```
User truy cập /cart
    │
    ▼
CartServlet.doGet()
    │
    ├─→ Lấy cart từ Session
    │
    ├─→ Nếu cart == null hoặc empty:
    │   └─→ Set empty cartItems → Forward cart.jsp
    │
    ├─→ Tính subtotal
    │   └─→ subtotal = Σ(item.price * item.quantity)
    │
    ├─→ Xử lý mã khuyến mãi (nếu action=applyPromo):
    │   │
    │   ├─→ PromotionDAO.getByCode(code)
    │   │   └─→ SELECT * FROM Promotions
    │   │       WHERE code = ? AND is_active = 1
    │   │       AND start_date <= NOW() AND end_date >= NOW()
    │   │
    │   ├─→ PromotionDAO.calculateDiscount(promo, subtotal)
    │   │   │
    │   │   ├─→ Nếu type = 'Percent':
    │   │   │   └─→ discount = subtotal * value / 100
    │   │   │
    │   │   └─→ Nếu type = 'FixedAmount':
    │   │       └─→ discount = value
    │   │
    │   └─→ Lưu promo và discountAmount vào Session
    │
    ├─→ Tính totalAmount
    │   └─→ totalAmount = subtotal - discountAmount
    │
    └─→ Set attributes:
        - cartItems
        - subtotal
        - discountAmount
        - totalAmount
        - appliedPromo
    │
    ▼
Forward → cart.jsp
```

### 5. Cập nhật/Xóa món trong giỏ hàng

```
User click "Cập nhật" hoặc "Xóa" trong cart
    │
    ▼
OrderItemServlet.doGet()
    │
    ├─→ action = request.getParameter("action")
    │   - "update": Cập nhật quantity
    │   - "remove": Xóa item
    │
    ├─→ Lấy cart từ Session
    ├─→ Tìm item trong cart theo productId
    │
    ├─→ Nếu action = "update":
    │   └─→ item.setQuantity(newQuantity)
    │   └─→ item.setTotal(item.getPrice() * newQuantity)
    │
    ├─→ Nếu action = "remove":
    │   └─→ cart.remove(item)
    │
    ├─→ Lưu cart vào Session
    │
    └─→ Redirect → cart
```

---

## 🪑 Luồng đặt bàn

### Quy trình đặt bàn đầy đủ

```
┌─────────────────────────────────────────┐
│ BƯỚC 1: Khách hàng đặt bàn             │
└─────────────────────────────────────────┘
    │
    │ User truy cập /reservation
    │
    ▼
ReservationServlet.doGet()
    │
    ├─→ RestaurantSettingsDAO.getSettingsByPage("reservation")
    │
    └─→ Forward → reservation.jsp
    │
    ▼
User điền form:
    - customerName
    - phone
    - bookingDate
    - bookingTime
    - numPeople
    - note (optional)
    │
    │ Click "Thanh toán tiền cọc và đặt bàn"
    │
    ▼
┌─────────────────────────────────────────┐
│ BƯỚC 2: Xử lý đặt bàn                  │
└─────────────────────────────────────────┘
    │
    ▼
ReservationServlet.doPost()
    │
    ├─→ Validate input
    │
    ├─→ Tạo Booking object:
    │   - customerName
    │   - phone
    │   - bookingDate
    │   - bookingTime
    │   - numPeople
    │   - note
    │   - status = "Pending"
    │   - account (nếu đã đăng nhập)
    │
    ├─→ Lưu vào Session:
    │   └─→ session.setAttribute("tempBooking", tempBooking)
    │
    ├─→ Tạo orderId cho VNPay:
    │   └─→ orderId = "BOOKING_" + System.currentTimeMillis()
    │   └─→ session.setAttribute("bookingOrderId", orderId)
    │
    ├─→ VNPayUtil.createPaymentUrl()
    │   └─→ Tạo URL thanh toán VNPay
    │   └─→ Amount: 100,000 VNĐ (tiền cọc)
    │
    └─→ Redirect → VNPay payment page
    │
    ▼
┌─────────────────────────────────────────┐
│ BƯỚC 3: Thanh toán VNPay               │
└─────────────────────────────────────────┘
    │
    │ User thanh toán trên VNPay
    │
    ▼
VNPay redirect về /vnpay-return
    │
    ▼
VNPayReturnServlet.doGet()
    │
    ├─→ Lấy parameters từ VNPay:
    │   - vnp_ResponseCode
    │   - vnp_TransactionStatus
    │   - vnp_TxnRef (orderId)
    │   - vnp_Amount
    │   - ...
    │
    ├─→ VNPayUtil.verifyPayment()
    │   └─→ Verify hash để đảm bảo tính toàn vẹn
    │
    ├─→ Nếu thanh toán thành công (ResponseCode = "00"):
    │   │
    │   ├─→ Lấy tempBooking từ Session
    │   │
    │   ├─→ Kiểm tra booking đã tồn tại chưa:
    │   │   └─→ BookingDAO.getByOrderId(orderId)
    │   │
    │   ├─→ Nếu chưa tồn tại:
    │   │   │
    │   │   ├─→ BookingDAO.createBooking(booking)
    │   │   │   └─→ INSERT INTO Bookings (...)
    │   │   │   └─→ Return bookingId
    │   │   │
    │   │   └─→ Set flashSuccess message
    │   │
    │   └─→ Nếu đã tồn tại:
    │       └─→ Hiển thị thông báo đã tạo
    │
    ├─→ Nếu thanh toán thất bại:
    │   └─→ Set error message
    │
    └─→ Redirect → reservation (với message)
    │
    ▼
┌─────────────────────────────────────────┐
│ BƯỚC 4: Admin/Staff nhận bàn           │
└─────────────────────────────────────────┘
    │
    │ Admin đăng nhập → /admin/bookings
    │
    ▼
AdminBookingsServlet.doGet()
    │
    ├─→ BookingDAO.getAll()
    │   └─→ SELECT * FROM Bookings ORDER BY booking_date DESC
    │
    └─→ Forward → admin/bookings.jsp
    │
    ▼
Admin tìm booking status = "Pending"
    │
    │ Click "Nhận bàn"
    │
    ▼
AssignTableServlet.doGet()
    │
    ├─→ BookingDAO.getById(bookingId)
    │
    ├─→ RestaurantTableDAO.getAll()
    │   └─→ SELECT * FROM RestaurantTables
    │
    ├─→ RestaurantTableDAO.getByBookingId(bookingId)
    │   └─→ Lấy bàn đã gán (nếu có)
    │
    └─→ Forward → admin/assign-table.jsp
    │
    ▼
Admin chọn bàn trên sơ đồ
    │
    │ Click "Xác nhận nhận bàn"
    │
    ▼
AssignTableServlet.doPost()
    │
    ├─→ Lấy danh sách tableIds đã chọn
    │
    ├─→ Validate: Phải chọn ít nhất 1 bàn
    │
    ├─→ Kiểm tra bàn có available không:
    │   └─→ RestaurantTableDAO.getById(tableId)
    │   └─→ Check status = "Available"
    │
    ├─→ BookingDAO.assignTables(bookingId, tableIds)
    │   │
    │   ├─→ INSERT INTO BookingTables (booking_id, table_id)
    │   │   VALUES (?, ?) cho mỗi bàn
    │   │
    │   ├─→ UPDATE RestaurantTables
    │   │   SET status = 'Reserved'
    │   │   WHERE id IN (tableIds)
    │   │
    │   └─→ UPDATE Bookings
    │       SET status = 'Confirmed'
    │       WHERE id = bookingId
    │
    └─→ Redirect → admin/bookings (với success message)
```

**Database Changes:**

```sql
-- Booking được tạo
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, 
                      num_people, status, deposit_amount, order_id)
VALUES (?, ?, ?, ?, ?, 'Pending', 100000, ?);

-- Bàn được gán
INSERT INTO BookingTables (booking_id, table_id)
VALUES (?, ?);

-- Status bàn được cập nhật
UPDATE RestaurantTables
SET status = 'Reserved'
WHERE id IN (?);

-- Status booking được cập nhật
UPDATE Bookings
SET status = 'Confirmed'
WHERE id = ?;
```

---

## 💳 Luồng thanh toán

### Thanh toán đơn hàng

```
User có giỏ hàng → Truy cập /payment
    │
    ▼
PaymentServlet.doGet()
    │
    ├─→ Kiểm tra đăng nhập:
    │   └─→ Account account = session.getAttribute("account")
    │   └─→ Nếu null → Redirect login
    │
    ├─→ Kiểm tra cart:
    │   └─→ Nếu empty → Redirect menu
    │
    ├─→ Tính tổng tiền:
    │   ├─→ subtotal = Σ(item.price * item.quantity)
    │   ├─→ discountAmount (từ appliedPromo)
    │   └─→ totalAmount = subtotal - discountAmount
    │
    └─→ Forward → payment.jsp
    │
    ▼
User chọn phương thức thanh toán:
    - COD (Cash on Delivery)
    - VNPay
    │
    │ Click "Thanh toán"
    │
    ▼
PaymentServlet.doPost()
    │
    ├─→ Validate cart và account
    │
    ├─→ Tính tổng tiền (giống doGet)
    │
    ├─→ Tạo Order object:
    │   - account
    │   - promotion (nếu có)
    │   - subtotal
    │   - discountAmount
    │   - totalAmount
    │   - paymentMethod
    │   - paymentStatus = "Unpaid"
    │   - orderStatus = "Pending"
    │   - note
    │
    ├─→ OrderDAO.createOrder(order, cart)
    │   │
    │   ├─→ BEGIN TRANSACTION
    │   │
    │   ├─→ INSERT INTO Orders (...)
    │   │   └─→ Return orderId
    │   │
    │   ├─→ INSERT INTO OrderDetails (order_id, product_id, quantity, price)
    │   │   VALUES (?, ?, ?, ?) cho mỗi item
    │   │
    │   └─→ COMMIT TRANSACTION
    │
    ├─→ Nếu paymentMethod = "VNPay":
    │   │
    │   ├─→ VNPayUtil.createPaymentUrl()
    │   │   └─→ Tạo URL thanh toán
    │   │
    │   └─→ Redirect → VNPay
    │   │
    │   └─→ (Sau khi thanh toán → VNPayReturnServlet)
    │
    └─→ Nếu paymentMethod = "COD":
        │
        ├─→ Xóa cart và promo từ Session
        │
        ├─→ Set flashSuccess message
        │
        └─→ Redirect → order-history
```

### VNPay Callback

```
VNPay redirect về /vnpay-return
    │
    ▼
VNPayReturnServlet.doGet()
    │
    ├─→ Lấy parameters từ VNPay
    │
    ├─→ VNPayUtil.verifyPayment()
    │   └─→ Verify hash
    │
    ├─→ Nếu thanh toán thành công:
    │   │
    │   ├─→ Lấy orderId từ vnp_TxnRef
    │   │
    │   ├─→ OrderDAO.updatePaymentStatus(orderId, "Paid")
    │   │   └─→ UPDATE Orders
    │   │       SET payment_status = 'Paid',
    │   │           payment_date = GETDATE()
    │   │       WHERE id = ?
    │   │
    │   └─→ Set flashSuccess message
    │
    └─→ Redirect → payment-success
    │
    ▼
PaymentSuccessServlet.doGet()
    │
    └─→ Forward → admin/payment-success.jsp
```

---

## 👨‍💼 Luồng quản lý (Admin/Staff)

### 1. Dashboard

```
Admin/Staff đăng nhập → /admin/dashboard
    │
    ▼
AdminDashboardServlet.doGet()
    │
    ├─→ Kiểm tra quyền DASHBOARD
    │   └─→ PermissionHelper.hasPermission(session, "DASHBOARD")
    │
    ├─→ OrderDAO.getStatistics()
    │   ├─→ Tổng doanh thu hôm nay
    │   ├─→ Tổng doanh thu tháng này
    │   ├─→ Số đơn hàng hôm nay
    │   └─→ Số đơn hàng tháng này
    │
    ├─→ BookingDAO.getStatistics()
    │   ├─→ Số đặt bàn hôm nay
    │   └─→ Số đặt bàn tháng này
    │
    ├─→ ProductDAO.getTopProducts()
    │   └─→ Top 5 sản phẩm bán chạy
    │
    └─→ Forward → admin/dashboard.jsp
```

### 2. Quản lý đơn hàng

```
Admin truy cập /admin/orders
    │
    ▼
AdminOrdersServlet.doGet()
    │
    ├─→ Kiểm tra quyền ORDERS
    │
    ├─→ Lấy filter parameters:
    │   - status
    │   - paymentStatus
    │   - dateFrom
    │   - dateTo
    │
    ├─→ OrderDAO.getAll(filterParams)
    │   └─→ SELECT o.*, a.full_name, a.phone
    │       FROM Orders o
    │       LEFT JOIN Accounts a ON o.account_id = a.id
    │       WHERE ... (filter conditions)
    │       ORDER BY o.created_at DESC
    │
    └─→ Forward → admin/orders.jsp
    │
    ▼
Admin click "Xem chi tiết"
    │
    ▼
OrderDetailsServlet.doGet()
    │
    ├─→ OrderDAO.getById(orderId)
    │
    ├─→ OrderDAO.getOrderDetails(orderId)
    │   └─→ SELECT od.*, p.name, p.image
    │       FROM OrderDetails od
    │       JOIN Products p ON od.product_id = p.id
    │       WHERE od.order_id = ?
    │
    └─→ Forward → admin/order-detail-view.jsp
```

### 3. Quản lý sản phẩm

```
Admin truy cập /admin/products
    │
    ▼
AdminProductsServlet.doGet()
    │
    ├─→ Kiểm tra quyền PRODUCTS
    │
    ├─→ ProductDAO.getAll()
    │   └─→ SELECT p.*, c.name as category_name
    │       FROM Products p
    │       LEFT JOIN Categories c ON p.category_id = c.id
    │
    ├─→ CategoryDAO.getAll()
    │   └─→ SELECT * FROM Categories
    │
    └─→ Forward → admin/products.jsp
    │
    ▼
Admin click "Thêm mới" hoặc "Sửa"
    │
    ▼
AdminProductsServlet.doPost()
    │
    ├─→ Validate input
    │
    ├─→ Nếu action = "create":
    │   └─→ ProductDAO.create(product)
    │       └─→ INSERT INTO Products (...)
    │
    ├─→ Nếu action = "update":
    │   └─→ ProductDAO.update(product)
    │       └─→ UPDATE Products SET ... WHERE id = ?
    │
    └─→ Nếu action = "delete":
        └─→ ProductDAO.delete(productId)
            └─→ UPDATE Products SET is_active = 0 WHERE id = ?
```

---

## 🔒 Luồng phân quyền

### Hệ thống phân quyền RBAC

```
┌─────────────────────────────────────┐
│   Database Structure                │
├─────────────────────────────────────┤
│ Roles (Vai trò)                     │
│ - id                                │
│ - name (Admin, Staff, User)         │
│ - description                       │
├─────────────────────────────────────┤
│ Permissions (Quyền)                │
│ - id                                │
│ - code (DASHBOARD, ORDERS, ...)     │
│ - name                              │
│ - description                       │
├─────────────────────────────────────┤
│ RolePermissions (Quyền của vai trò) │
│ - role_id                           │
│ - permission_id                     │
├─────────────────────────────────────┤
│ Accounts                            │
│ - id                                │
│ - role (0=User, 1=Admin, 2=Staff)   │
│ - role_id (FK to Roles)            │
└─────────────────────────────────────┘
```

### Luồng kiểm tra quyền

```
User truy cập trang admin
    │
    ▼
Admin Servlet (ví dụ: AdminOrdersServlet)
    │
    ├─→ Kiểm tra đăng nhập:
    │   └─→ Account account = session.getAttribute("account")
    │   └─→ Nếu null → Redirect login
    │
    ├─→ Kiểm tra quyền:
    │   └─→ PermissionHelper.hasPermission(session, "ORDERS")
    │       │
    │       ├─→ Lấy account từ session
    │       │
    │       ├─→ Nếu role = 1 (Admin):
    │       │   └─→ Return true (Admin có tất cả quyền)
    │       │
    │       ├─→ Lấy permissions từ session:
    │       │   └─→ List<String> permissions = 
    │       │       (List<String>) session.getAttribute("permissions")
    │       │
    │       └─→ Check permission code có trong list không
    │
    ├─→ Nếu không có quyền:
    │   └─→ Set error → Redirect → admin/dashboard
    │
    └─→ Nếu có quyền:
        └─→ Tiếp tục xử lý request
```

### Load permissions vào session

```
LoginServlet.doPost() (sau khi login thành công)
    │
    ▼
PermissionHelper.loadPermissionsToSession(session, accountId)
    │
    ├─→ Nếu role = 1 (Admin):
    │   └─→ Load tất cả permissions
    │       └─→ SELECT * FROM Permissions
    │
    ├─→ Nếu role khác:
    │   └─→ Load permissions theo role
    │       └─→ SELECT p.*
    │           FROM Permissions p
    │           JOIN RolePermissions rp ON p.id = rp.permission_id
    │           JOIN Roles r ON rp.role_id = r.id
    │           JOIN Accounts a ON a.role_id = r.id
    │           WHERE a.id = ?
    │
    ├─→ Convert to List<String> (chỉ lấy code)
    │
    └─→ session.setAttribute("permissions", permissionCodes)
```

---

## 📊 Sơ đồ tổng hợp

### User Journey - Đặt món

```
Home → Menu → Add to Cart → Cart → Apply Promo → Payment → VNPay → Payment Success → Order History
```

### User Journey - Đặt bàn

```
Home → Reservation → Fill Form → VNPay Deposit → Booking Created (Pending) 
→ Admin Assign Table → Booking Confirmed → Customer Arrives
```

### Admin Journey - Quản lý

```
Login → Dashboard → Orders/Bookings/Products → View Details → Update Status → Save
```

---

## 🔍 Chi tiết kỹ thuật

### Session Management

- **Session Timeout**: 30 phút (cấu hình trong web.xml)
- **Session Attributes**:
  - `account`: Account object (sau khi login)
  - `cart`: List<CartItem> (giỏ hàng)
  - `permissions`: List<String> (quyền của user)
  - `appliedPromo`: Promotion object (mã khuyến mãi đã áp dụng)
  - `discountAmount`: Double (số tiền giảm giá)
  - `tempBooking`: Booking object (tạm thời khi đặt bàn)
  - `bookingOrderId`: String (orderId cho VNPay)

### Database Transactions

- **Order Creation**: Sử dụng transaction để đảm bảo tính toàn vẹn
- **Booking Assignment**: Transaction khi gán bàn (cập nhật nhiều bảng)

### Error Handling

- **404 Error**: Redirect đến error404.jsp
- **500 Error**: Redirect đến error500.jsp
- **Validation Errors**: Hiển thị message trên form
- **Database Errors**: Log và hiển thị message thân thiện

---

**Tài liệu này được tạo bởi Ta Ngoc Tai - HAH Restaurant Team**

