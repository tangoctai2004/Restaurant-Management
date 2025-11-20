--=================================================================
-- FILE 4: INSERT DASHBOARD DATA - DỮ LIỆU MẪU CHO DASHBOARD
-- CSDL: SQL Server
-- MÔ TẢ: Script này chèn dữ liệu mẫu cho dashboard (Orders, Bookings, Accounts)
--         để có dữ liệu hiển thị thống kê, biểu đồ, và danh sách gần đây
-- SỬ DỤNG: Chạy file này SAU KHI đã chạy CreateTable.sql, InsertData.sql, và DataBonus.sql
--=================================================================

USE QLNhaHang;
GO

PRINT N'';
PRINT N'📊 ==========================================';
PRINT N'📊 BẮT ĐẦU CHÈN DỮ LIỆU CHO DASHBOARD';
PRINT N'📊 ==========================================';
PRINT N'';

-- ---
-- 1. THÊM KHÁCH HÀNG (ACCOUNTS)
-- ---
PRINT N'1️⃣ Đang thêm khách hàng...';
DECLARE @CustomerRoleId INT = (SELECT id FROM Roles WHERE name = N'Khách hàng');

INSERT INTO Accounts (username, [password], full_name, email, phone, [role], role_id, is_active)
VALUES
('nguyenvana', '123', N'Nguyễn Văn A', 'nguyenvana@gmail.com', '0912345678', 0, @CustomerRoleId, 1),
('tranthib', '123', N'Trần Thị B', 'tranthib@gmail.com', '0923456789', 0, @CustomerRoleId, 1),
('lethic', '123', N'Lê Thị C', 'lethic@gmail.com', '0934567890', 0, @CustomerRoleId, 1),
('phamvand', '123', N'Phạm Văn D', 'phamvand@gmail.com', '0945678901', 0, @CustomerRoleId, 1),
('hoangthie', '123', N'Hoàng Thị E', 'hoangthie@gmail.com', '0956789012', 0, @CustomerRoleId, 1),
('vuongvanf', '123', N'Vương Văn F', 'vuongvanf@gmail.com', '0967890123', 0, @CustomerRoleId, 1),
('dangthig', '123', N'Đặng Thị G', 'dangthig@gmail.com', '0978901234', 0, @CustomerRoleId, 1),
('buitvih', '123', N'Bùi Thị H', 'buitvih@gmail.com', '0989012345', 0, @CustomerRoleId, 1),
('ngothii', '123', N'Ngô Thị I', 'ngothii@gmail.com', '0990123456', 0, @CustomerRoleId, 1),
('duongvanj', '123', N'Dương Văn J', 'duongvanj@gmail.com', '0901234567', 0, @CustomerRoleId, 1);
PRINT N'   ✅ Đã thêm 10 khách hàng';
GO

-- ---
-- 2. THÊM ĐẶT BÀN (BOOKINGS) - Phân bố trong các tháng năm 2025
-- ---
PRINT N'2️⃣ Đang thêm đặt bàn...';

-- Lấy ID khách hàng và bàn
DECLARE @AccNguyenVanA INT, @AccTranThiB INT, @AccLeThiC INT, @AccPhamVanD INT, @AccHoangThiE INT;
DECLARE @Table101 INT, @Table102 INT, @Table103 INT, @Table104 INT, @Table201 INT, @Table202 INT, @VIP1 INT;

SELECT @AccNguyenVanA = id FROM Accounts WHERE username = 'nguyenvana';
SELECT @AccTranThiB = id FROM Accounts WHERE username = 'tranthib';
SELECT @AccLeThiC = id FROM Accounts WHERE username = 'lethic';
SELECT @AccPhamVanD = id FROM Accounts WHERE username = 'phamvand';
SELECT @AccHoangThiE = id FROM Accounts WHERE username = 'hoangthie';

