--=================================================================
-- FILE 2: INSERT DATA - CHÈN DỮ LIỆU MẪU
-- CSDL: SQL Server
-- MÔ TẢ: Script này chèn dữ liệu mẫu vào các bảng
-- SỬ DỤNG: Chạy file này SAU KHI đã chạy CreateTable.sql
--=================================================================

USE QLNhaHang;
GO

PRINT N'';
PRINT N'📦 ==========================================';
PRINT N'📦 BẮT ĐẦU CHÈN DỮ LIỆU MẪU';
PRINT N'📦 ==========================================';
PRINT N'';

-- ---
-- 1. ROLES (Vai trò)
-- ---
PRINT N'1️⃣ Đang chèn dữ liệu Roles...';
INSERT INTO Roles (name, description)
VALUES
(N'Khách hàng', N'Vai trò dành cho khách hàng'),
(N'Admin', N'Quản trị viên hệ thống'),
(N'Nhân viên', N'Nhân viên nhà hàng');
PRINT N'   ✅ Đã chèn 3 roles';
GO

-- ---
-- 2. PERMISSIONS (Quyền)
-- ---
PRINT N'2️⃣ Đang chèn dữ liệu Permissions...';
INSERT INTO Permissions (code, name, description)
VALUES
('DASHBOARD', N'Dashboard', N'Xem trang tổng quan và thống kê'),
('ORDERS', N'Đơn hàng', N'Quản lý đơn hàng và hóa đơn'),
('BOOKING', N'Đặt bàn', N'Quản lý đặt bàn'),
('TABLES', N'Quản lý bàn', N'Quản lý bàn ăn'),
('PRODUCTS', N'Món ăn', N'Quản lý món ăn'),
('CATEGORIES', N'Danh mục', N'Quản lý danh mục món ăn'),
('INGREDIENTS', N'Nguyên liệu', N'Quản lý nguyên liệu'),
('PROMOTIONS', N'Khuyến mãi', N'Quản lý khuyến mãi'),
('ACCOUNTS', N'Tài khoản', N'Quản lý tài khoản toàn bộ hệ thống'),
('ACCOUNTS-STAFF', N'Tài khoản - Nhân viên', N'Quản lý tài khoản, vai trò của nhân viên'),
('ACCOUNTS-CUSTOMER', N'Tài khoản - Khách hàng', N'Quản lý tài khoản, vai trò của khách hàng'),
('RESTAURANT_SETUP', N'Thiết lập nhà hàng', N'Thiết lập thông tin nhà hàng'),
('POSTS', N'Bài viết', N'Quản lý bài viết');
PRINT N'   ✅ Đã chèn 13 permissions';
GO

-- ---
-- 3. ROLE PERMISSIONS (Gán quyền cho Admin)
-- ---
PRINT N'3️⃣ Đang gán quyền cho Admin...';
DECLARE @AdminRoleId INT = (SELECT id FROM Roles WHERE name = N'Admin');
INSERT INTO RolePermissions (role_id, permission_id)
SELECT @AdminRoleId, id FROM Permissions;
PRINT N'   ✅ Đã gán tất cả quyền cho Admin';
GO

-- ---
-- 4. ACCOUNTS (Tài khoản)
-- ---
PRINT N'4️⃣ Đang chèn dữ liệu Accounts...';
INSERT INTO Accounts (username, [password], full_name, email, phone, [role], role_id)
VALUES
('admin', '123', N'Quản Trị Viên', 'admin@hah.com', '0987654321', 1, 2), -- Admin (role_id = 2 vì Admin là role thứ 2)
('nhanvien1', '123', N'Nhân viên', 'staff1@hah.com', '0123456001', 2, 3), -- Nhân viên (role_id = 3)
('khachhang', '123', N'Nguyễn Văn A', 'khach@gmail.com', '0123456789', 0, 1); -- Khách hàng (role_id = 1)
PRINT N'   ✅ Đã chèn 3 tài khoản mẫu';
GO

