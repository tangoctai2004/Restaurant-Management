package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.RestaurantSettingsDAO;
import model.Category;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ProductDAO productDAO = new ProductDAO();
    private RestaurantSettingsDAO settingsDAO = new RestaurantSettingsDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy settings cho trang chủ
        Map<String, String> homeSettings = settingsDAO.getSettingsByPage("home");
        Map<String, String> heroSettings = settingsDAO.getSettingsByPage("home_hero");
        Map<String, String> menuSectionSettings = settingsDAO.getSettingsByPage("home_menuSection");
        Map<String, String> aboutSectionSettings = settingsDAO.getSettingsByPage("home_aboutSection");
        Map<String, String> aboutFeatures = settingsDAO.getSettingsByPage("about_features");
        
        // Nếu chưa có features, khởi tạo mặc định
        if (aboutFeatures.isEmpty()) {
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
            
            settingsDAO.saveSettings(defaultFeatures, "about_features");
            aboutFeatures = settingsDAO.getSettingsByPage("about_features");
        }
        
        // Merge tất cả settings (ưu tiên section-specific settings)
        Map<String, String> allHomeSettings = new HashMap<>(homeSettings);
        allHomeSettings.putAll(heroSettings);
        allHomeSettings.putAll(menuSectionSettings);
        allHomeSettings.putAll(aboutSectionSettings);
        
        // Lấy danh sách danh mục
        List<Category> allCategories = categoryDAO.getAll();
        
        // Lấy danh sách category được chọn (nếu có)
        String selectedCategoriesStr = menuSectionSettings.get("selectedCategories");
        List<Category> displayCategories = new ArrayList<>();
        
        if (selectedCategoriesStr != null && !selectedCategoriesStr.trim().isEmpty()) {
            // Parse danh sách ID đã chọn
            List<String> selectedIds = Arrays.asList(selectedCategoriesStr.split(","));
            for (Category cat : allCategories) {
                if (selectedIds.contains(String.valueOf(cat.getId()))) {
                    displayCategories.add(cat);
                }
            }
        } else {
            // Nếu chưa có setting, hiển thị tất cả
            displayCategories = allCategories;
        }
        
        // Lấy số lượng món hiển thị mỗi category
        int itemsPerCategory = 6; // Mặc định
        try {
            String itemsPerCategoryStr = menuSectionSettings.get("itemsPerCategory");
            if (itemsPerCategoryStr != null && !itemsPerCategoryStr.trim().isEmpty()) {
                itemsPerCategory = Integer.parseInt(itemsPerCategoryStr.trim());
            }
        } catch (NumberFormatException e) {
            // Giữ giá trị mặc định
        }
        
        // Lấy danh sách sản phẩm đang bán (chỉ món active)
        List<Product> allProducts = productDAO.getAllActive();
        
        // Lọc và giới hạn số lượng món cho mỗi category
        Map<Integer, List<Product>> productsByCategory = new HashMap<>();
        for (Category cat : displayCategories) {
            List<Product> categoryProducts = allProducts.stream()
                .filter(p -> p.getCategoryId() == cat.getId())
                .limit(itemsPerCategory)
                .collect(Collectors.toList());
            productsByCategory.put(cat.getId(), categoryProducts);
        }
        
        // Set attributes
        request.setAttribute("categoryList", displayCategories);
        request.setAttribute("productList", allProducts);
        request.setAttribute("productsByCategory", productsByCategory);
        request.setAttribute("homeSettings", allHomeSettings);
        request.setAttribute("aboutFeatures", aboutFeatures);
        
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}