SELECT @Table101 = id FROM RestaurantTables WHERE [name] = N'Bàn 101';
SELECT @Table102 = id FROM RestaurantTables WHERE [name] = N'Bàn 102';
SELECT @Table103 = id FROM RestaurantTables WHERE [name] = N'Bàn 103';
SELECT @Table104 = id FROM RestaurantTables WHERE [name] = N'Bàn 104';
SELECT @Table201 = id FROM RestaurantTables WHERE [name] = N'Bàn 201';
SELECT @Table202 = id FROM RestaurantTables WHERE [name] = N'Bàn 202';
SELECT @VIP1 = id FROM RestaurantTables WHERE [name] = N'Phòng VIP 1';

-- Đặt bàn tháng 1/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Nguyễn Văn A', '0912345678', '2025-01-15', '18:00', 4, N'Kỷ niệm sinh nhật', 'Confirmed', @AccNguyenVanA, 'Paid', '2025-01-10 10:00:00'),
(N'Trần Thị B', '0923456789', '2025-01-20', '19:30', 6, N'Tiệc gia đình', 'Confirmed', @AccTranThiB, 'Paid', '2025-01-12 14:00:00'),
(N'Lê Văn X', '0934567890', '2025-01-25', '12:00', 2, NULL, 'Completed', NULL, 'Paid', '2025-01-18 09:00:00');

-- Đặt bàn tháng 2/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Phạm Văn D', '0945678901', '2025-02-10', '19:00', 8, N'Tiệc công ty', 'Confirmed', @AccPhamVanD, 'Paid', '2025-02-05 11:00:00'),
(N'Hoàng Thị E', '0956789012', '2025-02-14', '20:00', 2, N'Lễ tình nhân', 'Completed', @AccHoangThiE, 'Paid', '2025-02-10 15:00:00'),
(N'Nguyễn Thị Y', '0967890123', '2025-02-28', '18:30', 4, NULL, 'Confirmed', NULL, 'Paid', '2025-02-20 10:00:00');

-- Đặt bàn tháng 3/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Vương Văn F', '0967890123', '2025-03-08', '19:00', 10, N'Tiệc sinh nhật', 'Completed', NULL, 'Paid', '2025-03-01 09:00:00'),
(N'Đặng Thị G', '0978901234', '2025-03-15', '12:30', 4, NULL, 'Confirmed', NULL, 'Paid', '2025-03-10 14:00:00'),
(N'Bùi Thị H', '0989012345', '2025-03-22', '20:00', 6, N'Tiệc bạn bè', 'Confirmed', NULL, 'Paid', '2025-03-15 11:00:00');

-- Đặt bàn tháng 4/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Ngô Thị I', '0990123456', '2025-04-05', '18:00', 4, NULL, 'Completed', NULL, 'Paid', '2025-04-01 10:00:00'),
(N'Dương Văn J', '0901234567', '2025-04-12', '19:30', 8, N'Tiệc gia đình', 'Confirmed', NULL, 'Paid', '2025-04-05 15:00:00'),
(N'Trần Văn K', '0912345679', '2025-04-20', '20:00', 2, NULL, 'Completed', NULL, 'Paid', '2025-04-15 09:00:00');

-- Đặt bàn tháng 5/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Lê Thị L', '0923456780', '2025-05-01', '19:00', 6, N'Ngày lễ', 'Completed', NULL, 'Paid', '2025-04-25 14:00:00'),
(N'Phạm Văn M', '0934567891', '2025-05-10', '18:30', 4, NULL, 'Confirmed', NULL, 'Paid', '2025-05-05 11:00:00'),
(N'Hoàng Thị N', '0945678902', '2025-05-15', '20:00', 10, N'Tiệc sinh nhật', 'Completed', NULL, 'Paid', '2025-05-08 10:00:00');

-- Đặt bàn tháng 6/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Vương Văn O', '0956789013', '2025-06-05', '19:00', 4, NULL, 'Confirmed', NULL, 'Paid', '2025-06-01 09:00:00'),
(N'Đặng Thị P', '0967890124', '2025-06-12', '18:00', 8, N'Tiệc công ty', 'Completed', NULL, 'Paid', '2025-06-05 15:00:00'),
(N'Bùi Văn Q', '0978901235', '2025-06-20', '19:30', 6, NULL, 'Confirmed', NULL, 'Paid', '2025-06-10 11:00:00');