-- ---
-- 5. RESTAURANT TABLES (Bàn)
-- ---
PRINT N'5️⃣ Đang chèn dữ liệu RestaurantTables...';
INSERT INTO RestaurantTables ([name], capacity, [location_area], [status])
VALUES
(N'Bàn 101', 4, N'Tầng 1', 'Available'),
(N'Bàn 102', 4, N'Tầng 1', 'Available'),
(N'Bàn 103', 4, N'Tầng 1', 'Available'),
(N'Bàn 104', 4, N'Tầng 1', 'Available'),
(N'Bàn 105', 4, N'Tầng 1', 'Available'),
(N'Bàn 106', 4, N'Tầng 1', 'Available'),
(N'Bàn 201', 8, N'Tầng 2', 'Available'),
(N'Bàn 202', 8, N'Tầng 2', 'Available'),
(N'Bàn 203', 8, N'Tầng 2', 'Available'),
(N'Phòng VIP 1', 10, N'Tầng 2', 'Available'),
(N'Phòng VIP 2', 12, N'Tầng 2', 'Available'),
(N'Phòng VIP 3', 10, N'Tầng 2', 'Available');
PRINT N'   ✅ Đã chèn 12 bàn';
GO

-- ---
-- 6. CATEGORIES (Danh mục món ăn)
-- ---
PRINT N'6️⃣ Đang chèn dữ liệu Categories...';
INSERT INTO Categories ([name], [description])
VALUES 
(N'CÁC MÓN LẨU', N'Các món lẩu đặc biệt'),
(N'MÓN CHÍNH', N'Các món ăn chính'),
(N'MÓN KHAI VỊ', N'Các món khai vị'),
(N'MÓN NƯỚNG', N'Các món nướng');
PRINT N'   ✅ Đã chèn 4 danh mục';
GO

-- ---
-- 7. INGREDIENTS (Nguyên vật liệu)
-- ---
PRINT N'7️⃣ Đang chèn dữ liệu Ingredients...';
INSERT INTO Ingredients ([name], unit, price)
VALUES
-- Thịt và hải sản chính
(N'Cá hồi phi lê', 'kg', 450000),
(N'Vịt nguyên con', 'con', 180000),
(N'Tôm sú loại 1', 'kg', 380000),
(N'Thịt bò Mỹ', 'kg', 550000),
(N'Hải sản tổng hợp', 'kg', 320000),
(N'Thịt gà ta', 'kg', 120000),
-- Rau củ và gia vị
(N'Rau thơm', 'kg', 50000),
(N'Ớt tươi', 'kg', 80000),
(N'Tỏi', 'kg', 60000),
(N'Gừng', 'kg', 70000),
(N'Hành tây', 'kg', 40000),
(N'Cà chua', 'kg', 35000),
(N'Bí đỏ', 'kg', 30000),
(N'Rau sống', 'kg', 45000),
-- Gia vị và phụ liệu
(N'Bơ thực vật', 'kg', 180000),
(N'Kem tươi', 'lít', 150000),
(N'Nước dừa', 'lít', 40000),
(N'Gia vị Thái', 'gói', 25000),
(N'Dấm gạo', 'lít', 50000),
(N'Tiêu đen', 'kg', 200000),
(N'Muối', 'kg', 15000),
(N'Đường', 'kg', 25000),
(N'Dầu ăn', 'lít', 60000),
-- Cơm và tinh bột
(N'Gạo thơm', 'kg', 35000),
(N'Bún tươi', 'kg', 40000);
PRINT N'   ✅ Đã chèn 23 nguyên liệu';
GO

-- ---
-- 8. PRODUCTS (Món ăn)
-- ---
PRINT N'8️⃣ Đang chèn dữ liệu Products...';
DECLARE @CatGrill INT, @CatHotpot INT, @CatMain INT, @CatStarter INT;
SELECT @CatGrill = id FROM Categories WHERE [name] = N'MÓN NƯỚNG';
SELECT @CatHotpot = id FROM Categories WHERE [name] = N'CÁC MÓN LẨU';
SELECT @CatMain = id FROM Categories WHERE [name] = N'MÓN CHÍNH';
SELECT @CatStarter = id FROM Categories WHERE [name] = N'MÓN KHAI VỊ';

INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatGrill, N'Cá hồi nướng bơ', N'Cá hồi tươi ngon nướng với bơ thơm lừng', 220000, 'images/mon1.jpg'),
(@CatGrill, N'Vịt quay Tứ Xuyên', N'Vịt quay theo công thức Tứ Xuyên đặc biệt', 220000, 'images/mon2.jpg'),
(@CatGrill, N'Tôm nướng muối ớt', N'Tôm sú tươi nướng với muối ớt cay nồng', 150000, 'images/mon3.jpg'),
(@CatHotpot, N'Lẩu Thái chua cay', N'Lẩu Thái chua cay đậm đà hương vị', 350000, 'images/lau1.jpg'),
(@CatHotpot, N'Lẩu bò nhúng dấm', N'Lẩu bò nhúng dấm thanh mát', 320000, 'images/lau2.jpg'),
(@CatMain, N'Cơm gà xối mỡ', N'Cơm gà thơm ngon với gà xối mỡ đặc biệt', 65000, 'images/chinh1.jpg'),
(@CatMain, N'Bò sốt tiêu đen', N'Thịt bò mềm với sốt tiêu đen đậm đà', 150000, 'images/chinh2.jpg'),
(@CatStarter, N'Gỏi hải sản', N'Gỏi hải sản tươi ngon với nước sốt đặc biệt', 90000, 'images/khai1.jpg'),
(@CatStarter, N'Súp bí đỏ kem tươi', N'Súp bí đỏ kem tươi béo ngậy', 70000, 'images/khai2.jpg');
PRINT N'   ✅ Đã chèn 9 món ăn';
GO

-- ---
-- 9. PRODUCT INGREDIENTS (Công thức món ăn)
-- ---
PRINT N'9️⃣ Đang chèn dữ liệu ProductIngredients...';

-- Lấy ID sản phẩm
DECLARE @ProdSalmon INT, @ProdDuck INT, @ProdTom INT, @ProdLauThai INT, @ProdBoLau INT, @ProdComGa INT, @ProdBoTieu INT, @ProdGoi INT, @ProdSoup INT;
SELECT @ProdSalmon = id FROM Products WHERE [name] = N'Cá hồi nướng bơ';
SELECT @ProdDuck = id FROM Products WHERE [name] = N'Vịt quay Tứ Xuyên';
SELECT @ProdTom = id FROM Products WHERE [name] = N'Tôm nướng muối ớt';
SELECT @ProdLauThai = id FROM Products WHERE [name] = N'Lẩu Thái chua cay';
SELECT @ProdBoLau = id FROM Products WHERE [name] = N'Lẩu bò nhúng dấm';
SELECT @ProdComGa = id FROM Products WHERE [name] = N'Cơm gà xối mỡ';
SELECT @ProdBoTieu = id FROM Products WHERE [name] = N'Bò sốt tiêu đen';
SELECT @ProdGoi = id FROM Products WHERE [name] = N'Gỏi hải sản';
SELECT @ProdSoup = id FROM Products WHERE [name] = N'Súp bí đỏ kem tươi';

-- Lấy ID nguyên liệu
DECLARE @IngSalmon INT, @IngDuck INT, @IngTom INT, @IngBoMy INT, @IngHaiSan INT, @IngGa INT;
DECLARE @IngRauThom INT, @IngOt INT, @IngToi INT, @IngGung INT, @IngHanhTay INT, @IngCaChua INT, @IngBiDo INT, @IngRauSong INT;
DECLARE @IngBo INT, @IngKemTuoi INT, @IngNuocDua INT, @IngGiaViThai INT, @IngGiam INT, @IngTieu INT, @IngMuoi INT, @IngDuong INT, @IngDauAn INT;
DECLARE @IngGao INT;

