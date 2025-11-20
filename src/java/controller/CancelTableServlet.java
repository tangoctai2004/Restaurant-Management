package controller;

import dao.BookingDAO;
import dao.OrderDAO;
import model.Account;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CancelTableServlet", urlPatterns = {"/admin/cancel-table"})
public class CancelTableServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    
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
        
        String bookingIdStr = request.getParameter("bookingId");
        String tableIdStr = request.getParameter("tableId");
        
        if (bookingIdStr == null || tableIdStr == null) {
            response.sendRedirect("orders?tab=current");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int tableId = Integer.parseInt(tableIdStr);
            
            // Lấy order của booking (không phải hóa đơn cọc)
            Order order = orderDAO.getByBookingId(bookingId);
            
            if (order != null && "Unpaid".equals(order.getPaymentStatus()) && order.getTotalAmount() > 0) {
                // Nếu có hóa đơn chưa thanh toán, yêu cầu thanh toán trước
                session.setAttribute("flashError", "Vui lòng thanh toán hóa đơn trước khi hủy bàn! Tổng tiền: " + 
                    String.format("%.0f", order.getTotalAmount()) + " VNĐ");
                response.sendRedirect("orders?tab=current");
                return;
            }
            
            // Hủy bàn (giải phóng bàn và cập nhật booking)
            bookingDAO.releaseTableFromBooking(tableId);
            bookingDAO.updateBookingStatus(bookingId, "Canceled");
            
            // Nếu có order, cập nhật status
            if (order != null) {
                order.setOrderStatus("Canceled");
                orderDAO.updateOrder(order);
            }
            
            session.setAttribute("flashSuccess", "Đã hủy bàn thành công!");
            
            response.sendRedirect("orders?tab=current");
            
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Dữ liệu không hợp lệ!");
            response.sendRedirect("orders?tab=current");
        }
    }
}

