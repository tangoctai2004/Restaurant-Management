package dao;

import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    public List<Category> getAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(p.id) as product_count " +
                     "FROM Categories c " +
                     "LEFT JOIN Products p ON c.id = p.category_id " +
                     "GROUP BY c.id, c.name, c.description";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setProductCount(rs.getInt("product_count"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    public Category getById(int id) {
        String sql = "SELECT * FROM Categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                return category;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm danh mục mới
    public boolean create(Category category) {
        String sql = "INSERT INTO Categories (name, description) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            if (category.getDescription() != null && !category.getDescription().trim().isEmpty()) {
                ps.setString(2, category.getDescription());
            } else {
                ps.setNull(2, Types.NVARCHAR);
            }
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Category created successfully: " + category.getName());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error creating category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật danh mục
    public boolean update(Category category) {
        String sql = "UPDATE Categories SET name = ?, description = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            if (category.getDescription() != null && !category.getDescription().trim().isEmpty()) {
                ps.setString(2, category.getDescription());
            } else {
                ps.setNull(2, Types.NVARCHAR);
            }
            ps.setInt(3, category.getId());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Category updated successfully: ID " + category.getId());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error updating category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Xóa danh mục
    public boolean delete(int id) {
        String sql = "DELETE FROM Categories WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Category deleted successfully: ID " + id);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error deleting category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Tìm kiếm danh mục
    public List<Category> search(String keyword) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(p.id) as product_count " +
                     "FROM Categories c " +
                     "LEFT JOIN Products p ON c.id = p.category_id " +
                     "WHERE (c.name LIKE ? OR c.description LIKE ?) " +
                     "GROUP BY c.id, c.name, c.description " +
                     "ORDER BY c.name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setProductCount(rs.getInt("product_count"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
}



