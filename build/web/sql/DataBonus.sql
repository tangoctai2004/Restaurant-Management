--=================================================================
-- FILE 3: DATA BONUS - DỮ LIỆU BỔ SUNG CHO NHÀ HÀNG VIỆT NAM
-- CSDL: SQL Server
-- MÔ TẢ: Script này chèn thêm nhiều nguyên liệu, món ăn, danh mục
--         theo phong cách nhà hàng Việt Nam
-- SỬ DỤNG: Chạy file này SAU KHI đã chạy CreateTable.sql và InsertData.sql
--=================================================================

USE QLNhaHang;
GO

PRINT N'';
PRINT N'🍜 ==========================================';
PRINT N'🍜 BẮT ĐẦU CHÈN DỮ LIỆU BỔ SUNG VIỆT NAM';
PRINT N'🍜 ==========================================';
PRINT N'';

-- ---
-- 1. THÊM DANH MỤC MỚI (CATEGORIES)
-- ---
PRINT N'1️⃣ Đang thêm danh mục mới...';
INSERT INTO Categories ([name], [description])
VALUES
(N'PHỞ & BÚN', N'Các món phở và bún truyền thống Việt Nam'),
(N'CƠM', N'Các món cơm đặc trưng Việt Nam'),
(N'GỎI & NỘM', N'Các món gỏi và nộm tươi ngon'),
(N'BÁNH MÌ', N'Bánh mì Việt Nam với nhiều loại nhân'),
(N'CHẢ GIÒ & CHẢ CÁ', N'Các món chả giò, chả cá truyền thống'),
(N'CHÈ & ĐỒ NGỌT', N'Các món chè và đồ ngọt Việt Nam'),
(N'ĐỒ UỐNG', N'Các loại đồ uống Việt Nam'),
(N'LẨU VIỆT NAM', N'Các món lẩu đặc trưng Việt Nam');
PRINT N'   ✅ Đã thêm 8 danh mục mới';
GO

-- ---
-- 2. THÊM NGUYÊN LIỆU MỚI (INGREDIENTS)
-- ---
PRINT N'2️⃣ Đang thêm nguyên liệu mới...';
INSERT INTO Ingredients ([name], unit, price)
VALUES
-- Nguyên liệu đặc trưng Việt Nam
(N'Bánh phở tươi', 'kg', 45000),
(N'Bún tươi', 'kg', 40000),
(N'Bánh mì baguette', 'cái', 8000),
(N'Nước mắm Phú Quốc', 'chai', 85000),
(N'Chanh tươi', 'kg', 35000),
(N'Ớt hiểm', 'kg', 90000),
(N'Rau mùi', 'kg', 55000),
(N'Rau húng quế', 'kg', 60000),
(N'Rau ngò gai', 'kg', 50000),
(N'Rau xà lách', 'kg', 40000),
(N'Giá đỗ', 'kg', 30000),
(N'Hành tây tím', 'kg', 45000),
(N'Hành lá', 'kg', 50000),
(N'Ngò rí', 'kg', 48000),
(N'Rau răm', 'kg', 52000),
(N'Rau diếp cá', 'kg', 55000),
-- Thịt và hải sản
(N'Thịt bò thăn', 'kg', 480000),
(N'Thịt bò gân', 'kg', 320000),
(N'Xương bò', 'kg', 120000),
(N'Thịt heo ba chỉ', 'kg', 180000),
(N'Thịt heo nạc', 'kg', 200000),
(N'Chả lụa', 'kg', 220000),
(N'Chả cá', 'kg', 280000),
(N'Tôm tươi', 'kg', 400000),
(N'Cá basa', 'kg', 90000),
(N'Cá lóc', 'kg', 110000),
(N'Cá trắm', 'kg', 130000),
(N'Thịt gà ta', 'kg', 120000),
(N'Trứng gà', 'quả', 3500),
-- Gia vị và phụ liệu Việt Nam
(N'Bột nêm', 'gói', 25000),
(N'Bột ngọt', 'gói', 20000),
(N'Đường phèn', 'kg', 30000),
(N'Mắm tôm', 'chai', 45000),
(N'Tương ớt', 'chai', 35000),
(N'Tương đen', 'chai', 40000),
(N'Dầu hào', 'chai', 42000),
(N'Xì dầu', 'chai', 38000),
(N'Gừng tươi', 'kg', 70000),
(N'Sả', 'kg', 40000),
(N'Lá chanh', 'kg', 60000),
(N'Lá dứa', 'kg', 50000),
(N'Củ hành tím', 'kg', 50000),
(N'Ớt sừng', 'kg', 85000),
-- Rau củ Việt Nam
(N'Cà rốt', 'kg', 25000),
(N'Củ cải trắng', 'kg', 20000),
(N'Cà chua bi', 'kg', 40000),
(N'Dưa leo', 'kg', 30000),
(N'Đậu phộng', 'kg', 60000),
(N'Đậu xanh', 'kg', 45000),
(N'Bắp cải', 'kg', 20000),
(N'Cải thảo', 'kg', 22000),
-- Nguyên liệu làm bánh và chè
(N'Bột gạo', 'kg', 30000),
(N'Bột năng', 'kg', 35000),
(N'Bột báng', 'kg', 40000),
(N'Đậu đỏ', 'kg', 50000),
(N'Đậu xanh cà', 'kg', 48000),
(N'Đậu trắng', 'kg', 45000),
(N'Khoai môn', 'kg', 35000),
(N'Khoai lang', 'kg', 25000),
(N'Bột sắn dây', 'kg', 60000),
(N'Nước cốt dừa', 'lít', 80000),
(N'Dừa nạo', 'kg', 50000),
(N'Lá dứa', 'kg', 50000),
(N'Lá nếp', 'kg', 45000),
-- Nguyên liệu đồ uống
(N'Cà phê phin', 'gói', 120000),
(N'Trà xanh', 'gói', 80000),
(N'Trà đá', 'gói', 30000),
(N'Chanh dây', 'kg', 60000),
(N'Dừa tươi', 'quả', 25000),
(N'Đá viên', 'kg', 5000);
PRINT N'   ✅ Đã thêm 60 nguyên liệu mới';
GO

