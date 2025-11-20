--=================================================================
-- FILE 1: CREATE TABLE - TẠO CẤU TRÚC BẢNG
-- CSDL: SQL Server
-- MÔ TẢ: Script này tạo database và tất cả các bảng, constraints, indexes
-- SỬ DỤNG: Chạy file này TRƯỚC file InsertData.sql
--=================================================================

-- ---
-- BƯỚC 1: TẠO HOẶC SỬ DỤNG CSDL
-- ---
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'QLNhaHang')
BEGIN
    CREATE DATABASE QLNhaHang;
    PRINT N'✅ Đã tạo database QLNhaHang';
END
ELSE
BEGIN
    PRINT N'ℹ️ Database QLNhaHang đã tồn tại';
END
GO

USE QLNhaHang;
GO

-- ---
-- BƯỚC 2: XÓA CÁC BẢNG HIỆN TẠI (NẾU CÓ)
-- ---
PRINT N'🗑️ Đang xóa các bảng cũ (nếu có)...';

-- Xóa theo thứ tự để tránh lỗi foreign key
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.ProductIngredients', 'U') IS NOT NULL DROP TABLE dbo.ProductIngredients;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Ingredients', 'U') IS NOT NULL DROP TABLE dbo.Ingredients;
IF OBJECT_ID('dbo.BookingTables', 'U') IS NOT NULL DROP TABLE dbo.BookingTables;
IF OBJECT_ID('dbo.Bookings', 'U') IS NOT NULL DROP TABLE dbo.Bookings;
IF OBJECT_ID('dbo.RestaurantTables', 'U') IS NOT NULL DROP TABLE dbo.RestaurantTables;
IF OBJECT_ID('dbo.Promotions', 'U') IS NOT NULL DROP TABLE dbo.Promotions;
IF OBJECT_ID('dbo.Posts', 'U') IS NOT NULL DROP TABLE dbo.Posts;
IF OBJECT_ID('dbo.RestaurantSettings', 'U') IS NOT NULL DROP TABLE dbo.RestaurantSettings;
IF OBJECT_ID('dbo.RolePermissions', 'U') IS NOT NULL DROP TABLE dbo.RolePermissions;
IF OBJECT_ID('dbo.Permissions', 'U') IS NOT NULL DROP TABLE dbo.Permissions;
IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL DROP TABLE dbo.Roles;
IF OBJECT_ID('dbo.Accounts', 'U') IS NOT NULL DROP TABLE dbo.Accounts;
GO

PRINT N'✅ Đã xóa các bảng cũ (nếu có)';
GO

-- ---
-- BƯỚC 3: TẠO CẤU TRÚC BẢNG
-- ---
PRINT N'📋 Đang tạo các bảng...';

-- Bảng 1: Roles (Vai trò)
CREATE TABLE Roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);
PRINT N'   ✅ Đã tạo bảng Roles';
GO

-- Bảng 2: Permissions (Quyền)
CREATE TABLE Permissions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255)
);
PRINT N'   ✅ Đã tạo bảng Permissions';
GO

-- Bảng 3: RolePermissions (Quyền của từng vai trò)
CREATE TABLE RolePermissions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES Roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES Permissions(id) ON DELETE CASCADE,
    UNIQUE(role_id, permission_id)
);
PRINT N'   ✅ Đã tạo bảng RolePermissions';
GO

-- Bảng 4: Accounts (Tài khoản)
CREATE TABLE Accounts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    [password] VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    [role] INT NOT NULL DEFAULT 0, -- 0 = User, 1 = Admin, 2 = Staff (giữ lại để tương thích)
    role_id INT, -- Foreign key đến Roles
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);
PRINT N'   ✅ Đã tạo bảng Accounts';
GO

-- Bảng 5: Promotions (Khuyến mãi)
CREATE TABLE Promotions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [code] VARCHAR(20) UNIQUE NOT NULL,
    [description] NVARCHAR(255),
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('Percent', 'FixedAmount')),
    discount_value DECIMAL(18, 0) NOT NULL,
    min_order_value DECIMAL(18, 0) DEFAULT 0,
    max_discount_amount DECIMAL(18, 0),
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    is_active BIT DEFAULT 1
);
PRINT N'   ✅ Đã tạo bảng Promotions';
GO

