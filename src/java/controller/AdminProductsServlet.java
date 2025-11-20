package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Account;
import model.Category;
import model.Product;
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
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminProductsServlet", urlPatterns = {"/admin/products"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminProductsServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
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
        
        // Kiểm tra permission PRODUCTS
        if (!util.PermissionHelper.hasPermission(session, "PRODUCTS") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Món ăn!");
            return;
        }
        
        // Xử lý action delete và calculateCost
        String action = request.getParameter("action");
        if ("calculateCost".equals(action)) {
            // AJAX request để tính giá vốn
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    double costPrice = productDAO.calculateCostPrice(id);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\":true,\"costPrice\":" + costPrice + "}");
                    return;
                } catch (NumberFormatException e) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
                    return;
                }
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    if (productDAO.delete(id)) {
                        request.setAttribute("successMessage", "Xóa món ăn thành công!");
                    } else {
                        request.setAttribute("error", "Không thể xóa món ăn này!");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID không hợp lệ!");
                }
            }
        }
        
        // Lấy tham số search và categoryId
        String search = request.getParameter("search");
        String categoryIdStr = request.getParameter("categoryId");
        
        // Lấy danh sách products và categories
        try {
            List<Product> products;
            List<Category> categories = categoryDAO.getAll();
            
            // Xử lý search và filter
            if ((search != null && !search.trim().isEmpty()) || (categoryIdStr != null && !categoryIdStr.trim().isEmpty())) {
                String keyword = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
                Integer categoryId = null;
                if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                    try {
                        categoryId = Integer.parseInt(categoryIdStr.trim());
                    } catch (NumberFormatException e) {
                        categoryId = null;
                    }
                }
                products = productDAO.searchAndFilter(keyword, categoryId);
            } else {
                products = productDAO.getAll();
            }
            
            System.out.println("AdminProductsServlet: Loaded " + products.size() + " products and " + categories.size() + " categories");
            
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            if (search != null) {
                request.setAttribute("searchKeyword", search);
            }
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                request.setAttribute("selectedCategoryId", categoryIdStr);
            }
            
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("AdminProductsServlet ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            // Vẫn forward để hiển thị trang với thông báo lỗi
            try {
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + ex.getMessage());
            }
        }
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
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String categoryIdStr = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String imageUrl = request.getParameter("imageUrl");
        String isActiveStr = request.getParameter("isActive");
        
        // Validation: kiểm tra cả null và empty string
        if (name == null || name.trim().isEmpty() || 
            categoryIdStr == null || categoryIdStr.trim().isEmpty() || 
            priceStr == null || priceStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin! (Tên món, Danh mục, Giá bán là bắt buộc)");
            doGet(request, response);
            return;
        }
        
        // Xử lý upload file ảnh
        // Lấy URL ảnh hiện tại từ database nếu đang sửa
        String currentImageUrl = imageUrl;
        if ("update".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    Product existingProduct = productDAO.getById(Integer.parseInt(idStr));
                    if (existingProduct != null) {
                        currentImageUrl = existingProduct.getImageUrl();
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
        }
        String uploadedImageUrl = handleImageUpload(request, currentImageUrl);
        
        try {
            Product product = new Product();
            product.setName(name.trim());
            product.setCategoryId(Integer.parseInt(categoryIdStr.trim()));
            product.setDescription(description != null ? description.trim() : "");
            product.setPrice(Double.parseDouble(priceStr.trim()));
            product.setImageUrl(uploadedImageUrl);
            product.setActive(isActiveStr != null && "on".equals(isActiveStr));
            product.setCostPrice(0); // Sẽ được tính tự động sau khi lưu
            
            boolean success = false;
            if ("add".equals(action)) {
                success = productDAO.create(product);
                if (success) {
                    request.setAttribute("successMessage", "Thêm món ăn thành công! Giá vốn đã được tính tự động từ nguyên liệu.");
                } else {
                    request.setAttribute("error", "Không thể thêm món ăn!");
                }
            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    product.setId(Integer.parseInt(idStr));
                    success = productDAO.update(product);
                    if (success) {
                        request.setAttribute("successMessage", "Cập nhật món ăn thành công! Giá vốn đã được tính lại tự động.");
                    } else {
                        request.setAttribute("error", "Không thể cập nhật món ăn!");
                    }
                }
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        
        doGet(request, response);
    }
    
    /**
     * Xử lý upload file ảnh
     * @param request HttpServletRequest
     * @param existingImageUrl URL ảnh hiện tại (nếu có, dùng khi không upload ảnh mới)
     * @return Đường dẫn ảnh (URL) để lưu vào database
     */
    private String handleImageUpload(HttpServletRequest request, String existingImageUrl) {
        try {
            Part filePart = request.getPart("imageFile");
            
            // Nếu không có file upload, giữ nguyên ảnh cũ (khi sửa)
            if (filePart == null || filePart.getSize() == 0) {
                return existingImageUrl != null && !existingImageUrl.trim().isEmpty() 
                    ? existingImageUrl.trim() : "";
            }
            
            // Lấy tên file gốc
            String fileName = filePart.getSubmittedFileName();
            if (fileName == null || fileName.isEmpty()) {
                return existingImageUrl != null && !existingImageUrl.trim().isEmpty() 
                    ? existingImageUrl.trim() : "";
            }
            
            // Lấy extension của file
            String extension = "";
            int lastDotIndex = fileName.lastIndexOf('.');
            if (lastDotIndex > 0) {
                extension = fileName.substring(lastDotIndex);
            }
            
            // Tạo tên file mới (UUID để tránh trùng lặp)
            String newFileName = "product_" + UUID.randomUUID().toString() + extension;
            
            // Lấy đường dẫn thư mục images trong webapp
            String uploadPath = getServletContext().getRealPath("/images");
            File uploadDir = new File(uploadPath);
            
            // Tạo thư mục nếu chưa tồn tại
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Đường dẫn file đầy đủ
            File file = new File(uploadDir, newFileName);
            
            // Lưu file
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Trả về đường dẫn để lưu vào database (relative path)
            return "images/" + newFileName;
            
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            // Nếu có lỗi, trả về ảnh cũ hoặc rỗng
            return existingImageUrl != null && !existingImageUrl.trim().isEmpty() 
                ? existingImageUrl.trim() : "";
        }
    }
}