-- ---
-- 3. THÊM MÓN ĂN MỚI (PRODUCTS)
-- ---
PRINT N'3️⃣ Đang thêm món ăn mới...';

DECLARE @CatPho INT, @CatCom INT, @CatGoi INT, @CatBanhMi INT, @CatCha INT, @CatChe INT, @CatDoUong INT, @CatLauVN INT;
SELECT @CatPho = id FROM Categories WHERE [name] = N'PHỞ & BÚN';
SELECT @CatCom = id FROM Categories WHERE [name] = N'CƠM';
SELECT @CatGoi = id FROM Categories WHERE [name] = N'GỎI & NỘM';
SELECT @CatBanhMi = id FROM Categories WHERE [name] = N'BÁNH MÌ';
SELECT @CatCha = id FROM Categories WHERE [name] = N'CHẢ GIÒ & CHẢ CÁ';
SELECT @CatChe = id FROM Categories WHERE [name] = N'CHÈ & ĐỒ NGỌT';
SELECT @CatDoUong = id FROM Categories WHERE [name] = N'ĐỒ UỐNG';
SELECT @CatLauVN = id FROM Categories WHERE [name] = N'LẨU VIỆT NAM';

-- Phở & Bún
INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatPho, N'Phở bò tái', N'Phở bò tái thơm ngon với nước dùng đậm đà', 85000, 'images/pho-bo-tai.jpg'),
(@CatPho, N'Phở bò chín', N'Phở bò chín mềm ngon với nước dùng trong', 85000, 'images/pho-bo-chin.jpg'),
(@CatPho, N'Phở bò tái chín', N'Phở bò tái chín kết hợp hoàn hảo', 95000, 'images/pho-bo-tai-chin.jpg'),
(@CatPho, N'Phở gà', N'Phở gà thơm ngon với thịt gà mềm', 75000, 'images/pho-ga.jpg'),
(@CatPho, N'Bún chả Hà Nội', N'Bún chả Hà Nội đặc trưng với chả nướng thơm', 90000, 'images/bun-cha.jpg'),
(@CatPho, N'Bún bò Huế', N'Bún bò Huế cay nồng đậm đà', 95000, 'images/bun-bo-hue.jpg'),
(@CatPho, N'Bún riêu cua', N'Bún riêu cua chua ngọt thanh mát', 85000, 'images/bun-rieu-cua.jpg'),
(@CatPho, N'Bún thịt nướng', N'Bún thịt nướng với nước mắm pha đặc biệt', 80000, 'images/bun-thit-nuong.jpg');

-- Cơm
INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatCom, N'Cơm tấm sườn nướng', N'Cơm tấm với sườn nướng thơm lừng', 95000, 'images/com-tam-suon.jpg'),
(@CatCom, N'Cơm tấm bì chả', N'Cơm tấm với bì và chả trứng', 85000, 'images/com-tam-bi-cha.jpg'),
(@CatCom, N'Cơm gà nướng', N'Cơm gà nướng với da giòn thơm', 90000, 'images/com-ga-nuong.jpg'),
(@CatCom, N'Cơm cá kho tộ', N'Cơm với cá kho tộ đậm đà', 85000, 'images/com-ca-kho.jpg'),
(@CatCom, N'Cơm thịt kho tàu', N'Cơm với thịt kho tàu mềm ngon', 80000, 'images/com-thit-kho.jpg'),
(@CatCom, N'Cơm sườn xào chua ngọt', N'Cơm với sườn xào chua ngọt', 90000, 'images/com-suon-xao.jpg');

-- Gỏi & Nộm
INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatGoi, N'Gỏi cuốn tôm thịt', N'Gỏi cuốn tươi ngon với tôm và thịt', 120000, 'images/goi-cuon.jpg'),
(@CatGoi, N'Gỏi đu đủ tôm thịt', N'Gỏi đu đủ giòn với tôm và thịt', 90000, 'images/goi-du-du.jpg'),
(@CatGoi, N'Nộm hoa chuối', N'Nộm hoa chuối chua ngọt thanh mát', 80000, 'images/nom-hoa-chuoi.jpg'),
(@CatGoi, N'Gỏi ngó sen tôm thịt', N'Gỏi ngó sen giòn với tôm và thịt', 95000, 'images/goi-ngo-sen.jpg'),
(@CatGoi, N'Gỏi bưởi tôm thịt', N'Gỏi bưởi tươi ngon với tôm và thịt', 100000, 'images/goi-buoi.jpg');

