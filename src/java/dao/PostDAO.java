package dao;

import model.Post;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {
    
    // Lấy tất cả posts
    public List<Post> getAll() {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.*, pr.name as product_name, a.full_name as author_name " +
                     "FROM Posts p " +
                     "INNER JOIN Products pr ON p.product_id = pr.id " +
                     "INNER JOIN Accounts a ON p.author_id = a.id " +
                     "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setProductName(rs.getString("product_name"));
                post.setAuthorName(rs.getString("author_name"));
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Lấy posts theo status
    public List<Post> getByStatus(String status) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.*, pr.name as product_name, a.full_name as author_name " +
                     "FROM Posts p " +
                     "INNER JOIN Products pr ON p.product_id = pr.id " +
                     "INNER JOIN Accounts a ON p.author_id = a.id " +
                     "WHERE p.status = ? " +
                     "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setProductName(rs.getString("product_name"));
                post.setAuthorName(rs.getString("author_name"));
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Lấy post theo ID
    public Post getById(int id) {
        String sql = "SELECT p.*, pr.name as product_name, a.full_name as author_name " +
                     "FROM Posts p " +
                     "INNER JOIN Products pr ON p.product_id = pr.id " +
                     "INNER JOIN Accounts a ON p.author_id = a.id " +
                     "WHERE p.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setProductName(rs.getString("product_name"));
                post.setAuthorName(rs.getString("author_name"));
                return post;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy post theo product_id
    public Post getByProductId(int productId) {
        String sql = "SELECT p.*, pr.name as product_name, a.full_name as author_name " +
                     "FROM Posts p " +
                     "INNER JOIN Products pr ON p.product_id = pr.id " +
                     "INNER JOIN Accounts a ON p.author_id = a.id " +
                     "WHERE p.product_id = ? AND p.status = 'Published' " +
                     "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setProductName(rs.getString("product_name"));
                post.setAuthorName(rs.getString("author_name"));
                return post;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Tạo post mới
    public boolean create(Post post) {
        String sql = "INSERT INTO Posts (product_id, title, content, featured_image, author_id, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, post.getProductId());
            ps.setString(2, post.getTitle());
            ps.setString(3, post.getContent());
            ps.setString(4, post.getFeaturedImage());
            ps.setInt(5, post.getAuthorId());
            ps.setString(6, post.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật post
    public boolean update(Post post) {
        String sql = "UPDATE Posts SET product_id = ?, title = ?, content = ?, " +
                     "featured_image = ?, status = ?, updated_at = GETDATE() " +
                     "WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, post.getProductId());
            ps.setString(2, post.getTitle());
            ps.setString(3, post.getContent());
            ps.setString(4, post.getFeaturedImage());
            ps.setString(5, post.getStatus());
            ps.setInt(6, post.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Xóa post
    public boolean delete(int id) {
        String sql = "DELETE FROM Posts WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Tăng view count
    public boolean incrementViewCount(int id) {
        String sql = "UPDATE Posts SET view_count = view_count + 1 WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Tìm kiếm posts
    public List<Post> search(String keyword) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.*, pr.name as product_name, a.full_name as author_name " +
                     "FROM Posts p " +
                     "INNER JOIN Products pr ON p.product_id = pr.id " +
                     "INNER JOIN Accounts a ON p.author_id = a.id " +
                     "WHERE (p.title LIKE ? OR pr.name LIKE ? OR p.content LIKE ?) " +
                     "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setProductName(rs.getString("product_name"));
                post.setAuthorName(rs.getString("author_name"));
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Helper method để map ResultSet sang Post object
    private Post mapResultSetToPost(ResultSet rs) throws SQLException {
        Post post = new Post();
        post.setId(rs.getInt("id"));
        post.setProductId(rs.getInt("product_id"));
        post.setTitle(rs.getString("title"));
        post.setContent(rs.getString("content"));
        post.setFeaturedImage(rs.getString("featured_image"));
        post.setAuthorId(rs.getInt("author_id"));
        post.setStatus(rs.getString("status"));
        post.setViewCount(rs.getInt("view_count"));
        
        // Lấy Timestamp để có cả giờ phút giây
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            post.setCreatedAt(new Date(createdAt.getTime()));
        } else {
            post.setCreatedAt(rs.getDate("created_at"));
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            post.setUpdatedAt(new Date(updatedAt.getTime()));
        } else {
            post.setUpdatedAt(rs.getDate("updated_at"));
        }
        
        return post;
    }
}


