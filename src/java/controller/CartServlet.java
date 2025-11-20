package controller;

import dao.PromotionDAO;
import model.CartItem;
import model.Promotion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
    
    private PromotionDAO promotionDAO = new PromotionDAO();
    
    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("cartItems", new java.util.ArrayList<>());
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }
        
        // Tính tổng tiền
        double subtotal = 0;
        for (CartItem item : cart) {
            subtotal += item.getTotal();
        }
        
        // Xử lý mã khuyến mãi
        String action = request.getParameter("action");
        Promotion appliedPromo = (Promotion) session.getAttribute("appliedPromo");
        double discountAmount = 0;
        
        if ("applyPromo".equals(action)) {
            String promoCode = request.getParameter("code");
            if (promoCode != null && !promoCode.trim().isEmpty()) {
                Promotion promo = promotionDAO.getByCode(promoCode);
                if (promo != null) {
                    discountAmount = promotionDAO.calculateDiscount(promo, subtotal);
                    if (discountAmount > 0) {
                        session.setAttribute("appliedPromo", promo);
                        session.setAttribute("discountAmount", discountAmount);
                    } else {
                        request.setAttribute("promoError", "Mã khuyến mãi không áp dụng được cho đơn hàng này!");
                    }
                } else {
                    request.setAttribute("promoError", "Mã khuyến mãi không hợp lệ hoặc đã hết hạn!");
                }
            }
            appliedPromo = (Promotion) session.getAttribute("appliedPromo");
            Double discountAmountObj = (Double) session.getAttribute("discountAmount");
            discountAmount = (discountAmountObj != null) ? discountAmountObj : 0;
        } else {
            if (appliedPromo != null) {
                discountAmount = promotionDAO.calculateDiscount(appliedPromo, subtotal);
                session.setAttribute("discountAmount", discountAmount);
            }
        }
        
        double totalAmount = subtotal - discountAmount;
        
        request.setAttribute("cartItems", cart);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("appliedPromo", appliedPromo);
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
}