-- Bánh mì
INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatBanhMi, N'Bánh mì thịt nướng', N'Bánh mì với thịt nướng thơm lừng', 45000, 'images/banh-mi-thit.jpg'),
(@CatBanhMi, N'Bánh mì pate chả lụa', N'Bánh mì với pate và chả lụa', 40000, 'images/banh-mi-pate.jpg'),
(@CatBanhMi, N'Bánh mì xíu mại', N'Bánh mì với xíu mại đậm đà', 45000, 'images/banh-mi-xiu-mai.jpg'),
(@CatBanhMi, N'Bánh mì chả cá', N'Bánh mì với chả cá thơm ngon', 50000, 'images/banh-mi-cha-ca.jpg'),
(@CatBanhMi, N'Bánh mì trứng ốp la', N'Bánh mì với trứng ốp la', 35000, 'images/banh-mi-trung.jpg');

-- Chả giò & Chả cá
INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatCha, N'Chả giò truyền thống', N'Chả giò giòn rụm với nhân thịt tôm', 120000, 'images/cha-gio.jpg'),
(@CatCha, N'Chả giò tôm cua', N'Chả giò với tôm và cua tươi', 150000, 'images/cha-gio-tom-cua.jpg'),
(@CatCha, N'Chả cá Lã Vọng', N'Chả cá Lã Vọng thơm ngon đặc trưng', 180000, 'images/cha-ca.jpg'),
(@CatCha, N'Chả cốm', N'Chả cốm thơm ngon đặc biệt', 140000, 'images/cha-com.jpg'),
(@CatCha, N'Chả nem nướng', N'Chả nem nướng thơm lừng', 130000, 'images/cha-nem-nuong.jpg');

-- Chè & Đồ ngọt
INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatChe, N'Chè đậu xanh', N'Chè đậu xanh mát lạnh', 35000, 'images/che-dau-xanh.jpg'),
(@CatChe, N'Chè đậu đỏ', N'Chè đậu đỏ bổ dưỡng', 35000, 'images/che-dau-do.jpg'),
(@CatChe, N'Chè bưởi', N'Chè bưởi thanh mát', 40000, 'images/che-buoi.jpg'),
(@CatChe, N'Chè thái', N'Chè thái đủ loại trái cây', 45000, 'images/che-thai.jpg'),
(@CatChe, N'Chè trôi nước', N'Chè trôi nước truyền thống', 40000, 'images/che-troi-nuoc.jpg'),
(@CatChe, N'Chè khoai môn', N'Chè khoai môn béo ngậy', 40000, 'images/che-khoai-mon.jpg'),
(@CatChe, N'Chè chuối', N'Chè chuối thơm ngon', 35000, 'images/che-chuoi.jpg'),
(@CatChe, N'Bánh flan', N'Bánh flan mềm mịn', 45000, 'images/banh-flan.jpg');

-- Đồ uống
INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatDoUong, N'Cà phê đen đá', N'Cà phê đen đá đậm đà', 25000, 'images/ca-phe-den.jpg'),
(@CatDoUong, N'Cà phê sữa đá', N'Cà phê sữa đá thơm ngon', 30000, 'images/ca-phe-sua.jpg'),
(@CatDoUong, N'Cà phê bạc xỉu', N'Cà phê bạc xỉu ngọt ngào', 35000, 'images/ca-phe-bac-xiu.jpg'),
(@CatDoUong, N'Trà đá', N'Trà đá mát lạnh', 15000, 'images/tra-da.jpg'),
(@CatDoUong, N'Trà chanh', N'Trà chanh thanh mát', 25000, 'images/tra-chanh.jpg'),
(@CatDoUong, N'Nước chanh dây', N'Nước chanh dây tươi mát', 35000, 'images/chanh-day.jpg'),
(@CatDoUong, N'Nước dừa tươi', N'Nước dừa tươi mát lạnh', 30000, 'images/nuoc-dua.jpg'),
(@CatDoUong, N'Sinh tố bơ', N'Sinh tố bơ béo ngậy', 45000, 'images/sinh-to-bo.jpg'),
(@CatDoUong, N'Sinh tố xoài', N'Sinh tố xoài thơm ngon', 40000, 'images/sinh-to-xoai.jpg'),
(@CatDoUong, N'Nước cam ép', N'Nước cam ép tươi', 40000, 'images/nuoc-cam.jpg');

-- Lẩu Việt Nam
INSERT INTO Products (category_id, [name], [description], price, image_url)
VALUES
(@CatLauVN, N'Lẩu Thái', N'Lẩu Thái chua cay đậm đà', 350000, 'images/lau-thai.jpg'),
(@CatLauVN, N'Lẩu cua đồng', N'Lẩu cua đồng đặc trưng', 380000, 'images/lau-cua-dong.jpg'),
(@CatLauVN, N'Lẩu gà lá é', N'Lẩu gà lá é thơm ngon', 320000, 'images/lau-ga-la-e.jpg'),
(@CatLauVN, N'Lẩu cá lăng', N'Lẩu cá lăng tươi ngon', 400000, 'images/lau-ca-lang.jpg'),
(@CatLauVN, N'Lẩu tôm chua', N'Lẩu tôm chua thanh mát', 360000, 'images/lau-tom-chua.jpg');

