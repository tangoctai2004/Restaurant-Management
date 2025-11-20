package controller;

import dao.RestaurantSettingsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {
    
    private RestaurantSettingsDAO settingsDAO = new RestaurantSettingsDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra xem response đã được commit chưa
        if (response.isCommitted()) {
            return;
        }
        
        try {
            // Lấy settings cho trang liên hệ
            Map<String, String> contactSettings = settingsDAO.getSettingsByPage("contact");
            Map<String, String> heroSettings = settingsDAO.getSettingsByPage("contact_hero");
            Map<String, String> sectionSettings = settingsDAO.getSettingsByPage("contact_section");
            Map<String, String> formSettings = settingsDAO.getSettingsByPage("contact_form");
            Map<String, String> mapSettings = settingsDAO.getSettingsByPage("contact_map");
            
            // Merge tất cả settings (ưu tiên section-specific settings)
            Map<String, String> allContactSettings = new HashMap<>();
            if (contactSettings != null) allContactSettings.putAll(contactSettings);
            if (heroSettings != null) allContactSettings.putAll(heroSettings);
            if (sectionSettings != null) allContactSettings.putAll(sectionSettings);
            if (formSettings != null) allContactSettings.putAll(formSettings);
            if (mapSettings != null) allContactSettings.putAll(mapSettings);
            
            // Parse contact info items
            Map<String, String> contactInfoItems = settingsDAO.getSettingsByPage("contact_info_items");
            if (contactInfoItems == null || contactInfoItems.isEmpty()) {
                // Khởi tạo contact info items mặc định
                Map<String, String> defaultItems = new HashMap<>();
                defaultItems.put("info_1_title", "Địa Chỉ");
                defaultItems.put("info_1_content", "A108 Adam Street<br>New York, NY 535022, USA");
                defaultItems.put("info_1_icon", "fa fa-map-marker-alt");
                
                defaultItems.put("info_2_title", "Điện Thoại");
                defaultItems.put("info_2_content", "0865.787.333<br>Hotline: 1900.XXX.XXX");
                defaultItems.put("info_2_icon", "fa fa-phone");
                
                defaultItems.put("info_3_title", "Email");
                defaultItems.put("info_3_content", "hah@gmail.com<br>support@hahrestaurant.com");
                defaultItems.put("info_3_icon", "fa fa-envelope");
                
                defaultItems.put("info_4_title", "Giờ Mở Cửa");
                defaultItems.put("info_4_content", "Thứ 2 - Chủ Nhật: 10:00 - 22:00<br>Nghỉ lễ: 09:00 - 23:00");
                defaultItems.put("info_4_icon", "fa fa-clock");
                
                try {
                    settingsDAO.saveSettings(defaultItems, "contact_info_items");
                    contactInfoItems = settingsDAO.getSettingsByPage("contact_info_items");
                } catch (Exception e) {
                    System.err.println("❌ Error initializing default contact info items: " + e.getMessage());
                    e.printStackTrace();
                    contactInfoItems = defaultItems; // Sử dụng default items nếu không lưu được
                }
            }
            
            request.setAttribute("contactSettings", allContactSettings);
            request.setAttribute("contactInfoItems", contactInfoItems != null ? contactInfoItems : new HashMap<>());
            
            // Forward request - chỉ forward một lần
            request.getRequestDispatcher("contact.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("❌ Error in ContactServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Chỉ send error nếu response chưa commit
            if (!response.isCommitted()) {
                try {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra khi tải trang liên hệ: " + e.getMessage());
                } catch (IOException ioException) {
                    System.err.println("❌ Error sending error response: " + ioException.getMessage());
                }
            }
        }
    }
}

