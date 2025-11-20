package dao;

import model.Booking;
import model.RestaurantTable;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    
    // Tạo booking không cần chọn bàn (nhân viên sẽ sắp xếp sau)
    public boolean createBooking(Booking booking) {
        String sql = "INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, status, account_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, booking.getCustomerName());
                ps.setString(2, booking.getPhone());
                ps.setDate(3, booking.getBookingDate());
                ps.setTime(4, booking.getBookingTime());
                ps.setInt(5, booking.getNumPeople());
                ps.setString(6, booking.getNote());
                ps.setString(7, booking.getStatus());
                // Lưu account_id nếu có
                if (booking.getAccount() != null && booking.getAccount().getId() > 0) {
                    ps.setInt(8, booking.getAccount().getId());
                } else {
                    ps.setNull(8, Types.INTEGER);
                }
                
                int result = ps.executeUpdate();
                if (result > 0) {
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        int bookingId = rs.getInt(1);
                        System.out.println("✅ Booking created successfully with ID: " + bookingId + " (No table assigned - staff will arrange)");
                        return true;
                    }
                }
            } catch (SQLException e) {
                System.err.println("❌ Error creating booking: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Method cũ để tương thích (nếu cần)
    public boolean createBooking(Booking booking, List<Integer> tableIds) {
        String sql = "INSERT INTO Bookings (customer_name, phone, booking_date, booking_time, num_people, note, status, account_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, booking.getCustomerName());
                ps.setString(2, booking.getPhone());
                ps.setDate(3, booking.getBookingDate());
                ps.setTime(4, booking.getBookingTime());
                ps.setInt(5, booking.getNumPeople());
                ps.setString(6, booking.getNote());
                ps.setString(7, booking.getStatus());
                // Lưu account_id nếu có
                if (booking.getAccount() != null && booking.getAccount().getId() > 0) {
                    ps.setInt(8, booking.getAccount().getId());
                } else {
                    ps.setNull(8, Types.INTEGER);
                }
                
                int result = ps.executeUpdate();
                if (result > 0) {
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        int bookingId = rs.getInt(1);
                        
                        // Thêm vào bảng BookingTables
                        if (tableIds != null && !tableIds.isEmpty()) {
                            String tableSql = "INSERT INTO BookingTables (booking_id, table_id) VALUES (?, ?)";
                            try (PreparedStatement tablePs = conn.prepareStatement(tableSql)) {
                                for (Integer tableId : tableIds) {
                                    tablePs.setInt(1, bookingId);
                                    tablePs.setInt(2, tableId);
                                    tablePs.addBatch();
                                }
                                tablePs.executeBatch();
                            }
                            
                            // Cập nhật trạng thái bàn
                            String updateTableSql = "UPDATE RestaurantTables SET status = 'Reserved' WHERE id = ?";
                            try (PreparedStatement updatePs = conn.prepareStatement(updateTableSql)) {
                                for (Integer tableId : tableIds) {
                                    updatePs.setInt(1, tableId);
                                    updatePs.addBatch();
                                }
                                updatePs.executeBatch();
                            }
                        }
                        
                        conn.commit();
                        System.out.println("✅ Booking created successfully with ID: " + bookingId);
                        return true;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("❌ Error creating booking: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Kiểm tra booking đã tồn tại dựa trên thông tin
    public boolean bookingExists(String customerName, String phone, Date bookingDate, Time bookingTime) {
        String sql = "SELECT COUNT(*) FROM Bookings " +
                     "WHERE customer_name = ? AND phone = ? AND booking_date = ? AND booking_time = ? " +
                     "AND status != 'Canceled'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, customerName);
            ps.setString(2, phone);
            ps.setDate(3, bookingDate);
            ps.setTime(4, bookingTime);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Booking> getByAccountId(int accountId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.* FROM Bookings b " +
                     "INNER JOIN Orders o ON b.id = o.booking_id " +
                     "WHERE o.account_id = ? " +
                     "ORDER BY b.booking_date DESC, b.booking_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setPhone(rs.getString("phone"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setBookingTime(rs.getTime("booking_time"));
                booking.setNumPeople(rs.getInt("num_people"));
                booking.setNote(rs.getString("note"));
                booking.setStatus(rs.getString("status"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    booking.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    booking.setCreatedAt(rs.getDate("created_at"));
                }
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // Lấy danh sách booking theo số điện thoại (để khách hàng xem lịch sử đặt bàn)
    public List<Booking> getByPhone(String phone) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings " +
                     "WHERE phone = ? " +
                     "ORDER BY booking_date DESC, booking_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setPhone(rs.getString("phone"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setBookingTime(rs.getTime("booking_time"));
                booking.setNumPeople(rs.getInt("num_people"));
                booking.setNote(rs.getString("note"));
                booking.setStatus(rs.getString("status"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    booking.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    booking.setCreatedAt(rs.getDate("created_at"));
                }
                // Load account nếu có
                int accountId = rs.getInt("account_id");
                if (!rs.wasNull() && accountId > 0) {
                    AccountDAO accountDAO = new AccountDAO();
                    model.Account account = accountDAO.getById(accountId);
                    if (account != null) {
                        booking.setAccount(account);
                    }
                }
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // Lấy booking theo ID
    public Booking getById(int bookingId) {
        String sql = "SELECT * FROM Bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setPhone(rs.getString("phone"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setBookingTime(rs.getTime("booking_time"));
                booking.setNumPeople(rs.getInt("num_people"));
                booking.setNote(rs.getString("note"));
                booking.setStatus(rs.getString("status"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    booking.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    booking.setCreatedAt(rs.getDate("created_at"));
                }
                // Load account nếu có
                int accountId = rs.getInt("account_id");
                if (!rs.wasNull() && accountId > 0) {
                    AccountDAO accountDAO = new AccountDAO();
                    model.Account account = accountDAO.getById(accountId);
                    if (account != null) {
                        booking.setAccount(account);
                    }
                }
                return booking;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Gán bàn cho booking
    public boolean assignTablesToBooking(int bookingId, List<Integer> tableIds) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                // Lấy danh sách bàn cũ đã gán cho booking này (trước khi xóa) - sử dụng cùng connection
                List<Integer> oldTableIds = new ArrayList<>();
                String getOldTablesSql = "SELECT table_id FROM BookingTables WHERE booking_id = ?";
                try (PreparedStatement getOldPs = conn.prepareStatement(getOldTablesSql)) {
                    getOldPs.setInt(1, bookingId);
                    ResultSet rs = getOldPs.executeQuery();
                    while (rs.next()) {
                        oldTableIds.add(rs.getInt("table_id"));
                    }
                }
                
                // Xóa các bàn cũ đã gán cho booking này (nếu có)
                String deleteSql = "DELETE FROM BookingTables WHERE booking_id = ?";
                try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                    deletePs.setInt(1, bookingId);
                    deletePs.executeUpdate();
                }
                
                // Giải phóng các bàn cũ (cập nhật status về Available)
                if (!oldTableIds.isEmpty()) {
                    String releaseTableSql = "UPDATE RestaurantTables SET status = 'Available' WHERE id = ?";
                    try (PreparedStatement releasePs = conn.prepareStatement(releaseTableSql)) {
                        for (Integer oldTableId : oldTableIds) {
                            releasePs.setInt(1, oldTableId);
                            releasePs.addBatch();
                        }
                        releasePs.executeBatch();
                    }
                    System.out.println("✅ Released " + oldTableIds.size() + " old table(s) back to Available");
                }
                
                // Thêm các bàn mới vào BookingTables
                if (tableIds != null && !tableIds.isEmpty()) {
                    String insertSql = "INSERT INTO BookingTables (booking_id, table_id) VALUES (?, ?)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        for (Integer tableId : tableIds) {
                            insertPs.setInt(1, bookingId);
                            insertPs.setInt(2, tableId);
                            insertPs.addBatch();
                        }
                        insertPs.executeBatch();
                    }
                    
                    // Cập nhật trạng thái bàn mới thành Reserved
                    String updateTableSql = "UPDATE RestaurantTables SET status = 'Reserved' WHERE id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateTableSql)) {
                        for (Integer tableId : tableIds) {
                            updatePs.setInt(1, tableId);
                            updatePs.addBatch();
                        }
                        updatePs.executeBatch();
                    }
                    System.out.println("✅ Reserved " + tableIds.size() + " new table(s)");
                }
                
                // Cập nhật trạng thái booking thành Confirmed
                String updateBookingSql = "UPDATE Bookings SET status = 'Confirmed' WHERE id = ?";
                try (PreparedStatement updateBookingPs = conn.prepareStatement(updateBookingSql)) {
                    updateBookingPs.setInt(1, bookingId);
                    updateBookingPs.executeUpdate();
                }
                
                conn.commit();
                System.out.println("✅ Tables assigned to booking ID: " + bookingId);
                return true;
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("❌ Error assigning tables: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy danh sách bàn đã gán cho booking
    public List<Integer> getTableIdsByBookingId(int bookingId) {
        List<Integer> tableIds = new ArrayList<>();
        String sql = "SELECT table_id FROM BookingTables WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                tableIds.add(rs.getInt("table_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tableIds;
    }
    
    // Lấy bookingId từ tableId (để biết booking nào đang sử dụng bàn này)
    public List<Integer> getBookingIdsByTableId(int tableId) {
        List<Integer> bookingIds = new ArrayList<>();
        String sql = "SELECT booking_id FROM BookingTables WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                bookingIds.add(rs.getInt("booking_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookingIds;
    }
    
    // Giải phóng bàn khỏi booking (khi bàn được thay đổi status)
    public boolean releaseTableFromBooking(int tableId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                // Lấy danh sách booking đang sử dụng bàn này
                List<Integer> bookingIds = getBookingIdsByTableId(tableId);
                
                if (!bookingIds.isEmpty()) {
                    // Xóa relationship trong BookingTables
                    String deleteSql = "DELETE FROM BookingTables WHERE table_id = ?";
                    try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                        deletePs.setInt(1, tableId);
                        deletePs.executeUpdate();
                    }
                    
                    // Cập nhật status booking về Pending (chưa được xác nhận)
                    String updateBookingSql = "UPDATE Bookings SET status = 'Pending' WHERE id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateBookingSql)) {
                        for (Integer bookingId : bookingIds) {
                            updatePs.setInt(1, bookingId);
                            updatePs.addBatch();
                        }
                        updatePs.executeBatch();
                    }
                    
                    System.out.println("✅ Released table " + tableId + " from " + bookingIds.size() + " booking(s). Bookings updated to Pending.");
                }
                
                // Cập nhật status bàn về Available (trống)
                String updateTableSql = "UPDATE RestaurantTables SET status = 'Available' WHERE id = ?";
                try (PreparedStatement updateTablePs = conn.prepareStatement(updateTableSql)) {
                    updateTablePs.setInt(1, tableId);
                    updateTablePs.executeUpdate();
                }
                
                System.out.println("✅ Table " + tableId + " status updated to Available.");
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("❌ Error releasing table: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Hủy booking
    public boolean cancelBooking(int bookingId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                // Lấy danh sách bàn đã gán cho booking này
                List<Integer> tableIds = getTableIdsByBookingId(bookingId);
                
                // Giải phóng các bàn (cập nhật status về Available)
                if (!tableIds.isEmpty()) {
                    String releaseTableSql = "UPDATE RestaurantTables SET status = 'Available' WHERE id = ?";
                    try (PreparedStatement releasePs = conn.prepareStatement(releaseTableSql)) {
                        for (Integer tableId : tableIds) {
                            releasePs.setInt(1, tableId);
                            releasePs.addBatch();
                        }
                        releasePs.executeBatch();
                    }
                    
                    // Xóa relationship trong BookingTables
                    String deleteSql = "DELETE FROM BookingTables WHERE booking_id = ?";
                    try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                        deletePs.setInt(1, bookingId);
                        deletePs.executeUpdate();
                    }
                    
                    System.out.println("✅ Released " + tableIds.size() + " table(s) from canceled booking ID: " + bookingId);
                }
                
                // Cập nhật status booking thành Canceled
                String updateBookingSql = "UPDATE Bookings SET status = 'Canceled' WHERE id = ?";
                try (PreparedStatement updatePs = conn.prepareStatement(updateBookingSql)) {
                    updatePs.setInt(1, bookingId);
                    updatePs.executeUpdate();
                }
                
                conn.commit();
                System.out.println("✅ Booking ID: " + bookingId + " has been canceled");
                return true;
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("❌ Error canceling booking: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật status booking
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy các booking đang active (có hóa đơn đã kích hoạt) - cho hóa đơn hiện tại
    public List<Booking> getActiveBookings() {
        List<Booking> bookings = new ArrayList<>();
        // Chỉ lấy các booking có order (hóa đơn đã kích hoạt) và chưa thanh toán hoàn tất
        // Điều kiện: payment_status != 'Paid' VÀ order_status != 'Completed'
        // Không cần DISTINCT vì mỗi booking chỉ có 1 order (booking_id là UNIQUE trong Orders)
        String sql = "SELECT b.* FROM Bookings b " +
                     "INNER JOIN Orders o ON b.id = o.booking_id " +
                     "WHERE o.payment_status != 'Paid' " +
                     "AND o.order_status != 'Completed' " +
                     "AND o.order_status != 'Canceled' " +
                     "ORDER BY o.created_at DESC";
        
        System.out.println("🔍 Executing query: " + sql);
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("🔍 Query executed, processing results...");
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setPhone(rs.getString("phone"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setBookingTime(rs.getTime("booking_time"));
                booking.setNumPeople(rs.getInt("num_people"));
                booking.setNote(rs.getString("note"));
                booking.setStatus(rs.getString("status"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    booking.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    booking.setCreatedAt(rs.getDate("created_at"));
                }
                
                // Load tables cho booking này
                List<Integer> tableIds = getTableIdsByBookingId(booking.getId());
                if (!tableIds.isEmpty()) {
                    List<RestaurantTable> tables = new ArrayList<>();
                    RestaurantTableDAO tableDAO = new RestaurantTableDAO();
                    for (Integer tableId : tableIds) {
                        RestaurantTable table = tableDAO.getById(tableId);
                        if (table != null) {
                            tables.add(table);
                        }
                    }
                    booking.setTables(tables);
                    System.out.println("✅ Loaded " + tables.size() + " table(s) for booking #" + booking.getId());
                } else {
                    System.out.println("⚠️ No tables found for booking #" + booking.getId());
                }
                
                bookings.add(booking);
                System.out.println("✅ Added booking #" + booking.getId() + " to active list");
            }
            
            System.out.println("🔍 Total active bookings found: " + bookings.size());
        } catch (SQLException e) {
            System.err.println("❌ Error getting active bookings: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }
    
    // Lấy tất cả bookings (cho admin) - có load tables
    public List<Booking> getAll() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings ORDER BY booking_date DESC, booking_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setPhone(rs.getString("phone"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setBookingTime(rs.getTime("booking_time"));
                booking.setNumPeople(rs.getInt("num_people"));
                booking.setNote(rs.getString("note"));
                booking.setStatus(rs.getString("status"));
                // Lấy Timestamp để có cả giờ phút giây
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    booking.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    booking.setCreatedAt(rs.getDate("created_at"));
                }
                // Load account nếu có
                int accountId = rs.getInt("account_id");
                if (!rs.wasNull() && accountId > 0) {
                    AccountDAO accountDAO = new AccountDAO();
                    model.Account account = accountDAO.getById(accountId);
                    if (account != null) {
                        booking.setAccount(account);
                    }
                }
                
                // Load tables cho booking này
                List<Integer> tableIds = getTableIdsByBookingId(booking.getId());
                if (!tableIds.isEmpty()) {
                    List<RestaurantTable> tables = new ArrayList<>();
                    RestaurantTableDAO tableDAO = new RestaurantTableDAO();
                    for (Integer tableId : tableIds) {
                        RestaurantTable table = tableDAO.getById(tableId);
                        if (table != null) {
                            tables.add(table);
                        }
                    }
                    booking.setTables(tables);
                }
                
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    // Lấy số booking theo tháng/năm
    public int getBookingCountByMonthYear(int month, int year) {
        String sql = "SELECT COUNT(*) as count " +
                     "FROM Bookings " +
                     "WHERE MONTH(booking_date) = ? " +
                     "AND YEAR(booking_date) = ?";
        
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
    
    // Lấy số booking theo năm
    public int getBookingCountByYear(int year) {
        String sql = "SELECT COUNT(*) as count " +
                     "FROM Bookings " +
                     "WHERE YEAR(booking_date) = ?";
        
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
    
    // Tìm kiếm booking
    public List<Booking> search(String keyword) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings " +
                     "WHERE (customer_name LIKE ? OR phone LIKE ?) " +
                     "ORDER BY booking_date DESC, booking_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setPhone(rs.getString("phone"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setBookingTime(rs.getTime("booking_time"));
                booking.setNumPeople(rs.getInt("num_people"));
                booking.setNote(rs.getString("note"));
                booking.setStatus(rs.getString("status"));
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    booking.setCreatedAt(new Date(createdAt.getTime()));
                } else {
                    booking.setCreatedAt(rs.getDate("created_at"));
                }
                int accountId = rs.getInt("account_id");
                if (!rs.wasNull() && accountId > 0) {
                    AccountDAO accountDAO = new AccountDAO();
                    model.Account account = accountDAO.getById(accountId);
                    if (account != null) {
                        booking.setAccount(account);
                    }
                }
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}