-- Đặt bàn tháng 7/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Ngô Thị R', '0989012346', '2025-07-08', '20:00', 4, NULL, 'Completed', NULL, 'Paid', '2025-07-01 10:00:00'),
(N'Dương Văn S', '0990123457', '2025-07-15', '19:00', 2, N'Lễ kỷ niệm', 'Confirmed', NULL, 'Paid', '2025-07-08 14:00:00'),
(N'Trần Thị T', '0901234568', '2025-07-25', '18:30', 6, NULL, 'Completed', NULL, 'Paid', '2025-07-15 09:00:00');

-- Đặt bàn tháng 8/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Lê Văn U', '0912345670', '2025-08-05', '19:00', 8, N'Tiệc gia đình', 'Confirmed', NULL, 'Paid', '2025-08-01 11:00:00'),
(N'Phạm Thị V', '0923456781', '2025-08-12', '20:00', 4, NULL, 'Completed', NULL, 'Paid', '2025-08-05 15:00:00'),
(N'Hoàng Văn W', '0934567892', '2025-08-20', '19:30', 10, N'Tiệc sinh nhật', 'Confirmed', NULL, 'Paid', '2025-08-10 10:00:00');

-- Đặt bàn tháng 9/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Vương Thị X', '0945678903', '2025-09-05', '18:00', 4, NULL, 'Completed', NULL, 'Paid', '2025-09-01 09:00:00'),
(N'Đặng Văn Y', '0956789014', '2025-09-15', '19:00', 6, N'Tiệc bạn bè', 'Confirmed', NULL, 'Paid', '2025-09-08 14:00:00'),
(N'Bùi Thị Z', '0967890125', '2025-09-25', '20:00', 2, NULL, 'Completed', NULL, 'Paid', '2025-09-15 11:00:00');

-- Đặt bàn tháng 10/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Ngô Văn AA', '0978901236', '2025-10-10', '19:30', 8, N'Tiệc công ty', 'Confirmed', NULL, 'Paid', '2025-10-05 10:00:00'),
(N'Dương Thị BB', '0989012347', '2025-10-18', '18:00', 4, NULL, 'Completed', NULL, 'Paid', '2025-10-10 15:00:00'),
(N'Trần Văn CC', '0990123458', '2025-10-28', '20:00', 6, N'Tiệc gia đình', 'Confirmed', NULL, 'Paid', '2025-10-20 09:00:00');

-- Đặt bàn tháng 11/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Lê Thị DD', '0901234569', '2025-11-05', '19:00', 4, NULL, 'Completed', NULL, 'Paid', '2025-11-01 11:00:00'),
(N'Phạm Văn EE', '0912345671', '2025-11-15', '18:30', 10, N'Tiệc sinh nhật', 'Confirmed', NULL, 'Paid', '2025-11-08 14:00:00'),
(N'Hoàng Thị FF', '0923456782', '2025-11-22', '20:00', 2, NULL, 'Completed', NULL, 'Paid', '2025-11-15 10:00:00');

-- Đặt bàn tháng 12/2025
INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, [status], account_id, payment_status, created_at)
VALUES
(N'Vương Văn GG', '0934567893', '2025-12-10', '19:00', 6, N'Tiệc cuối năm', 'Confirmed', NULL, 'Paid', '2025-12-05 09:00:00'),
(N'Đặng Thị HH', '0945678904', '2025-12-20', '20:00', 8, N'Tiệc Giáng Sinh', 'Completed', NULL, 'Paid', '2025-12-15 15:00:00'),
(N'Bùi Văn II', '0956789015', '2025-12-31', '19:30', 12, N'Tiệc đón năm mới', 'Confirmed', NULL, 'Paid', '2025-12-25 11:00:00');

PRINT N'   ✅ Đã thêm 30 đặt bàn (phân bố trong 12 tháng)';
GO

-- ---
-- 3. THÊM ĐƠN HÀNG (ORDERS) VÀ CHI TIẾT (ORDER DETAILS) - Phân bố trong các tháng
-- ---
PRINT N'3️⃣ Đang thêm đơn hàng và chi tiết...';

