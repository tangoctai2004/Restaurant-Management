package util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class để hash và verify password
 * Sử dụng SHA-256 với salt để bảo mật
 * 
 * LƯU Ý: Trong production, nên dùng BCrypt (cần thêm dependency jbcrypt-0.4.jar)
 * Class này sử dụng SHA-256 + salt (Java built-in, không cần thư viện ngoài)
 */
public class PasswordUtil {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Tạo salt ngẫu nhiên
     */
    private static byte[] generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return salt;
    }
    
    /**
     * Hash password với SHA-256 và salt
     * Format: salt:hash (cả hai đều được encode base64)
     * 
     * @param plainPassword Mật khẩu gốc
     * @return Mật khẩu đã hash dạng "salt:hash" (base64 encoded)
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            return null;
        }
        
        try {
            // Tạo salt
            byte[] salt = generateSalt();
            
            // Hash password với salt
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedBytes = md.digest(plainPassword.getBytes("UTF-8"));
            
            // Encode salt và hash thành base64
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hashedBytes);
            
            // Trả về format: salt:hash
            return saltBase64 + ":" + hashBase64;
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Kiểm tra mật khẩu có khớp không
     * 
     * @param plainPassword Mật khẩu gốc (từ user input)
     * @param hashedPassword Mật khẩu đã hash (từ database, format: salt:hash)
     * @return true nếu khớp, false nếu không
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.trim().isEmpty()) {
            return false;
        }
        
        try {
            // Tách salt và hash từ stored password
            String[] parts = hashedPassword.split(":");
            if (parts.length != 2) {
                // Nếu format không đúng (có thể là password cũ chưa hash)
                // Trả về false để bắt buộc user đổi password
                return false;
            }
            
            String saltBase64 = parts[0];
            String storedHashBase64 = parts[1];
            
            // Decode salt
            byte[] salt = Base64.getDecoder().decode(saltBase64);
            
            // Hash password input với salt đã lưu
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedBytes = md.digest(plainPassword.getBytes("UTF-8"));
            String inputHashBase64 = Base64.getEncoder().encodeToString(hashedBytes);
            
            // So sánh hash
            return storedHashBase64.equals(inputHashBase64);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra xem password đã được hash chưa
     * (để hỗ trợ migration từ plaintext sang hash)
     */
    public static boolean isHashed(String password) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        // Password đã hash có format: salt:hash (có dấu :)
        return password.contains(":") && password.split(":").length == 2;
    }
}

