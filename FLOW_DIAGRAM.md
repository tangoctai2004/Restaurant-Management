# 🔄 LUỒNG HOẠT ĐỘNG HỆ THỐNG HAH RESTAURANT

## 📋 MỤC LỤC
1. [Luồng tổng quan](#luồng-tổng-quan)
2. [Luồng đăng nhập/đăng ký](#luồng-đăng-nhậpđăng-ký)
3. [Luồng xem thực đơn và đặt món](#luồng-xem-thực-đơn-và-đặt-món)
4. [Luồng đặt bàn](#luồng-đặt-bàn)
5. [Luồng thanh toán](#luồng-thanh-toán)
6. [Luồng xem lịch sử đơn hàng](#luồng-xem-lịch-sử-đơn-hàng)

---

## 🌐 LUỒNG TỔNG QUAN

```
User truy cập website
    ↓
index.html → Redirect → HomeServlet
    ↓
home.jsp (hiển thị trang chủ với danh mục và sản phẩm)
    ↓
User có thể:
    ├─→ Đăng nhập/Đăng ký
    ├─→ Xem thực đơn
    ├─→ Đặt bàn
    └─→ Xem giỏ hàng
```

---

## 🔐 LUỒNG ĐĂNG NHẬP/ĐĂNG KÝ

### **Đăng nhập:**
```
1. User click "Đăng nhập" → LoginServlet (GET)
   ↓
2. Hiển thị login.jsp
   ↓
3. User nhập username/password → Submit form
   ↓
4. LoginServlet (POST)
   ├─→ Validate input
   ├─→ AccountDAO.login(username, password)
   │   └─→ Query: SELECT * FROM Accounts WHERE username=? AND password=?
   │
   ├─→ Nếu thành công:
   │   ├─→ Lưu Account vào Session
   │   ├─→ Role = Admin/Staff → Redirect → admin/dashboard.jsp
   │   └─→ Role = User → Redirect → home
   │
   └─→ Nếu thất bại:
       └─→ Hiển thị error → login.jsp
```

### **Đăng ký:**
```
1. User click "Đăng ký" → RegisterServlet (GET)
   ↓
2. Hiển thị register.jsp
   ↓
3. User điền form → Submit
   ↓
4. RegisterServlet (POST)
   ├─→ Validate input (username, password, fullName)
   ├─→ Kiểm tra password == repassword
   ├─→ AccountDAO.checkUsernameExists(username)
   │   └─→ Query: SELECT COUNT(*) FROM Accounts WHERE username=?
   │
   ├─→ Nếu username đã tồn tại:
   │   └─→ Hiển thị error → register.jsp
   │
   └─→ Nếu hợp lệ:
       ├─→ Tạo Account object
       ├─→ AccountDAO.register(account)
       │   └─→ INSERT INTO Accounts (username, password, full_name, ...)
       ├─→ Hiển thị success message
       └─→ Redirect → login.jsp
```

---

## 🍽️ LUỒNG XEM THỰC ĐƠN VÀ ĐẶT MÓN

### **Xem trang chủ:**
```
1. User truy cập /home → HomeServlet (GET)
   ↓
2. HomeServlet:
   ├─→ CategoryDAO.getAll()
   │   └─→ Query: SELECT c.*, COUNT(p.id) FROM Categories c LEFT JOIN Products p...
   ├─→ ProductDAO.getAll()
   │   └─→ Query: SELECT p.*, c.name FROM Products p LEFT JOIN Categories c...
   │
   └─→ Set attributes: categoryList, productList
   ↓
3. Forward → home.jsp
   └─→ Hiển thị danh mục và sản phẩm
```

### **Xem thực đơn:**
```
1. User click "Thực đơn" → MenuServlet (GET)
   ↓
2. MenuServlet:
   ├─→ CategoryDAO.getAll() → categories
   ├─→ ProductDAO.getAll() → allProducts
   ├─→ Kiểm tra Session cart
   │   └─→ hasActiveOrder = (cart != null && !cart.isEmpty())
   │
   └─→ Set attributes: categories, allProducts, hasActiveOrder
   ↓
3. Forward → menu.jsp
   └─→ Hiển thị sidebar danh mục và grid sản phẩm
```

### **Thêm món vào giỏ hàng:**
```
1. User click "Đặt món" trên sản phẩm
   ↓
2. Link: orderitem?action=add&productId=123
   ↓
3. OrderItemServlet (GET)
   ├─→ Lấy cart từ Session (nếu chưa có → tạo mới)
   ├─→ ProductDAO.getById(productId)
   │   └─→ Query: SELECT * FROM Products WHERE id=?
   │
   ├─→ Kiểm tra sản phẩm đã có trong cart chưa:
   │   ├─→ Nếu có: tăng quantity + 1
   │   └─→ Nếu chưa: thêm CartItem mới (quantity=1)
   │
   ├─→ Lưu cart vào Session
   ├─→ Set flashSuccess message
   └─→ Redirect → menu
```

### **Xem giỏ hàng:**
```
1. User click "Giỏ hàng" → CartServlet (GET)
   ↓
2. CartServlet:
   ├─→ Lấy cart từ Session
   ├─→ Tính subtotal = tổng (price * quantity) của tất cả items
   │
   ├─→ Xử lý mã khuyến mãi (nếu có action=applyPromo):
   │   ├─→ PromotionDAO.getByCode(code)
   │   │   └─→ Query: SELECT * FROM Promotions WHERE code=? AND is_active=1...
   │   ├─→ PromotionDAO.calculateDiscount(promo, subtotal)
   │   │   ├─→ Nếu Percent: discount = subtotal * value / 100
   │   │   └─→ Nếu FixedAmount: discount = value
   │   └─→ Lưu promo và discountAmount vào Session
   │
   ├─→ totalAmount = subtotal - discountAmount
   └─→ Set attributes: cartItems, subtotal, discountAmount, totalAmount
   ↓
3. Forward → cart.jsp
   └─→ Hiển thị danh sách món, tổng tiền, form áp dụng mã KM
```

### **Cập nhật số lượng trong giỏ hàng:**
```
1. User click +/- trong cart
   ↓
2. Link: orderitem?action=update&productId=123&quantity=2
   ↓
3. OrderItemServlet (GET)
   ├─→ Lấy cart từ Session
   ├─→ Tìm CartItem có productId tương ứng
   ├─→ Cập nhật quantity
   └─→ Redirect → cart
```

### **Xóa món khỏi giỏ hàng:**
```
1. User click "Xóa" trong cart
   ↓
2. Link: orderitem?action=remove&productId=123
   ↓
3. OrderItemServlet (GET)
   ├─→ Lấy cart từ Session
   ├─→ Remove CartItem có productId tương ứng
   └─→ Redirect → cart
```

---

## 📅 LUỒNG ĐẶT BÀN

```
1. User click "Đặt bàn" → ReservationServlet (GET)
   ↓
2. ReservationServlet:
   ├─→ RestaurantTableDAO.getAll()
   │   └─→ Query: SELECT * FROM RestaurantTables ORDER BY name
   └─→ Set attribute: availableTables
   ↓
3. Forward → reservation.jsp
   └─→ Hiển thị form đặt bàn với dropdown chọn bàn
   ↓
4. User điền form → Submit
   ↓
5. ReservationServlet (POST)
   ├─→ Validate input (customerName, phone, bookingDate, bookingTime, numPeople)
   ├─→ Tạo Booking object
   ├─→ BookingDAO.createBooking(booking, tableIds)
   │   ├─→ BEGIN TRANSACTION
   │   ├─→ INSERT INTO Bookings (customer_name, phone, booking_date, ...)
   │   ├─→ Lấy booking_id vừa tạo
   │   ├─→ INSERT INTO BookingTables (booking_id, table_id) cho mỗi bàn
   │   ├─→ UPDATE RestaurantTables SET status='Reserved' WHERE id IN (...)
   │   └─→ COMMIT
   │
   ├─→ Nếu thành công:
   │   └─→ Set successMessage → Forward → reservation.jsp
   │
   └─→ Nếu thất bại:
       └─→ Set error → Forward → reservation.jsp
```

---

## 💳 LUỒNG THANH TOÁN

```
1. User click "Thanh toán" trong cart → PaymentServlet (GET)
   ↓
2. PaymentServlet:
   ├─→ Kiểm tra đã đăng nhập chưa (nếu chưa → redirect login)
   ├─→ Kiểm tra cart có items không (nếu rỗng → redirect menu)
   ├─→ Tính subtotal từ cart
   ├─→ Lấy appliedPromo từ Session
   ├─→ Tính discountAmount = PromotionDAO.calculateDiscount(promo, subtotal)
   ├─→ totalAmount = subtotal - discountAmount
   └─→ Set attributes: cartItems, subtotal, discountAmount, totalAmount
   ↓
3. Forward → payment.jsp
   └─→ Hiển thị form thanh toán và tóm tắt đơn hàng
   ↓
4. User điền form → Submit
   ↓
5. PaymentServlet (POST)
   ├─→ Lấy thông tin từ form (paymentMethod, note)
   ├─→ Tính lại subtotal, discountAmount, totalAmount
   ├─→ Tạo Order object
   ├─→ OrderDAO.createOrder(order, cartItems)
   │   ├─→ BEGIN TRANSACTION
   │   ├─→ INSERT INTO Orders (account_id, subtotal, discount_amount, ...)
   │   ├─→ Lấy order_id vừa tạo
   │   ├─→ INSERT INTO OrderDetails (order_id, product_id, quantity, price) cho mỗi item
   │   └─→ COMMIT
   │
   ├─→ Nếu thành công:
   │   ├─→ Xóa cart, appliedPromo, discountAmount khỏi Session
   │   ├─→ Set flashSuccess với orderId
   │   └─→ Redirect → order-history
   │
   └─→ Nếu thất bại:
       └─→ Set error → Forward → payment.jsp
```

---

## 📜 LUỒNG XEM LỊCH SỬ ĐƠN HÀNG

```
1. User click "Lịch sử đơn hàng" → OrderHistoryServlet (GET)
   ↓
2. OrderHistoryServlet:
   ├─→ Kiểm tra đã đăng nhập chưa (nếu chưa → redirect login)
   ├─→ Lấy Account từ Session
   ├─→ OrderDAO.getByAccountId(accountId)
   │   ├─→ Query: SELECT o.*, a.full_name FROM Orders o LEFT JOIN Accounts a...
   │   ├─→ Với mỗi Order:
   │   │   └─→ OrderDAO.getOrderDetails(orderId)
   │   │       └─→ Query: SELECT od.*, p.name, p.image_url FROM OrderDetails od...
   │   └─→ Trả về List<Order> với orderDetails đầy đủ
   │
   └─→ Set attribute: orders
   ↓
3. Forward → order-history.jsp
   └─→ Hiển thị danh sách đơn hàng với chi tiết từng món
```

---

## 🔄 LUỒNG ĐĂNG XUẤT

```
1. User click "Đăng xuất" → LogoutServlet (GET)
   ↓
2. LogoutServlet:
   ├─→ Lấy Session
   ├─→ session.invalidate() (xóa toàn bộ session)
   └─→ Redirect → home
```

---

## 📊 SƠ ĐỒ TƯƠNG TÁC GIỮA CÁC LỚP

```
┌─────────────┐
│   JSP Page  │
└──────┬──────┘
       │ Request
       ↓
┌─────────────┐
│   Servlet   │ ←─── CharacterEncodingFilter (UTF-8)
└──────┬──────┘
       │
       ↓
┌─────────────┐
│    DAO      │
└──────┬──────┘
       │
       ↓
┌─────────────┐
│  Database   │
│ (SQL Server)│
└─────────────┘
```

---

## 🔑 CÁC THÀNH PHẦN CHÍNH

### **Session Attributes:**
- `account` - Account object (sau khi đăng nhập)
- `cart` - List<CartItem> (giỏ hàng)
- `appliedPromo` - Promotion object (mã khuyến mãi đã áp dụng)
- `discountAmount` - Double (số tiền giảm)
- `flashSuccess` - String (thông báo thành công)
- `flashError` - String (thông báo lỗi)

### **Request Attributes:**
- `categoryList`, `categories` - List<Category>
- `productList`, `allProducts` - List<Product>
- `cartItems` - List<CartItem>
- `orders` - List<Order>
- `availableTables` - List<RestaurantTable>
- `subtotal`, `discountAmount`, `totalAmount` - Double
- `error`, `successMessage` - String

---

## ⚠️ LƯU Ý QUAN TRỌNG

1. **Encoding:** Tất cả request/response đều được filter qua `CharacterEncodingFilter` để đảm bảo UTF-8
2. **Session Management:** Giỏ hàng và thông tin user được lưu trong Session
3. **Transaction:** Các thao tác tạo Order và Booking sử dụng transaction để đảm bảo tính toàn vẹn dữ liệu
4. **Validation:** Tất cả input đều được validate ở Servlet trước khi xử lý
5. **Security:** Password hiện tại lưu plain text (nên hash trong production)

---

## 🚀 CÁCH CHẠY VÀ TEST

1. **Khởi động server** (Tomcat/Jetty)
2. **Truy cập:** `http://localhost:8080/HAH-Restaurant/`
3. **Test các luồng:**
   - Đăng ký tài khoản mới
   - Đăng nhập
   - Xem thực đơn
   - Thêm món vào giỏ hàng
   - Áp dụng mã khuyến mãi
   - Đặt bàn
   - Thanh toán
   - Xem lịch sử đơn hàng



