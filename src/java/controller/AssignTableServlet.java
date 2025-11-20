package controller;

import dao.BookingDAO;
import dao.RestaurantTableDAO;
import model.Account;
import model.Booking;
import model.RestaurantTable;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AssignTableServlet", urlPatterns = {"/admin/assign-table"})
public class AssignTableServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private RestaurantTableDAO tableDAO = new RestaurantTableDAO();
    
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
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy thông tin đặt bàn!");
            request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingDAO.getById(bookingId);
            
            if (booking == null) {
                request.setAttribute("error", "Không tìm thấy đặt bàn!");
                request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
                return;
            }
            
            // Lấy danh sách tất cả bàn
            List<RestaurantTable> allTables = tableDAO.getAll();
            
            // Lấy danh sách bàn đã được chọn cho booking này
            List<Integer> selectedTableIds = bookingDAO.getTableIdsByBookingId(bookingId);
            
            request.setAttribute("booking", booking);
            request.setAttribute("allTables", allTables);
            request.setAttribute("selectedTableIds", selectedTableIds);
            
            request.getRequestDispatcher("/admin/assign-table.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID đặt bàn không hợp lệ!");
            request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra quyền admin hoặc staff
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        String bookingIdStr = request.getParameter("bookingId");
        String[] tableIdsStr = request.getParameterValues("tableIds");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy thông tin đặt bàn!");
            doGet(request, response);
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            List<Integer> tableIds = new ArrayList<>();
            
            if (tableIdsStr != null) {
                for (String tableIdStr : tableIdsStr) {
                    try {
                        tableIds.add(Integer.parseInt(tableIdStr));
                    } catch (NumberFormatException e) {
                        // Bỏ qua giá trị không hợp lệ
                    }
                }
            }
            
            // Gán bàn cho booking
            boolean success = bookingDAO.assignTablesToBooking(bookingId, tableIds);
            
            if (success) {
                session.setAttribute("flashSuccess", "Nhận bàn thành công! Đã gán " + tableIds.size() + " bàn cho đặt bàn #" + bookingId);
                response.sendRedirect("bookings");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi nhận bàn! Vui lòng thử lại.");
                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID đặt bàn không hợp lệ!");
            doGet(request, response);
        }
    }
}