PRINT N'   ✅ Đã thêm 58 món ăn mới';
GO

-- ---
-- 4. THÊM CÔNG THỨC CHO CÁC MÓN ĂN MỚI (PRODUCT INGREDIENTS)
-- ---
PRINT N'4️⃣ Đang thêm công thức cho các món ăn mới...';

-- Lấy ID nguyên liệu mới
DECLARE @IngBanhPho INT, @IngBun INT, @IngBanhMi INT, @IngNuocMam INT, @IngChanh INT, @IngOtHiem INT;
DECLARE @IngRauMui INT, @IngRauHung INT, @IngRauNgo INT, @IngRauXaLach INT, @IngGiaDo INT, @IngHanhTim INT, @IngHanhLa INT;
DECLARE @IngNgoRi INT, @IngRauRam INT, @IngRauDiepCa INT;
DECLARE @IngBoThan INT, @IngBoGan INT, @IngXuongBo INT, @IngHeoBaChi INT, @IngHeoNac INT, @IngChaLua INT, @IngChaCa INT;
DECLARE @IngTomTuoi INT, @IngCaBasa INT, @IngCaLoc INT, @IngCaTram INT, @IngGaTa INT, @IngTrungGa INT;
DECLARE @IngBotNem INT, @IngBotNgot INT, @IngDuongPhen INT, @IngMamTom INT, @IngTuongOt INT, @IngTuongDen INT;
DECLARE @IngDauHao INT, @IngXiDau INT, @IngGungTuoi INT, @IngSa INT, @IngLaChanh INT, @IngLaDua INT, @IngCuHanhTim INT, @IngOtSung INT;
DECLARE @IngCaRot INT, @IngCuCai INT, @IngCaChuaBi INT, @IngDuaLeo INT, @IngDauPhong INT, @IngDauXanh INT, @IngBapCai INT, @IngCaiThao INT;
DECLARE @IngBotGao INT, @IngBotNang INT, @IngBotBang INT, @IngDauDo INT, @IngDauXanhCa INT, @IngDauTrang INT;
DECLARE @IngKhoaiMon INT, @IngKhoaiLang INT, @IngBotSanDay INT, @IngNuocCotDua INT, @IngDuaNao INT, @IngLaNep INT;
DECLARE @IngCaPhe INT, @IngTraXanh INT, @IngTraDa INT, @IngChanhDay INT, @IngDuaTuoi INT, @IngDaVien INT;

