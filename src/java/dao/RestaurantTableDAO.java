package dao;

import model.RestaurantTable;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantTableDAO {
    
    public List<RestaurantTable> getAvailableTables(int numPeople, String bookingDate, String bookingTime) {
        List<RestaurantTable> tables = new ArrayList<>();
        // Lấy các bàn có sức chứa >= số người và đang trống
        String sql = "SELECT * FROM RestaurantTables " +
                     "WHERE capacity >= ? AND status = 'Available' " +
                     "ORDER BY capacity ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, numPeople);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                RestaurantTable table = new RestaurantTable();
                table.setId(rs.getInt("id"));
                table.setName(rs.getString("name"));
                table.setCapacity(rs.getInt("capacity"));
                table.setLocationArea(rs.getString("location_area"));
                table.setStatus(rs.getString("status"));
                tables.add(table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }
    
    public List<RestaurantTable> getAll() {
        List<RestaurantTable> tables = new ArrayList<>();
        String sql = "SELECT * FROM RestaurantTables ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                RestaurantTable table = new RestaurantTable();
                table.setId(rs.getInt("id"));
                table.setName(rs.getString("name"));
                table.setCapacity(rs.getInt("capacity"));
                table.setLocationArea(rs.getString("location_area"));
                table.setStatus(rs.getString("status"));
                tables.add(table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }
    
    public RestaurantTable getById(int id) {
        String sql = "SELECT * FROM RestaurantTables WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RestaurantTable table = new RestaurantTable();
                table.setId(rs.getInt("id"));
                table.setName(rs.getString("name"));
                table.setCapacity(rs.getInt("capacity"));
                table.setLocationArea(rs.getString("location_area"));
                table.setStatus(rs.getString("status"));
                return table;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean update(RestaurantTable table) {
        String sql = "UPDATE RestaurantTables SET name = ?, capacity = ?, location_area = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, table.getName());
            ps.setInt(2, table.getCapacity());
            ps.setString(3, table.getLocationArea());
            ps.setString(4, table.getStatus());
            ps.setInt(5, table.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM RestaurantTables WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean create(RestaurantTable table) {
        String sql = "INSERT INTO RestaurantTables (name, capacity, location_area, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, table.getName());
            ps.setInt(2, table.getCapacity());
            ps.setString(3, table.getLocationArea());
            ps.setString(4, table.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}



