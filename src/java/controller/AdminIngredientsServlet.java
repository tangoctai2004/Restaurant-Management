package controller;

import dao.IngredientDAO;
import model.Account;
import model.Ingredient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminIngredientsServlet", urlPatterns = {"/admin/ingredients"})
public class AdminIngredientsServlet extends HttpServlet {
    
    private IngredientDAO ingredientDAO = new IngredientDAO();
    
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
        
        // Kiểm tra permission INGREDIENTS
        if (!util.PermissionHelper.hasPermission(session, "INGREDIENTS") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Nguyên liệu!");
            return;
        }
        
        // Xử lý action delete
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    if (ingredientDAO.delete(id)) {
                        // Sau khi xóa nguyên liệu, cần tính lại giá vốn cho tất cả món ăn
                        dao.ProductDAO productDAO = new dao.ProductDAO();
                        productDAO.recalculateAllCostPrices();
                        request.setAttribute("successMessage", "Xóa nguyên liệu thành công!");
                    } else {
                        request.setAttribute("error", "Không thể xóa nguyên liệu này!");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID không hợp lệ!");
                }
            }
        }
        
        // Lấy tham số search
        String search = request.getParameter("search");
        
        // Lấy danh sách ingredients
        List<Ingredient> ingredients;
        if (search != null && !search.trim().isEmpty()) {
            ingredients = ingredientDAO.search(search.trim());
            request.setAttribute("searchKeyword", search);
        } else {
            ingredients = ingredientDAO.getAll();
        }
        
        request.setAttribute("ingredients", ingredients);
        
        request.getRequestDispatcher("/admin/ingredients.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        // Kiểm tra permission INGREDIENTS
        if (!util.PermissionHelper.hasPermission(session, "INGREDIENTS") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Nguyên liệu!");
            return;
        }
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String unit = request.getParameter("unit");
        String priceStr = request.getParameter("price");
        
        if (name == null || name.trim().isEmpty() || unit == null || unit.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin! (Tên và đơn vị là bắt buộc)");
            doGet(request, response);
            return;
        }
        
        try {
            Ingredient ingredient = new Ingredient();
            ingredient.setName(name.trim());
            ingredient.setUnit(unit.trim());
            ingredient.setPrice(priceStr != null && !priceStr.trim().isEmpty() 
                ? Double.parseDouble(priceStr.trim()) : 0);
            
            boolean success = false;
            if ("add".equals(action)) {
                success = ingredientDAO.create(ingredient);
                if (success) {
                    request.setAttribute("successMessage", "Thêm nguyên liệu thành công!");
                } else {
                    request.setAttribute("error", "Không thể thêm nguyên liệu!");
                }
            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    ingredient.setId(Integer.parseInt(idStr));
                    success = ingredientDAO.update(ingredient);
                    if (success) {
                        request.setAttribute("successMessage", "Cập nhật nguyên liệu thành công!");
                        // Sau khi cập nhật giá nguyên liệu, tính lại giá vốn cho tất cả món ăn
                        dao.ProductDAO productDAO = new dao.ProductDAO();
                        productDAO.recalculateAllCostPrices();
                    } else {
                        request.setAttribute("error", "Không thể cập nhật nguyên liệu!");
                    }
                }
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        
        doGet(request, response);
    }
}

