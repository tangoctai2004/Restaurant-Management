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

@WebServlet(name = "AboutServlet", urlPatterns = {"/about"})
public class AboutServlet extends HttpServlet {
    
    private RestaurantSettingsDAO settingsDAO = new RestaurantSettingsDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra xem response đã được commit chưa
        if (response.isCommitted()) {
            return;
        }
        
        try {
            // Lấy settings cho trang giới thiệu
            Map<String, String> aboutSettings = settingsDAO.getSettingsByPage("about");
            Map<String, String> heroSettings = settingsDAO.getSettingsByPage("about_hero");
            Map<String, String> storySettings = settingsDAO.getSettingsByPage("about_story");
            Map<String, String> valuesSettings = settingsDAO.getSettingsByPage("about_values");
            Map<String, String> gallerySettings = settingsDAO.getSettingsByPage("about_gallery");
            
            // Merge tất cả settings (ưu tiên section-specific settings)
            Map<String, String> allAboutSettings = new HashMap<>();
            if (aboutSettings != null) allAboutSettings.putAll(aboutSettings);
            if (heroSettings != null) allAboutSettings.putAll(heroSettings);
            if (storySettings != null) allAboutSettings.putAll(storySettings);
            if (valuesSettings != null) allAboutSettings.putAll(valuesSettings);
            if (gallerySettings != null) allAboutSettings.putAll(gallerySettings);
            
            // Parse values (tương tự features)
            Map<String, String> values = settingsDAO.getSettingsByPage("about_values_items");
            if (values == null || values.isEmpty()) {
                // Khởi tạo values mặc định
                Map<String, String> defaultValues = new HashMap<>();
                defaultValues.put("value_1_title", "Chất Lượng");
                defaultValues.put("value_1_description", "Chúng tôi luôn chọn lựa những nguyên liệu tươi ngon nhất, đảm bảo chất lượng từng món ăn đến tay thực khách.");
                defaultValues.put("value_1_icon", "fa fa-heart");
                
                defaultValues.put("value_2_title", "Phục Vụ");
                defaultValues.put("value_2_description", "Đội ngũ nhân viên chuyên nghiệp, tận tâm, luôn sẵn sàng phục vụ và mang đến trải nghiệm tốt nhất cho khách hàng.");
                defaultValues.put("value_2_icon", "fa fa-users");
                
                defaultValues.put("value_3_title", "Đổi Mới");
                defaultValues.put("value_3_description", "Không ngừng sáng tạo, cải tiến menu và dịch vụ để mang đến những điều mới mẻ, thú vị cho thực khách.");
                defaultValues.put("value_3_icon", "fa fa-star");
                
                try {
                    settingsDAO.saveSettings(defaultValues, "about_values_items");
                    values = settingsDAO.getSettingsByPage("about_values_items");
                } catch (Exception e) {
                    System.err.println("❌ Error initializing default values: " + e.getMessage());
                    e.printStackTrace();
                    values = defaultValues; // Sử dụng default values nếu không lưu được
                }
            }
            
            // Parse gallery images
            Map<String, String> galleryImages = settingsDAO.getSettingsByPage("about_gallery_images");
            if (galleryImages == null || galleryImages.isEmpty()) {
                // Khởi tạo gallery mặc định
                Map<String, String> defaultGallery = new HashMap<>();
                defaultGallery.put("gallery_1_image", "images/gallery-1.jpg");
                defaultGallery.put("gallery_2_image", "images/gallery-2.jpg");
                defaultGallery.put("gallery_3_image", "images/gallery-3.jpg");
                defaultGallery.put("gallery_4_image", "images/gallery-4.jpg");
                
                try {
                    settingsDAO.saveSettings(defaultGallery, "about_gallery_images");
                    galleryImages = settingsDAO.getSettingsByPage("about_gallery_images");
                } catch (Exception e) {
                    System.err.println("❌ Error initializing default gallery: " + e.getMessage());
                    e.printStackTrace();
                    galleryImages = defaultGallery; // Sử dụng default gallery nếu không lưu được
                }
            }
            
            // Set attributes trước khi forward
            request.setAttribute("aboutSettings", allAboutSettings);
            request.setAttribute("values", values != null ? values : new HashMap<>());
            request.setAttribute("galleryImages", galleryImages != null ? galleryImages : new HashMap<>());
            
            // Forward request - chỉ forward một lần
            request.getRequestDispatcher("about.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("❌ Error in AboutServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Chỉ send error nếu response chưa commit
            if (!response.isCommitted()) {
                try {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra khi tải trang giới thiệu: " + e.getMessage());
                } catch (IOException ioException) {
                    System.err.println("❌ Error sending error response: " + ioException.getMessage());
                }
            }
        }
    }
}

