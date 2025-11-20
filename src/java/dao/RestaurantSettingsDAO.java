package dao;

import model.RestaurantSettings;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class RestaurantSettingsDAO {
    
    // Lấy tất cả settings
    public Map<String, String> getAllSettings() {
        Map<String, String> settings = new HashMap<>();
        String sql = "SELECT setting_key, setting_value FROM RestaurantSettings";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                settings.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            // Nếu bảng chưa tồn tại, trả về map rỗng thay vì throw exception
            System.err.println("⚠️ Bảng RestaurantSettings chưa được tạo. Vui lòng chạy script SQL: CreateRestaurantSettingsTable.sql");
            e.printStackTrace();
        }
        return settings;
    }
    
    // Lấy setting theo key
    public String getSetting(String key) {
        String sql = "SELECT setting_value FROM RestaurantSettings WHERE setting_key = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, key);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("setting_value");
            }
        } catch (SQLException e) {
            System.err.println("⚠️ Bảng RestaurantSettings chưa được tạo. Vui lòng chạy script SQL: CreateRestaurantSettingsTable.sql");
            e.printStackTrace();
        }
        return null;
    }
    
    // Lưu hoặc cập nhật setting
    public boolean saveSetting(String key, String value, String pageName, String description) {
        String checkSql = "SELECT COUNT(*) FROM RestaurantSettings WHERE setting_key = ?";
        String insertSql = "INSERT INTO RestaurantSettings (setting_key, setting_value, page_name, description) VALUES (?, ?, ?, ?)";
        String updateSql = "UPDATE RestaurantSettings SET setting_value = ?, page_name = ?, description = ? WHERE setting_key = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Kiểm tra xem setting đã tồn tại chưa
            boolean exists = false;
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, key);
                ResultSet rs = checkPs.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    exists = true;
                }
            }
            
            if (exists) {
                // Cập nhật
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setString(1, value != null ? value : "");
                    ps.setString(2, pageName != null ? pageName : "");
                    ps.setString(3, description != null ? description : "");
                    ps.setString(4, key);
                    
                    int result = ps.executeUpdate();
                    return result > 0;
                }
            } else {
                // Thêm mới
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setString(1, key);
                    ps.setString(2, value != null ? value : "");
                    ps.setString(3, pageName != null ? pageName : "");
                    ps.setString(4, description != null ? description : "");
                    
                    int result = ps.executeUpdate();
                    return result > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lưu nhiều settings cùng lúc
    public boolean saveSettings(Map<String, String> settings, String pageName) {
        String checkSql = "SELECT COUNT(*) FROM RestaurantSettings WHERE setting_key = ? AND page_name = ?";
        String insertSql = "INSERT INTO RestaurantSettings (setting_key, setting_value, page_name) VALUES (?, ?, ?)";
        String updateSql = "UPDATE RestaurantSettings SET setting_value = ? WHERE setting_key = ? AND page_name = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.err.println("❌ Database connection failed in saveSettings.");
                return false;
            }
            conn.setAutoCommit(false);
            
            try {
                for (Map.Entry<String, String> entry : settings.entrySet()) {
                    String key = entry.getKey();
                    String value = entry.getValue();
                    
                    // Kiểm tra xem setting đã tồn tại chưa (cả key và page_name)
                    boolean exists = false;
                    try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                        checkPs.setString(1, key);
                        checkPs.setString(2, pageName);
                        ResultSet rs = checkPs.executeQuery();
                        if (rs.next() && rs.getInt(1) > 0) {
                            exists = true;
                        }
                    }
                    
                    if (exists) {
                        // Cập nhật
                        try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                            ps.setString(1, value != null ? value : "");
                            ps.setString(2, key);
                            ps.setString(3, pageName);
                            int rowsUpdated = ps.executeUpdate();
                            if (rowsUpdated == 0) {
                                System.err.println("⚠️ Warning: No rows updated for key: " + key + ", page: " + pageName);
                            }
                        }
                    } else {
                        // Thêm mới
                        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                            ps.setString(1, key);
                            ps.setString(2, value != null ? value : "");
                            ps.setString(3, pageName != null ? pageName : "");
                            ps.executeUpdate();
                        }
                    }
                }
                
                conn.commit();
                System.out.println("✅ Settings saved successfully for page: " + pageName);
                return true;
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("❌ Error saving settings: " + e.getMessage());
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy settings theo page
    public Map<String, String> getSettingsByPage(String pageName) {
        Map<String, String> settings = new HashMap<>();
        String sql = "SELECT setting_key, setting_value FROM RestaurantSettings WHERE page_name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, pageName);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                settings.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            // Nếu bảng chưa tồn tại, trả về map rỗng thay vì throw exception
            System.err.println("⚠️ Bảng RestaurantSettings chưa được tạo. Vui lòng chạy script SQL: CreateRestaurantSettingsTable.sql");
            e.printStackTrace();
        }
        return settings;
    }
}