-- Bảng 6: RestaurantTables (Quản lý Bàn)
CREATE TABLE RestaurantTables (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    [location_area] NVARCHAR(100),
    [status] VARCHAR(20) NOT NULL DEFAULT 'Available' CHECK ([status] IN ('Available', 'Occupied', 'Reserved', 'Maintenance'))
);
PRINT N'   ✅ Đã tạo bảng RestaurantTables';
GO

-- Bảng 7: Bookings (Thông tin đặt bàn)
CREATE TABLE Bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    num_people INT NOT NULL,
    note NVARCHAR(500),
    [status] VARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK ([status] IN ('Pending', 'Confirmed', 'Canceled', 'Completed', 'NoShow')),
    created_at DATETIME DEFAULT GETDATE(),
    account_id INT NULL,
    -- Thông tin thanh toán cọc bàn
    payment_method NVARCHAR(50) NULL,
    payment_status VARCHAR(20) NULL DEFAULT 'Unpaid' CHECK (payment_status IN ('Unpaid', 'Paid', 'Failed', 'Refunded')),
    transaction_ref VARCHAR(100) NULL,
    paid_at DATETIME NULL,
    -- Thông tin hoàn tiền
    refund_status VARCHAR(20) NULL DEFAULT 'Unrefunded' CHECK (refund_status IN ('Unrefunded', 'Pending', 'Refunded', 'Failed')),
    refund_amount DECIMAL(18, 0) NULL DEFAULT 0,
    refunded_at DATETIME NULL,
    refund_note NVARCHAR(500) NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(id) ON DELETE SET NULL
);
PRINT N'   ✅ Đã tạo bảng Bookings';
GO

-- Bảng 8: BookingTables (Bảng map: Đặt bàn X dùng những bàn Y, Z)
CREATE TABLE BookingTables (
    booking_id INT NOT NULL,
    table_id INT NOT NULL,
    PRIMARY KEY (booking_id, table_id),
    FOREIGN KEY (booking_id) REFERENCES Bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES RestaurantTables(id)
);
PRINT N'   ✅ Đã tạo bảng BookingTables';
GO

-- Bảng 9: Ingredients (Nguyên vật liệu)
CREATE TABLE Ingredients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) NOT NULL,
    unit NVARCHAR(20) NOT NULL,
    price DECIMAL(18, 0) DEFAULT 0
);
PRINT N'   ✅ Đã tạo bảng Ingredients';
GO

-- Bảng 10: Categories (Danh mục món ăn)
CREATE TABLE Categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) NOT NULL,
    [description] NVARCHAR(255)
);
PRINT N'   ✅ Đã tạo bảng Categories';
GO

-- Bảng 11: Products (Món ăn)
CREATE TABLE Products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT,
    [name] NVARCHAR(100) NOT NULL,
    [description] NVARCHAR(1000),
    price DECIMAL(18, 0) NOT NULL,
    cost_price DECIMAL(18, 0) DEFAULT 0,
    image_url VARCHAR(500),
    is_active BIT DEFAULT 1,
    FOREIGN KEY (category_id) REFERENCES Categories(id)
);
PRINT N'   ✅ Đã tạo bảng Products';
GO

-- Bảng 12: ProductIngredients (Định lượng: Món X cần Nguyên liệu Y)
CREATE TABLE ProductIngredients (
    product_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity_needed DECIMAL(10, 3) NOT NULL,
    PRIMARY KEY (product_id, ingredient_id),
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(id) ON DELETE CASCADE
);
PRINT N'   ✅ Đã tạo bảng ProductIngredients';
GO

