package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductIngredientDAO {
    
    // Lấy danh sách nguyên liệu của một món ăn
    public List<Map<String, Object>> getIngredientsByProductId(int productId) {
        List<Map<String, Object>> ingredients = new ArrayList<>();
        String sql = "SELECT pi.product_id, pi.ingredient_id, pi.quantity_needed, " +
                     "i.name as ingredient_name, i.unit, i.price " +
                     "FROM ProductIngredients pi " +
                     "INNER JOIN Ingredients i ON pi.ingredient_id = i.id " +
                     "WHERE pi.product_id = ? " +
                     "ORDER BY i.name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("productId", rs.getInt("product_id"));
                item.put("ingredientId", rs.getInt("ingredient_id"));
                item.put("ingredientName", rs.getString("ingredient_name"));
                item.put("unit", rs.getString("unit"));
                item.put("quantityNeeded", rs.getDouble("quantity_needed"));
                item.put("price", rs.getDouble("price"));
                ingredients.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ingredients;
    }
    
    // Thêm nguyên liệu vào món ăn
    public boolean addIngredientToProduct(int productId, int ingredientId, double quantityNeeded) {
        String sql = "INSERT INTO ProductIngredients (product_id, ingredient_id, quantity_needed) " +
                     "VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ps.setInt(2, ingredientId);
            ps.setDouble(3, quantityNeeded);
            
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                // Tính lại giá vốn sau khi thêm nguyên liệu
                ProductDAO productDAO = new ProductDAO();
                productDAO.updateCostPrice(productId);
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật số lượng nguyên liệu cần thiết
    public boolean updateQuantity(int productId, int ingredientId, double quantityNeeded) {
        String sql = "UPDATE ProductIngredients SET quantity_needed = ? " +
                     "WHERE product_id = ? AND ingredient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, quantityNeeded);
            ps.setInt(2, productId);
            ps.setInt(3, ingredientId);
            
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                // Tính lại giá vốn sau khi cập nhật
                ProductDAO productDAO = new ProductDAO();
                productDAO.updateCostPrice(productId);
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Xóa nguyên liệu khỏi món ăn
    public boolean removeIngredientFromProduct(int productId, int ingredientId) {
        String sql = "DELETE FROM ProductIngredients WHERE product_id = ? AND ingredient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ps.setInt(2, ingredientId);
            
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                // Tính lại giá vốn sau khi xóa
                ProductDAO productDAO = new ProductDAO();
                productDAO.updateCostPrice(productId);
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Kiểm tra xem nguyên liệu đã có trong món ăn chưa
    public boolean exists(int productId, int ingredientId) {
        String sql = "SELECT COUNT(*) FROM ProductIngredients WHERE product_id = ? AND ingredient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ps.setInt(2, ingredientId);
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

