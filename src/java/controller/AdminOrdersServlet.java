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
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "AdminOrdersServlet", urlPatterns = {"/admin/orders"})
public class AdminOrdersServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    
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
        
        // Kiểm tra permission ORDERS
        if (!util.PermissionHelper.hasPermission(session, "ORDERS") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Đơn hàng!");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        // Xử lý xem chi tiết hóa đơn
        if ("view".equals(action) && idStr != null) {
            try {
                int orderId = Integer.parseInt(idStr);
                Order order = orderDAO.getById(orderId);
                
                if (order == null) {
                    session.setAttribute("flashError", "Không tìm thấy hóa đơn!");
                    response.sendRedirect("orders?tab=history");
                    return;
                }
                
                // Load booking đầy đủ nếu có
                if (order.getBooking() != null && order.getBooking().getId() > 0) {
                    Booking booking = bookingDAO.getById(order.getBooking().getId());
                    if (booking != null) {
                        // Load tables cho booking
                        List<Integer> tableIds = bookingDAO.getTableIdsByBookingId(booking.getId());
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
                        order.setBooking(booking);
                    }
                }
                
                request.setAttribute("order", order);
                request.getRequestDispatcher("/admin/order-detail-view.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                session.setAttribute("flashError", "ID hóa đơn không hợp lệ!");
                response.sendRedirect("orders?tab=history");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashError", "Có lỗi xảy ra: " + e.getMessage());
                response.sendRedirect("orders?tab=history");
                return;
            }
        }
        
        String tab = request.getParameter("tab");
        String subTab = request.getParameter("subTab"); // subTab: deposit, refund, table
        String search = request.getParameter("search"); // Tham số tìm kiếm
        
        // Xử lý tab "history" - Lịch sử hóa đơn
        if ("history".equals(tab)) {
            List<Order> orders = null;
            
            // Xử lý search và filter theo subTab
            if (search != null && !search.trim().isEmpty()) {
                // Có tìm kiếm
                if ("deposit".equals(subTab)) {
                    // Tìm kiếm hóa đơn cọc bàn
                    orders = orderDAO.searchDepositOrders(search.trim());
                    request.setAttribute("orderType", "deposit");
                } else if ("refund".equals(subTab)) {
                    // Tìm kiếm hóa đơn hoàn tiền
                    orders = orderDAO.searchRefundOrders(search.trim());
                    request.setAttribute("orderType", "refund");
                } else {
                    // Tìm kiếm hóa đơn tại bàn
                    orders = orderDAO.searchTableOrders(search.trim());
                    request.setAttribute("orderType", "table");
                }
                request.setAttribute("searchKeyword", search);
            } else {
                // Không có tìm kiếm, lấy tất cả
                if ("deposit".equals(subTab)) {
                    // Hóa đơn cọc bàn
                    orders = orderDAO.getDepositOrders();
                    request.setAttribute("orderType", "deposit");
                } else if ("refund".equals(subTab)) {
                    // Hóa đơn hoàn tiền
                    orders = orderDAO.getRefundOrders();
                    request.setAttribute("orderType", "refund");
                } else {
                    // Mặc định: Hóa đơn tại bàn (không phải deposit và refund)
                    orders = orderDAO.getTableOrders();
                    request.setAttribute("orderType", "table");
                }
            }
            
            request.setAttribute("completedOrders", orders);
        } else {
            // Tab "current" - Hóa đơn hiện tại
            List<Booking> activeBookings = bookingDAO.getActiveBookings();
            
            System.out.println("🔍 Found " + activeBookings.size() + " active booking(s) with orders");
            
            // Load order cho mỗi booking (đã có order vì getActiveBookings chỉ lấy booking có order)
            for (Booking booking : activeBookings) {
                Order order = orderDAO.getByBookingId(booking.getId());
                if (order != null) {
                    booking.setOrder(order);
                    System.out.println("✅ Loaded order #" + order.getId() + " for booking #" + booking.getId());
                    // Bộ đếm thời gian sẽ dùng order.createdAt làm mốc (từ lúc hóa đơn được kích hoạt)
                } else {
                    System.out.println("⚠️ No order found for booking #" + booking.getId());
                }
            }
            
            request.setAttribute("activeBookings", activeBookings);
        }
        
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }
}