SELECT @IngBanhPho = id FROM Ingredients WHERE [name] = N'Bánh phở tươi';
SELECT @IngBun = id FROM Ingredients WHERE [name] = N'Bún tươi';
SELECT @IngBanhMi = id FROM Ingredients WHERE [name] = N'Bánh mì baguette';
SELECT @IngNuocMam = id FROM Ingredients WHERE [name] = N'Nước mắm Phú Quốc';
SELECT @IngChanh = id FROM Ingredients WHERE [name] = N'Chanh tươi';
SELECT @IngOtHiem = id FROM Ingredients WHERE [name] = N'Ớt hiểm';
SELECT @IngRauMui = id FROM Ingredients WHERE [name] = N'Rau mùi';
SELECT @IngRauHung = id FROM Ingredients WHERE [name] = N'Rau húng quế';
SELECT @IngRauNgo = id FROM Ingredients WHERE [name] = N'Rau ngò gai';
SELECT @IngRauXaLach = id FROM Ingredients WHERE [name] = N'Rau xà lách';
SELECT @IngGiaDo = id FROM Ingredients WHERE [name] = N'Giá đỗ';
SELECT @IngHanhTim = id FROM Ingredients WHERE [name] = N'Hành tây tím';
SELECT @IngHanhLa = id FROM Ingredients WHERE [name] = N'Hành lá';
SELECT @IngNgoRi = id FROM Ingredients WHERE [name] = N'Ngò rí';
SELECT @IngRauRam = id FROM Ingredients WHERE [name] = N'Rau răm';
SELECT @IngRauDiepCa = id FROM Ingredients WHERE [name] = N'Rau diếp cá';
SELECT @IngBoThan = id FROM Ingredients WHERE [name] = N'Thịt bò thăn';
SELECT @IngBoGan = id FROM Ingredients WHERE [name] = N'Thịt bò gân';
SELECT @IngXuongBo = id FROM Ingredients WHERE [name] = N'Xương bò';
SELECT @IngHeoBaChi = id FROM Ingredients WHERE [name] = N'Thịt heo ba chỉ';
SELECT @IngHeoNac = id FROM Ingredients WHERE [name] = N'Thịt heo nạc';
SELECT @IngChaLua = id FROM Ingredients WHERE [name] = N'Chả lụa';
SELECT @IngChaCa = id FROM Ingredients WHERE [name] = N'Chả cá';
SELECT @IngTomTuoi = id FROM Ingredients WHERE [name] = N'Tôm tươi';
SELECT @IngCaBasa = id FROM Ingredients WHERE [name] = N'Cá basa';
SELECT @IngCaLoc = id FROM Ingredients WHERE [name] = N'Cá lóc';
SELECT @IngCaTram = id FROM Ingredients WHERE [name] = N'Cá trắm';
SELECT @IngGaTa = id FROM Ingredients WHERE [name] = N'Thịt gà ta';
SELECT @IngTrungGa = id FROM Ingredients WHERE [name] = N'Trứng gà';
SELECT @IngBotNem = id FROM Ingredients WHERE [name] = N'Bột nêm';
SELECT @IngBotNgot = id FROM Ingredients WHERE [name] = N'Bột ngọt';
SELECT @IngDuongPhen = id FROM Ingredients WHERE [name] = N'Đường phèn';
SELECT @IngMamTom = id FROM Ingredients WHERE [name] = N'Mắm tôm';
SELECT @IngTuongOt = id FROM Ingredients WHERE [name] = N'Tương ớt';
SELECT @IngTuongDen = id FROM Ingredients WHERE [name] = N'Tương đen';
SELECT @IngDauHao = id FROM Ingredients WHERE [name] = N'Dầu hào';
SELECT @IngXiDau = id FROM Ingredients WHERE [name] = N'Xì dầu';
SELECT @IngGungTuoi = id FROM Ingredients WHERE [name] = N'Gừng tươi';
SELECT @IngSa = id FROM Ingredients WHERE [name] = N'Sả';
SELECT @IngLaChanh = id FROM Ingredients WHERE [name] = N'Lá chanh';
SELECT @IngLaDua = id FROM Ingredients WHERE [name] = N'Lá dứa';
SELECT @IngCuHanhTim = id FROM Ingredients WHERE [name] = N'Củ hành tím';
SELECT @IngOtSung = id FROM Ingredients WHERE [name] = N'Ớt sừng';
SELECT @IngCaRot = id FROM Ingredients WHERE [name] = N'Cà rốt';
SELECT @IngCuCai = id FROM Ingredients WHERE [name] = N'Củ cải trắng';
SELECT @IngCaChuaBi = id FROM Ingredients WHERE [name] = N'Cà chua bi';
SELECT @IngDuaLeo = id FROM Ingredients WHERE [name] = N'Dưa leo';
SELECT @IngDauPhong = id FROM Ingredients WHERE [name] = N'Đậu phộng';
SELECT @IngDauXanh = id FROM Ingredients WHERE [name] = N'Đậu xanh';
SELECT @IngBapCai = id FROM Ingredients WHERE [name] = N'Bắp cải';
SELECT @IngCaiThao = id FROM Ingredients WHERE [name] = N'Cải thảo';
SELECT @IngBotGao = id FROM Ingredients WHERE [name] = N'Bột gạo';
SELECT @IngBotNang = id FROM Ingredients WHERE [name] = N'Bột năng';
SELECT @IngBotBang = id FROM Ingredients WHERE [name] = N'Bột báng';
SELECT @IngDauDo = id FROM Ingredients WHERE [name] = N'Đậu đỏ';
SELECT @IngDauXanhCa = id FROM Ingredients WHERE [name] = N'Đậu xanh cà';
SELECT @IngDauTrang = id FROM Ingredients WHERE [name] = N'Đậu trắng';
SELECT @IngKhoaiMon = id FROM Ingredients WHERE [name] = N'Khoai môn';
SELECT @IngKhoaiLang = id FROM Ingredients WHERE [name] = N'Khoai lang';
SELECT @IngBotSanDay = id FROM Ingredients WHERE [name] = N'Bột sắn dây';
SELECT @IngNuocCotDua = id FROM Ingredients WHERE [name] = N'Nước cốt dừa';
SELECT @IngDuaNao = id FROM Ingredients WHERE [name] = N'Dừa nạo';
SELECT @IngLaNep = id FROM Ingredients WHERE [name] = N'Lá nếp';
SELECT @IngCaPhe = id FROM Ingredients WHERE [name] = N'Cà phê phin';
SELECT @IngTraXanh = id FROM Ingredients WHERE [name] = N'Trà xanh';
SELECT @IngTraDa = id FROM Ingredients WHERE [name] = N'Trà đá';
SELECT @IngChanhDay = id FROM Ingredients WHERE [name] = N'Chanh dây';
SELECT @IngDuaTuoi = id FROM Ingredients WHERE [name] = N'Dừa tươi';
SELECT @IngDaVien = id FROM Ingredients WHERE [name] = N'Đá viên';