-- Bảng 13: Orders (Hóa đơn)
CREATE TABLE Orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    account_id INT NULL,
    booking_id INT NULL,
    promotion_id INT NULL,
    subtotal DECIMAL(18, 0) NOT NULL,
    discount_amount DECIMAL(18, 0) DEFAULT 0,
    total_amount DECIMAL(18, 0) NOT NULL,
    payment_method NVARCHAR(50),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Unpaid' CHECK (payment_status IN ('Unpaid', 'Paid', 'Failed', 'Refunded')),
    order_status VARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (order_status IN ('Pending', 'Confirmed', 'Cooking', 'Ready', 'Completed', 'Canceled')),
    transaction_ref VARCHAR(100),
    note NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    cashier_id INT NULL,
    paid_at DATETIME NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(id) ON DELETE SET NULL,
    FOREIGN KEY (booking_id) REFERENCES Bookings(id) ON DELETE SET NULL,
    FOREIGN KEY (promotion_id) REFERENCES Promotions(id) ON DELETE SET NULL,
    FOREIGN KEY (cashier_id) REFERENCES Accounts(id) ON DELETE NO ACTION
);
PRINT N'   ✅ Đã tạo bảng Orders';
GO

-- Bảng 14: OrderDetails (Chi tiết hóa đơn)
CREATE TABLE OrderDetails (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(18, 0) NOT NULL,
    is_completed BIT DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES Orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE NO ACTION
);
PRINT N'   ✅ Đã tạo bảng OrderDetails';
GO

-- Bảng 15: Posts (Bài viết chi tiết món ăn)
CREATE TABLE Posts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    content NTEXT NOT NULL,
    featured_image NVARCHAR(500),
    author_id INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Draft' CHECK (status IN ('Published', 'Draft')),
    view_count INT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Accounts(id)
);
PRINT N'   ✅ Đã tạo bảng Posts';
GO

-- Bảng 16: RestaurantSettings (Thiết lập nhà hàng - Tùy chỉnh giao diện)
CREATE TABLE RestaurantSettings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL,
    setting_value NVARCHAR(MAX),
    page_name VARCHAR(50) NOT NULL,
    description NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_RestaurantSettings_Key_Page UNIQUE (setting_key, page_name)
);
PRINT N'   ✅ Đã tạo bảng RestaurantSettings';
GO

-- ---
-- BƯỚC 4: TẠO INDEXES
-- ---
PRINT N'📊 Đang tạo indexes...';

CREATE INDEX IX_RestaurantSettings_PageName ON RestaurantSettings(page_name);
CREATE INDEX IX_RestaurantSettings_SettingKey ON RestaurantSettings(setting_key);
CREATE INDEX IX_Accounts_Username ON Accounts(username);
CREATE INDEX IX_Accounts_Email ON Accounts(email);
CREATE INDEX IX_Accounts_RoleId ON Accounts(role_id);
CREATE INDEX IX_Products_CategoryId ON Products(category_id);
CREATE INDEX IX_Orders_AccountId ON Orders(account_id);
CREATE INDEX IX_Orders_BookingId ON Orders(booking_id);
CREATE INDEX IX_Orders_CreatedAt ON Orders(created_at);
CREATE INDEX IX_Bookings_AccountId ON Bookings(account_id);
CREATE INDEX IX_Bookings_BookingDate ON Bookings(booking_date);
CREATE INDEX IX_Bookings_Status ON Bookings([status]);
CREATE INDEX IX_OrderDetails_OrderId ON OrderDetails(order_id);
CREATE INDEX IX_OrderDetails_ProductId ON OrderDetails(product_id);
CREATE INDEX IX_Posts_ProductId ON Posts(product_id);
CREATE INDEX IX_Posts_AuthorId ON Posts(author_id);
CREATE INDEX IX_Posts_Status ON Posts(status);

PRINT N'   ✅ Đã tạo tất cả indexes';
GO

-- ---
-- HOÀN TẤT
-- ---
PRINT N'';
PRINT N'✅ ==========================================';
PRINT N'✅ HOÀN TẤT TẠO CẤU TRÚC BẢNG!';
PRINT N'✅ ==========================================';
PRINT N'';
PRINT N'📋 Đã tạo:';
PRINT N'   - 16 bảng (Roles, Permissions, RolePermissions, Accounts, Promotions,';
PRINT N'     RestaurantTables, Bookings, BookingTables, Ingredients, Categories,';
PRINT N'     Products, ProductIngredients, Orders, OrderDetails, Posts, RestaurantSettings)';
PRINT N'   - Tất cả foreign keys và constraints';
PRINT N'   - Tất cả indexes cần thiết';
PRINT N'';
PRINT N'📝 BƯỚC TIẾP THEO: Chạy file InsertData.sql để chèn dữ liệu mẫu';
PRINT N'';
GO

