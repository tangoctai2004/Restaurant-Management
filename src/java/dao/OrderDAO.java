package dao;

import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderDAO {
    
    public int createOrder(Order order, List<CartItem> cartItems) {
        String sql = "INSERT INTO Orders (account_id, booking_id, promotion_id, subtotal, discount_amount, total_amount, " +
                     "payment_method, payment_status, order_status, note, created_at, cashier_id, paid_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                if (order.getAccount() != null) {
                    ps.setInt(1, order.getAccount().getId());
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                
                if (order.getBooking() != null) {
                    ps.setInt(2, order.getBooking().getId());
                } else {
                    ps.setNull(2, Types.INTEGER);
                }
                
                if (order.getPromotion() != null) {
                    ps.setInt(3, order.getPromotion().getId());
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                
                ps.setDouble(4, order.getSubtotal());
                ps.setDouble(5, order.getDiscountAmount());
                ps.setDouble(6, order.getTotalAmount());
                ps.setString(7, order.getPaymentMethod());
                ps.setString(8, order.getPaymentStatus());
                ps.setString(9, order.getOrderStatus());
                ps.setString(10, order.getNote());
                // Set created_at từ Java để đảm bảo timezone đúng
                Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                ps.setTimestamp(11, currentTime);
                
                // Cashier ID
                if (order.getCashier() != null && order.getCashier().getId() > 0) {
                    ps.setInt(12, order.getCashier().getId());
                } else {
                    ps.setNull(12, Types.INTEGER);
                }
                
                // Paid at
                if (order.getPaidAt() != null) {
                    ps.setTimestamp(13, new Timestamp(order.getPaidAt().getTime()));
                } else {
                    ps.setNull(13, Types.TIMESTAMP);
                }
                
                int result = ps.executeUpdate();
                if (result > 0) {
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        int orderId = rs.getInt(1);
                        
                        // Thêm OrderDetails (chỉ thêm nếu có items)
                        if (cartItems != null && !cartItems.isEmpty()) {
                            String detailSql = "INSERT INTO OrderDetails (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
                            try (PreparedStatement detailPs = conn.prepareStatement(detailSql)) {
                                for (CartItem item : cartItems) {
                                    detailPs.setInt(1, orderId);
                                    detailPs.setInt(2, item.getProduct().getId());
                                    detailPs.setInt(3, item.getQuantity());
                                    detailPs.setDouble(4, item.getPrice());
                                    detailPs.addBatch();
                                }
                                detailPs.executeBatch();
                            }
                        }
                        
                        conn.commit();
                        System.out.println("✅ Order created successfully with ID: " + orderId + (cartItems == null || cartItems.isEmpty() ? " (empty order)" : ""));
                        return orderId;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("❌ Error creating order: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }
    
    public List<Order> getByAccountId(int accountId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, a.full_name, a.email, a.phone " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "WHERE o.account_id = ? " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                
                Account account = new Account();
                account.setId(accountId);
                account.setFullName(rs.getString("full_name"));
                account.setEmail(rs.getString("email"));
                account.setPhone(rs.getString("phone"));
                order.setAccount(account);
                
                order.setSubtotal(rs.getDouble("subtotal"));
                order.setDiscountAmount(rs.getDouble("discount_amount"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setNote(rs.getString("note"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    java.sql.Date dateOnly = rs.getDate("created_at");
                    if (dateOnly != null) {
                        order.setCreatedAt(new Date(dateOnly.getTime()));
                    }
                }
                
                // Load order details
                order.setOrderDetails(getOrderDetails(order.getId()));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public Order getById(int id) {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "WHERE o.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                
                // Load booking nếu có
                int bookingId = rs.getInt("booking_id");
                if (!rs.wasNull() && bookingId > 0) {
                    Booking booking = new Booking();
                    booking.setId(bookingId);
                    order.setBooking(booking);
                }
                
                if (rs.getObject("account_id") != null) {
                    Account account = new Account();
                    account.setId(rs.getInt("account_id"));
                    account.setFullName(rs.getString("full_name"));
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    order.setAccount(account);
                }
                
                // Load cashier
                int cashierId = rs.getInt("cashier_id");
                if (!rs.wasNull() && cashierId > 0) {
                    Account cashier = new Account();
                    cashier.setId(cashierId);
                    cashier.setFullName(rs.getString("cashier_name"));
                    cashier.setUsername(rs.getString("cashier_username"));
                    order.setCashier(cashier);
                }
                
                order.setSubtotal(rs.getDouble("subtotal"));
                order.setDiscountAmount(rs.getDouble("discount_amount"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setTransactionRef(rs.getString("transaction_ref"));
                order.setNote(rs.getString("note"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    java.sql.Date dateOnly = rs.getDate("created_at");
                    if (dateOnly != null) {
                        order.setCreatedAt(new Date(dateOnly.getTime()));
                    }
                }
                // Load paid_at
                Timestamp paidAt = rs.getTimestamp("paid_at");
                if (paidAt != null) {
                    order.setPaidAt(new Date(paidAt.getTime()));
                }
                
                // Load order details (chỉ load nếu không phải hóa đơn cọc hoặc hoàn tiền)
                if (order.getNote() == null || (!order.getNote().equals("DEPOSIT") && !order.getNote().equals("REFUND"))) {
                order.setOrderDetails(getOrderDetails(order.getId()));
                } else {
                    // Hóa đơn cọc và hoàn tiền không có orderDetails
                    order.setOrderDetails(new ArrayList<>());
                }
                
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Order> getAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "b.customer_name as booking_customer_name, b.phone as booking_phone " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Bookings b ON o.booking_id = b.id " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                
                if (rs.getObject("account_id") != null) {
                    Account account = new Account();
                    account.setId(rs.getInt("account_id"));
                    account.setFullName(rs.getString("full_name"));
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    order.setAccount(account);
                }
                
                // Load booking nếu có
                if (rs.getObject("booking_id") != null) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("booking_id"));
                    booking.setCustomerName(rs.getString("booking_customer_name"));
                    booking.setPhone(rs.getString("booking_phone"));
                    order.setBooking(booking);
                }
                
                order.setSubtotal(rs.getDouble("subtotal"));
                order.setDiscountAmount(rs.getDouble("discount_amount"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setNote(rs.getString("note"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    java.sql.Date dateOnly = rs.getDate("created_at");
                    if (dateOnly != null) {
                        order.setCreatedAt(new Date(dateOnly.getTime()));
                    }
                }
                
                // Load order details
                order.setOrderDetails(getOrderDetails(order.getId()));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    // Kiểm tra xem một bàn có order chưa thanh toán không
    // Kiểm tra qua BookingTables (nếu bàn chưa được release) hoặc qua table status
    public boolean hasUnpaidOrder(int tableId) {
        // Cách 1: Kiểm tra qua BookingTables (nếu bàn vẫn còn trong BookingTables)
        String sql1 = "SELECT o.id FROM Orders o " +
                     "INNER JOIN Bookings b ON o.booking_id = b.id " +
                     "INNER JOIN BookingTables bt ON b.id = bt.booking_id " +
                     "WHERE bt.table_id = ? " +
                     "AND o.payment_status != 'Paid' " +
                     "AND o.order_status != 'Completed' " +
                     "AND o.order_status != 'Canceled'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql1)) {
            
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return true; // Có order chưa thanh toán
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Cách 2: Nếu bàn đã được release nhưng vẫn ở trạng thái Occupied,
        // kiểm tra xem có order nào của booking liên quan chưa thanh toán không
        // (kiểm tra qua table status - nếu status là Occupied thì có thể có order chưa thanh toán)
        // Logic này sẽ được xử lý ở AdminTablesServlet bằng cách kiểm tra status trước
        
        return false;
    }
    
    // Lấy order theo bookingId
    public Order getByBookingId(int bookingId) {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "WHERE o.booking_id = ? " +
                     "AND (o.note != 'DEPOSIT' OR o.note IS NULL) " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                
                if (rs.getObject("account_id") != null) {
                    Account account = new Account();
                    account.setId(rs.getInt("account_id"));
                    account.setFullName(rs.getString("full_name"));
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    order.setAccount(account);
                }
                
                // Load cashier
                int cashierId = rs.getInt("cashier_id");
                if (!rs.wasNull() && cashierId > 0) {
                    Account cashier = new Account();
                    cashier.setId(cashierId);
                    cashier.setFullName(rs.getString("cashier_name"));
                    cashier.setUsername(rs.getString("cashier_username"));
                    order.setCashier(cashier);
                }
                
                order.setSubtotal(rs.getDouble("subtotal"));
                order.setDiscountAmount(rs.getDouble("discount_amount"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setNote(rs.getString("note"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    java.sql.Date dateOnly = rs.getDate("created_at");
                    if (dateOnly != null) {
                        order.setCreatedAt(new Date(dateOnly.getTime()));
                    }
                }
                // Load paid_at
                Timestamp paidAt = rs.getTimestamp("paid_at");
                if (paidAt != null) {
                    order.setPaidAt(new Date(paidAt.getTime()));
                }
                
                // Load order details
                order.setOrderDetails(getOrderDetails(order.getId()));
                
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy hóa đơn hoàn tiền (REFUND) của booking
    public Order getRefundOrderByBookingId(int bookingId) {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "WHERE o.booking_id = ? AND o.note = 'REFUND' " +
                     "AND o.payment_status = 'Paid' " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                
                if (rs.getObject("account_id") != null) {
                    Account account = new Account();
                    account.setId(rs.getInt("account_id"));
                    account.setFullName(rs.getString("full_name"));
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    order.setAccount(account);
                }
                
                // Load cashier
                int cashierId = rs.getInt("cashier_id");
                if (!rs.wasNull() && cashierId > 0) {
                    Account cashier = new Account();
                    cashier.setId(cashierId);
                    cashier.setFullName(rs.getString("cashier_name"));
                    cashier.setUsername(rs.getString("cashier_username"));
                    order.setCashier(cashier);
                }
                
                // Load booking
                Booking booking = new Booking();
                booking.setId(bookingId);
                order.setBooking(booking);
                
                order.setSubtotal(rs.getDouble("subtotal"));
                order.setDiscountAmount(rs.getDouble("discount_amount"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setTransactionRef(rs.getString("transaction_ref"));
                order.setNote(rs.getString("note"));
                
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    java.sql.Date dateOnly = rs.getDate("created_at");
                    if (dateOnly != null) {
                        order.setCreatedAt(new Date(dateOnly.getTime()));
                    }
                }
                
                Timestamp paidAt = rs.getTimestamp("paid_at");
                if (paidAt != null) {
                    order.setPaidAt(new Date(paidAt.getTime()));
                }
                
                // Hóa đơn hoàn tiền không có orderDetails
                order.setOrderDetails(new ArrayList<>());
                
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy hóa đơn cọc (DEPOSIT) của booking
    public Order getDepositOrderByBookingId(int bookingId) {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "WHERE o.booking_id = ? AND o.note = 'DEPOSIT' " +
                     "AND o.payment_status = 'Paid' " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                
                if (rs.getObject("account_id") != null) {
                    Account account = new Account();
                    account.setId(rs.getInt("account_id"));
                    account.setFullName(rs.getString("full_name"));
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    order.setAccount(account);
                }
                
                // Load cashier
                int cashierId = rs.getInt("cashier_id");
                if (!rs.wasNull() && cashierId > 0) {
                    Account cashier = new Account();
                    cashier.setId(cashierId);
                    cashier.setFullName(rs.getString("cashier_name"));
                    cashier.setUsername(rs.getString("cashier_username"));
                    order.setCashier(cashier);
                }
                
                order.setSubtotal(rs.getDouble("subtotal"));
                order.setDiscountAmount(rs.getDouble("discount_amount"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setTransactionRef(rs.getString("transaction_ref"));
                order.setNote(rs.getString("note"));
                
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    java.sql.Date dateOnly = rs.getDate("created_at");
                    if (dateOnly != null) {
                        order.setCreatedAt(new Date(dateOnly.getTime()));
                    }
                }
                
                Timestamp paidAt = rs.getTimestamp("paid_at");
                if (paidAt != null) {
                    order.setPaidAt(new Date(paidAt.getTime()));
                }
                
                // Hóa đơn cọc không có orderDetails
                order.setOrderDetails(new ArrayList<>());
                
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy các orders đã hoàn thành và thanh toán - cho lịch sử hóa đơn (tất cả)
    public List<Order> getCompletedPaidOrders() {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username, " +
                     "p.code as promotion_code, p.description as promotion_description " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "LEFT JOIN Promotions p ON o.promotion_id = p.id " +
                     "WHERE o.order_status = 'Completed' AND o.payment_status = 'Paid' " +
                     "ORDER BY o.created_at DESC";
        
        return loadOrdersFromQuery(sql);
    }
    
    // Lấy hóa đơn cọc bàn (DEPOSIT)
    public List<Order> getDepositOrders() {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username, " +
                     "p.code as promotion_code, p.description as promotion_description " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "LEFT JOIN Promotions p ON o.promotion_id = p.id " +
                     "WHERE o.order_status = 'Completed' AND o.payment_status = 'Paid' " +
                     "AND o.note = 'DEPOSIT' " +
                     "ORDER BY o.created_at DESC";
        
        return loadOrdersFromQuery(sql);
    }
    
    // Lấy hóa đơn hoàn tiền (REFUND)
    public List<Order> getRefundOrders() {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username, " +
                     "p.code as promotion_code, p.description as promotion_description " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "LEFT JOIN Promotions p ON o.promotion_id = p.id " +
                     "WHERE o.order_status = 'Completed' AND o.payment_status = 'Paid' " +
                     "AND o.note = 'REFUND' " +
                     "ORDER BY o.created_at DESC";
        
        return loadOrdersFromQuery(sql);
    }
    
    // Lấy hóa đơn tại bàn (không phải DEPOSIT và REFUND)
    public List<Order> getTableOrders() {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username, " +
                     "p.code as promotion_code, p.description as promotion_description " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "LEFT JOIN Promotions p ON o.promotion_id = p.id " +
                     "WHERE o.order_status = 'Completed' AND o.payment_status = 'Paid' " +
                     "AND (o.note IS NULL OR (o.note != 'DEPOSIT' AND o.note != 'REFUND')) " +
                     "ORDER BY o.created_at DESC";
        
        return loadOrdersFromQuery(sql);
    }
    
    // Tìm kiếm hóa đơn cọc bàn
    public List<Order> searchDepositOrders(String keyword) {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username, " +
                     "p.code as promotion_code, p.description as promotion_description, " +
                     "b.customer_name as booking_customer_name, b.phone as booking_phone " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "LEFT JOIN Promotions p ON o.promotion_id = p.id " +
                     "LEFT JOIN Bookings b ON o.booking_id = b.id " +
                     "WHERE o.order_status = 'Completed' AND o.payment_status = 'Paid' " +
                     "AND o.note = 'DEPOSIT' " +
                     "AND (CAST(o.id AS NVARCHAR) LIKE ? " +
                     "     OR a.full_name LIKE ? OR a.phone LIKE ? " +
                     "     OR b.customer_name LIKE ? OR b.phone LIKE ?) " +
                     "ORDER BY o.created_at DESC";
        
        return loadOrdersFromQueryWithSearch(sql, keyword);
    }
    
    // Tìm kiếm hóa đơn hoàn tiền
    public List<Order> searchRefundOrders(String keyword) {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username, " +
                     "p.code as promotion_code, p.description as promotion_description, " +
                     "b.customer_name as booking_customer_name, b.phone as booking_phone " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "LEFT JOIN Promotions p ON o.promotion_id = p.id " +
                     "LEFT JOIN Bookings b ON o.booking_id = b.id " +
                     "WHERE o.order_status = 'Completed' AND o.payment_status = 'Paid' " +
                     "AND o.note = 'REFUND' " +
                     "AND (CAST(o.id AS NVARCHAR) LIKE ? " +
                     "     OR a.full_name LIKE ? OR a.phone LIKE ? " +
                     "     OR b.customer_name LIKE ? OR b.phone LIKE ?) " +
                     "ORDER BY o.created_at DESC";
        
        return loadOrdersFromQueryWithSearch(sql, keyword);
    }
    
    // Tìm kiếm hóa đơn tại bàn
    public List<Order> searchTableOrders(String keyword) {
        String sql = "SELECT o.*, a.full_name, a.email, a.phone, " +
                     "c.full_name as cashier_name, c.username as cashier_username, " +
                     "p.code as promotion_code, p.description as promotion_description, " +
                     "b.customer_name as booking_customer_name, b.phone as booking_phone " +
                     "FROM Orders o " +
                     "LEFT JOIN Accounts a ON o.account_id = a.id " +
                     "LEFT JOIN Accounts c ON o.cashier_id = c.id " +
                     "LEFT JOIN Promotions p ON o.promotion_id = p.id " +
                     "LEFT JOIN Bookings b ON o.booking_id = b.id " +
                     "WHERE o.order_status = 'Completed' AND o.payment_status = 'Paid' " +
                     "AND (o.note IS NULL OR (o.note != 'DEPOSIT' AND o.note != 'REFUND')) " +
                     "AND (CAST(o.id AS NVARCHAR) LIKE ? " +
                     "     OR a.full_name LIKE ? OR a.phone LIKE ? " +
                     "     OR b.customer_name LIKE ? OR b.phone LIKE ?) " +
                     "ORDER BY o.created_at DESC";
        
        return loadOrdersFromQueryWithSearch(sql, keyword);
    }
    
    // Helper method để load orders từ query với search
    private List<Order> loadOrdersFromQueryWithSearch(String sql, String keyword) {
        List<Order> orders = new ArrayList<>();
        String searchPattern = "%" + keyword + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Set 5 parameters cho search (id, account name, account phone, booking name, booking phone)
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                
                // Load booking nếu có
                int bookingId = rs.getInt("booking_id");
                if (!rs.wasNull() && bookingId > 0) {
                    Booking booking = new Booking();
                    booking.setId(bookingId);
                    // Load thông tin booking nếu có
                    String bookingCustomerName = rs.getString("booking_customer_name");
                    String bookingPhone = rs.getString("booking_phone");
                    if (bookingCustomerName != null) {
                        booking.setCustomerName(bookingCustomerName);
                    }
                    if (bookingPhone != null) {
                        booking.setPhone(bookingPhone);
                    }
                    order.setBooking(booking);
                }
                
                order.setSubtotal(rs.getDouble("subtotal"));
                order.setDiscountAmount(rs.getDouble("discount_amount"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setTransactionRef(rs.getString("transaction_ref"));
                order.setNote(rs.getString("note"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    java.sql.Date dateOnly = rs.getDate("created_at");
                    if (dateOnly != null) {
                        order.setCreatedAt(new Date(dateOnly.getTime()));
                    }
                }
                
                // Load account nếu có
                int accountId = rs.getInt("account_id");
                if (!rs.wasNull() && accountId > 0) {
                    Account account = new Account();
                    account.setId(accountId);
                    account.setFullName(rs.getString("full_name"));
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    order.setAccount(account);
                }
                
                // Load cashier nếu có
                int cashierId = rs.getInt("cashier_id");
                if (!rs.wasNull() && cashierId > 0) {
                    Account cashier = new Account();
                    cashier.setId(cashierId);
                    cashier.setFullName(rs.getString("cashier_name"));
                    cashier.setUsername(rs.getString("cashier_username"));
                    order.setCashier(cashier);
                }
                
                // Load paid_at
                Timestamp paidAt = rs.getTimestamp("paid_at");
                if (paidAt != null) {
                    order.setPaidAt(new Date(paidAt.getTime()));
                }
                
                // Load promotion nếu có
                int promotionId = rs.getInt("promotion_id");
                if (!rs.wasNull() && promotionId > 0) {
                    Promotion promotion = new Promotion();
                    promotion.setId(promotionId);
                    promotion.setCode(rs.getString("promotion_code"));
                    promotion.setDescription(rs.getString("promotion_description"));
                    order.setPromotion(promotion);
                }
                
                // Load order details (chỉ load nếu không phải hóa đơn cọc hoặc hoàn tiền)
                if (order.getNote() == null || (!order.getNote().equals("DEPOSIT") && !order.getNote().equals("REFUND"))) {
                    order.setOrderDetails(getOrderDetails(order.getId()));
                } else {
                    // Hóa đơn cọc và hoàn tiền không có orderDetails
                    order.setOrderDetails(new ArrayList<>());
                }
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    // Helper method để load orders từ query
    private List<Order> loadOrdersFromQuery(String sql) {
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                
                // Load booking nếu có
                int bookingId = rs.getInt("booking_id");
                if (!rs.wasNull() && bookingId > 0) {
                    Booking booking = new Booking();
                    booking.setId(bookingId);
                    order.setBooking(booking);
                }
                
                order.setSubtotal(rs.getDouble("subtotal"));
                order.setDiscountAmount(rs.getDouble("discount_amount"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setTransactionRef(rs.getString("transaction_ref"));
                order.setNote(rs.getString("note"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    java.sql.Date dateOnly = rs.getDate("created_at");
                    if (dateOnly != null) {
                        order.setCreatedAt(new Date(dateOnly.getTime()));
                    }
                }
                
                // Load account nếu có
                int accountId = rs.getInt("account_id");
                if (!rs.wasNull() && accountId > 0) {
                    Account account = new Account();
                    account.setId(accountId);
                    account.setFullName(rs.getString("full_name"));
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    order.setAccount(account);
                }
                
                // Load cashier nếu có
                int cashierId = rs.getInt("cashier_id");
                if (!rs.wasNull() && cashierId > 0) {
                    Account cashier = new Account();
                    cashier.setId(cashierId);
                    cashier.setFullName(rs.getString("cashier_name"));
                    cashier.setUsername(rs.getString("cashier_username"));
                    order.setCashier(cashier);
                }
                
                // Load paid_at
                Timestamp paidAt = rs.getTimestamp("paid_at");
                if (paidAt != null) {
                    order.setPaidAt(new Date(paidAt.getTime()));
                }
                
                // Load promotion nếu có
                int promotionId = rs.getInt("promotion_id");
                if (!rs.wasNull() && promotionId > 0) {
                    Promotion promotion = new Promotion();
                    promotion.setId(promotionId);
                    promotion.setCode(rs.getString("promotion_code"));
                    promotion.setDescription(rs.getString("promotion_description"));
                    order.setPromotion(promotion);
                }
                
                // Load order details (chỉ load nếu không phải hóa đơn cọc hoặc hoàn tiền)
                if (order.getNote() == null || (!order.getNote().equals("DEPOSIT") && !order.getNote().equals("REFUND"))) {
                order.setOrderDetails(getOrderDetails(order.getId()));
                } else {
                    // Hóa đơn cọc và hoàn tiền không có orderDetails
                    order.setOrderDetails(new ArrayList<>());
                }
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    // Cập nhật order
    public boolean updateOrder(Order order) {
        String sql = "UPDATE Orders SET payment_method = ?, payment_status = ?, order_status = ?, " +
                     "transaction_ref = ?, promotion_id = ?, discount_amount = ?, total_amount = ?, " +
                     "cashier_id = ?, paid_at = ?, note = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, order.getPaymentMethod());
            ps.setString(2, order.getPaymentStatus());
            ps.setString(3, order.getOrderStatus());
            ps.setString(4, order.getTransactionRef());
            
            // Promotion ID
            if (order.getPromotion() != null) {
                ps.setInt(5, order.getPromotion().getId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            
            // Discount amount
            ps.setDouble(6, order.getDiscountAmount());
            
            // Total amount (đã trừ discount)
            ps.setDouble(7, order.getTotalAmount());
            
            // Cashier ID
            if (order.getCashier() != null && order.getCashier().getId() > 0) {
                ps.setInt(8, order.getCashier().getId());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            
            // Paid at
            if (order.getPaidAt() != null) {
                ps.setTimestamp(9, new Timestamp(order.getPaidAt().getTime()));
            } else {
                ps.setNull(9, Types.TIMESTAMP);
            }
            
            // Note
            ps.setString(10, order.getNote());
            
            ps.setInt(11, order.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        // Load is_completed nếu có, nếu không thì mặc định false
        String sql = "SELECT od.*, p.name, p.image_url, " +
                     "CASE WHEN od.is_completed IS NULL THEN 0 ELSE od.is_completed END as is_completed " +
                     "FROM OrderDetails od " +
                     "INNER JOIN Products p ON od.product_id = p.id " +
                     "WHERE od.order_id = ? " +
                     "ORDER BY od.id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setId(rs.getInt("id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPrice(rs.getDouble("price"));
                detail.setCompleted(rs.getBoolean("is_completed"));
                
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setImageUrl(rs.getString("image_url"));
                detail.setProduct(product);
                
                details.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }
    
    // Thêm món vào order hiện tại
    public boolean addItemToOrder(int orderId, int productId, int quantity, double price) {
        String sql = "INSERT INTO OrderDetails (order_id, product_id, quantity, price, is_completed) " +
                     "VALUES (?, ?, ?, ?, 0)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setDouble(4, price);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Kiểm tra món đã có trong order chưa (chỉ lấy món chưa lên để thêm vào)
    public OrderDetail getOrderDetailByProduct(int orderId, int productId) {
        String sql = "SELECT od.*, p.name, p.image_url, " +
                     "CASE WHEN od.is_completed IS NULL THEN 0 ELSE od.is_completed END as is_completed " +
                     "FROM OrderDetails od " +
                     "INNER JOIN Products p ON od.product_id = p.id " +
                     "WHERE od.order_id = ? AND od.product_id = ? " +
                     "AND (od.is_completed = 0 OR od.is_completed IS NULL) " +
                     "ORDER BY od.id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setId(rs.getInt("id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPrice(rs.getDouble("price"));
                detail.setCompleted(rs.getBoolean("is_completed"));
                
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setImageUrl(rs.getString("image_url"));
                detail.setProduct(product);
                
                return detail;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Kiểm tra xem có món đã lên không (để biết có cần tách record không)
    public OrderDetail getCompletedOrderDetailByProduct(int orderId, int productId) {
        String sql = "SELECT od.*, p.name, p.image_url, " +
                     "CASE WHEN od.is_completed IS NULL THEN 0 ELSE od.is_completed END as is_completed " +
                     "FROM OrderDetails od " +
                     "INNER JOIN Products p ON od.product_id = p.id " +
                     "WHERE od.order_id = ? AND od.product_id = ? " +
                     "AND od.is_completed = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setId(rs.getInt("id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPrice(rs.getDouble("price"));
                detail.setCompleted(rs.getBoolean("is_completed"));
                
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setImageUrl(rs.getString("image_url"));
                detail.setProduct(product);
                
                return detail;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Cập nhật số lượng
    public boolean updateQuantity(int detailId, int quantity) {
        String sql = "UPDATE OrderDetails SET quantity = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quantity);
            ps.setInt(2, detailId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Xóa món khỏi order
    public boolean removeItem(int detailId) {
        String sql = "DELETE FROM OrderDetails WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, detailId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy OrderDetail theo ID
    public OrderDetail getOrderDetailById(int detailId) {
        String sql = "SELECT od.*, p.name, p.image_url, " +
                     "CASE WHEN od.is_completed IS NULL THEN 0 ELSE od.is_completed END as is_completed " +
                     "FROM OrderDetails od " +
                     "INNER JOIN Products p ON od.product_id = p.id " +
                     "WHERE od.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, detailId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setId(rs.getInt("id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPrice(rs.getDouble("price"));
                detail.setCompleted(rs.getBoolean("is_completed"));
                
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setImageUrl(rs.getString("image_url"));
                detail.setProduct(product);
                
                return detail;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Toggle completed status
    public boolean toggleCompleted(int detailId, boolean completed) {
        String sql = "UPDATE OrderDetails SET is_completed = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, completed);
            ps.setInt(2, detailId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Xóa tất cả món chưa lên (is_completed = 0 hoặc NULL)
    public boolean deleteAllUncompletedItems(int orderId) {
        String sql = "DELETE FROM OrderDetails WHERE order_id = ? AND (is_completed = 0 OR is_completed IS NULL)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            return ps.executeUpdate() >= 0; // >= 0 vì có thể không có món nào để xóa
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Tính lại tổng tiền order
    public boolean recalculateOrderTotal(int orderId) {
        String sql = "UPDATE Orders SET subtotal = (" +
                     "    SELECT COALESCE(SUM(price * quantity), 0) " +
                     "    FROM OrderDetails " +
                     "    WHERE order_id = ?" +
                     "), total_amount = (" +
                     "    SELECT COALESCE(SUM(price * quantity), 0) - COALESCE(discount_amount, 0) " +
                     "    FROM OrderDetails " +
                     "    WHERE order_id = ?" +
                     ") " +
                     "WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ps.setInt(2, orderId);
            ps.setInt(3, orderId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy doanh thu theo tháng/năm
    // Doanh thu = Tổng hóa đơn tại bàn + Tổng hóa đơn cọc - Tổng hóa đơn hoàn tiền
    public double getRevenueByMonthYear(int month, int year) {
        String sql = "SELECT " +
                     "COALESCE(SUM(CASE WHEN (note IS NULL OR (note != 'DEPOSIT' AND note != 'REFUND')) THEN total_amount ELSE 0 END), 0) + " +
                     "COALESCE(SUM(CASE WHEN note = 'DEPOSIT' THEN total_amount ELSE 0 END), 0) - " +
                     "COALESCE(SUM(CASE WHEN note = 'REFUND' THEN total_amount ELSE 0 END), 0) as revenue " +
                     "FROM Orders " +
                     "WHERE payment_status = 'Paid' " +
                     "AND order_status = 'Completed' " +
                     "AND MONTH(created_at) = ? " +
                     "AND YEAR(created_at) = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("revenue");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy doanh thu theo năm
    // Doanh thu = Tổng hóa đơn tại bàn + Tổng hóa đơn cọc - Tổng hóa đơn hoàn tiền
    public double getRevenueByYear(int year) {
        String sql = "SELECT " +
                     "COALESCE(SUM(CASE WHEN (note IS NULL OR (note != 'DEPOSIT' AND note != 'REFUND')) THEN total_amount ELSE 0 END), 0) + " +
                     "COALESCE(SUM(CASE WHEN note = 'DEPOSIT' THEN total_amount ELSE 0 END), 0) - " +
                     "COALESCE(SUM(CASE WHEN note = 'REFUND' THEN total_amount ELSE 0 END), 0) as revenue " +
                     "FROM Orders " +
                     "WHERE payment_status = 'Paid' " +
                     "AND order_status = 'Completed' " +
                     "AND YEAR(created_at) = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("revenue");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy dữ liệu doanh thu theo từng tháng trong năm
    // Doanh thu = Tổng hóa đơn tại bàn + Tổng hóa đơn cọc - Tổng hóa đơn hoàn tiền
    public List<MonthlyRevenue> getMonthlyRevenueByYear(int year) {
        List<MonthlyRevenue> monthlyRevenues = new ArrayList<>();
        String sql = "SELECT MONTH(created_at) as month, " +
                     "COALESCE(SUM(CASE WHEN (note IS NULL OR (note != 'DEPOSIT' AND note != 'REFUND')) THEN total_amount ELSE 0 END), 0) + " +
                     "COALESCE(SUM(CASE WHEN note = 'DEPOSIT' THEN total_amount ELSE 0 END), 0) - " +
                     "COALESCE(SUM(CASE WHEN note = 'REFUND' THEN total_amount ELSE 0 END), 0) as revenue " +
                     "FROM Orders " +
                     "WHERE payment_status = 'Paid' " +
                     "AND order_status = 'Completed' " +
                     "AND YEAR(created_at) = ? " +
                     "GROUP BY MONTH(created_at) " +
                     "ORDER BY MONTH(created_at)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                MonthlyRevenue mr = new MonthlyRevenue();
                mr.setMonth(rs.getInt("month"));
                mr.setRevenue(rs.getDouble("revenue"));
                monthlyRevenues.add(mr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return monthlyRevenues;
    }
    
    // Lấy số đơn hàng theo tháng/năm (chỉ tính hóa đơn tại bàn, không tính cọc và hoàn tiền)
    public int getOrderCountByMonthYear(int month, int year) {
        String sql = "SELECT COUNT(*) as count " +
                     "FROM Orders " +
                     "WHERE payment_status = 'Paid' " +
                     "AND order_status = 'Completed' " +
                     "AND (note IS NULL OR (note != 'DEPOSIT' AND note != 'REFUND')) " +
                     "AND MONTH(created_at) = ? " +
                     "AND YEAR(created_at) = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy số đơn hàng theo năm
    public int getOrderCountByYear(int year) {
        String sql = "SELECT COUNT(*) as count " +
                     "FROM Orders " +
                     "WHERE payment_status = 'Paid' " +
                     "AND order_status = 'Completed' " +
                     "AND YEAR(created_at) = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Tính tổng chi phí (giá vốn) của các đơn hàng theo tháng/năm
    public double getTotalCostByMonthYear(int month, int year) {
        String sql = "SELECT COALESCE(SUM(p.cost_price * od.quantity), 0) as total_cost " +
                     "FROM Orders o " +
                     "INNER JOIN OrderDetails od ON o.id = od.order_id " +
                     "INNER JOIN Products p ON od.product_id = p.id " +
                     "WHERE o.payment_status = 'Paid' " +
                     "AND o.order_status = 'Completed' " +
                     "AND MONTH(o.created_at) = ? " +
                     "AND YEAR(o.created_at) = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total_cost");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Tính tổng chi phí (giá vốn) của các đơn hàng theo năm (cho biểu đồ)
    public List<MonthlyCost> getMonthlyCostByYear(int year) {
        List<MonthlyCost> monthlyCosts = new ArrayList<>();
        String sql = "SELECT MONTH(o.created_at) as month, " +
                     "COALESCE(SUM(p.cost_price * od.quantity), 0) as total_cost " +
                     "FROM Orders o " +
                     "INNER JOIN OrderDetails od ON o.id = od.order_id " +
                     "INNER JOIN Products p ON od.product_id = p.id " +
                     "WHERE o.payment_status = 'Paid' " +
                     "AND o.order_status = 'Completed' " +
                     "AND YEAR(o.created_at) = ? " +
                     "GROUP BY MONTH(o.created_at) " +
                     "ORDER BY MONTH(o.created_at)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                MonthlyCost mc = new MonthlyCost();
                mc.setMonth(rs.getInt("month"));
                mc.setCost(rs.getDouble("total_cost"));
                monthlyCosts.add(mc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return monthlyCosts;
    }
    
    // Inner class để lưu dữ liệu doanh thu theo tháng
    public static class MonthlyRevenue {
        private int month;
        private double revenue;
        
        public int getMonth() {
            return month;
        }
        
        public void setMonth(int month) {
            this.month = month;
        }
        
        public double getRevenue() {
            return revenue;
        }
        
        public void setRevenue(double revenue) {
            this.revenue = revenue;
        }
    }
    
    // Inner class để lưu dữ liệu chi phí theo tháng
    public static class MonthlyCost {
        private int month;
        private double cost;
        
        public int getMonth() {
            return month;
        }
        
        public void setMonth(int month) {
            this.month = month;
        }
        
        public double getCost() {
            return cost;
        }
        
        public void setCost(double cost) {
            this.cost = cost;
        }
    }
}



