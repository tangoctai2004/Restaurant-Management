package controller;

import dao.BookingDAO;
import dao.OrderDAO;
import model.Account;
import model.Booking;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "PaymentSuccessServlet", urlPatterns = {"/admin/payment-success"})
public class PaymentSuccessServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private OrderDAO orderDAO = new OrderDAO();
    
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
        
        // Kiểm tra xem có thông tin thanh toán thành công không
        String paymentSuccess = (String) session.getAttribute("paymentSuccess");
        if (!"true".equals(paymentSuccess)) {
            response.sendRedirect("orders?tab=current");
            return;
        }
        
        try {
            Integer bookingId = (Integer) session.getAttribute("paymentBookingId");
            Integer tableId = (Integer) session.getAttribute("paymentTableId");
            String amount = (String) session.getAttribute("paymentAmount");
            String transactionNo = (String) session.getAttribute("paymentTransactionNo");
            String method = (String) session.getAttribute("paymentMethod");
            
            if (bookingId == null) {
                response.sendRedirect("orders?tab=current");
                return;
            }
            
            // Lấy thông tin booking và order
            Booking booking = bookingDAO.getById(bookingId);
            Order order = orderDAO.getByBookingId(bookingId);
            
            // Load tables cho booking - ưu tiên dùng tableId từ session nếu có
            String tableName = "N/A";
            if (booking != null) {
                java.util.List<Integer> tableIds = bookingDAO.getTableIdsByBookingId(bookingId);
                if (!tableIds.isEmpty()) {
                    java.util.List<model.RestaurantTable> tables = new java.util.ArrayList<>();
                    dao.RestaurantTableDAO tableDAO = new dao.RestaurantTableDAO();
                    for (Integer tid : tableIds) {
                        model.RestaurantTable table = tableDAO.getById(tid);
                        if (table != null) {
                            tables.add(table);
                            // Lấy tên bàn đầu tiên
                            if ("N/A".equals(tableName)) {
                                tableName = table.getName();
                            }
                        }
                    }
                    booking.setTables(tables);
                } else if (tableId != null && tableId > 0) {
                    // Nếu không có tables trong booking nhưng có tableId từ session, load trực tiếp
                    dao.RestaurantTableDAO tableDAO = new dao.RestaurantTableDAO();
                    model.RestaurantTable table = tableDAO.getById(tableId);
                    if (table != null) {
                        tableName = table.getName();
                        java.util.List<model.RestaurantTable> tables = new java.util.ArrayList<>();
                        tables.add(table);
                        booking.setTables(tables);
                    }
                }
            } else if (tableId != null && tableId > 0) {
                // Nếu booking null nhưng có tableId, load trực tiếp
                dao.RestaurantTableDAO tableDAO = new dao.RestaurantTableDAO();
                model.RestaurantTable table = tableDAO.getById(tableId);
                if (table != null) {
                    tableName = table.getName();
                }
            }
            
            // Tính số tiền từ amount (VNPay trả về số tiền nhân 100)
            // Số tiền này đã là số tiền sau khi trừ cọc (vì VNPay đã tính với số tiền đã trừ)
            long amountLong = 0;
            if (amount != null && !amount.isEmpty()) {
                try {
                    amountLong = Long.parseLong(amount) / 100;
                } catch (NumberFormatException e) {
                    // Nếu không lấy được từ VNPay, tính từ order và trừ cọc
                    long DEPOSIT_AMOUNT = 100000;
                    amountLong = order != null ? Math.max(0, (long) order.getTotalAmount() - DEPOSIT_AMOUNT) : 0;
                }
            } else if (order != null) {
                // Trừ 100k tiền cọc đã đặt
                long DEPOSIT_AMOUNT = 100000;
                amountLong = Math.max(0, (long) order.getTotalAmount() - DEPOSIT_AMOUNT);
            }
            
            request.setAttribute("booking", booking);
            request.setAttribute("order", order);
            request.setAttribute("tableId", tableId);
            request.setAttribute("tableName", tableName);
            request.setAttribute("amount", amountLong);
            request.setAttribute("transactionNo", transactionNo);
            request.setAttribute("paymentMethod", method);
            
            // Xóa session attributes
            session.removeAttribute("paymentSuccess");
            session.removeAttribute("paymentBookingId");
            session.removeAttribute("paymentTableId");
            session.removeAttribute("paymentAmount");
            session.removeAttribute("paymentTransactionNo");
            session.removeAttribute("paymentMethod");
            
            request.getRequestDispatcher("/admin/payment-success.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashError", "Có lỗi xảy ra!");
            response.sendRedirect("orders?tab=current");
        }
    }
}

