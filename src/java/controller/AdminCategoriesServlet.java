package controller;

import dao.CategoryDAO;
import model.Account;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoriesServlet", urlPatterns = {"/admin/categories"})
public class AdminCategoriesServlet extends HttpServlet {
    
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
        
        // Kiểm tra permission CATEGORIES
        if (!util.PermissionHelper.hasPermission(session, "CATEGORIES") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Danh mục!");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        // Xử lý xóa danh mục (GET request)
        if ("delete".equals(action) && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                boolean success = categoryDAO.delete(id);
                if (success) {
                    session.setAttribute("successMessage", "Đã xóa danh mục thành công!");
                } else {
                    session.setAttribute("error", "Không thể xóa danh mục! Có thể danh mục này đang được sử dụng bởi các món ăn.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID danh mục không hợp lệ!");
            }
            response.sendRedirect("categories");
            return;
        }
        
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
        
        // Lấy tham số search
        String search = request.getParameter("search");
        
        // Lấy danh sách categories
        List<Category> categories;
        if (search != null && !search.trim().isEmpty()) {
            categories = categoryDAO.search(search.trim());
            request.setAttribute("searchKeyword", search);
        } else {
            categories = categoryDAO.getAll();
        }
        
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
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
        String description = request.getParameter("description");
        String idStr = request.getParameter("id");
        
        if (name == null || name.trim().isEmpty()) {
            session.setAttribute("error", "Tên danh mục không được để trống!");
            response.sendRedirect("categories");
            return;
        }
        
        try {
            if ("add".equals(action)) {
                // Thêm danh mục mới
                Category category = new Category();
                category.setName(name.trim());
                category.setDescription(description != null ? description.trim() : null);
                
                boolean success = categoryDAO.create(category);
                if (success) {
                    session.setAttribute("successMessage", "Đã thêm danh mục '" + category.getName() + "' thành công!");
                } else {
                    session.setAttribute("error", "Không thể thêm danh mục! Có thể tên danh mục đã tồn tại.");
                }
            } else if ("update".equals(action) && idStr != null) {
                // Cập nhật danh mục
                int id = Integer.parseInt(idStr);
                Category category = new Category();
                category.setId(id);
                category.setName(name.trim());
                category.setDescription(description != null ? description.trim() : null);
                
                boolean success = categoryDAO.update(category);
                if (success) {
                    session.setAttribute("successMessage", "Đã cập nhật danh mục thành công!");
                } else {
                    session.setAttribute("error", "Không thể cập nhật danh mục!");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID danh mục không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect("categories");
    }
}