-- Lấy ID các nguyên liệu cũ (từ InsertData.sql)
DECLARE @IngToi INT, @IngGung INT, @IngMuoi INT, @IngDuong INT, @IngDauAn INT, @IngGao INT, @IngRauThom INT, @IngRauSong INT;
SELECT @IngToi = id FROM Ingredients WHERE [name] = N'Tỏi';
SELECT @IngGung = id FROM Ingredients WHERE [name] = N'Gừng';
SELECT @IngMuoi = id FROM Ingredients WHERE [name] = N'Muối';
SELECT @IngDuong = id FROM Ingredients WHERE [name] = N'Đường';
SELECT @IngDauAn = id FROM Ingredients WHERE [name] = N'Dầu ăn';
SELECT @IngGao = id FROM Ingredients WHERE [name] = N'Gạo thơm';
SELECT @IngRauThom = id FROM Ingredients WHERE [name] = N'Rau thơm';
SELECT @IngRauSong = id FROM Ingredients WHERE [name] = N'Rau sống';

-- Lấy ID sản phẩm mới
DECLARE @ProdPhoBoTai INT, @ProdPhoBoChin INT, @ProdPhoBoTaiChin INT, @ProdPhoGa INT;
DECLARE @ProdBunCha INT, @ProdBunBoHue INT, @ProdBunRieuCua INT, @ProdBunThitNuong INT;
DECLARE @ProdComTamSuon INT, @ProdComTamBiCha INT, @ProdComGaNuong INT, @ProdComCaKho INT, @ProdComThitKho INT, @ProdComSuonXao INT;
DECLARE @ProdGoiCuon INT, @ProdGoiDuDu INT, @ProdNomHoaChuoi INT, @ProdGoiNgoSen INT, @ProdGoiBuoi INT;
DECLARE @ProdBanhMiThit INT, @ProdBanhMiPate INT, @ProdBanhMiXiuMai INT, @ProdBanhMiChaCa INT, @ProdBanhMiTrung INT;
DECLARE @ProdChaGio INT, @ProdChaGioTomCua INT, @ProdChaCaLV INT, @ProdChaCom INT, @ProdChaNemNuong INT;
DECLARE @ProdCheDauXanh INT, @ProdCheDauDo INT, @ProdCheBuoi INT, @ProdCheThai INT, @ProdCheTroiNuoc INT, @ProdCheKhoaiMon INT, @ProdCheChuoi INT, @ProdBanhFlan INT;
DECLARE @ProdCaPheDen INT, @ProdCaPheSua INT, @ProdCaPheBacXiu INT, @ProdTraDa INT, @ProdTraChanh INT, @ProdChanhDay INT, @ProdNuocDua INT, @ProdSinhToBo INT, @ProdSinhToXoai INT, @ProdNuocCam INT;
DECLARE @ProdLauThai INT, @ProdLauCuaDong INT, @ProdLauGaLae INT, @ProdLauCaLang INT, @ProdLauTomChua INT;