-- Lấy ID sản phẩm
DECLARE @ProdPhoBoTai INT, @ProdBunCha INT, @ProdComTamSuon INT, @ProdGoiCuon INT, @ProdBanhMiThit INT;
DECLARE @ProdChaGio INT, @ProdCheDauXanh INT, @ProdCaPheSua INT, @ProdLauThai INT;
DECLARE @ProdPhoGa INT, @ProdBunBoHue INT, @ProdComGaNuong INT, @ProdBanhMiPate INT;
DECLARE @ProdChaCa INT, @ProdCheThai INT, @ProdNuocDua INT, @ProdLauCuaDong INT;

SELECT @ProdPhoBoTai = id FROM Products WHERE [name] = N'Phở bò tái';
SELECT @ProdBunCha = id FROM Products WHERE [name] = N'Bún chả Hà Nội';
SELECT @ProdComTamSuon = id FROM Products WHERE [name] = N'Cơm tấm sườn nướng';
SELECT @ProdGoiCuon = id FROM Products WHERE [name] = N'Gỏi cuốn tôm thịt';
SELECT @ProdBanhMiThit = id FROM Products WHERE [name] = N'Bánh mì thịt nướng';
SELECT @ProdChaGio = id FROM Products WHERE [name] = N'Chả giò truyền thống';
SELECT @ProdCheDauXanh = id FROM Products WHERE [name] = N'Chè đậu xanh';
SELECT @ProdCaPheSua = id FROM Products WHERE [name] = N'Cà phê sữa đá';
SELECT @ProdLauThai = id FROM Products WHERE [name] = N'Lẩu Thái';
SELECT @ProdPhoGa = id FROM Products WHERE [name] = N'Phở gà';
SELECT @ProdBunBoHue = id FROM Products WHERE [name] = N'Bún bò Huế';
SELECT @ProdComGaNuong = id FROM Products WHERE [name] = N'Cơm gà nướng';
SELECT @ProdBanhMiPate = id FROM Products WHERE [name] = N'Bánh mì pate chả lụa';
SELECT @ProdChaCa = id FROM Products WHERE [name] = N'Chả cá Lã Vọng';
SELECT @ProdCheThai = id FROM Products WHERE [name] = N'Chè thái';
SELECT @ProdNuocDua = id FROM Products WHERE [name] = N'Nước dừa tươi';
SELECT @ProdLauCuaDong = id FROM Products WHERE [name] = N'Lẩu cua đồng';

-- Lấy ID khách hàng và nhân viên
DECLARE @StaffId INT;
SELECT @StaffId = id FROM Accounts WHERE username = 'nhanvien1';

-- Lấy ID promotion
DECLARE @PromoGIAM10 INT;
SELECT @PromoGIAM10 = id FROM Promotions WHERE [code] = 'GIAM10';

-- Lấy ID bookings (sẽ dùng một số booking đã tạo)
DECLARE @Booking1 INT, @Booking2 INT, @Booking3 INT, @Booking4 INT, @Booking5 INT;
SELECT TOP 1 @Booking1 = id FROM Bookings ORDER BY id;
SELECT TOP 1 @Booking2 = id FROM Bookings ORDER BY id OFFSET 1 ROWS;
SELECT TOP 1 @Booking3 = id FROM Bookings ORDER BY id OFFSET 2 ROWS;
SELECT TOP 1 @Booking4 = id FROM Bookings ORDER BY id OFFSET 3 ROWS;
SELECT TOP 1 @Booking5 = id FROM Bookings ORDER BY id OFFSET 4 ROWS;

-- ===== THÁNG 1/2025 =====
-- Đơn hàng 1 - Tháng 1
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (@AccNguyenVanA, @Booking1, NULL, 450000, 0, 450000, 'COD', 'Paid', 'Completed', @StaffId, '2025-01-15 18:30:00', '2025-01-15 18:00:00');
DECLARE @Order1 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order1, @ProdPhoBoTai, 2, 85000, 1),
(@Order1, @ProdBunCha, 2, 90000, 1),
(@Order1, @ProdCaPheSua, 2, 30000, 1);

