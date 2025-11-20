package controller;

import dao.BookingDAO;
import dao.OrderDAO;
import model.Account;
import model.Booking;
import model.Order;
import model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminBookingsServlet", urlPatterns = {"/admin/bookings"})
public class AdminBookingsServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private OrderDAO orderDAO = new OrderDAO();
    
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
        
        // Kiểm tra permission BOOKING
        if (!util.PermissionHelper.hasPermission(session, "BOOKING") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Đặt bàn!");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        // Xử lý xem chi tiết booking
        if ("view".equals(action) && idStr != null) {
            try {
                int bookingId = Integer.parseInt(idStr);
                Booking booking = bookingDAO.getById(bookingId);
                
                if (booking == null) {
                    request.setAttribute("error", "Không tìm thấy đặt bàn!");
                    response.sendRedirect("bookings");
                    return;
                }
                
                // Load tables cho booking
                List<Integer> tableIds = bookingDAO.getTableIdsByBookingId(bookingId);
                if (!tableIds.isEmpty()) {
                    List<model.RestaurantTable> tables = new ArrayList<>();
                    dao.RestaurantTableDAO tableDAO = new dao.RestaurantTableDAO();
                    for (Integer tableId : tableIds) {
                        model.RestaurantTable table = tableDAO.getById(tableId);
                        if (table != null) {
                            tables.add(table);
                        }
                    }
                    booking.setTables(tables);
                }
                
                // Kiểm tra hóa đơn cọc và hoàn tiền để hiển thị nút hoàn tiền
                Order depositOrder = orderDAO.getDepositOrderByBookingId(bookingId);
                if (depositOrder != null && "Paid".equals(depositOrder.getPaymentStatus())) {
                    // Kiểm tra xem đã có hóa đơn hoàn tiền chưa
                    String checkRefundSql = "SELECT COUNT(*) FROM Orders WHERE booking_id = ? AND note = 'REFUND'";
                    try (java.sql.Connection conn = dao.DBConnection.getConnection();
                         java.sql.PreparedStatement ps = conn.prepareStatement(checkRefundSql)) {
                        ps.setInt(1, bookingId);
                        java.sql.ResultSet rs = ps.executeQuery();
                        if (rs.next() && rs.getInt(1) == 0) {
                            // Chưa có hóa đơn hoàn tiền, lưu vào booking để hiển thị nút
                            booking.setNote(booking.getNote() != null ? booking.getNote() + ";CAN_REFUND" : "CAN_REFUND");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/admin/booking-detail.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID đặt bàn không hợp lệ!");
            }
        }
        
        // Xử lý kích hoạt hóa đơn (khách nhận bàn)
        if ("activate".equals(action) && idStr != null) {
            try {
                int bookingId = Integer.parseInt(idStr);
                
                // Kiểm tra booking có tồn tại không
                Booking booking = bookingDAO.getById(bookingId);
                if (booking == null) {
                    session.setAttribute("flashError", "Không tìm thấy đặt bàn!");
                    response.sendRedirect("bookings");
                    return;
                }
                
                // Kiểm tra booking đã có order chưa
                Order existingOrder = orderDAO.getByBookingId(bookingId);
                if (existingOrder != null) {
                    session.setAttribute("flashError", "Hóa đơn cho đặt bàn này đã được kích hoạt!");
                    response.sendRedirect("bookings");
                    return;
                }
                
                // Tạo Order mới (hóa đơn rỗng, chưa có món)
                Order order = new Order();
                Booking orderBooking = new Booking();
                orderBooking.setId(bookingId);
                order.setBooking(orderBooking);
                // Set account từ booking nếu có
                if (booking.getAccount() != null) {
                    order.setAccount(booking.getAccount());
                }
                order.setSubtotal(0);
                order.setDiscountAmount(0);
                order.setTotalAmount(0);
                order.setPaymentMethod("COD");
                order.setPaymentStatus("Unpaid");
                order.setOrderStatus("Pending");
                order.setNote("Hóa đơn được kích hoạt khi khách nhận bàn");
                
                // Tạo order với cart rỗng
                List<model.CartItem> emptyCart = new ArrayList<>();
                int orderId = orderDAO.createOrder(order, emptyCart);
                
                if (orderId > 0) {
                    // Cập nhật trạng thái bàn từ Reserved sang Occupied
                    List<Integer> tableIds = bookingDAO.getTableIdsByBookingId(bookingId);
                    if (!tableIds.isEmpty()) {
                        dao.RestaurantTableDAO tableDAO = new dao.RestaurantTableDAO();
                        for (Integer tableId : tableIds) {
                            model.RestaurantTable table = tableDAO.getById(tableId);
                            if (table != null) {
                                table.setStatus("Occupied");
                                tableDAO.update(table);
                            }
                        }
                        System.out.println("✅ Updated " + tableIds.size() + " table(s) to Occupied for booking #" + bookingId);
                    }
                    
                    // Cập nhật trạng thái booking - giữ "Confirmed" nhưng có thể thêm logic để phân biệt
                    // (Không đổi status vì database chỉ cho phép các status cố định)
                    // Status sẽ được hiển thị khác trong JSP nếu có order
                    
                    session.setAttribute("flashSuccess", "Đã kích hoạt hóa đơn cho đặt bàn #" + bookingId + "! Khách có thể bắt đầu gọi món.");
                } else {
                    session.setAttribute("flashError", "Có lỗi xảy ra khi kích hoạt hóa đơn!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("flashError", "ID đặt bàn không hợp lệ!");
            }
            response.sendRedirect("bookings");
            return;
        }
        
        // Xử lý hủy booking
        if ("cancel".equals(action) && idStr != null) {
            try {
                int bookingId = Integer.parseInt(idStr);
                boolean success = bookingDAO.cancelBooking(bookingId);
                
                if (success) {
                    session.setAttribute("flashSuccess", "Đã hủy đặt bàn #" + bookingId + " thành công!");
                } else {
                    session.setAttribute("flashError", "Có lỗi xảy ra khi hủy đặt bàn!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("flashError", "ID đặt bàn không hợp lệ!");
            }
            response.sendRedirect("bookings");
            return;
        }
        
        // Xử lý hoàn tiền
        if ("refund".equals(action) && idStr != null) {
            try {
                int bookingId = Integer.parseInt(idStr);
                
                // Kiểm tra xem có hóa đơn cọc đã thanh toán không
                Order depositOrder = orderDAO.getDepositOrderByBookingId(bookingId);
                
                if (depositOrder == null || !"Paid".equals(depositOrder.getPaymentStatus())) {
                    session.setAttribute("flashError", "Không tìm thấy hóa đơn cọc đã thanh toán để hoàn tiền!");
                    response.sendRedirect("bookings");
                    return;
                }
                
                // Kiểm tra xem đã có hóa đơn hoàn tiền chưa
                String checkRefundSql = "SELECT COUNT(*) FROM Orders WHERE booking_id = ? AND note = 'REFUND'";
                try (java.sql.Connection conn = dao.DBConnection.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement(checkRefundSql)) {
                    ps.setInt(1, bookingId);
                    java.sql.ResultSet rs = ps.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        session.setAttribute("flashError", "Hóa đơn hoàn tiền cho đặt bàn này đã được tạo!");
                        response.sendRedirect("bookings");
                        return;
                    }
                }
                
                // Tạo hóa đơn hoàn tiền
                Order refundOrder = new Order();
                Booking refundBooking = new Booking();
                refundBooking.setId(bookingId);
                refundOrder.setBooking(refundBooking);
                
                // Set account từ deposit order nếu có
                if (depositOrder.getAccount() != null) {
                    refundOrder.setAccount(depositOrder.getAccount());
                }
                
                // Thông tin hóa đơn hoàn tiền
                long REFUND_AMOUNT = 100000; // Số tiền hoàn lại
                refundOrder.setSubtotal(REFUND_AMOUNT);
                refundOrder.setDiscountAmount(0);
                refundOrder.setTotalAmount(REFUND_AMOUNT);
                refundOrder.setPaymentMethod("COD"); // Hoàn tại quầy
                refundOrder.setPaymentStatus("Paid");
                refundOrder.setOrderStatus("Completed");
                refundOrder.setNote("REFUND"); // Đánh dấu đây là hóa đơn hoàn tiền
                refundOrder.setCashier(account); // Nhân viên thực hiện hoàn tiền
                refundOrder.setPaidAt(new java.util.Date());
                
                // Tạo hóa đơn hoàn tiền (không có orderDetails)
                int refundOrderId = orderDAO.createOrder(refundOrder, null);
                if (refundOrderId > 0) {
                    System.out.println("✅ Refund order created with ID: " + refundOrderId);
                    session.setAttribute("flashSuccess", "Đã tạo hóa đơn hoàn tiền #" + refundOrderId + " (100,000 VNĐ) cho đặt bàn #" + bookingId + "!");
                } else {
                    System.err.println("❌ Failed to create refund order for booking #" + bookingId);
                    // Kiểm tra xem có phải lỗi do constraint UNIQUE không
                    String errorMsg = "Có lỗi xảy ra khi tạo hóa đơn hoàn tiền! ";
                    errorMsg += "Nếu lỗi liên quan đến booking_id UNIQUE, vui lòng chạy script SQL: RemoveUniqueConstraintFromBookingId.sql";
                    session.setAttribute("flashError", errorMsg);
                }
            } catch (NumberFormatException e) {
                session.setAttribute("flashError", "ID đặt bàn không hợp lệ!");
            } catch (java.sql.SQLException e) {
                e.printStackTrace();
                String errorMsg = "Lỗi database: " + e.getMessage();
                // Kiểm tra xem có phải lỗi UNIQUE constraint không
                if (e.getMessage() != null && e.getMessage().contains("UNIQUE")) {
                    errorMsg += " - Vui lòng chạy script SQL: RemoveUniqueConstraintFromBookingId.sql để bỏ constraint UNIQUE trên booking_id";
                }
                session.setAttribute("flashError", errorMsg);
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashError", "Có lỗi xảy ra: " + e.getMessage());
            }
            response.sendRedirect("bookings");
            return;
        }
        
        // Lấy tham số search
        String search = request.getParameter("search");
        
        // Lấy danh sách bookings
        List<Booking> bookings;
        if (search != null && !search.trim().isEmpty()) {
            bookings = bookingDAO.search(search.trim());
            request.setAttribute("searchKeyword", search);
        } else {
            bookings = bookingDAO.getAll();
        }
        
        // Load order cho mỗi booking để kiểm tra xem đã kích hoạt hóa đơn chưa
        // Và kiểm tra hóa đơn cọc/hoàn tiền
        for (Booking booking : bookings) {
            Order order = orderDAO.getByBookingId(booking.getId());
            if (order != null) {
                booking.setOrder(order);
            }
            
            // Kiểm tra hóa đơn cọc và hoàn tiền để hiển thị nút hoàn tiền
            Order depositOrder = orderDAO.getDepositOrderByBookingId(booking.getId());
            if (depositOrder != null && "Paid".equals(depositOrder.getPaymentStatus())) {
                // Kiểm tra xem đã có hóa đơn hoàn tiền chưa
                String checkRefundSql = "SELECT COUNT(*) FROM Orders WHERE booking_id = ? AND note = 'REFUND'";
                try (java.sql.Connection conn = dao.DBConnection.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement(checkRefundSql)) {
                    ps.setInt(1, booking.getId());
                    java.sql.ResultSet rs = ps.executeQuery();
                    if (rs.next() && rs.getInt(1) == 0) {
                        // Chưa có hóa đơn hoàn tiền, lưu vào booking để hiển thị nút
                        booking.setNote(booking.getNote() != null ? booking.getNote() + ";CAN_REFUND" : "CAN_REFUND");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        
        request.setAttribute("bookings", bookings);
        
        // Kiểm tra flash message
        String flashSuccess = (String) session.getAttribute("flashSuccess");
        if (flashSuccess != null) {
            request.setAttribute("flashSuccess", flashSuccess);
            session.removeAttribute("flashSuccess");
        }
        
        String flashError = (String) session.getAttribute("flashError");
        if (flashError != null) {
            request.setAttribute("error", flashError);
            session.removeAttribute("flashError");
        }
        
        request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
    }
}

