package dao;

import model.Role;
import model.Permission;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO {
    
    // Lấy tất cả roles
    public List<Role> getAll() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT r.*, COUNT(a.id) as account_count " +
                     "FROM Roles r " +
                     "LEFT JOIN Accounts a ON r.id = a.role_id " +
                     "GROUP BY r.id, r.name, r.description, r.created_at " +
                     "ORDER BY r.name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
                role.setCreatedAt(rs.getDate("created_at"));
                role.setAccountCount(rs.getInt("account_count"));
                roles.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
    
    // Lấy role theo ID
    public Role getById(int id) {
        String sql = "SELECT * FROM Roles WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
                role.setCreatedAt(rs.getDate("created_at"));
                
                // Load permissions cho role
                role.setPermissions(getPermissionsByRoleId(id));
                
                return role;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Tạo role mới
    public boolean create(Role role) {
        String sql = "INSERT INTO Roles (name, description) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, role.getName());
            if (role.getDescription() != null && !role.getDescription().trim().isEmpty()) {
                ps.setString(2, role.getDescription());
            } else {
                ps.setNull(2, Types.NVARCHAR);
            }
            
            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int roleId = rs.getInt(1);
                    // Lưu permissions nếu có
                    if (role.getPermissions() != null && !role.getPermissions().isEmpty()) {
                        saveRolePermissions(roleId, role.getPermissions());
                    }
                    System.out.println("✅ Role created successfully: " + role.getName() + " (ID: " + roleId + ")");
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error creating role: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật role
    public boolean update(Role role) {
        String sql = "UPDATE Roles SET name = ?, description = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role.getName());
            if (role.getDescription() != null && !role.getDescription().trim().isEmpty()) {
                ps.setString(2, role.getDescription());
            } else {
                ps.setNull(2, Types.NVARCHAR);
            }
            ps.setInt(3, role.getId());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Cập nhật permissions
                if (role.getPermissions() != null) {
                    updateRolePermissions(role.getId(), role.getPermissions());
                }
                System.out.println("✅ Role updated successfully: ID " + role.getId());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error updating role: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Xóa role
    public boolean delete(int id) {
        // Kiểm tra xem có tài khoản nào đang sử dụng role này không
        String checkSql = "SELECT COUNT(*) FROM Accounts WHERE role_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.err.println("❌ Cannot delete role: There are accounts using this role");
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        String sql = "DELETE FROM Roles WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Role deleted successfully: ID " + id);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error deleting role: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy tất cả permissions
    public List<Permission> getAllPermissions() {
        List<Permission> permissions = new ArrayList<>();
        String sql = "SELECT * FROM Permissions ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
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
    
    // Lấy permissions của một role
    public List<Permission> getPermissionsByRoleId(int roleId) {
        List<Permission> permissions = new ArrayList<>();
        String sql = "SELECT p.*, 1 as granted " +
                     "FROM Permissions p " +
                     "INNER JOIN RolePermissions rp ON p.id = rp.permission_id " +
                     "WHERE rp.role_id = ? " +
                     "ORDER BY p.name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Permission permission = new Permission();
                permission.setId(rs.getInt("id"));
                permission.setCode(rs.getString("code"));
                permission.setName(rs.getString("name"));
                permission.setDescription(rs.getString("description"));
                permission.setGranted(true);
                permissions.add(permission);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissions;
    }
    
    // Lấy tất cả permissions với trạng thái granted cho một role
    public List<Permission> getAllPermissionsWithGranted(int roleId) {
        List<Permission> allPermissions = getAllPermissions();
        List<Permission> rolePermissions = getPermissionsByRoleId(roleId);
        
        // Đánh dấu permissions nào được granted
        for (Permission permission : allPermissions) {
            for (Permission rolePerm : rolePermissions) {
                if (permission.getId() == rolePerm.getId()) {
                    permission.setGranted(true);
                    break;
                }
            }
        }
        
        return allPermissions;
    }
    
    // Lưu permissions cho role
    private void saveRolePermissions(int roleId, List<Permission> permissions) throws SQLException {
        String deleteSql = "DELETE FROM RolePermissions WHERE role_id = ?";
        String insertSql = "INSERT INTO RolePermissions (role_id, permission_id) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Xóa permissions cũ
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, roleId);
                ps.executeUpdate();
            }
            
            // Thêm permissions mới
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                for (Permission permission : permissions) {
                    if (permission.isGranted()) {
                        ps.setInt(1, roleId);
                        ps.setInt(2, permission.getId());
                        ps.addBatch();
                    }
                }
                ps.executeBatch();
            }
        }
    }
    
    // Cập nhật permissions cho role
    private void updateRolePermissions(int roleId, List<Permission> permissions) throws SQLException {
        saveRolePermissions(roleId, permissions);
    }
    
    // Tìm kiếm roles
    public List<Role> search(String keyword) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT r.*, COUNT(a.id) as account_count " +
                     "FROM Roles r " +
                     "LEFT JOIN Accounts a ON r.id = a.role_id " +
                     "WHERE (r.name LIKE ? OR r.description LIKE ?) " +
                     "GROUP BY r.id, r.name, r.description, r.created_at " +
                     "ORDER BY r.name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
                role.setCreatedAt(rs.getDate("created_at"));
                role.setAccountCount(rs.getInt("account_count"));
                roles.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
}