-- Đơn hàng 2 - Tháng 1
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (@AccTranThiB, @Booking2, @PromoGIAM10, 1200000, 120000, 1080000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-01-20 20:00:00', '2025-01-20 19:30:00');
DECLARE @Order2 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order2, @ProdLauThai, 1, 350000, 1),
(@Order2, @ProdGoiCuon, 2, 120000, 1),
(@Order2, @ProdChaGio, 2, 120000, 1),
(@Order2, @ProdComTamSuon, 4, 95000, 1);

-- Đơn hàng 3 - Tháng 1 (khách vãng lai)
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 170000, 0, 170000, 'COD', 'Paid', 'Completed', @StaffId, '2025-01-25 12:30:00', '2025-01-25 12:00:00');
DECLARE @Order3 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order3, @ProdPhoGa, 2, 75000, 1),
(@Order3, @ProdBanhMiThit, 1, 45000, 1);

-- ===== THÁNG 2/2025 =====
-- Đơn hàng 4 - Tháng 2
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (@AccPhamVanD, NULL, NULL, 800000, 0, 800000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-02-10 19:30:00', '2025-02-10 19:00:00');
DECLARE @Order4 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order4, @ProdLauCuaDong, 1, 380000, 1),
(@Order4, @ProdComGaNuong, 4, 90000, 1),
(@Order4, @ProdCaPheSua, 4, 30000, 1);

-- Đơn hàng 5 - Tháng 2
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (@AccHoangThiE, NULL, NULL, 240000, 0, 240000, 'COD', 'Paid', 'Completed', @StaffId, '2025-02-14 20:30:00', '2025-02-14 20:00:00');
DECLARE @Order5 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order5, @ProdGoiCuon, 1, 120000, 1),
(@Order5, @ProdChaGio, 1, 120000, 1);

-- Đơn hàng 6 - Tháng 2 (khách vãng lai)
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 285000, 0, 285000, 'COD', 'Paid', 'Completed', @StaffId, '2025-02-28 19:00:00', '2025-02-28 18:30:00');
DECLARE @Order6 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order6, @ProdBunBoHue, 2, 95000, 1),
(@Order6, @ProdBanhMiPate, 2, 40000, 1),
(@Order6, @ProdCheDauXanh, 1, 35000, 1);

-- ===== THÁNG 3/2025 =====
-- Đơn hàng 7 - Tháng 3
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, @PromoGIAM10, 1000000, 100000, 900000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-03-08 19:30:00', '2025-03-08 19:00:00');
DECLARE @Order7 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order7, @ProdLauThai, 2, 350000, 1),
(@Order7, @ProdGoiCuon, 2, 120000, 1),
(@Order7, @ProdChaCa, 1, 180000, 1);

-- Đơn hàng 8 - Tháng 3
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 380000, 0, 380000, 'COD', 'Paid', 'Completed', @StaffId, '2025-03-15 13:00:00', '2025-03-15 12:30:00');
DECLARE @Order8 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order8, @ProdComTamSuon, 4, 95000, 1);

-- Đơn hàng 9 - Tháng 3
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 540000, 0, 540000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-03-22 20:30:00', '2025-03-22 20:00:00');
DECLARE @Order9 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order9, @ProdGoiCuon, 2, 120000, 1),
(@Order9, @ProdChaGio, 2, 120000, 1),
(@Order9, @ProdCheThai, 2, 45000, 1);

-- ===== THÁNG 4/2025 =====
-- Đơn hàng 10 - Tháng 4
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 425000, 0, 425000, 'COD', 'Paid', 'Completed', @StaffId, '2025-04-05 18:30:00', '2025-04-05 18:00:00');
DECLARE @Order10 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order10, @ProdPhoBoTai, 3, 85000, 1),
(@Order10, @ProdBanhMiThit, 2, 45000, 1),
(@Order10, @ProdCaPheSua, 2, 30000, 1);

-- Đơn hàng 11 - Tháng 4
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 760000, 0, 760000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-04-12 20:00:00', '2025-04-12 19:30:00');
DECLARE @Order11 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order11, @ProdLauCuaDong, 1, 380000, 1),
(@Order11, @ProdComGaNuong, 4, 90000, 1),
(@Order11, @ProdNuocDua, 4, 30000, 1);

