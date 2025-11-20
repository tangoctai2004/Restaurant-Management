package controller;

import dao.BookingDAO;
import dao.OrderDAO;
import dao.RestaurantSettingsDAO;
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
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "PrintInvoiceServlet", urlPatterns = {"/admin/print-invoice"})
public class PrintInvoiceServlet extends HttpServlet {
    
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
        
        String bookingIdStr = request.getParameter("bookingId");
        String orderIdStr = request.getParameter("orderId");
        String tableIdStr = request.getParameter("tableId");
        
        int bookingId = 0;
        Order order = null;
        Booking booking = null;
        
        try {
            // Nếu có orderId, lấy order trước rồi lấy bookingId từ order
            if (orderIdStr != null && !orderIdStr.isEmpty()) {
                int orderId = Integer.parseInt(orderIdStr);
                order = orderDAO.getById(orderId);
                if (order != null && order.getBooking() != null) {
                    bookingId = order.getBooking().getId();
                }
            } else if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                bookingId = Integer.parseInt(bookingIdStr);
            } else {
                session.setAttribute("flashError", "Thiếu thông tin hóa đơn!");
                response.sendRedirect("orders?tab=history");
                return;
            }
            
            // Lấy thông tin booking và order
            if (booking == null && bookingId > 0) {
                booking = bookingDAO.getById(bookingId);
            }
            
            // Nếu order chưa có và có bookingId, thử lấy order
            // Lưu ý: getByBookingId chỉ lấy hóa đơn bàn ăn, không lấy DEPOSIT/REFUND
            if (order == null && bookingId > 0) {
                // Thử lấy hóa đơn bàn ăn trước
                order = orderDAO.getByBookingId(bookingId);
                // Nếu không có, có thể là hóa đơn cọc hoặc hoàn tiền
                if (order == null) {
                    // Thử lấy hóa đơn cọc
                    order = orderDAO.getDepositOrderByBookingId(bookingId);
                }
                // Nếu vẫn không có, thử lấy hóa đơn hoàn tiền
                if (order == null) {
                    order = orderDAO.getRefundOrderByBookingId(bookingId);
                }
            }
            
            // Nếu order là hóa đơn cọc và không có booking, vẫn cho phép in
            if (order == null) {
                session.setAttribute("flashError", "Không tìm thấy hóa đơn!");
                response.sendRedirect("orders?tab=current");
                return;
            }
            
            // Nếu là hóa đơn cọc (DEPOSIT) hoặc hoàn tiền (REFUND), booking có thể null hoặc cần load lại
            boolean isDepositOrder = "DEPOSIT".equals(order.getNote());
            boolean isRefundOrder = "REFUND".equals(order.getNote());
            boolean isSpecialOrder = isDepositOrder || isRefundOrder;
            
            if (booking == null && !isSpecialOrder) {
                session.setAttribute("flashError", "Không tìm thấy thông tin đặt bàn!");
                response.sendRedirect("orders?tab=current");
                return;
            }
            
            // Nếu booking null nhưng là hóa đơn cọc hoặc hoàn tiền, thử load lại từ order
            if (booking == null && isSpecialOrder && order.getBooking() != null) {
                booking = bookingDAO.getById(order.getBooking().getId());
                if (booking != null) {
                    bookingId = booking.getId();
                }
            }
            
            // Load tables cho booking (nếu có booking)
            if (booking != null && bookingId > 0) {
            java.util.List<Integer> tableIds = bookingDAO.getTableIdsByBookingId(bookingId);
            if (!tableIds.isEmpty()) {
                java.util.List<model.RestaurantTable> tables = new java.util.ArrayList<>();
                dao.RestaurantTableDAO tableDAO = new dao.RestaurantTableDAO();
                for (Integer tableId : tableIds) {
                    model.RestaurantTable table = tableDAO.getById(tableId);
                    if (table != null) {
                        tables.add(table);
                    }
                }
                booking.setTables(tables);
                } else if (order != null && order.getNote() != null && !order.getNote().equals("DEPOSIT")) {
                // Nếu không có tables trong booking (đã bị release), thử lấy từ order.note
                // Format: "TABLE:Bàn 101" hoặc "note;TABLE:Bàn 101"
                    // Chỉ làm điều này cho hóa đơn bàn ăn, không phải hóa đơn cọc
                String note = order.getNote();
                String tableName = null;
                
                // Tìm pattern "TABLE:..." trong note
                if (note.contains("TABLE:")) {
                    int tableIndex = note.indexOf("TABLE:");
                    if (tableIndex >= 0) {
                        String tablePart = note.substring(tableIndex + 6); // "TABLE:".length() = 6
                        // Lấy phần đầu tiên (trước dấu ; nếu có)
                        int semicolonIndex = tablePart.indexOf(";");
                        if (semicolonIndex > 0) {
                            tableName = tablePart.substring(0, semicolonIndex);
                        } else {
                            tableName = tablePart;
                        }
                    }
                }
                
                // Nếu tìm thấy table name, tạo một RestaurantTable object giả để hiển thị
                if (tableName != null && !tableName.isEmpty() && !"N/A".equals(tableName)) {
                    model.RestaurantTable table = new model.RestaurantTable();
                    table.setName(tableName);
                    java.util.List<model.RestaurantTable> tables = new java.util.ArrayList<>();
                    tables.add(table);
                    booking.setTables(tables);
                    }
                }
            }
            
            // Load invoice settings
            RestaurantSettingsDAO settingsDAO = new RestaurantSettingsDAO();
            Map<String, String> invoiceSettings = settingsDAO.getSettingsByPage("invoice");
            if (invoiceSettings == null) {
                invoiceSettings = new HashMap<>();
            }
            
            // Set default values if not present
            if (!invoiceSettings.containsKey("restaurantName")) {
                invoiceSettings.put("restaurantName", "HAH RESTAURANT");
            }
            if (!invoiceSettings.containsKey("address")) {
                invoiceSettings.put("address", "Số 310/3, Ngọc Đại, Xã Đại Mỗ, Huyện Từ Liêm, Đai Mễ, Nam Từ Liêm, Hà Nội, Việt Nam");
            }
            if (!invoiceSettings.containsKey("hotline")) {
                invoiceSettings.put("hotline", "1900 1008");
            }
            
            request.setAttribute("booking", booking);
            request.setAttribute("order", order);
            request.setAttribute("tableId", tableIdStr);
            request.setAttribute("invoiceSettings", invoiceSettings);
            
            request.getRequestDispatcher("/admin/print-invoice.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Dữ liệu không hợp lệ!");
            response.sendRedirect("orders?tab=current");
        }
    }
}

