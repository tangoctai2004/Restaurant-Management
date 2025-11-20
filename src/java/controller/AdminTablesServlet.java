package controller;

import dao.BookingDAO;
import dao.RestaurantTableDAO;
import model.Account;
import model.RestaurantTable;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminTablesServlet", urlPatterns = {"/admin/tables"})
public class AdminTablesServlet extends HttpServlet {
    
    private RestaurantTableDAO tableDAO = new RestaurantTableDAO();
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
        
        // Kiểm tra permission TABLES
        if (!util.PermissionHelper.hasPermission(session, "TABLES") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Quản lý bàn!");
            return;
        }
        
        // Xử lý xóa bàn
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    // Giải phóng bàn khỏi booking trước khi xóa
                    bookingDAO.releaseTableFromBooking(id);
                    tableDAO.delete(id);
                    session.setAttribute("successMessage", "Xóa bàn thành công!");
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID bàn không hợp lệ!");
                }
            }
        }
        
        // Lấy danh sách tables
        List<RestaurantTable> tables = tableDAO.getAll();
        request.setAttribute("tables", tables);
        
        // Kiểm tra flash message
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }
        
        request.getRequestDispatcher("/admin/tables.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        // Kiểm tra permission TABLES
        if (!util.PermissionHelper.hasPermission(session, "TABLES") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Quản lý bàn!");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String capacityStr = request.getParameter("capacity");
        String locationArea = request.getParameter("locationArea");
        String status = request.getParameter("status");
        
        try {
            if ("add".equals(action)) {
                // Thêm bàn mới
                RestaurantTable table = new RestaurantTable();
                table.setName(name);
                table.setCapacity(Integer.parseInt(capacityStr));
                table.setLocationArea(locationArea);
                table.setStatus(status != null ? status : "Available");
                
                if (tableDAO.create(table)) {
                    session.setAttribute("successMessage", "Thêm bàn mới thành công!");
                } else {
                    request.setAttribute("error", "Có lỗi xảy ra khi thêm bàn!");
                }
            } else if ("update".equals(action) && idStr != null) {
                // Cập nhật bàn
                int id = Integer.parseInt(idStr);
                RestaurantTable oldTable = tableDAO.getById(id);
                
                if (oldTable == null) {
                    request.setAttribute("error", "Không tìm thấy bàn!");
                    doGet(request, response);
                    return;
                }
                
                // Kiểm tra nếu bàn đang ở trạng thái "Occupied" và có order chưa thanh toán
                if ("Occupied".equals(oldTable.getStatus()) && !"Occupied".equals(status)) {
                    dao.OrderDAO orderDAO = new dao.OrderDAO();
                    if (orderDAO.hasUnpaidOrder(id)) {
                        // Bàn đang được sử dụng và có hóa đơn chưa thanh toán
                        session.setAttribute("errorMessage", "Bàn này đang có khách và chưa thanh toán. Vui lòng thanh toán hóa đơn trước khi thay đổi trạng thái!");
                        response.sendRedirect("tables");
                        return;
                    }
                }
                
                RestaurantTable table = new RestaurantTable();
                table.setId(id);
                table.setName(name);
                table.setCapacity(Integer.parseInt(capacityStr));
                table.setLocationArea(locationArea);
                table.setStatus(status != null ? status : "Available");
                
                // Kiểm tra nếu status bàn thay đổi từ Reserved sang trạng thái khác
                // thì cần giải phóng booking
                if ("Reserved".equals(oldTable.getStatus()) && !"Reserved".equals(table.getStatus())) {
                    // Bàn đang Reserved và chuyển sang trạng thái khác (Available, Occupied, Maintenance)
                    // Cần giải phóng booking
                    bookingDAO.releaseTableFromBooking(id);
                    System.out.println("✅ Table " + id + " status changed from Reserved to " + table.getStatus() + ". Booking released.");
                }
                
                if (tableDAO.update(table)) {
                    session.setAttribute("successMessage", "Cập nhật bàn thành công!");
                } else {
                    request.setAttribute("error", "Có lỗi xảy ra khi cập nhật bàn!");
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        
        response.sendRedirect("tables");
    }
}