SELECT @IngSalmon = id FROM Ingredients WHERE [name] = N'Cá hồi phi lê';
SELECT @IngDuck = id FROM Ingredients WHERE [name] = N'Vịt nguyên con';
SELECT @IngTom = id FROM Ingredients WHERE [name] = N'Tôm sú loại 1';
SELECT @IngBoMy = id FROM Ingredients WHERE [name] = N'Thịt bò Mỹ';
SELECT @IngHaiSan = id FROM Ingredients WHERE [name] = N'Hải sản tổng hợp';
SELECT @IngGa = id FROM Ingredients WHERE [name] = N'Thịt gà ta';
SELECT @IngRauThom = id FROM Ingredients WHERE [name] = N'Rau thơm';
SELECT @IngOt = id FROM Ingredients WHERE [name] = N'Ớt tươi';
SELECT @IngToi = id FROM Ingredients WHERE [name] = N'Tỏi';
SELECT @IngGung = id FROM Ingredients WHERE [name] = N'Gừng';
SELECT @IngHanhTay = id FROM Ingredients WHERE [name] = N'Hành tây';
SELECT @IngCaChua = id FROM Ingredients WHERE [name] = N'Cà chua';
SELECT @IngBiDo = id FROM Ingredients WHERE [name] = N'Bí đỏ';
SELECT @IngRauSong = id FROM Ingredients WHERE [name] = N'Rau sống';
SELECT @IngBo = id FROM Ingredients WHERE [name] = N'Bơ thực vật';
SELECT @IngKemTuoi = id FROM Ingredients WHERE [name] = N'Kem tươi';
SELECT @IngNuocDua = id FROM Ingredients WHERE [name] = N'Nước dừa';
SELECT @IngGiaViThai = id FROM Ingredients WHERE [name] = N'Gia vị Thái';
SELECT @IngGiam = id FROM Ingredients WHERE [name] = N'Dấm gạo';
SELECT @IngTieu = id FROM Ingredients WHERE [name] = N'Tiêu đen';
SELECT @IngMuoi = id FROM Ingredients WHERE [name] = N'Muối';
SELECT @IngDuong = id FROM Ingredients WHERE [name] = N'Đường';
SELECT @IngDauAn = id FROM Ingredients WHERE [name] = N'Dầu ăn';
SELECT @IngGao = id FROM Ingredients WHERE [name] = N'Gạo thơm';

-- Công thức món ăn (tính cho 1 phần)
-- 1. Cá hồi nướng bơ
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdSalmon, @IngSalmon, 0.250),
(@ProdSalmon, @IngBo, 0.050),
(@ProdSalmon, @IngToi, 0.010),
(@ProdSalmon, @IngRauThom, 0.020),
(@ProdSalmon, @IngMuoi, 0.005),
(@ProdSalmon, @IngTieu, 0.003),
(@ProdSalmon, @IngDauAn, 0.010);

-- 2. Vịt quay Tứ Xuyên
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdDuck, @IngDuck, 0.500),
(@ProdDuck, @IngGiaViThai, 0.010),
(@ProdDuck, @IngGung, 0.020),
(@ProdDuck, @IngToi, 0.015),
(@ProdDuck, @IngDuong, 0.010),
(@ProdDuck, @IngMuoi, 0.005),
(@ProdDuck, @IngDauAn, 0.015);

-- 3. Tôm nướng muối ớt
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdTom, @IngTom, 0.250),
(@ProdTom, @IngOt, 0.030),
(@ProdTom, @IngMuoi, 0.010),
(@ProdTom, @IngTieu, 0.005),
(@ProdTom, @IngDauAn, 0.010);

-- 4. Lẩu Thái chua cay
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdLauThai, @IngHaiSan, 0.500),
(@ProdLauThai, @IngGiaViThai, 0.050),
(@ProdLauThai, @IngNuocDua, 0.200),
(@ProdLauThai, @IngCaChua, 0.100),
(@ProdLauThai, @IngOt, 0.020),
(@ProdLauThai, @IngGung, 0.010),
(@ProdLauThai, @IngRauSong, 0.100),
(@ProdLauThai, @IngMuoi, 0.010),
(@ProdLauThai, @IngDuong, 0.015);

-- 5. Lẩu bò nhúng dấm
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdBoLau, @IngBoMy, 0.300),
(@ProdBoLau, @IngGiam, 0.100),
(@ProdBoLau, @IngGung, 0.020),
(@ProdBoLau, @IngToi, 0.010),
(@ProdBoLau, @IngRauSong, 0.150),
(@ProdBoLau, @IngMuoi, 0.010),
(@ProdBoLau, @IngDuong, 0.010);

-- 6. Cơm gà xối mỡ
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdComGa, @IngGa, 0.200),
(@ProdComGa, @IngGao, 0.150),
(@ProdComGa, @IngDauAn, 0.010),
(@ProdComGa, @IngMuoi, 0.005),
(@ProdComGa, @IngRauThom, 0.010);

-- 7. Bò sốt tiêu đen
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdBoTieu, @IngBoMy, 0.150),
(@ProdBoTieu, @IngTieu, 0.010),
(@ProdBoTieu, @IngHanhTay, 0.050),
(@ProdBoTieu, @IngToi, 0.010),
(@ProdBoTieu, @IngDauAn, 0.010),
(@ProdBoTieu, @IngMuoi, 0.005),
(@ProdBoTieu, @IngDuong, 0.005);

