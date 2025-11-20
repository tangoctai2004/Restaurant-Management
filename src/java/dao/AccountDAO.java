package dao;

import model.Account;
import model.Permission;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {
    
    public Account login(String username, String password) {
        String sql = "SELECT * FROM Accounts WHERE username = ? AND password = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setId(rs.getInt("id"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setFullName(rs.getString("full_name"));
                account.setEmail(rs.getString("email"));
                account.setPhone(rs.getString("phone"));
                account.setRole(rs.getInt("role"));
                account.setActive(rs.getBoolean("is_active"));
                account.setCreatedAt(rs.getDate("created_at"));
                
                return account;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy permissions của account dựa trên role_id
    public List<Permission> getPermissionsByAccountId(int accountId) {
        List<Permission> permissions = new ArrayList<>();
        String sql = "SELECT p.* " +
                     "FROM Permissions p " +
                     "INNER JOIN RolePermissions rp ON p.id = rp.permission_id " +
                     "INNER JOIN Accounts a ON rp.role_id = a.role_id " +
                     "WHERE a.id = ? " +
                     "ORDER BY p.code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Permission permission = new Permission();
                permission.setId(rs.getInt("id"));
                permission.setCode(rs.getString("code"));
                permission.setName(rs.getString("name"));
                permission.setDescription(rs.getString("description"));
                permissions.add(permission);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissions;
    }
    
    // Kiểm tra account có permission không
    public boolean hasPermission(int accountId, String permissionCode) {
        String sql = "SELECT COUNT(*) as count " +
                     "FROM Permissions p " +
                     "INNER JOIN RolePermissions rp ON p.id = rp.permission_id " +
                     "INNER JOIN Accounts a ON rp.role_id = a.role_id " +
                     "WHERE a.id = ? AND p.code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ps.setString(2, permissionCode);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean register(Account account) {
        // account.getRole() giờ là role_id từ Roles table
        Integer roleId = account.getRole();
        int legacyRole = 0; // Mặc định là khách hàng
        
        // Xác định legacy role dựa trên role_id
        // role_id = 1: Khách hàng -> legacy role = 0
        // role_id = 2: Admin -> legacy role = 1
        // role_id = 3: Nhân viên -> legacy role = 2
        // role_id > 3: Các role tùy chỉnh -> legacy role = 2 (nhân viên)
        if (roleId == 1) {
            legacyRole = 0; // Khách hàng
        } else if (roleId == 2) {
            legacyRole = 1; // Admin
        } else {
            legacyRole = 2; // Nhân viên hoặc role tùy chỉnh
        }
        
        String sql = "INSERT INTO Accounts (username, password, full_name, email, phone, role, role_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getFullName());
            ps.setString(4, account.getEmail());
            ps.setString(5, account.getPhone());
            ps.setInt(6, legacyRole);
            ps.setInt(7, roleId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Accounts WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Account getById(int id) {
        String sql = "SELECT a.*, r.name as role_name " +
                     "FROM Accounts a " +
                     "LEFT JOIN Roles r ON a.role_id = r.id " +
                     "WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setId(rs.getInt("id"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setFullName(rs.getString("full_name"));
                account.setEmail(rs.getString("email"));
                account.setPhone(rs.getString("phone"));
                account.setRole(rs.getInt("role"));
                account.setActive(rs.getBoolean("is_active"));
                account.setCreatedAt(rs.getDate("created_at"));
                
                // Load role_id và role_name
                Integer roleId = rs.getObject("role_id") != null ? rs.getInt("role_id") : null;
                if (roleId != null) {
                    account.setRoleId(roleId);
                    account.setRoleName(rs.getString("role_name"));
                    account.setRole(roleId); // Dùng role_id để edit
                }
                return account;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Account> getAll() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT a.*, r.name as role_name " +
                     "FROM Accounts a " +
                     "LEFT JOIN Roles r ON a.role_id = r.id " +
                     "ORDER BY a.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Account account = new Account();
                account.setId(rs.getInt("id"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setFullName(rs.getString("full_name"));
                account.setEmail(rs.getString("email"));
                account.setPhone(rs.getString("phone"));
                account.setRole(rs.getInt("role"));
                account.setActive(rs.getBoolean("is_active"));
                account.setCreatedAt(rs.getDate("created_at"));
                
                // Load role_id và role_name
                Integer roleId = rs.getObject("role_id") != null ? rs.getInt("role_id") : null;
                if (roleId != null) {
                    account.setRoleId(roleId);
                    account.setRoleName(rs.getString("role_name"));
                }
                accounts.add(account);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return accounts;
    }
    
    // Đếm số khách hàng mới theo tháng/năm (dựa trên created_at)
    public int getCustomerCountByMonthYear(int month, int year) {
        String sql = "SELECT COUNT(*) as count " +
                     "FROM Accounts " +
                     "WHERE role = 0 " +
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
    
    // Đếm tổng số khách hàng đã đặt hàng trong tháng/năm (bao gồm cả khách vãng lai)
    // Khách hàng = Account đã đặt hàng + Khách vãng lai (từ booking)
    public int getActiveCustomerCountByMonthYear(int month, int year) {
        // Đếm số account đã đặt hàng
        String sqlAccounts = "SELECT COUNT(DISTINCT o.account_id) as count " +
                            "FROM Orders o " +
                            "INNER JOIN Accounts a ON o.account_id = a.id " +
                            "WHERE a.role = 0 " +
                            "AND o.payment_status = 'Paid' " +
                            "AND o.order_status = 'Completed' " +
                            "AND MONTH(o.created_at) = ? " +
                            "AND YEAR(o.created_at) = ? " +
                            "AND o.account_id IS NOT NULL";
        
        // Đếm số khách vãng lai (có booking nhưng không có account)
        // Sử dụng CONCAT để tạo unique identifier cho mỗi khách vãng lai
        String sqlWalkIns = "SELECT COUNT(DISTINCT CONCAT(b.customer_name, '-', b.phone)) as count " +
                           "FROM Orders o " +
                           "INNER JOIN Bookings b ON o.booking_id = b.id " +
                           "WHERE o.account_id IS NULL " +
                           "AND o.payment_status = 'Paid' " +
                           "AND o.order_status = 'Completed' " +
                           "AND MONTH(o.created_at) = ? " +
                           "AND YEAR(o.created_at) = ?";
        
        int accountCount = 0;
        int walkInCount = 0;
        
        try (Connection conn = DBConnection.getConnection()) {
            // Đếm account
            try (PreparedStatement ps = conn.prepareStatement(sqlAccounts)) {
                ps.setInt(1, month);
                ps.setInt(2, year);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    accountCount = rs.getInt("count");
                }
            }
            
            // Đếm khách vãng lai
            try (PreparedStatement ps = conn.prepareStatement(sqlWalkIns)) {
                ps.setInt(1, month);
                ps.setInt(2, year);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    walkInCount = rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return accountCount + walkInCount;
    }
    
    // Tìm kiếm tài khoản
    public List<Account> search(String keyword) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT a.*, r.name as role_name " +
                     "FROM Accounts a " +
                     "LEFT JOIN Roles r ON a.role_id = r.id " +
                     "WHERE (a.username LIKE ? OR a.full_name LIKE ? OR a.email LIKE ? OR a.phone LIKE ?) " +
                     "ORDER BY a.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Account account = new Account();
                account.setId(rs.getInt("id"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setFullName(rs.getString("full_name"));
                account.setEmail(rs.getString("email"));
                account.setPhone(rs.getString("phone"));
                account.setRole(rs.getInt("role"));
                account.setActive(rs.getBoolean("is_active"));
                account.setCreatedAt(rs.getDate("created_at"));
                
                // Load role_id và role_name
                Integer roleId = rs.getObject("role_id") != null ? rs.getInt("role_id") : null;
                if (roleId != null) {
                    account.setRoleId(roleId);
                    account.setRoleName(rs.getString("role_name"));
                }
                accounts.add(account);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return accounts;
    }
    
    // Cập nhật tài khoản
    public boolean update(Account account) {
        // account.getRole() giờ là role_id từ Roles table
        Integer roleId = account.getRole();
        int legacyRole = 0; // Mặc định là khách hàng
        
        // Xác định legacy role dựa trên role_id
        // role_id = 1: Khách hàng -> legacy role = 0
        // role_id = 2: Admin -> legacy role = 1
        // role_id = 3: Nhân viên -> legacy role = 2
        // role_id > 3: Các role tùy chỉnh -> legacy role = 2 (nhân viên)
        if (roleId == 1) {
            legacyRole = 0; // Khách hàng
        } else if (roleId == 2) {
            legacyRole = 1; // Admin
        } else {
            legacyRole = 2; // Nhân viên hoặc role tùy chỉnh
        }
        
        String sql;
        if (account.getPassword() != null && !account.getPassword().trim().isEmpty()) {
            // Cập nhật kèm mật khẩu
            sql = "UPDATE Accounts SET username = ?, password = ?, full_name = ?, email = ?, phone = ?, role = ?, role_id = ?, is_active = ? WHERE id = ?";
        } else {
            // Cập nhật không đổi mật khẩu
            sql = "UPDATE Accounts SET username = ?, full_name = ?, email = ?, phone = ?, role = ?, role_id = ?, is_active = ? WHERE id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            ps.setString(paramIndex++, account.getUsername());
            
            if (account.getPassword() != null && !account.getPassword().trim().isEmpty()) {
                ps.setString(paramIndex++, account.getPassword());
            }
            
            ps.setString(paramIndex++, account.getFullName());
            ps.setString(paramIndex++, account.getEmail());
            ps.setString(paramIndex++, account.getPhone());
            ps.setInt(paramIndex++, legacyRole);
            ps.setInt(paramIndex++, roleId);
            ps.setBoolean(paramIndex++, account.isActive());
            ps.setInt(paramIndex++, account.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Toggle trạng thái active/inactive
    public boolean toggleStatus(int accountId) {
        String sql = "UPDATE Accounts SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Kiểm tra username đã tồn tại (trừ account hiện tại)
    public boolean checkUsernameExists(String username, int excludeAccountId) {
        String sql = "SELECT COUNT(*) FROM Accounts WHERE username = ? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setInt(2, excludeAccountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}