-- Đơn hàng 12 - Tháng 4
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 190000, 0, 190000, 'COD', 'Paid', 'Completed', @StaffId, '2025-04-20 20:30:00', '2025-04-20 20:00:00');
DECLARE @Order12 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order12, @ProdBunCha, 2, 90000, 1),
(@Order12, @ProdBanhMiPate, 1, 40000, 1);

-- ===== THÁNG 5/2025 =====
-- Đơn hàng 13 - Tháng 5
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 570000, 0, 570000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-05-01 19:30:00', '2025-05-01 19:00:00');
DECLARE @Order13 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order13, @ProdGoiCuon, 3, 120000, 1),
(@Order13, @ProdChaGio, 2, 120000, 1),
(@Order13, @ProdCheThai, 2, 45000, 1);

-- Đơn hàng 14 - Tháng 5
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 380000, 0, 380000, 'COD', 'Paid', 'Completed', @StaffId, '2025-05-10 19:00:00', '2025-05-10 18:30:00');
DECLARE @Order14 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order14, @ProdComTamSuon, 4, 95000, 1);

-- Đơn hàng 15 - Tháng 5
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, @PromoGIAM10, 1100000, 110000, 990000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-05-15 20:30:00', '2025-05-15 20:00:00');
DECLARE @Order15 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order15, @ProdLauThai, 2, 350000, 1),
(@Order15, @ProdChaCa, 1, 180000, 1),
(@Order15, @ProdGoiCuon, 2, 120000, 1);

-- ===== THÁNG 6/2025 =====
-- Đơn hàng 16 - Tháng 6
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 340000, 0, 340000, 'COD', 'Paid', 'Completed', @StaffId, '2025-06-05 19:30:00', '2025-06-05 19:00:00');
DECLARE @Order16 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order16, @ProdPhoBoTai, 2, 85000, 1),
(@Order16, @ProdBunCha, 1, 90000, 1),
(@Order16, @ProdBanhMiThit, 2, 45000, 1);

-- Đơn hàng 17 - Tháng 6
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 760000, 0, 760000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-06-12 18:30:00', '2025-06-12 18:00:00');
DECLARE @Order17 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order17, @ProdLauCuaDong, 1, 380000, 1),
(@Order17, @ProdComGaNuong, 4, 90000, 1),
(@Order17, @ProdNuocDua, 4, 30000, 1);

-- Đơn hàng 18 - Tháng 6
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 570000, 0, 570000, 'COD', 'Paid', 'Completed', @StaffId, '2025-06-20 20:00:00', '2025-06-20 19:30:00');
DECLARE @Order18 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order18, @ProdGoiCuon, 3, 120000, 1),
(@Order18, @ProdChaGio, 2, 120000, 1),
(@Order18, @ProdCheThai, 2, 45000, 1);

-- ===== THÁNG 7/2025 =====
-- Đơn hàng 19 - Tháng 7
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 425000, 0, 425000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-07-08 20:30:00', '2025-07-08 20:00:00');
DECLARE @Order19 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order19, @ProdPhoBoTai, 3, 85000, 1),
(@Order19, @ProdBanhMiThit, 2, 45000, 1),
(@Order19, @ProdCaPheSua, 2, 30000, 1);

-- Đơn hàng 20 - Tháng 7
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 190000, 0, 190000, 'COD', 'Paid', 'Completed', @StaffId, '2025-07-15 19:30:00', '2025-07-15 19:00:00');
DECLARE @Order20 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order20, @ProdBunCha, 2, 90000, 1),
(@Order20, @ProdBanhMiPate, 1, 40000, 1);

-- Đơn hàng 21 - Tháng 7
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 570000, 0, 570000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-07-25 19:00:00', '2025-07-25 18:30:00');
DECLARE @Order21 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order21, @ProdGoiCuon, 3, 120000, 1),
(@Order21, @ProdChaGio, 2, 120000, 1),
(@Order21, @ProdCheThai, 2, 45000, 1);