-- 8. Gỏi hải sản
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdGoi, @IngHaiSan, 0.150),
(@ProdGoi, @IngRauSong, 0.100),
(@ProdGoi, @IngCaChua, 0.050),
(@ProdGoi, @IngOt, 0.010),
(@ProdGoi, @IngGiam, 0.020),
(@ProdGoi, @IngDuong, 0.010),
(@ProdGoi, @IngMuoi, 0.005);

-- 9. Súp bí đỏ kem tươi
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdSoup, @IngBiDo, 0.300),
(@ProdSoup, @IngKemTuoi, 0.100),
(@ProdSoup, @IngDauAn, 0.010),
(@ProdSoup, @IngMuoi, 0.005),
(@ProdSoup, @IngTieu, 0.002),
(@ProdSoup, @IngRauThom, 0.010);

PRINT N'   ✅ Đã chèn công thức cho 9 món ăn';
GO

-- ---
-- 10. TÍNH GIÁ VỐN CHO TẤT CẢ MÓN ĂN
-- ---
PRINT N'🔟 Đang tính giá vốn cho các món ăn...';
UPDATE Products
SET cost_price = (
    SELECT COALESCE(SUM(i.price * pi.quantity_needed), 0)
    FROM ProductIngredients pi
    INNER JOIN Ingredients i ON pi.ingredient_id = i.id
    WHERE pi.product_id = Products.id
);
PRINT N'   ✅ Đã tính giá vốn cho tất cả món ăn';
GO

-- ---
-- 11. PROMOTIONS (Khuyến mãi)
-- ---
PRINT N'1️⃣1️⃣ Đang chèn dữ liệu Promotions...';
INSERT INTO Promotions ([code], [description], discount_type, discount_value, min_order_value, start_date, end_date, is_active)
VALUES
('GIAM10', N'Giảm 10% tổng hóa đơn', 'Percent', 10, 500000, '2025-01-01', '2025-12-31', 1),
('GIAM50K', N'Giảm 50.000 VNĐ cho đơn từ 300.000 VNĐ', 'FixedAmount', 50000, 300000, '2025-01-01', '2025-12-31', 1);
PRINT N'   ✅ Đã chèn 2 mã khuyến mãi';
GO

-- ---
-- 12. RESTAURANT SETTINGS (Thiết lập nhà hàng - Để trống, sẽ được quản lý qua admin)
-- ---
PRINT N'1️⃣2️⃣ RestaurantSettings đã sẵn sàng (có thể tùy chỉnh qua admin/restaurant-setup)';
GO

-- ---
-- HOÀN TẤT
-- ---
PRINT N'';
PRINT N'✅ ==========================================';
PRINT N'✅ HOÀN TẤT CHÈN DỮ LIỆU MẪU!';
PRINT N'✅ ==========================================';
PRINT N'';
PRINT N'📊 TÓM TẮT DỮ LIỆU ĐÃ CHÈN:';
PRINT N'   ✅ 3 Roles (Khách hàng, Admin, Nhân viên)';
PRINT N'   ✅ 13 Permissions (bao gồm RESTAURANT_SETUP)';
PRINT N'   ✅ Đã gán tất cả quyền cho Admin';
PRINT N'   ✅ 3 Accounts (admin, nhanvien1, khachhang)';
PRINT N'   ✅ 12 RestaurantTables (bàn và phòng VIP)';
PRINT N'   ✅ 4 Categories (Lẩu, Món chính, Khai vị, Nướng)';
PRINT N'   ✅ 23 Ingredients (nguyên liệu với giá)';
PRINT N'   ✅ 9 Products (món ăn)';
PRINT N'   ✅ Công thức cho 9 món ăn (ProductIngredients)';
PRINT N'   ✅ Đã tính giá vốn cho tất cả món ăn';
PRINT N'   ✅ 2 Promotions (mã khuyến mãi)';
PRINT N'';
PRINT N'🎉 CSDL QLNhaHang đã sẵn sàng để sử dụng!';
PRINT N'';
PRINT N'📝 THÔNG TIN ĐĂNG NHẬP:';
PRINT N'   👤 Admin: username="admin", password="123"';
PRINT N'   👤 Nhân viên: username="nhanvien1", password="123"';
PRINT N'   👤 Khách hàng: username="khachhang", password="123"';
PRINT N'';
GO

