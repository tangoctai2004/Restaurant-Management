package controller;

import dao.RestaurantSettingsDAO;
import dao.CategoryDAO;
import model.Account;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "AdminRestaurantSetupServlet", urlPatterns = {"/admin/restaurant-setup"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminRestaurantSetupServlet extends HttpServlet {
    
    private RestaurantSettingsDAO settingsDAO = new RestaurantSettingsDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        // Kiểm tra permission RESTAURANT_SETUP
        if (!util.PermissionHelper.hasPermission(session, "RESTAURANT_SETUP") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Thiết lập nhà hàng!");
            return;
        }
        
        // Lấy tất cả settings
        Map<String, String> allSettings = settingsDAO.getAllSettings();
        request.setAttribute("settings", allSettings);
        
        // Lấy settings theo từng trang để dễ hiển thị
        // Lưu ý: Các section được lưu với pageName_section, nên cần load đúng
        // Load từng section riêng biệt và merge lại (ưu tiên section-specific settings)
        Map<String, String> allHomeSettings = new HashMap<>();
        
        // Load từ "home" trước (các settings chung)
        Map<String, String> homeSettings = settingsDAO.getSettingsByPage("home");
        if (homeSettings != null) {
            allHomeSettings.putAll(homeSettings);
        }
        
        // Load từ "home_hero" (Hero section - override nếu có)
        Map<String, String> homeHeroSettings = settingsDAO.getSettingsByPage("home_hero");
        if (homeHeroSettings != null && !homeHeroSettings.isEmpty()) {
            System.out.println("✅ Loaded home_hero settings: " + homeHeroSettings);
            allHomeSettings.putAll(homeHeroSettings);
        }
        
        // Load từ "home_menuSection" (Menu section - override nếu có)
        Map<String, String> homeMenuSectionSettings = settingsDAO.getSettingsByPage("home_menuSection");
        if (homeMenuSectionSettings != null) {
            allHomeSettings.putAll(homeMenuSectionSettings);
        }
        
        // Load từ "home_aboutSection" (About section - override nếu có)
        Map<String, String> homeAboutSectionSettings = settingsDAO.getSettingsByPage("home_aboutSection");
        if (homeAboutSectionSettings != null) {
            allHomeSettings.putAll(homeAboutSectionSettings);
        }
        
        request.setAttribute("homeSettings", allHomeSettings);
        request.setAttribute("menuSettings", settingsDAO.getSettingsByPage("menu"));
        request.setAttribute("reservationSettings", settingsDAO.getSettingsByPage("reservation"));
        
        // Load about settings (merge tất cả sections)
        Map<String, String> allAboutSettings = new HashMap<>();
        allAboutSettings.putAll(settingsDAO.getSettingsByPage("about"));
        allAboutSettings.putAll(settingsDAO.getSettingsByPage("about_hero"));
        allAboutSettings.putAll(settingsDAO.getSettingsByPage("about_story"));
        allAboutSettings.putAll(settingsDAO.getSettingsByPage("about_values"));
        allAboutSettings.putAll(settingsDAO.getSettingsByPage("about_gallery"));
        request.setAttribute("aboutSettings", allAboutSettings);
        
        // Load values và gallery images cho about page
        Map<String, String> values = settingsDAO.getSettingsByPage("about_values_items");
        request.setAttribute("values", values);
        Map<String, String> galleryImages = settingsDAO.getSettingsByPage("about_gallery_images");
        request.setAttribute("galleryImages", galleryImages);
        
        // Load contact settings (merge tất cả sections)
        Map<String, String> allContactSettings = new HashMap<>();
        allContactSettings.putAll(settingsDAO.getSettingsByPage("contact"));
        allContactSettings.putAll(settingsDAO.getSettingsByPage("contact_hero"));
        allContactSettings.putAll(settingsDAO.getSettingsByPage("contact_section"));
        allContactSettings.putAll(settingsDAO.getSettingsByPage("contact_form"));
        allContactSettings.putAll(settingsDAO.getSettingsByPage("contact_map"));
        request.setAttribute("contactSettings", allContactSettings);
        
        // Load contact info items
        Map<String, String> contactInfoItems = settingsDAO.getSettingsByPage("contact_info_items");
        request.setAttribute("contactInfoItems", contactInfoItems);
        
        // Load footer settings
        Map<String, String> footerSettings = settingsDAO.getSettingsByPage("footer");
        request.setAttribute("footerSettings", footerSettings);
        
        // Load invoice settings
        Map<String, String> invoiceSettings = settingsDAO.getSettingsByPage("invoice");
        if (invoiceSettings == null) {
            invoiceSettings = new HashMap<>();
        }
        request.setAttribute("invoiceSettings", invoiceSettings);
        
        request.setAttribute("contactSettings", settingsDAO.getSettingsByPage("contact"));
        request.setAttribute("headerSettings", settingsDAO.getSettingsByPage("header"));
        request.setAttribute("footerSettings", settingsDAO.getSettingsByPage("footer"));
        
        // Lấy danh sách categories cho section thực đơn
        List<Category> categories = categoryDAO.getAll();
        request.setAttribute("categories", categories);
        
        // Lấy danh sách products cho section thực đơn
        dao.ProductDAO productDAO = new dao.ProductDAO();
        List<model.Product> allProducts = productDAO.getAllActive();
        request.setAttribute("allProducts", allProducts);
        
        // Lấy danh sách features (các phần giới thiệu)
        Map<String, String> aboutFeatures = settingsDAO.getSettingsByPage("about_features");
        
        // Nếu chưa có features, khởi tạo các features mặc định
        if (aboutFeatures.isEmpty()) {
            // Khởi tạo 3 features mặc định
            Map<String, String> defaultFeatures = new HashMap<>();
            defaultFeatures.put("feature_1_title", "Thực đơn phong phú");
            defaultFeatures.put("feature_1_description", "Đa dạng món ăn cùng nhiều combo hấp dẫn, phục vụ mọi khẩu vị thực khách.");
            defaultFeatures.put("feature_1_icon", "fa fa-utensils");
            
            defaultFeatures.put("feature_2_title", "Không gian rộng rãi");
            defaultFeatures.put("feature_2_description", "Ấm cúng - Độc đáo - Thoải mái check-in. Có phòng riêng cho hội họp, sinh nhật.");
            defaultFeatures.put("feature_2_icon", "fa fa-chair");
            
            defaultFeatures.put("feature_3_title", "Phục vụ tận tâm");
            defaultFeatures.put("feature_3_description", "Chu đáo - Tận tình - Hết mình vì khách hàng, mang lại trải nghiệm tốt nhất.");
            defaultFeatures.put("feature_3_icon", "fa fa-heart");
            
            // Lưu vào database
            settingsDAO.saveSettings(defaultFeatures, "about_features");
            
            // Lấy lại sau khi lưu
            aboutFeatures = settingsDAO.getSettingsByPage("about_features");
        }
        
        request.setAttribute("aboutFeatures", aboutFeatures);
        
        // Lấy thông báo từ session nếu có
        String error = (String) session.getAttribute("error");
        String successMessage = (String) session.getAttribute("successMessage");
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        
        // Lấy activeTab từ session để giữ tab hiện tại sau khi lưu
        String activeTab = (String) session.getAttribute("activeTab");
        if (activeTab != null) {
            request.setAttribute("activeTab", activeTab);
            session.removeAttribute("activeTab"); // Xóa sau khi dùng
        }
        
        request.getRequestDispatcher("/admin/restaurant-setup.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra quyền admin hoặc staff
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        String pageName = request.getParameter("pageName");
        String section = request.getParameter("section"); // section riêng biệt
        String activeTab = request.getParameter("activeTab"); // Tab hiện tại để giữ lại sau khi lưu
        
        // Lưu activeTab vào session để giữ tab sau khi redirect
        if (activeTab != null && !activeTab.trim().isEmpty()) {
            session.setAttribute("activeTab", activeTab.trim());
        } else if (pageName != null && !pageName.trim().isEmpty()) {
            // Nếu không có activeTab, dùng pageName làm tab mặc định
            session.setAttribute("activeTab", pageName.trim());
        }
        
        if (pageName == null || pageName.trim().isEmpty()) {
            session.setAttribute("error", "Không xác định được trang cần cập nhật!");
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
            return;
        }
        
        try {
            Map<String, String> settings = new HashMap<>();
            
            // Xử lý upload ảnh nếu có
            String imageFieldName = request.getParameter("imageFieldName");
            if (imageFieldName != null && !imageFieldName.isEmpty()) {
                try {
                    String imageUrl = handleImageUpload(request, imageFieldName);
                    if (imageUrl != null && !imageUrl.isEmpty()) {
                        String settingKey = imageFieldName.replace("setting_", "");
                        settings.put(settingKey, imageUrl);
                    }
                } catch (Exception e) {
                    System.err.println("Error uploading image: " + e.getMessage());
                }
            }
            
            // Lấy tất cả parameters bắt đầu bằng "setting_"
            Map<String, String[]> parameterMap = request.getParameterMap();
            for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
                String key = entry.getKey();
                if (key.startsWith("setting_") && (imageFieldName == null || !key.equals(imageFieldName))) {
                    String settingKey = key.substring(8); // Bỏ "setting_" prefix
                    String value = entry.getValue()[0];
                    settings.put(settingKey, value);
                }
            }
            
            // Xử lý đặc biệt cho section thực đơn (selected categories)
            if ("home".equals(pageName) && "menuSection".equals(section)) {
                String[] selectedCategories = request.getParameterValues("selectedCategories");
                if (selectedCategories != null && selectedCategories.length > 0) {
                    settings.put("selectedCategories", String.join(",", selectedCategories));
                } else {
                    settings.put("selectedCategories", ""); // Xóa tất cả nếu không chọn gì
                }
            }
            
            // Xử lý đặc biệt cho trang thực đơn
            if ("menu".equals(pageName)) {
                try {
                    // Xử lý selected categories
                    String[] selectedCategories = request.getParameterValues("selectedCategories");
                    if (selectedCategories != null && selectedCategories.length > 0) {
                        settings.put("selectedCategories", String.join(",", selectedCategories));
                    } else {
                        settings.put("selectedCategories", ""); // Xóa tất cả nếu không chọn gì
                    }
                    
                    // Lấy danh sách categories để xử lý selected products
                    CategoryDAO categoryDAO = new CategoryDAO();
                    List<Category> categories = categoryDAO.getAll();
                    
                    // Xử lý selected products cho mỗi category (chỉ xử lý các category đã chọn)
                    if (selectedCategories != null && selectedCategories.length > 0) {
                        for (String catIdStr : selectedCategories) {
                            try {
                                int catId = Integer.parseInt(catIdStr);
                                String[] selectedProducts = request.getParameterValues("selectedProducts_cat_" + catId);
                                if (selectedProducts != null && selectedProducts.length > 0) {
                                    settings.put("selectedProducts_cat_" + catId, String.join(",", selectedProducts));
                                } else {
                                    // Nếu không chọn gì, xóa setting này (sẽ hiển thị tất cả)
                                    settings.put("selectedProducts_cat_" + catId, "");
                                }
                            } catch (NumberFormatException e) {
                                System.err.println("⚠️ Invalid category ID: " + catIdStr);
                            }
                        }
                    }
                    
                    // Xử lý showSearchBox và showDetailButton (checkbox)
                    String showSearchBox = request.getParameter("setting_showSearchBox");
                    settings.put("showSearchBox", showSearchBox != null && "true".equals(showSearchBox) ? "true" : "false");
                    
                    String showDetailButton = request.getParameter("setting_showDetailButton");
                    settings.put("showDetailButton", showDetailButton != null && "true".equals(showDetailButton) ? "true" : "false");
                    
                    System.out.println("✅ Menu settings processed: " + settings);
                } catch (Exception e) {
                    System.err.println("❌ Error processing menu settings: " + e.getMessage());
                    e.printStackTrace();
                    session.setAttribute("error", "Có lỗi xảy ra khi xử lý thiết lập thực đơn: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                    return;
                }
            }
            
            // Xử lý đặc biệt cho values (các value cards)
            if ("about".equals(pageName) && "aboutValues".equals(section)) {
                String action = request.getParameter("valueAction");
                System.out.println("🔧 Processing value action: " + action);
                
                // Load tất cả values hiện có từ database
                Map<String, String> allValues = settingsDAO.getSettingsByPage("about_values_items");
                System.out.println("📋 Current values in DB: " + allValues);
                
                if ("add".equals(action) || "update".equals(action)) {
                    String valueId = request.getParameter("valueId");
                    String valueTitle = request.getParameter("valueTitle");
                    String valueDescription = request.getParameter("valueDescription");
                    String valueIcon = request.getParameter("valueIcon");
                    
                    System.out.println("📝 Value data - ID: " + valueId + ", Title: " + valueTitle);
                    
                    if (valueId != null && !valueId.isEmpty() && valueTitle != null && !valueTitle.trim().isEmpty()) {
                        if (valueId.startsWith("new_")) {
                            valueId = "value_" + System.currentTimeMillis() + "_" + (int)(Math.random() * 1000);
                            System.out.println("✨ Creating new value with ID: " + valueId);
                        } else {
                            if (!valueId.startsWith("value_")) {
                                valueId = "value_" + valueId;
                            }
                            System.out.println("🔄 Updating existing value with ID: " + valueId);
                        }
                        
                        allValues.put(valueId + "_title", valueTitle != null ? valueTitle.trim() : "");
                        allValues.put(valueId + "_description", valueDescription != null ? valueDescription.trim() : "");
                        allValues.put(valueId + "_icon", valueIcon != null && !valueIcon.trim().isEmpty() ? valueIcon.trim() : "fa fa-star");
                        allValues.remove(valueId + "_deleted");
                        
                        System.out.println("💾 All values after update: " + allValues);
                    } else {
                        System.err.println("⚠️ Invalid value data - missing ID or Title");
                        session.setAttribute("error", "Vui lòng điền đầy đủ thông tin value!");
                        response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                        return;
                    }
                } else if ("delete".equals(action)) {
                    String valueId = request.getParameter("valueId");
                    if (valueId != null && !valueId.isEmpty()) {
                        if (!valueId.startsWith("value_")) {
                            valueId = "value_" + valueId;
                        }
                        allValues.put(valueId + "_deleted", "true");
                        System.out.println("🗑️ Deleting value: " + valueId);
                    }
                }
                
                String actualPageName = "about_values_items";
                System.out.println("💾 Saving all values to page: " + actualPageName);
                boolean success = settingsDAO.saveSettings(allValues, actualPageName);
                
                if (success) {
                    String actionName = "add".equals(action) ? "Thêm" : ("update".equals(action) ? "Cập nhật" : "Xóa");
                    session.setAttribute("successMessage", "Đã " + actionName + " value card thành công!");
                } else {
                    session.setAttribute("error", "Có lỗi xảy ra khi " + ("add".equals(action) ? "thêm" : ("update".equals(action) ? "cập nhật" : "xóa")) + " value card!");
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                return;
            }
            
            // Xử lý đặc biệt cho gallery images
            if ("about".equals(pageName) && "aboutGallery".equals(section)) {
                String action = request.getParameter("galleryAction");
                System.out.println("🔧 Processing gallery action: " + action);
                
                // Load tất cả gallery images hiện có từ database
                Map<String, String> allGalleryImages = settingsDAO.getSettingsByPage("about_gallery_images");
                System.out.println("📋 Current gallery images in DB: " + allGalleryImages);
                
                if ("add".equals(action) || "update".equals(action)) {
                    String galleryId = request.getParameter("galleryId");
                    String galleryImageFieldName = request.getParameter("imageFieldName");
                    
                    // Xử lý upload ảnh
                    String imagePath = null;
                    if (galleryImageFieldName != null && !galleryImageFieldName.isEmpty()) {
                        imagePath = handleImageUpload(request, galleryImageFieldName);
                    }
                    
                    System.out.println("📝 Gallery data - ID: " + galleryId + ", Image: " + imagePath);
                    
                    if (galleryId != null && !galleryId.isEmpty()) {
                        if (galleryId.startsWith("new_")) {
                            galleryId = "gallery_" + System.currentTimeMillis() + "_" + (int)(Math.random() * 1000);
                            System.out.println("✨ Creating new gallery image with ID: " + galleryId);
                        } else {
                            if (!galleryId.startsWith("gallery_")) {
                                galleryId = "gallery_" + galleryId;
                            }
                            System.out.println("🔄 Updating existing gallery image with ID: " + galleryId);
                        }
                        
                        // Nếu có ảnh mới, cập nhật; nếu không, giữ nguyên ảnh cũ
                        if (imagePath != null && !imagePath.isEmpty()) {
                            allGalleryImages.put(galleryId + "_image", imagePath);
                        } else if ("add".equals(action)) {
                            // Nếu là thêm mới mà không có ảnh, báo lỗi
                            session.setAttribute("error", "Vui lòng chọn ảnh!");
                            response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                            return;
                        }
                        // Nếu là update mà không có ảnh mới, giữ nguyên ảnh cũ
                        
                        allGalleryImages.remove(galleryId + "_deleted");
                        System.out.println("💾 All gallery images after update: " + allGalleryImages);
                    } else {
                        System.err.println("⚠️ Invalid gallery data - missing ID");
                        session.setAttribute("error", "Có lỗi xảy ra!");
                        response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                        return;
                    }
                } else if ("delete".equals(action)) {
                    String galleryId = request.getParameter("galleryId");
                    if (galleryId != null && !galleryId.isEmpty()) {
                        if (!galleryId.startsWith("gallery_")) {
                            galleryId = "gallery_" + galleryId;
                        }
                        allGalleryImages.put(galleryId + "_deleted", "true");
                        System.out.println("🗑️ Deleting gallery image: " + galleryId);
                    }
                }
                
                String actualPageName = "about_gallery_images";
                System.out.println("💾 Saving all gallery images to page: " + actualPageName);
                boolean success = settingsDAO.saveSettings(allGalleryImages, actualPageName);
                
                if (success) {
                    String actionName = "add".equals(action) ? "Thêm" : ("update".equals(action) ? "Cập nhật" : "Xóa");
                    session.setAttribute("successMessage", "Đã " + actionName + " ảnh gallery thành công!");
                } else {
                    session.setAttribute("error", "Có lỗi xảy ra khi " + ("add".equals(action) ? "thêm" : ("update".equals(action) ? "cập nhật" : "xóa")) + " ảnh gallery!");
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                return;
            }
            
            // Xử lý đặc biệt cho contact info items
            if ("contact".equals(pageName) && "contactInfo".equals(section)) {
                String action = request.getParameter("infoAction");
                System.out.println("🔧 Processing contact info action: " + action);
                
                // Load tất cả contact info items hiện có từ database
                Map<String, String> allContactInfoItems = settingsDAO.getSettingsByPage("contact_info_items");
                System.out.println("📋 Current contact info items in DB: " + allContactInfoItems);
                
                if ("add".equals(action) || "update".equals(action)) {
                    String infoId = request.getParameter("infoId");
                    String infoTitle = request.getParameter("infoTitle");
                    String infoContent = request.getParameter("infoContent");
                    String infoIcon = request.getParameter("infoIcon");
                    
                    System.out.println("📝 Contact info data - ID: " + infoId + ", Title: " + infoTitle);
                    
                    if (infoId != null && !infoId.isEmpty() && infoTitle != null && !infoTitle.trim().isEmpty()) {
                        if (infoId.startsWith("new_")) {
                            infoId = "info_" + System.currentTimeMillis() + "_" + (int)(Math.random() * 1000);
                            System.out.println("✨ Creating new contact info with ID: " + infoId);
                        } else {
                            if (!infoId.startsWith("info_")) {
                                infoId = "info_" + infoId;
                            }
                            System.out.println("🔄 Updating existing contact info with ID: " + infoId);
                        }
                        
                        allContactInfoItems.put(infoId + "_title", infoTitle != null ? infoTitle.trim() : "");
                        allContactInfoItems.put(infoId + "_content", infoContent != null ? infoContent.trim() : "");
                        allContactInfoItems.put(infoId + "_icon", infoIcon != null && !infoIcon.trim().isEmpty() ? infoIcon.trim() : "fa fa-star");
                        allContactInfoItems.remove(infoId + "_deleted");
                        
                        System.out.println("💾 All contact info items after update: " + allContactInfoItems);
                    } else {
                        System.err.println("⚠️ Invalid contact info data - missing ID or Title");
                        session.setAttribute("error", "Vui lòng điền đầy đủ thông tin contact info!");
                        response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                        return;
                    }
                } else if ("delete".equals(action)) {
                    String infoId = request.getParameter("infoId");
                    if (infoId != null && !infoId.isEmpty()) {
                        if (!infoId.startsWith("info_")) {
                            infoId = "info_" + infoId;
                        }
                        allContactInfoItems.put(infoId + "_deleted", "true");
                        System.out.println("🗑️ Deleting contact info: " + infoId);
                    }
                }
                
                String actualPageName = "contact_info_items";
                System.out.println("💾 Saving all contact info items to page: " + actualPageName);
                boolean success = settingsDAO.saveSettings(allContactInfoItems, actualPageName);
                
                if (success) {
                    String actionName = "add".equals(action) ? "Thêm" : ("update".equals(action) ? "Cập nhật" : "Xóa");
                    session.setAttribute("successMessage", "Đã " + actionName + " contact info thành công!");
                } else {
                    session.setAttribute("error", "Có lỗi xảy ra khi " + ("add".equals(action) ? "thêm" : ("update".equals(action) ? "cập nhật" : "xóa")) + " contact info!");
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                return;
            }
            
            // Xử lý đặc biệt cho features (các phần giới thiệu)
            if ("about".equals(pageName) && "aboutFeatures".equals(section)) {
                String action = request.getParameter("featureAction");
                System.out.println("🔧 Processing feature action: " + action);
                
                // Load tất cả features hiện có từ database
                Map<String, String> allFeatures = settingsDAO.getSettingsByPage("about_features");
                System.out.println("📋 Current features in DB: " + allFeatures);
                
                if ("add".equals(action) || "update".equals(action)) {
                    String featureId = request.getParameter("featureId");
                    String featureTitle = request.getParameter("featureTitle");
                    String featureDescription = request.getParameter("featureDescription");
                    String featureIcon = request.getParameter("featureIcon");
                    
                    System.out.println("📝 Feature data - ID: " + featureId + ", Title: " + featureTitle);
                    
                    if (featureId != null && !featureId.isEmpty() && featureTitle != null && !featureTitle.trim().isEmpty()) {
                        // Nếu là feature mới, tạo ID từ timestamp + random để tránh trùng
                        if (featureId.startsWith("new_")) {
                            featureId = "feature_" + System.currentTimeMillis() + "_" + (int)(Math.random() * 1000);
                            System.out.println("✨ Creating new feature with ID: " + featureId);
                        } else {
                            // Đảm bảo có prefix "feature_"
                            if (!featureId.startsWith("feature_")) {
                                featureId = "feature_" + featureId;
                            }
                            System.out.println("🔄 Updating existing feature with ID: " + featureId);
                        }
                        
                        // Cập nhật hoặc thêm feature vào map
                        allFeatures.put(featureId + "_title", featureTitle != null ? featureTitle.trim() : "");
                        allFeatures.put(featureId + "_description", featureDescription != null ? featureDescription.trim() : "");
                        allFeatures.put(featureId + "_icon", featureIcon != null && !featureIcon.trim().isEmpty() ? featureIcon.trim() : "fa fa-star");
                        // Đảm bảo không bị đánh dấu deleted
                        allFeatures.remove(featureId + "_deleted");
                        
                        System.out.println("💾 All features after update: " + allFeatures);
                    } else {
                        System.err.println("⚠️ Invalid feature data - missing ID or Title");
                        session.setAttribute("error", "Vui lòng điền đầy đủ thông tin feature!");
                        response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                        return;
                    }
                } else if ("delete".equals(action)) {
                    String featureId = request.getParameter("featureId");
                    if (featureId != null && !featureId.isEmpty()) {
                        if (!featureId.startsWith("feature_")) {
                            featureId = "feature_" + featureId;
                        }
                        // Đánh dấu là đã xóa (giữ lại trong DB nhưng đánh dấu deleted)
                        allFeatures.put(featureId + "_deleted", "true");
                        System.out.println("🗑️ Deleting feature: " + featureId);
                        System.out.println("💾 All features after delete: " + allFeatures);
                    }
                }
                
                // Lưu tất cả features lại vào database
                String actualPageName = "about_features";
                System.out.println("💾 Saving all features to page: " + actualPageName);
                boolean success = settingsDAO.saveSettings(allFeatures, actualPageName);
                
                if (success) {
                    String actionName = "add".equals(action) ? "Thêm" : ("update".equals(action) ? "Cập nhật" : "Xóa");
                    session.setAttribute("successMessage", "Đã " + actionName + " feature thành công!");
                } else {
                    session.setAttribute("error", "Có lỗi xảy ra khi " + ("add".equals(action) ? "thêm" : ("update".equals(action) ? "cập nhật" : "xóa")) + " feature!");
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
                return;
            }
            
            // Lưu settings cho các section khác
            // Đối với reservation, luôn lưu vào "reservation" (không thêm section suffix)
            String actualPageName;
            if ("reservation".equals(pageName)) {
                actualPageName = "reservation"; // Luôn lưu vào reservation, không phải reservation_general
            } else {
                actualPageName = section != null && !section.isEmpty() ? pageName + "_" + section : pageName;
            }
            System.out.println("💾 Saving settings to page: " + actualPageName + ", settings: " + settings);
            boolean success = settingsDAO.saveSettings(settings, actualPageName);
            
            if (success) {
                String sectionName = section != null ? " (" + section + ")" : "";
                session.setAttribute("successMessage", "Đã lưu thiết lập cho " + pageName + sectionName + " thành công!");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi lưu thiết lập!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/restaurant-setup");
    }
    
    /**
     * Xử lý upload file ảnh
     */
    private String handleImageUpload(HttpServletRequest request, String fieldName) {
        try {
            Part filePart = request.getPart(fieldName);
            
            if (filePart == null || filePart.getSize() == 0) {
                return null;
            }
            
            String fileName = filePart.getSubmittedFileName();
            if (fileName == null || fileName.isEmpty()) {
                return null;
            }
            
            // Lấy extension
            String extension = "";
            int lastDotIndex = fileName.lastIndexOf('.');
            if (lastDotIndex > 0) {
                extension = fileName.substring(lastDotIndex);
            }
            
            // Tạo tên file mới
            String newFileName = "restaurant_" + UUID.randomUUID().toString() + extension;
            
            // Lấy đường dẫn thư mục images
            String uploadPath = getServletContext().getRealPath("/images");
            File uploadDir = new File(uploadPath);
            
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Lưu file
            File file = new File(uploadDir, newFileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            
            return "images/" + newFileName;
            
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            return null;
        }
    }
}

