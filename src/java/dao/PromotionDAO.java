package dao;

import model.Promotion;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PromotionDAO {
    
    public Promotion getByCode(String code) {
        String sql = "SELECT * FROM Promotions " +
                     "WHERE code = ? AND is_active = 1 " +
                     "AND start_date <= ? AND end_date >= ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            Date now = new Date();
            ps.setString(1, code);
            ps.setTimestamp(2, new Timestamp(now.getTime()));
            ps.setTimestamp(3, new Timestamp(now.getTime()));
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Promotion promo = new Promotion();
                promo.setId(rs.getInt("id"));
                promo.setCode(rs.getString("code"));
                promo.setDescription(rs.getString("description"));
                promo.setDiscountType(rs.getString("discount_type"));
                promo.setDiscountValue(rs.getDouble("discount_value"));
                promo.setMinOrderValue(rs.getDouble("min_order_value"));
                if (rs.getObject("max_discount_amount") != null) {
                    promo.setMaxDiscountAmount(rs.getDouble("max_discount_amount"));
                }
                promo.setStartDate(rs.getDate("start_date"));
                promo.setEndDate(rs.getDate("end_date"));
                promo.setActive(rs.getBoolean("is_active"));
                return promo;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public double calculateDiscount(Promotion promo, double subtotal) {
        if (promo == null || subtotal < promo.getMinOrderValue()) {
            return 0;
        }
        
        double discount = 0;
        if ("Percent".equals(promo.getDiscountType())) {
            discount = subtotal * promo.getDiscountValue() / 100;
            if (promo.getMaxDiscountAmount() != null && discount > promo.getMaxDiscountAmount()) {
                discount = promo.getMaxDiscountAmount();
            }
        } else if ("FixedAmount".equals(promo.getDiscountType())) {
            discount = promo.getDiscountValue();
            if (discount > subtotal) {
                discount = subtotal;
            }
        }
        
        return discount;
    }
    
    public List<Promotion> getAll() {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM Promotions ORDER BY start_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Promotion promo = new Promotion();
                promo.setId(rs.getInt("id"));
                promo.setCode(rs.getString("code"));
                promo.setDescription(rs.getString("description"));
                promo.setDiscountType(rs.getString("discount_type"));
                promo.setDiscountValue(rs.getDouble("discount_value"));
                promo.setMinOrderValue(rs.getDouble("min_order_value"));
                if (rs.getObject("max_discount_amount") != null) {
                    promo.setMaxDiscountAmount(rs.getDouble("max_discount_amount"));
                }
                promo.setStartDate(rs.getDate("start_date"));
                promo.setEndDate(rs.getDate("end_date"));
                promo.setActive(rs.getBoolean("is_active"));
                promotions.add(promo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return promotions;
    }
    
    // Lấy danh sách voucher đang active và trong thời gian hiệu lực
    public List<Promotion> getActivePromotions() {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM Promotions " +
                     "WHERE is_active = 1 " +
                     "AND start_date <= ? AND end_date >= ? " +
                     "ORDER BY start_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            Date now = new Date();
            ps.setTimestamp(1, new Timestamp(now.getTime()));
            ps.setTimestamp(2, new Timestamp(now.getTime()));
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Promotion promo = new Promotion();
                promo.setId(rs.getInt("id"));
                promo.setCode(rs.getString("code"));
                promo.setDescription(rs.getString("description"));
                promo.setDiscountType(rs.getString("discount_type"));
                promo.setDiscountValue(rs.getDouble("discount_value"));
                promo.setMinOrderValue(rs.getDouble("min_order_value"));
                if (rs.getObject("max_discount_amount") != null) {
                    promo.setMaxDiscountAmount(rs.getDouble("max_discount_amount"));
                }
                promo.setStartDate(rs.getDate("start_date"));
                promo.setEndDate(rs.getDate("end_date"));
                promo.setActive(rs.getBoolean("is_active"));
                promotions.add(promo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return promotions;
    }
    
    public Promotion getById(int id) {
        String sql = "SELECT * FROM Promotions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Promotion promo = new Promotion();
                promo.setId(rs.getInt("id"));
                promo.setCode(rs.getString("code"));
                promo.setDescription(rs.getString("description"));
                promo.setDiscountType(rs.getString("discount_type"));
                promo.setDiscountValue(rs.getDouble("discount_value"));
                promo.setMinOrderValue(rs.getDouble("min_order_value"));
                if (rs.getObject("max_discount_amount") != null) {
                    promo.setMaxDiscountAmount(rs.getDouble("max_discount_amount"));
                }
                promo.setStartDate(rs.getDate("start_date"));
                promo.setEndDate(rs.getDate("end_date"));
                promo.setActive(rs.getBoolean("is_active"));
                return promo;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean create(Promotion promo) {
        String sql = "INSERT INTO Promotions (code, description, discount_type, discount_value, min_order_value, max_discount_amount, start_date, end_date, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, promo.getCode());
            ps.setString(2, promo.getDescription());
            ps.setString(3, promo.getDiscountType());
            ps.setDouble(4, promo.getDiscountValue());
            ps.setDouble(5, promo.getMinOrderValue());
            if (promo.getMaxDiscountAmount() != null) {
                ps.setDouble(6, promo.getMaxDiscountAmount());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            ps.setDate(7, promo.getStartDate());
            ps.setDate(8, promo.getEndDate());
            ps.setBoolean(9, promo.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(Promotion promo) {
        String sql = "UPDATE Promotions SET code = ?, description = ?, discount_type = ?, discount_value = ?, " +
                     "min_order_value = ?, max_discount_amount = ?, start_date = ?, end_date = ?, is_active = ? " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, promo.getCode());
            ps.setString(2, promo.getDescription());
            ps.setString(3, promo.getDiscountType());
            ps.setDouble(4, promo.getDiscountValue());
            ps.setDouble(5, promo.getMinOrderValue());
            if (promo.getMaxDiscountAmount() != null) {
                ps.setDouble(6, promo.getMaxDiscountAmount());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            ps.setDate(7, promo.getStartDate());
            ps.setDate(8, promo.getEndDate());
            ps.setBoolean(9, promo.isActive());
            ps.setInt(10, promo.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM Promotions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean toggleStatus(int id) {
        // Lấy trạng thái hiện tại
        Promotion promo = getById(id);
        if (promo == null) {
            return false;
        }
        
        // Đảo ngược trạng thái
        String sql = "UPDATE Promotions SET is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, !promo.isActive());
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}



