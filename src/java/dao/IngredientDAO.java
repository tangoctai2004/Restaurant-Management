package dao;

import model.Ingredient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IngredientDAO {
    
    public List<Ingredient> getAll() {
        List<Ingredient> ingredients = new ArrayList<>();
        String sql = "SELECT * FROM Ingredients ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Ingredient ingredient = new Ingredient();
                ingredient.setId(rs.getInt("id"));
                ingredient.setName(rs.getString("name"));
                ingredient.setUnit(rs.getString("unit"));
                ingredient.setPrice(rs.getDouble("price"));
                ingredients.add(ingredient);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ingredients;
    }
    
    public Ingredient getById(int id) {
        String sql = "SELECT * FROM Ingredients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Ingredient ingredient = new Ingredient();
                ingredient.setId(rs.getInt("id"));
                ingredient.setName(rs.getString("name"));
                ingredient.setUnit(rs.getString("unit"));
                ingredient.setPrice(rs.getDouble("price"));
                return ingredient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean create(Ingredient ingredient) {
        String sql = "INSERT INTO Ingredients (name, unit, price) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, ingredient.getName());
            ps.setString(2, ingredient.getUnit());
            ps.setDouble(3, ingredient.getPrice());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(Ingredient ingredient) {
        String sql = "UPDATE Ingredients SET name = ?, unit = ?, price = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, ingredient.getName());
            ps.setString(2, ingredient.getUnit());
            ps.setDouble(3, ingredient.getPrice());
            ps.setInt(4, ingredient.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM Ingredients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Tìm kiếm nguyên liệu
    public List<Ingredient> search(String keyword) {
        List<Ingredient> ingredients = new ArrayList<>();
        String sql = "SELECT * FROM Ingredients " +
                     "WHERE name LIKE ? " +
                     "ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Ingredient ingredient = new Ingredient();
                ingredient.setId(rs.getInt("id"));
                ingredient.setName(rs.getString("name"));
                ingredient.setUnit(rs.getString("unit"));
                ingredient.setPrice(rs.getDouble("price"));
                ingredients.add(ingredient);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ingredients;
    }
}

