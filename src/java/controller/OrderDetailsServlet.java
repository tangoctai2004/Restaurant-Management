package controller;

import dao.BookingDAO;
import dao.CategoryDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import model.Account;
import model.Booking;
import model.Order;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderDetailsServlet", urlPatterns = {"/admin/order-details"})
public class OrderDetailsServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
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
        
        if (bookingIdStr == null) {
            response.sendRedirect("orders?tab=current");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // Lấy booking
            Booking booking = bookingDAO.getById(bookingId);
            if (booking == null) {
                session.setAttribute("flashError", "Không tìm thấy đặt bàn!");
                response.sendRedirect("orders?tab=current");
                return;
            }
            
            // Lấy order (nếu có)
            Order order = orderDAO.getByBookingId(bookingId);
            
            if (order == null) {
                session.setAttribute("flashError", "Hóa đơn chưa được kích hoạt cho booking này!");
                response.sendRedirect("orders?tab=current");
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
            
            // Lấy danh sách categories và products (chỉ món đang bán)
            List<model.Category> categories = categoryDAO.getAll();
            List<Product> products = productDAO.getAllActive();
            
            request.setAttribute("booking", booking);
            request.setAttribute("order", order);
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("tableId", tableIdStr);
            
            request.getRequestDispatcher("/admin/order-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Dữ liệu không hợp lệ!");
            response.sendRedirect("orders?tab=current");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra quyền admin hoặc staff
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Bạn không có quyền truy cập!\"}");
            return;
        }
        
        String action = request.getParameter("action");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            if ("addItem".equals(action)) {
                String orderIdStr = request.getParameter("orderId");
                String productIdStr = request.getParameter("productId");
                
                if (orderIdStr == null || productIdStr == null) {
                    out.print("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
                    return;
                }
                
                int orderId = Integer.parseInt(orderIdStr);
                int productId = Integer.parseInt(productIdStr);
                
                Product product = productDAO.getById(productId);
                if (product == null) {
                    out.print("{\"success\": false, \"message\": \"Không tìm thấy sản phẩm!\"}");
                    return;
                }
                
                // Kiểm tra món có đang bán không
                if (!product.isActive()) {
                    out.print("{\"success\": false, \"message\": \"Món ăn này đang tạm dừng, không thể thêm vào đơn hàng!\"}");
                    return;
                }
                
                // Kiểm tra món đã có trong order chưa (chỉ lấy món chưa lên)
                model.OrderDetail existingUncompleted = orderDAO.getOrderDetailByProduct(orderId, productId);
                
                // Kiểm tra xem có món đã lên không
                model.OrderDetail existingCompleted = orderDAO.getCompletedOrderDetailByProduct(orderId, productId);
                
                if (existingUncompleted != null) {
                    // Có món chưa lên → chỉ tăng số lượng
                    int newQuantity = existingUncompleted.getQuantity() + 1;
                    orderDAO.updateQuantity(existingUncompleted.getId(), newQuantity);
                } else if (existingCompleted != null) {
                    // Có món đã lên nhưng không có món chưa lên → tạo record mới cho phần chưa lên
                    orderDAO.addItemToOrder(orderId, productId, 1, product.getPrice());
                } else {
                    // Chưa có món nào → thêm mới
                    orderDAO.addItemToOrder(orderId, productId, 1, product.getPrice());
                }
                
                // Tính lại tổng tiền
                orderDAO.recalculateOrderTotal(orderId);
                
                out.print("{\"success\": true, \"message\": \"Đã thêm món vào hóa đơn!\"}");
                
            } else if ("updateQuantity".equals(action)) {
                String detailIdStr = request.getParameter("detailId");
                String quantityStr = request.getParameter("quantity");
                
                if (detailIdStr == null || quantityStr == null) {
                    out.print("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
                    return;
                }
                
                int detailId = Integer.parseInt(detailIdStr);
                int quantity = Integer.parseInt(quantityStr);
                
                if (quantity < 1) {
                    out.print("{\"success\": false, \"message\": \"Số lượng phải lớn hơn 0!\"}");
                    return;
                }
                
                // Lấy thông tin detail trước khi update
                model.OrderDetail detailBefore = orderDAO.getOrderDetailById(detailId);
                if (detailBefore == null) {
                    out.print("{\"success\": false, \"message\": \"Không tìm thấy món!\"}");
                    return;
                }
                
                int orderId = detailBefore.getOrderId();
                int productId = detailBefore.getProduct().getId();
                boolean wasCompleted = detailBefore.isCompleted();
                int oldQuantity = detailBefore.getQuantity();
                
                // Nếu tăng số lượng và món đã completed → tách thành 2 record
                if (quantity > oldQuantity && wasCompleted) {
                    // Giữ nguyên record đã lên với quantity = 1, completed = true
                    orderDAO.updateQuantity(detailId, 1);
                    // Tạo record mới cho phần chưa lên
                    int newUncompletedQuantity = quantity - 1;
                    orderDAO.addItemToOrder(orderId, productId, newUncompletedQuantity, detailBefore.getPrice());
                }
                // Nếu giảm số lượng món đã completed
                else if (quantity < oldQuantity && wasCompleted) {
                    // Không cho phép giảm số lượng món đã lên
                    out.print("{\"success\": false, \"message\": \"Không thể giảm số lượng món đã lên!\"}");
                    return;
                }
                // Nếu giảm số lượng món chưa completed
                else if (!wasCompleted) {
                    // Nếu giảm về 1 và có record đã lên cùng product → xóa record chưa lên này
                    if (quantity == 1) {
                        model.OrderDetail completedDetail = orderDAO.getCompletedOrderDetailByProduct(orderId, productId);
                        if (completedDetail != null) {
                            // Có món đã lên → xóa record chưa lên này
                            orderDAO.removeItem(detailId);
                        } else {
                            // Không có món đã lên → chỉ cập nhật số lượng
                            boolean success = orderDAO.updateQuantity(detailId, quantity);
                            if (!success) {
                                out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra!\"}");
                                return;
                            }
                        }
                    } else {
                        // Giảm số lượng nhưng vẫn > 1 → chỉ cập nhật số lượng
                        boolean success = orderDAO.updateQuantity(detailId, quantity);
                        if (!success) {
                            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra!\"}");
                            return;
                        }
                    }
                }
                // Các trường hợp khác (món đã completed và không tăng) → không làm gì
                else {
                    out.print("{\"success\": false, \"message\": \"Không thể thay đổi số lượng món đã lên!\"}");
                    return;
                }
                
                // Tính lại tổng tiền
                orderDAO.recalculateOrderTotal(orderId);
                out.print("{\"success\": true, \"message\": \"Đã cập nhật số lượng!\"}");
                
            } else if ("removeItem".equals(action)) {
                String detailIdStr = request.getParameter("detailId");
                
                if (detailIdStr == null) {
                    out.print("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
                    return;
                }
                
                int detailId = Integer.parseInt(detailIdStr);
                
                // Lấy thông tin detail trước khi xóa
                model.OrderDetail detail = orderDAO.getOrderDetailById(detailId);
                if (detail == null) {
                    out.print("{\"success\": false, \"message\": \"Không tìm thấy món!\"}");
                    return;
                }
                
                int orderId = detail.getOrderId();
                boolean wasCompleted = detail.isCompleted();
                
                // Kiểm tra nếu món đã lên thì không cho xóa
                if (wasCompleted) {
                    out.print("{\"success\": false, \"message\": \"Không thể xóa món đã lên!\"}");
                    return;
                }
                
                // Chỉ xóa món chưa lên
                boolean success = orderDAO.removeItem(detailId);
                if (success) {
                    orderDAO.recalculateOrderTotal(orderId);
                    out.print("{\"success\": true, \"message\": \"Đã xóa món khỏi hóa đơn!\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra!\"}");
                }
                
            } else if ("toggleCompleted".equals(action)) {
                String detailIdStr = request.getParameter("detailId");
                String completedStr = request.getParameter("completed");
                
                if (detailIdStr == null || completedStr == null) {
                    out.print("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
                    return;
                }
                
                int detailId = Integer.parseInt(detailIdStr);
                boolean completed = Boolean.parseBoolean(completedStr);
                
                // Lấy orderId trước khi toggle
                model.OrderDetail detail = orderDAO.getOrderDetailById(detailId);
                if (detail == null) {
                    out.print("{\"success\": false, \"message\": \"Không tìm thấy món!\"}");
                    return;
                }
                
                int orderId = detail.getOrderId();
                
                boolean success = orderDAO.toggleCompleted(detailId, completed);
                if (success) {
                    // Tự động tính lại tổng tiền
                    orderDAO.recalculateOrderTotal(orderId);
                    out.print("{\"success\": true, \"message\": \"Đã cập nhật trạng thái!\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra!\"}");
                }
                
            } else if ("deleteAllUncompleted".equals(action)) {
                String orderIdStr = request.getParameter("orderId");
                
                if (orderIdStr == null) {
                    out.print("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
                    return;
                }
                
                int orderId = Integer.parseInt(orderIdStr);
                boolean success = orderDAO.deleteAllUncompletedItems(orderId);
                
                if (success) {
                    orderDAO.recalculateOrderTotal(orderId);
                    out.print("{\"success\": true, \"message\": \"Đã xóa tất cả món chưa lên!\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra!\"}");
                }
                
            } else {
                out.print("{\"success\": false, \"message\": \"Action không hợp lệ!\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ!\"}");
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Unknown error";
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + errorMsg + "\"}");
        }
    }
}