-- ===== THÁNG 8/2025 =====
-- Đơn hàng 22 - Tháng 8
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 760000, 0, 760000, 'COD', 'Paid', 'Completed', @StaffId, '2025-08-05 19:30:00', '2025-08-05 19:00:00');
DECLARE @Order22 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order22, @ProdLauCuaDong, 1, 380000, 1),
(@Order22, @ProdComGaNuong, 4, 90000, 1),
(@Order22, @ProdNuocDua, 4, 30000, 1);

-- Đơn hàng 23 - Tháng 8
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 340000, 0, 340000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-08-12 20:30:00', '2025-08-12 20:00:00');
DECLARE @Order23 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order23, @ProdPhoBoTai, 2, 85000, 1),
(@Order23, @ProdBunCha, 1, 90000, 1),
(@Order23, @ProdBanhMiThit, 2, 45000, 1);

-- Đơn hàng 24 - Tháng 8
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, @PromoGIAM10, 1100000, 110000, 990000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-08-20 20:00:00', '2025-08-20 19:30:00');
DECLARE @Order24 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order24, @ProdLauThai, 2, 350000, 1),
(@Order24, @ProdChaCa, 1, 180000, 1),
(@Order24, @ProdGoiCuon, 2, 120000, 1);

-- ===== THÁNG 9/2025 =====
-- Đơn hàng 25 - Tháng 9
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 425000, 0, 425000, 'COD', 'Paid', 'Completed', @StaffId, '2025-09-05 18:30:00', '2025-09-05 18:00:00');
DECLARE @Order25 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order25, @ProdPhoBoTai, 3, 85000, 1),
(@Order25, @ProdBanhMiThit, 2, 45000, 1),
(@Order25, @ProdCaPheSua, 2, 30000, 1);

-- Đơn hàng 26 - Tháng 9
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 570000, 0, 570000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-09-15 19:30:00', '2025-09-15 19:00:00');
DECLARE @Order26 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order26, @ProdGoiCuon, 3, 120000, 1),
(@Order26, @ProdChaGio, 2, 120000, 1),
(@Order26, @ProdCheThai, 2, 45000, 1);

-- Đơn hàng 27 - Tháng 9
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 190000, 0, 190000, 'COD', 'Paid', 'Completed', @StaffId, '2025-09-25 20:30:00', '2025-09-25 20:00:00');
DECLARE @Order27 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order27, @ProdBunCha, 2, 90000, 1),
(@Order27, @ProdBanhMiPate, 1, 40000, 1);

-- ===== THÁNG 10/2025 =====
-- Đơn hàng 28 - Tháng 10
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 760000, 0, 760000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-10-10 20:00:00', '2025-10-10 19:30:00');
DECLARE @Order28 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order28, @ProdLauCuaDong, 1, 380000, 1),
(@Order28, @ProdComGaNuong, 4, 90000, 1),
(@Order28, @ProdNuocDua, 4, 30000, 1);

-- Đơn hàng 29 - Tháng 10
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 340000, 0, 340000, 'COD', 'Paid', 'Completed', @StaffId, '2025-10-18 18:30:00', '2025-10-18 18:00:00');
DECLARE @Order29 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order29, @ProdPhoBoTai, 2, 85000, 1),
(@Order29, @ProdBunCha, 1, 90000, 1),
(@Order29, @ProdBanhMiThit, 2, 45000, 1);

-- Đơn hàng 30 - Tháng 10
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, @PromoGIAM10, 1000000, 100000, 900000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-10-28 20:30:00', '2025-10-28 20:00:00');
DECLARE @Order30 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order30, @ProdLauThai, 2, 350000, 1),
(@Order30, @ProdGoiCuon, 2, 120000, 1),
(@Order30, @ProdChaCa, 1, 180000, 1);

-- ===== THÁNG 11/2025 =====
-- Đơn hàng 31 - Tháng 11
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 425000, 0, 425000, 'COD', 'Paid', 'Completed', @StaffId, '2025-11-05 19:30:00', '2025-11-05 19:00:00');
DECLARE @Order31 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order31, @ProdPhoBoTai, 3, 85000, 1),
(@Order31, @ProdBanhMiThit, 2, 45000, 1),
(@Order31, @ProdCaPheSua, 2, 30000, 1);