SELECT @ProdPhoBoTai = id FROM Products WHERE [name] = N'Phở bò tái';
SELECT @ProdPhoBoChin = id FROM Products WHERE [name] = N'Phở bò chín';
SELECT @ProdPhoBoTaiChin = id FROM Products WHERE [name] = N'Phở bò tái chín';
SELECT @ProdPhoGa = id FROM Products WHERE [name] = N'Phở gà';
SELECT @ProdBunCha = id FROM Products WHERE [name] = N'Bún chả Hà Nội';
SELECT @ProdBunBoHue = id FROM Products WHERE [name] = N'Bún bò Huế';
SELECT @ProdBunRieuCua = id FROM Products WHERE [name] = N'Bún riêu cua';
SELECT @ProdBunThitNuong = id FROM Products WHERE [name] = N'Bún thịt nướng';
SELECT @ProdComTamSuon = id FROM Products WHERE [name] = N'Cơm tấm sườn nướng';
SELECT @ProdComTamBiCha = id FROM Products WHERE [name] = N'Cơm tấm bì chả';
SELECT @ProdComGaNuong = id FROM Products WHERE [name] = N'Cơm gà nướng';
SELECT @ProdComCaKho = id FROM Products WHERE [name] = N'Cơm cá kho tộ';
SELECT @ProdComThitKho = id FROM Products WHERE [name] = N'Cơm thịt kho tàu';
SELECT @ProdComSuonXao = id FROM Products WHERE [name] = N'Cơm sườn xào chua ngọt';
SELECT @ProdGoiCuon = id FROM Products WHERE [name] = N'Gỏi cuốn tôm thịt';
SELECT @ProdGoiDuDu = id FROM Products WHERE [name] = N'Gỏi đu đủ tôm thịt';
SELECT @ProdNomHoaChuoi = id FROM Products WHERE [name] = N'Nộm hoa chuối';
SELECT @ProdGoiNgoSen = id FROM Products WHERE [name] = N'Gỏi ngó sen tôm thịt';
SELECT @ProdGoiBuoi = id FROM Products WHERE [name] = N'Gỏi bưởi tôm thịt';
SELECT @ProdBanhMiThit = id FROM Products WHERE [name] = N'Bánh mì thịt nướng';
SELECT @ProdBanhMiPate = id FROM Products WHERE [name] = N'Bánh mì pate chả lụa';
SELECT @ProdBanhMiXiuMai = id FROM Products WHERE [name] = N'Bánh mì xíu mại';
SELECT @ProdBanhMiChaCa = id FROM Products WHERE [name] = N'Bánh mì chả cá';
SELECT @ProdBanhMiTrung = id FROM Products WHERE [name] = N'Bánh mì trứng ốp la';
SELECT @ProdChaGio = id FROM Products WHERE [name] = N'Chả giò truyền thống';
SELECT @ProdChaGioTomCua = id FROM Products WHERE [name] = N'Chả giò tôm cua';
SELECT @ProdChaCaLV = id FROM Products WHERE [name] = N'Chả cá Lã Vọng';
SELECT @ProdChaCom = id FROM Products WHERE [name] = N'Chả cốm';
SELECT @ProdChaNemNuong = id FROM Products WHERE [name] = N'Chả nem nướng';
SELECT @ProdCheDauXanh = id FROM Products WHERE [name] = N'Chè đậu xanh';
SELECT @ProdCheDauDo = id FROM Products WHERE [name] = N'Chè đậu đỏ';
SELECT @ProdCheBuoi = id FROM Products WHERE [name] = N'Chè bưởi';
SELECT @ProdCheThai = id FROM Products WHERE [name] = N'Chè thái';
SELECT @ProdCheTroiNuoc = id FROM Products WHERE [name] = N'Chè trôi nước';
SELECT @ProdCheKhoaiMon = id FROM Products WHERE [name] = N'Chè khoai môn';
SELECT @ProdCheChuoi = id FROM Products WHERE [name] = N'Chè chuối';
SELECT @ProdBanhFlan = id FROM Products WHERE [name] = N'Bánh flan';
SELECT @ProdCaPheDen = id FROM Products WHERE [name] = N'Cà phê đen đá';
SELECT @ProdCaPheSua = id FROM Products WHERE [name] = N'Cà phê sữa đá';
SELECT @ProdCaPheBacXiu = id FROM Products WHERE [name] = N'Cà phê bạc xỉu';
SELECT @ProdTraDa = id FROM Products WHERE [name] = N'Trà đá';
SELECT @ProdTraChanh = id FROM Products WHERE [name] = N'Trà chanh';
SELECT @ProdChanhDay = id FROM Products WHERE [name] = N'Nước chanh dây';
SELECT @ProdNuocDua = id FROM Products WHERE [name] = N'Nước dừa tươi';
SELECT @ProdSinhToBo = id FROM Products WHERE [name] = N'Sinh tố bơ';
SELECT @ProdSinhToXoai = id FROM Products WHERE [name] = N'Sinh tố xoài';
SELECT @ProdNuocCam = id FROM Products WHERE [name] = N'Nước cam ép';
SELECT @ProdLauThai = id FROM Products WHERE [name] = N'Lẩu Thái';
SELECT @ProdLauCuaDong = id FROM Products WHERE [name] = N'Lẩu cua đồng';
SELECT @ProdLauGaLae = id FROM Products WHERE [name] = N'Lẩu gà lá é';
SELECT @ProdLauCaLang = id FROM Products WHERE [name] = N'Lẩu cá lăng';
SELECT @ProdLauTomChua = id FROM Products WHERE [name] = N'Lẩu tôm chua';

-- Công thức cho các món ăn (mẫu một số món phổ biến)
-- Phở bò tái
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdPhoBoTai, @IngBanhPho, 0.200),
(@ProdPhoBoTai, @IngBoThan, 0.150),
(@ProdPhoBoTai, @IngXuongBo, 0.500),
(@ProdPhoBoTai, @IngHanhLa, 0.020),
(@ProdPhoBoTai, @IngRauMui, 0.030),
(@ProdPhoBoTai, @IngRauHung, 0.030),
(@ProdPhoBoTai, @IngGiaDo, 0.050),
(@ProdPhoBoTai, @IngChanh, 0.050),
(@ProdPhoBoTai, @IngOtHiem, 0.010),
(@ProdPhoBoTai, @IngGung, 0.030),
(@ProdPhoBoTai, @IngCuHanhTim, 0.020),
(@ProdPhoBoTai, @IngBotNem, 0.010),
(@ProdPhoBoTai, @IngMuoi, 0.010),
(@ProdPhoBoTai, @IngDuong, 0.010);

-- Bún chả Hà Nội
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdBunCha, @IngBun, 0.200),
(@ProdBunCha, @IngHeoBaChi, 0.200),
(@ProdBunCha, @IngNuocMam, 0.050),
(@ProdBunCha, @IngDuong, 0.020),
(@ProdBunCha, @IngChanh, 0.030),
(@ProdBunCha, @IngToi, 0.010),
(@ProdBunCha, @IngOtHiem, 0.010),
(@ProdBunCha, @IngRauXaLach, 0.100),
(@ProdBunCha, @IngRauHung, 0.050),
(@ProdBunCha, @IngRauMui, 0.030);

-- Cơm tấm sườn nướng
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdComTamSuon, @IngGao, 0.200),
(@ProdComTamSuon, @IngHeoBaChi, 0.250),
(@ProdComTamSuon, @IngNuocMam, 0.030),
(@ProdComTamSuon, @IngDuong, 0.015),
(@ProdComTamSuon, @IngToi, 0.010),
(@ProdComTamSuon, @IngHanhLa, 0.010),
(@ProdComTamSuon, @IngDuaLeo, 0.100),
(@ProdComTamSuon, @IngCaChuaBi, 0.050);

