package controller;

import dao.PromotionDAO;
import model.Account;
import model.Promotion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "AdminPromotionsServlet", urlPatterns = {"/admin/promotions"})
public class AdminPromotionsServlet extends HttpServlet {
    
    private PromotionDAO promotionDAO = new PromotionDAO();
    
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
        
        // Kiểm tra permission PROMOTIONS
        if (!util.PermissionHelper.hasPermission(session, "PROMOTIONS") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Khuyến mãi!");
            return;
        }
        
        // Xử lý action delete
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    if (promotionDAO.delete(id)) {
                        request.setAttribute("successMessage", "Xóa khuyến mãi thành công!");
                    } else {
                        request.setAttribute("error", "Không thể xóa khuyến mãi này!");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID không hợp lệ!");
                }
            }
        }
        
        // Lấy danh sách promotions
        List<Promotion> promotions = promotionDAO.getAll();
        request.setAttribute("promotions", promotions);
        
        request.getRequestDispatcher("/admin/promotions.jsp").forward(request, response);
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
        String code = request.getParameter("code");
        String description = request.getParameter("description");
        String discountType = request.getParameter("discountType");
        String discountValueStr = request.getParameter("discountValue");
        String minOrderValueStr = request.getParameter("minOrderValue");
        String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String isActiveStr = request.getParameter("isActive");
        
        // Validation
        if (code == null || code.trim().isEmpty() || 
            discountType == null || discountValueStr == null || 
            startDateStr == null || endDateStr == null) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin! (Mã KM, Loại giảm, Giá trị, Ngày bắt đầu, Ngày kết thúc là bắt buộc)");
            doGet(request, response);
            return;
        }
        
        try {
            Promotion promo = new Promotion();
            promo.setCode(code.trim());
            promo.setDescription(description != null ? description.trim() : "");
            promo.setDiscountType(discountType);
            promo.setDiscountValue(Double.parseDouble(discountValueStr.trim()));
            promo.setMinOrderValue(minOrderValueStr != null && !minOrderValueStr.trim().isEmpty() 
                ? Double.parseDouble(minOrderValueStr.trim()) : 0);
            promo.setMaxDiscountAmount(maxDiscountAmountStr != null && !maxDiscountAmountStr.trim().isEmpty() 
                ? Double.parseDouble(maxDiscountAmountStr.trim()) : null);
            promo.setActive(isActiveStr != null && "on".equals(isActiveStr));
            
            // Parse dates từ datetime-local format (yyyy-MM-ddTHH:mm)
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            try {
                java.util.Date startDate = sdf.parse(startDateStr);
                java.util.Date endDate = sdf.parse(endDateStr);
                promo.setStartDate(new Date(startDate.getTime()));
                promo.setEndDate(new Date(endDate.getTime()));
            } catch (ParseException e) {
                request.setAttribute("error", "Định dạng ngày không hợp lệ!");
                doGet(request, response);
                return;
            }
            
            boolean success = false;
            if ("add".equals(action)) {
                success = promotionDAO.create(promo);
                if (success) {
                    request.setAttribute("successMessage", "Thêm khuyến mãi thành công!");
                } else {
                    request.setAttribute("error", "Không thể thêm khuyến mãi! (Có thể mã KM đã tồn tại)");
                }
            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    promo.setId(Integer.parseInt(idStr));
                    success = promotionDAO.update(promo);
                    if (success) {
                        request.setAttribute("successMessage", "Cập nhật khuyến mãi thành công!");
                    } else {
                        request.setAttribute("error", "Không thể cập nhật khuyến mãi!");
                    }
                }
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        
        doGet(request, response);
    }
}

