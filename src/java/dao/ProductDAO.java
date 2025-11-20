package dao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
    // Helper method để lấy cost_price an toàn (xử lý trường hợp cột chưa tồn tại)
    private double getCostPriceSafely(ResultSet rs) {
        try {
            // Thử lấy giá trị trực tiếp
            double value = rs.getDouble("cost_price");
            return rs.wasNull() ? 0 : value;
        } catch (SQLException e) {
            // Cột không tồn tại hoặc có lỗi, trả về 0
            return 0;
        }
    }
    
    // Lấy tất cả món ăn (bao gồm cả tạm dừng) - dùng cho admin
    public List<Product> getAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name " +
                     "FROM Products p " +
                     "LEFT JOIN Categories c ON p.category_id = c.id " +
                     "ORDER BY p.id";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCategoryName(rs.getString("category_name"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setCostPrice(getCostPriceSafely(rs));
                product.setImageUrl(rs.getString("image_url"));
                product.setActive(rs.getBoolean("is_active"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    // Lấy chỉ món ăn đang bán (is_active = 1) - dùng cho khách hàng và nhân viên thêm món
    public List<Product> getAllActive() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name " +
                     "FROM Products p " +
                     "LEFT JOIN Categories c ON p.category_id = c.id " +
                     "WHERE p.is_active = 1 " +
                     "ORDER BY p.id";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCategoryName(rs.getString("category_name"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setCostPrice(getCostPriceSafely(rs));
                product.setImageUrl(rs.getString("image_url"));
                product.setActive(rs.getBoolean("is_active"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public List<Product> getByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name " +
                     "FROM Products p " +
                     "LEFT JOIN Categories c ON p.category_id = c.id " +
                     "WHERE p.category_id = ? " +
                     "ORDER BY p.id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCategoryName(rs.getString("category_name"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setCostPrice(getCostPriceSafely(rs));
                product.setImageUrl(rs.getString("image_url"));
                product.setActive(rs.getBoolean("is_active"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public Product getById(int id) {
        String sql = "SELECT p.*, c.name as category_name " +
                     "FROM Products p " +
                     "LEFT JOIN Categories c ON p.category_id = c.id " +
                     "WHERE p.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCategoryName(rs.getString("category_name"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setCostPrice(getCostPriceSafely(rs));
                product.setImageUrl(rs.getString("image_url"));
                product.setActive(rs.getBoolean("is_active"));
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Product> search(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name " +
                     "FROM Products p " +
                     "LEFT JOIN Categories c ON p.category_id = c.id " +
                     "WHERE (p.name LIKE ? OR p.description LIKE ?) " +
                     "ORDER BY p.id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCategoryName(rs.getString("category_name"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setCostPrice(getCostPriceSafely(rs));
                product.setImageUrl(rs.getString("image_url"));
                product.setActive(rs.getBoolean("is_active"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    // Tìm kiếm và lọc theo danh mục
    public List<Product> searchAndFilter(String keyword, Integer categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name " +
                     "FROM Products p " +
                     "LEFT JOIN Categories c ON p.category_id = c.id " +
                     "WHERE 1=1";
        
        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            conditions.add("(p.name LIKE ? OR p.description LIKE ?)");
            String searchPattern = "%" + keyword + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (categoryId != null && categoryId > 0) {
            conditions.add("p.category_id = ?");
            params.add(categoryId);
        }
        
        if (!conditions.isEmpty()) {
            sql += " AND " + String.join(" AND ", conditions);
        }
        
        sql += " ORDER BY p.id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                }
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCategoryName(rs.getString("category_name"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setCostPrice(getCostPriceSafely(rs));
                product.setImageUrl(rs.getString("image_url"));
                product.setActive(rs.getBoolean("is_active"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    // Tính giá vốn của món ăn từ nguyên liệu
    // Công thức: cost_price = SUM(ingredient.price * quantity_needed)
    public double calculateCostPrice(int productId) {
        String sql = "SELECT COALESCE(SUM(i.price * pi.quantity_needed), 0) as cost_price " +
                     "FROM ProductIngredients pi " +
                     "INNER JOIN Ingredients i ON pi.ingredient_id = i.id " +
                     "WHERE pi.product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("cost_price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Cập nhật giá vốn cho một món ăn
    public boolean updateCostPrice(int productId) {
        double costPrice = calculateCostPrice(productId);
        String sql = "UPDATE Products SET cost_price = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, costPrice);
            ps.setInt(2, productId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật giá vốn cho tất cả món ăn (khi giá nguyên liệu thay đổi)
    public void recalculateAllCostPrices() {
        String sql = "SELECT id FROM Products";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                int productId = rs.getInt("id");
                updateCostPrice(productId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public boolean create(Product product) {
        String sql = "INSERT INTO Products (category_id, name, description, price, cost_price, image_url, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setDouble(5, product.getCostPrice());
            ps.setString(6, product.getImageUrl());
            ps.setBoolean(7, product.isActive());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int productId = rs.getInt(1);
                    // Tính lại giá vốn từ nguyên liệu sau khi tạo
                    updateCostPrice(productId);
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(Product product) {
        String sql = "UPDATE Products SET category_id = ?, name = ?, description = ?, price = ?, " +
                     "cost_price = ?, image_url = ?, is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setDouble(5, product.getCostPrice());
            ps.setString(6, product.getImageUrl());
            ps.setBoolean(7, product.isActive());
            ps.setInt(8, product.getId());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Tính lại giá vốn từ nguyên liệu sau khi cập nhật
                updateCostPrice(product.getId());
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM Products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}



