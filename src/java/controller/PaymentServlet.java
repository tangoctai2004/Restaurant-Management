package controller;

import dao.OrderDAO;
import dao.PromotionDAO;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private PromotionDAO promotionDAO = new PromotionDAO();
    
    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("menu");
            return;
        }
        
        // Tính tổng tiền
        double subtotal = 0;
        for (CartItem item : cart) {
            subtotal += item.getTotal();
        }
        
        // Tính giảm giá
        Promotion appliedPromo = (Promotion) session.getAttribute("appliedPromo");
        double discountAmount = 0;
        if (appliedPromo != null) {
            discountAmount = promotionDAO.calculateDiscount(appliedPromo, subtotal);
        }
        
        double totalAmount = subtotal - discountAmount;
        
        request.setAttribute("cartItems", cart);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("totalAmount", totalAmount);
        
        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }
    
    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("menu");
            return;
        }
        
        String paymentMethod = request.getParameter("paymentMethod");
        String note = request.getParameter("note");
        
        // Tính tổng tiền
        double subtotal = 0;
        for (CartItem item : cart) {
            subtotal += item.getTotal();
        }
        
        // Tính giảm giá
        Promotion appliedPromo = (Promotion) session.getAttribute("appliedPromo");
        double discountAmount = 0;
        if (appliedPromo != null) {
            discountAmount = promotionDAO.calculateDiscount(appliedPromo, subtotal);
        }
        
        double totalAmount = subtotal - discountAmount;
        
        // Tạo đơn hàng
        Order order = new Order();
        order.setAccount(account);
        order.setPromotion(appliedPromo);
        order.setSubtotal(subtotal);
        order.setDiscountAmount(discountAmount);
        order.setTotalAmount(totalAmount);
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("Unpaid");
        order.setOrderStatus("Pending");
        order.setNote(note);
        
        int orderId = orderDAO.createOrder(order, cart);
        
        if (orderId > 0) {
            // Xóa giỏ hàng và mã khuyến mãi
            session.removeAttribute("cart");
            session.removeAttribute("appliedPromo");
            session.removeAttribute("discountAmount");
            
            session.setAttribute("flashSuccess", "Đặt hàng thành công! Mã đơn hàng: #" + orderId);
            response.sendRedirect("order-history");
        } else {
            request.setAttribute("error", "Đặt hàng thất bại! Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}



