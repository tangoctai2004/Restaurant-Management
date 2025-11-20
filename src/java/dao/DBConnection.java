package dao;
import java.sql.*;

public class DBConnection {

       private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=QLNhaHang;encrypt=true;trustServerCertificate=true";

    private static final String USER = "sa";
    private static final String PASSWORD = "Tangoctai2004"; // đúng mật khẩu bạn vừa đặt

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
