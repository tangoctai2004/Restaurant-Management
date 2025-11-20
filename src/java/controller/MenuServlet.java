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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "MenuServlet", urlPatterns = {"/menu"})
public class MenuServlet extends HttpServlet {
    
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ProductDAO productDAO = new ProductDAO();
    private RestaurantSettingsDAO settingsDAO = new RestaurantSettingsDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy settings cho trang thực đơn
        Map<String, String> menuSettings = settingsDAO.getSettingsByPage("menu");
        
        // Lấy tất cả danh mục
        List<Category> allCategories = categoryDAO.getAll();
        
        // Lọc danh mục theo settings
        String selectedCategoriesStr = menuSettings.get("selectedCategories");
        List<Category> displayCategories = new ArrayList<>();
        
        if (selectedCategoriesStr != null && !selectedCategoriesStr.trim().isEmpty()) {
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
        
        // Lấy tất cả sản phẩm đang bán
        List<Product> allProducts = productDAO.getAllActive();
        
        // Lọc sản phẩm theo settings
        Map<Integer, List<Product>> productsByCategory = new HashMap<>();
        for (Category cat : displayCategories) {
            String selectedProductsKey = "selectedProducts_cat_" + cat.getId();
            String selectedProductsStr = menuSettings.get(selectedProductsKey);
            
            List<Product> categoryProducts;
            if (selectedProductsStr != null && !selectedProductsStr.trim().isEmpty()) {
                // Chỉ hiển thị các món đã chọn
                List<String> selectedProductIds = Arrays.asList(selectedProductsStr.split(","));
                categoryProducts = allProducts.stream()
                    .filter(p -> p.getCategoryId() == cat.getId() && selectedProductIds.contains(String.valueOf(p.getId())))
                    .collect(Collectors.toList());
            } else {
                // Hiển thị tất cả món trong category
                categoryProducts = allProducts.stream()
                    .filter(p -> p.getCategoryId() == cat.getId())
                    .collect(Collectors.toList());
            }
            productsByCategory.put(cat.getId(), categoryProducts);
        }
        
        // Lấy số lượng món mỗi dòng
        int itemsPerRow = 4; // Mặc định
        try {
            String itemsPerRowStr = menuSettings.get("itemsPerRow");
            if (itemsPerRowStr != null && !itemsPerRowStr.trim().isEmpty()) {
                itemsPerRow = Integer.parseInt(itemsPerRowStr.trim());
            }
        } catch (NumberFormatException e) {
            // Giữ giá trị mặc định
        }
        
        // Kiểm tra có đơn hàng đang xử lý không
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<model.CartItem> cart = (List<model.CartItem>) session.getAttribute("cart");
        request.setAttribute("hasActiveOrder", cart != null && !cart.isEmpty());
        
        // Set attributes
        request.setAttribute("categories", displayCategories);
        request.setAttribute("allProducts", allProducts);
        request.setAttribute("productsByCategory", productsByCategory);
        request.setAttribute("menuSettings", menuSettings);
        request.setAttribute("itemsPerRow", itemsPerRow);
        
        request.getRequestDispatcher("menu.jsp").forward(request, response);
    }
}