-- Gỏi cuốn tôm thịt
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdGoiCuon, @IngBun, 0.100),
(@ProdGoiCuon, @IngTomTuoi, 0.100),
(@ProdGoiCuon, @IngHeoNac, 0.100),
(@ProdGoiCuon, @IngRauXaLach, 0.100),
(@ProdGoiCuon, @IngRauHung, 0.050),
(@ProdGoiCuon, @IngRauMui, 0.030),
(@ProdGoiCuon, @IngGiaDo, 0.050),
(@ProdGoiCuon, @IngNuocMam, 0.030),
(@ProdGoiCuon, @IngDuong, 0.015),
(@ProdGoiCuon, @IngChanh, 0.020);

-- Bánh mì thịt nướng
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdBanhMiThit, @IngBanhMi, 1.000),
(@ProdBanhMiThit, @IngHeoBaChi, 0.150),
(@ProdBanhMiThit, @IngChaLua, 0.050),
(@ProdBanhMiThit, @IngDuaLeo, 0.050),
(@ProdBanhMiThit, @IngRauMui, 0.020),
(@ProdBanhMiThit, @IngOtHiem, 0.010),
(@ProdBanhMiThit, @IngTuongOt, 0.010),
(@ProdBanhMiThit, @IngTuongDen, 0.010);

-- Chả giò truyền thống
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdChaGio, @IngHeoNac, 0.200),
(@ProdChaGio, @IngTomTuoi, 0.100),
(@ProdChaGio, @IngBapCai, 0.150),
(@ProdChaGio, @IngCuCai, 0.100),
(@ProdChaGio, @IngGiaDo, 0.050),
(@ProdChaGio, @IngToi, 0.010),
(@ProdChaGio, @IngHanhLa, 0.020),
(@ProdChaGio, @IngBotGao, 0.050),
(@ProdChaGio, @IngDauAn, 0.100);

-- Chè đậu xanh
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdCheDauXanh, @IngDauXanhCa, 0.150),
(@ProdCheDauXanh, @IngDuongPhen, 0.050),
(@ProdCheDauXanh, @IngNuocCotDua, 0.100),
(@ProdCheDauXanh, @IngLaDua, 0.010);

-- Cà phê sữa đá
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdCaPheSua, @IngCaPhe, 0.020),
(@ProdCaPheSua, @IngDuong, 0.015),
(@ProdCaPheSua, @IngNuocCotDua, 0.100),
(@ProdCaPheSua, @IngDaVien, 0.200);

-- Lẩu Thái
INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed)
VALUES
(@ProdLauThai, @IngTomTuoi, 0.300),
(@ProdLauThai, @IngCaBasa, 0.200),
(@ProdLauThai, @IngRauSong, 0.200),
(@ProdLauThai, @IngRauHung, 0.100),
(@ProdLauThai, @IngRauMui, 0.050),
(@ProdLauThai, @IngGiaDo, 0.100),
(@ProdLauThai, @IngChanh, 0.050),
(@ProdLauThai, @IngOtSung, 0.030),
(@ProdLauThai, @IngGung, 0.020),
(@ProdLauThai, @IngSa, 0.020),
(@ProdLauThai, @IngNuocMam, 0.050),
(@ProdLauThai, @IngDuong, 0.020);

PRINT N'   ✅ Đã thêm công thức cho các món ăn mới';
GO

-- ---
-- 5. TÍNH GIÁ VỐN CHO CÁC MÓN ĂN MỚI
-- ---
PRINT N'5️⃣ Đang tính giá vốn cho các món ăn mới...';
UPDATE Products
SET cost_price = (
    SELECT COALESCE(SUM(i.price * pi.quantity_needed), 0)
    FROM ProductIngredients pi
    INNER JOIN Ingredients i ON pi.ingredient_id = i.id
    WHERE pi.product_id = Products.id
)
WHERE cost_price = 0 OR cost_price IS NULL;
PRINT N'   ✅ Đã tính giá vốn cho tất cả món ăn mới';
GO

-- ---
-- HOÀN TẤT
-- ---
PRINT N'';
PRINT N'✅ ==========================================';
PRINT N'✅ HOÀN TẤT CHÈN DỮ LIỆU BỔ SUNG!';
PRINT N'✅ ==========================================';
PRINT N'';
PRINT N'📊 TÓM TẮT DỮ LIỆU ĐÃ THÊM:';
PRINT N'   ✅ 8 danh mục mới (Phở & Bún, Cơm, Gỏi & Nộm, Bánh mì,';
PRINT N'      Chả giò & Chả cá, Chè & Đồ ngọt, Đồ uống, Lẩu Việt Nam)';
PRINT N'   ✅ 60 nguyên liệu mới (đặc trưng Việt Nam)';
PRINT N'   ✅ 58 món ăn mới (phong phú đa dạng)';
PRINT N'   ✅ Công thức cho các món ăn mới';
PRINT N'   ✅ Đã tính giá vốn cho tất cả món ăn mới';
PRINT N'';
PRINT N'🎉 Nhà hàng của bạn giờ đã có menu phong phú hơn với';
PRINT N'   nhiều món ăn đặc trưng Việt Nam!';
PRINT N'';
GO

