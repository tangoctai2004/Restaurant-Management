package util;

import jakarta.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class VNPayUtil {
    
    // Cấu hình VNPay (thay đổi theo thông tin thực tế)
    private static final String vnp_Version = "2.1.0";
    private static final String vnp_Command = "pay";
    private static final String vnp_TmnCode = "PVEVPRMW"; // Mã website của bạn
    private static final String vnp_HashSecret = "840SCE1GSH34TQSJ2CK3AQ8J5UBIPC5F"; // Secret key
    private static final String vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String vnp_ReturnUrl = "http://localhost:9999/HAH-Restaurant/vnpay-return";
    
    public static String createPaymentUrl(HttpServletRequest request, long amount, String orderInfo, String orderId) {
        try {
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount * 100)); // VNPay yêu cầu số tiền nhân 100
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", orderId);
            vnp_Params.put("vnp_OrderInfo", orderInfo);
            vnp_Params.put("vnp_OrderType", "other");
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", getIpAddress(request));
            
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
            
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
            
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            String queryUrl = query.toString();
            String vnp_SecureHash = hmacSHA512(vnp_HashSecret, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = vnp_Url + "?" + queryUrl;
            return paymentUrl;
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes();
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }
    
    public static String getIpAddress(HttpServletRequest request) {
        String ipAdress;
        try {
            ipAdress = request.getHeader("X-FORWARDED-FOR");
            if (ipAdress == null) {
                ipAdress = request.getRemoteAddr();
            }
        } catch (Exception e) {
            ipAdress = "Invalid IP:" + e.getMessage();
        }
        return ipAdress;
    }
    
    public static boolean verifyPayment(Map<String, String> params, String vnp_SecureHash) {
        try {
            String hashSecret = vnp_HashSecret;
            StringBuilder hashData = new StringBuilder();
            List<String> fieldNames = new ArrayList<>(params.keySet());
            Collections.sort(fieldNames);
            
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = params.get(fieldName);
                // Bỏ qua SecureHash và SecureHashType
                if ((fieldValue != null) && (fieldValue.length() > 0) 
                    && !fieldName.equals("vnp_SecureHash") 
                    && !fieldName.equals("vnp_SecureHashType")) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    // Encode lại giá trị để khớp với hash từ VNPay
                    // VNPay tính hash từ query string đã encode
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        hashData.append('&');
                    }
                }
            }
            
            String checkSum = hmacSHA512(hashSecret, hashData.toString());
            boolean isValid = checkSum.equalsIgnoreCase(vnp_SecureHash);
            
            // Log để debug
            System.out.println("=== VNPay Verification ===");
            System.out.println("HashData: " + hashData.toString());
            System.out.println("Expected Hash: " + checkSum);
            System.out.println("Received Hash: " + vnp_SecureHash);
            System.out.println("Is Valid: " + isValid);
            
            return isValid;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

