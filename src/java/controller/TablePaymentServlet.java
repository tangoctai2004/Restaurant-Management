package controller;

import dao.BookingDAO;
import dao.OrderDAO;
import model.Account;
import model.Order;
import util.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "TablePaymentServlet", urlPatterns = {"/admin/table-payment"})
public class TablePaymentServlet extends HttpServlet {
    
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
        String method = request.getParameter("method");
        String finalAmountStr = request.getParameter("finalAmount");
        
        if (bookingIdStr == null || tableIdStr == null || method == null) {
            response.sendRedirect("orders?tab=current");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int tableId = Integer.parseInt(tableIdStr);
            
            // Lấy order của booking
            Order order = orderDAO.getByBookingId(bookingId);
            
            if (order == null) {
                session.setAttribute("flashError", "Không tìm thấy hóa đơn cho bàn này!");
                response.sendRedirect("orders?tab=current");
                return;
            }
            
            // Tính số tiền sau khi trừ cọc (luôn luôn trừ cọc)
            // Sử dụng subtotal (tổng tiền món ăn gốc) làm cơ sở tính toán
            long DEPOSIT_AMOUNT = 100000;
            double originalTotal = order.getSubtotal(); // Tổng tiền món ăn (chưa trừ cọc)
            double amountAfterDeposit = Math.max(0, originalTotal - DEPOSIT_AMOUNT);
            
            // Cập nhật totalAmount = số tiền sau khi trừ cọc (số tiền khách phải thanh toán)
            order.setTotalAmount(amountAfterDeposit);
            
            // Xử lý thanh toán
            if ("COD".equals(method)) {
                // Lấy tên bàn trước khi release
                String tableName = "N/A";
                dao.RestaurantTableDAO tableDAO = new dao.RestaurantTableDAO();
                model.RestaurantTable table = tableDAO.getById(tableId);
                if (table != null) {
                    tableName = table.getName();
                }
                
                // Thanh toán tiền mặt
                order.setPaymentMethod("COD");
                order.setPaymentStatus("Paid");
                order.setOrderStatus("Completed");
                
                // Lưu tên bàn vào note để dùng khi in hóa đơn (sau khi release sẽ không còn trong booking.tables)
                if (order.getNote() == null || order.getNote().isEmpty()) {
                    order.setNote("TABLE:" + tableName);
                } else {
                    order.setNote(order.getNote() + ";TABLE:" + tableName);
                }
                
                // Lưu thông tin nhân viên thu ngân và thời gian thanh toán
                order.setCashier(account);
                order.setPaidAt(new java.util.Date());
                
                // Cập nhật order với promotion và discount (nếu có) và payment status
                // Chỉ cần gọi updateOrder một lần, nó sẽ cập nhật tất cả các field
                if (orderDAO.updateOrder(order)) {
                    // Cập nhật status bàn về Available
                    bookingDAO.releaseTableFromBooking(tableId);
                    // Cập nhật booking status
                    bookingDAO.updateBookingStatus(bookingId, "Completed");
                    
                    // Trả về JSON response cho AJAX (bao gồm tên bàn)
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"tableName\": \"" + 
                        tableName.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") + "\"}");
                    return;
                } else {
                    // Trả về lỗi
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": false, \"error\": \"Có lỗi xảy ra khi thanh toán!\"}");
                    return;
                }
                
            } else if ("VNPAY".equals(method)) {
                // Thanh toán VNPay
                // Sử dụng số tiền từ frontend (đã tính chính xác với cọc và discount)
                // Hoặc sử dụng totalAmount đã được tính (sau khi trừ cọc và discount)
                long finalAmount = 0;
                if (finalAmountStr != null && !finalAmountStr.isEmpty()) {
                    try {
                        finalAmount = Long.parseLong(finalAmountStr);
                    } catch (NumberFormatException e) {
                        // Nếu không parse được, sử dụng totalAmount đã được tính
                        finalAmount = Math.max(0, (long)order.getTotalAmount());
                    }
                } else {
                    // Nếu không có finalAmount từ frontend, sử dụng totalAmount đã được tính
                    finalAmount = Math.max(0, (long)order.getTotalAmount());
                }
                
                
                String orderId = "TABLE_PAY_" + System.currentTimeMillis();
                String orderInfo = "Thanh toan hoa don ban " + tableId + " - Booking #" + bookingId;
                
                String paymentUrl = VNPayUtil.createPaymentUrl(
                    request, 
                    finalAmount, 
                    orderInfo, 
                    orderId
                );
                
                if (paymentUrl != null) {
                    // Lưu thông tin vào session để xử lý sau khi thanh toán
                    session.setAttribute("tablePaymentBookingId", bookingId);
                    session.setAttribute("tablePaymentTableId", tableId);
                    session.setAttribute("tablePaymentOrderId", order.getId());
                    session.setAttribute("tablePaymentOrderIdRef", orderId);
                    
                    response.sendRedirect(paymentUrl);
                } else {
                    session.setAttribute("flashError", "Không thể tạo link thanh toán VNPay!");
                    response.sendRedirect("orders?tab=current");
                }
            } else {
                session.setAttribute("flashError", "Phương thức thanh toán không hợp lệ!");
                response.sendRedirect("orders?tab=current");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Dữ liệu không hợp lệ!");
            response.sendRedirect("orders?tab=current");
        }
    }
}

