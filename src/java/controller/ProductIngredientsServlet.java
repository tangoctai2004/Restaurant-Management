package controller;

import dao.IngredientDAO;
import dao.ProductDAO;
import dao.ProductIngredientDAO;
import model.Account;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProductIngredientsServlet", urlPatterns = {"/admin/product-ingredients"})
public class ProductIngredientsServlet extends HttpServlet {
    
    private ProductIngredientDAO productIngredientDAO = new ProductIngredientDAO();
    private ProductDAO productDAO = new ProductDAO();
    private IngredientDAO ingredientDAO = new IngredientDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra quyền admin hoặc staff
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        
        if (productIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số productId!");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            
            // Xử lý xóa nguyên liệu (GET request)
            if ("remove".equals(action)) {
                String ingredientIdStr = request.getParameter("ingredientId");
                if (ingredientIdStr != null) {
                    int ingredientId = Integer.parseInt(ingredientIdStr);
                    boolean success = productIngredientDAO.removeIngredientFromProduct(productId, ingredientId);
                    if (success) {
                        session.setAttribute("successMessage", "Đã xóa nguyên liệu thành công!");
                    } else {
                        session.setAttribute("error", "Không thể xóa nguyên liệu!");
                    }
                }
                response.sendRedirect("product-ingredients?productId=" + productId);
                return;
            }
            
            Product product = productDAO.getById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy món ăn!");
                return;
            }
            
            // Lấy danh sách nguyên liệu của món ăn
            List<Map<String, Object>> productIngredients = productIngredientDAO.getIngredientsByProductId(productId);
            
            // Lấy danh sách tất cả nguyên liệu
            List<model.Ingredient> allIngredients = ingredientDAO.getAll();
            
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
            
            request.setAttribute("product", product);
            request.setAttribute("productIngredients", productIngredients);
            request.setAttribute("allIngredients", allIngredients);
            
            request.getRequestDispatcher("/admin/product-ingredients.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ!");
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
        String productIdStr = request.getParameter("productId");
        
        if (productIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số productId!");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            
            if ("add".equals(action)) {
                String ingredientIdStr = request.getParameter("ingredientId");
                String quantityStr = request.getParameter("quantity");
                
                if (ingredientIdStr != null && quantityStr != null) {
                    int ingredientId = Integer.parseInt(ingredientIdStr);
                    double quantity = Double.parseDouble(quantityStr);
                    
                    // Kiểm tra số lượng phải lớn hơn 0
                    if (quantity <= 0) {
                        session.setAttribute("error", "Số lượng phải lớn hơn 0! Nếu muốn xóa nguyên liệu, vui lòng sử dụng nút xóa.");
                        response.sendRedirect("product-ingredients?productId=" + productId);
                        return;
                    }
                    
                    if (productIngredientDAO.exists(productId, ingredientId)) {
                        // Nếu đã tồn tại, cập nhật số lượng
                        productIngredientDAO.updateQuantity(productId, ingredientId, quantity);
                    } else {
                        // Nếu chưa tồn tại, thêm mới
                        productIngredientDAO.addIngredientToProduct(productId, ingredientId, quantity);
                    }
                }
            } else if ("update".equals(action)) {
                String ingredientIdStr = request.getParameter("ingredientId");
                String quantityStr = request.getParameter("quantity");
                
                if (ingredientIdStr != null && quantityStr != null) {
                    int ingredientId = Integer.parseInt(ingredientIdStr);
                    double quantity = Double.parseDouble(quantityStr);
                    
                    // Kiểm tra số lượng phải lớn hơn 0
                    if (quantity <= 0) {
                        session.setAttribute("error", "Số lượng phải lớn hơn 0! Nếu muốn xóa nguyên liệu, vui lòng sử dụng nút xóa.");
                        response.sendRedirect("product-ingredients?productId=" + productId);
                        return;
                    }
                    
                    productIngredientDAO.updateQuantity(productId, ingredientId, quantity);
                    session.setAttribute("successMessage", "Đã cập nhật số lượng nguyên liệu thành công!");
                }
            }
            
            response.sendRedirect("product-ingredients?productId=" + productId);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu không hợp lệ!");
        }
    }
}