-- Đơn hàng 32 - Tháng 11
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 1100000, 0, 1100000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-11-15 19:00:00', '2025-11-15 18:30:00');
DECLARE @Order32 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order32, @ProdLauThai, 2, 350000, 1),
(@Order32, @ProdChaCa, 1, 180000, 1),
(@Order32, @ProdGoiCuon, 2, 120000, 1);

-- Đơn hàng 33 - Tháng 11
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 190000, 0, 190000, 'COD', 'Paid', 'Completed', @StaffId, '2025-11-22 20:30:00', '2025-11-22 20:00:00');
DECLARE @Order33 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order33, @ProdBunCha, 2, 90000, 1),
(@Order33, @ProdBanhMiPate, 1, 40000, 1);

-- ===== THÁNG 12/2025 =====
-- Đơn hàng 34 - Tháng 12
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 570000, 0, 570000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-12-10 19:30:00', '2025-12-10 19:00:00');
DECLARE @Order34 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order34, @ProdGoiCuon, 3, 120000, 1),
(@Order34, @ProdChaGio, 2, 120000, 1),
(@Order34, @ProdCheThai, 2, 45000, 1);

-- Đơn hàng 35 - Tháng 12
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, @PromoGIAM10, 1200000, 120000, 1080000, 'VNPAY', 'Paid', 'Completed', @StaffId, '2025-12-20 20:30:00', '2025-12-20 20:00:00');
DECLARE @Order35 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order35, @ProdLauThai, 2, 350000, 1),
(@Order35, @ProdGoiCuon, 2, 120000, 1),
(@Order35, @ProdChaGio, 2, 120000, 1),
(@Order35, @ProdComTamSuon, 4, 95000, 1);

-- Đơn hàng 36 - Tháng 12
INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, payment_method, payment_status, order_status, cashier_id, paid_at, created_at)
VALUES (NULL, NULL, NULL, 760000, 0, 760000, 'COD', 'Paid', 'Completed', @StaffId, '2025-12-31 20:00:00', '2025-12-31 19:30:00');
DECLARE @Order36 INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) VALUES
(@Order36, @ProdLauCuaDong, 1, 380000, 1),
(@Order36, @ProdComGaNuong, 4, 90000, 1),
(@Order36, @ProdNuocDua, 4, 30000, 1);

PRINT N'   ✅ Đã thêm 36 đơn hàng với chi tiết (phân bố trong 12 tháng)';
GO

-- ---
-- HOÀN TẤT
-- ---
PRINT N'';
PRINT N'✅ ==========================================';
PRINT N'✅ HOÀN TẤT CHÈN DỮ LIỆU CHO DASHBOARD!';
PRINT N'✅ ==========================================';
PRINT N'';
PRINT N'📊 TÓM TẮT DỮ LIỆU ĐÃ CHÈN:';
PRINT N'   ✅ 10 khách hàng mới';
PRINT N'   ✅ 30 đặt bàn (phân bố trong 12 tháng năm 2025)';
PRINT N'   ✅ 36 đơn hàng với chi tiết (phân bố trong 12 tháng)';
PRINT N'   ✅ Tất cả đơn hàng đã thanh toán (Paid) và hoàn thành (Completed)';
PRINT N'   ✅ Một số đơn hàng có áp dụng khuyến mãi';
PRINT N'';
PRINT N'📈 Dashboard sẽ hiển thị:';
PRINT N'   - Tổng đơn hàng theo tháng/năm';
PRINT N'   - Doanh thu và lợi nhuận theo tháng/năm';
PRINT N'   - Số đặt bàn theo tháng/năm';
PRINT N'   - Số khách hàng theo tháng/năm';
PRINT N'   - Biểu đồ doanh thu & lợi nhuận 12 tháng';
PRINT N'   - Danh sách đơn hàng và đặt bàn gần đây';
PRINT N'';
PRINT N'🎉 Dữ liệu dashboard đã sẵn sàng!';
PRINT N'';
GO

