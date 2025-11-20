package dao;
import java.sql.*;
import java.io.InputStream;
import java.util.Properties;

public class DBConnection {
    
    private static String URL;
    private static String USER;
    private static String PASSWORD;
    
    // Load config từ file properties
    static {
        loadConfig();
    }
    
    private static void loadConfig() {
        Properties props = new Properties();
        try (InputStream input = DBConnection.class.getClassLoader()
                .getResourceAsStream("config/database.properties")) {
            
            if (input == null) {
                System.err.println("⚠️ Không tìm thấy file database.properties!");
                System.err.println("⚠️ Sử dụng giá trị mặc định (cần cấu hình lại!)");
                // Fallback values (cần thay đổi)
                URL = "jdbc:sqlserver://localhost:1433;databaseName=QLNhaHang;encrypt=true;trustServerCertificate=true";
                USER = "sa";
                PASSWORD = "your_password_here";
                return;
            }
            
            props.load(input);
            URL = props.getProperty("db.url");
            USER = props.getProperty("db.user");
            PASSWORD = props.getProperty("db.password");
            
            if (URL == null || USER == null || PASSWORD == null) {
                System.err.println("⚠️ Thiếu thông tin cấu hình trong database.properties!");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi đọc file config: " + e.getMessage());
            e.printStackTrace();
            // Fallback values
            URL = "jdbc:sqlserver://localhost:1433;databaseName=QLNhaHang;encrypt=true;trustServerCertificate=true";
            USER = "sa";
            PASSWORD = "your_password_here";
        }
    }

    public static Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            System.out.println("❌ Kết nối thất bại: " + e.getMessage());
            e.printStackTrace(); // rất quan trọng để biết đúng nguyên nhân
            return null;
        }
    }

    public static void main(String[] args) {
        try (Connection c = getConnection()) {
            System.out.println(c != null ? "✅ Kết nối thành công!" : "⛔ Không thể kết nối!");
        } catch (Exception ignore) {}
    }
}
