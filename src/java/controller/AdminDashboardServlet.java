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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    
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
        
        // Kiểm tra permission DASHBOARD
        if (!util.PermissionHelper.hasPermission(session, "DASHBOARD") && account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Dashboard!");
            return;
        }
        
        // Lấy tham số tháng/năm từ request (mặc định là tháng/năm hiện tại)
        Calendar cal = Calendar.getInstance();
        int currentYear = cal.get(Calendar.YEAR);
        int currentMonth = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH bắt đầu từ 0
        
        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");
        
        int selectedYear = (yearParam != null && !yearParam.isEmpty()) 
            ? Integer.parseInt(yearParam) 
            : currentYear;
        int selectedMonth = (monthParam != null && !monthParam.isEmpty()) 
            ? Integer.parseInt(monthParam) 
            : currentMonth;
        
        // Tính toán thống kê theo tháng/năm được chọn
        int totalOrders = orderDAO.getOrderCountByMonthYear(selectedMonth, selectedYear);
        double totalRevenue = orderDAO.getRevenueByMonthYear(selectedMonth, selectedYear);
        int totalBookings = bookingDAO.getBookingCountByMonthYear(selectedMonth, selectedYear);
        
        // Số khách hàng: Đếm số khách hàng đã đặt hàng trong tháng/năm (chính xác hơn)
        dao.AccountDAO accountDAO = new dao.AccountDAO();
        int totalCustomers = accountDAO.getActiveCustomerCountByMonthYear(selectedMonth, selectedYear);
        
        // Tính lợi nhuận từ giá vốn thực tế
        // Công thức: Lợi nhuận = Doanh thu - Chi phí (giá vốn)
        double totalCost = orderDAO.getTotalCostByMonthYear(selectedMonth, selectedYear);
        double profit = totalRevenue - totalCost;
        
        // Lấy dữ liệu cho biểu đồ (12 tháng gần nhất trong năm được chọn)
        List<OrderDAO.MonthlyRevenue> monthlyRevenues = orderDAO.getMonthlyRevenueByYear(selectedYear);
        List<OrderDAO.MonthlyCost> monthlyCosts = orderDAO.getMonthlyCostByYear(selectedYear);
        
        // Tạo List dữ liệu cho biểu đồ (12 tháng)
        List<Double> revenueDataList = new ArrayList<>();
        List<Double> profitDataList = new ArrayList<>();
        List<String> monthLabelsList = new ArrayList<>();
        
        // Khởi tạo 12 tháng với giá trị 0
        for (int i = 1; i <= 12; i++) {
            revenueDataList.add(0.0);
            profitDataList.add(0.0);
            monthLabelsList.add("Tháng " + i);
        }
        
        // Điền dữ liệu doanh thu
        for (OrderDAO.MonthlyRevenue mr : monthlyRevenues) {
            int monthIndex = mr.getMonth() - 1; // Chuyển từ 1-12 sang 0-11
            if (monthIndex >= 0 && monthIndex < 12) {
                revenueDataList.set(monthIndex, mr.getRevenue());
            }
        }
        
        // Điền dữ liệu chi phí và tính lợi nhuận
        for (OrderDAO.MonthlyCost mc : monthlyCosts) {
            int monthIndex = mc.getMonth() - 1;
            if (monthIndex >= 0 && monthIndex < 12) {
                double revenue = revenueDataList.get(monthIndex);
                double cost = mc.getCost();
                double monthlyProfit = revenue - cost; // Lợi nhuận = Doanh thu - Chi phí
                profitDataList.set(monthIndex, monthlyProfit);
            }
        }
        
        // Tính lợi nhuận cho các tháng có doanh thu nhưng chưa có chi phí (nếu có)
        for (int i = 0; i < 12; i++) {
            if (revenueDataList.get(i) > 0 && profitDataList.get(i) == 0) {
                // Nếu có doanh thu nhưng chưa có chi phí, lợi nhuận = doanh thu (tạm thời)
                profitDataList.set(i, revenueDataList.get(i));
            }
        }
        
        // Đơn hàng gần đây (chỉ hóa đơn tại bàn, không tính cọc và hoàn tiền)
        List<Order> allTableOrders = orderDAO.getTableOrders();
        List<Order> recentOrders = allTableOrders.size() > 5 
            ? allTableOrders.subList(0, 5) 
            : allTableOrders;
        
        // Đặt bàn gần đây (5 booking đầu tiên)
        List<Booking> allBookings = bookingDAO.getAll();
        List<Booking> recentBookings = allBookings.size() > 5 
            ? allBookings.subList(0, 5) 
            : allBookings;
        
        // Lấy danh sách năm có dữ liệu (từ năm hiện tại trở về 5 năm trước)
        List<Integer> availableYears = new ArrayList<>();
        for (int i = 0; i < 6; i++) {
            availableYears.add(currentYear - i);
        }
        
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("profit", profit);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("recentBookings", recentBookings);
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("availableYears", availableYears);
        request.setAttribute("revenueData", revenueDataList);
        request.setAttribute("profitData", profitDataList);
        request.setAttribute("monthLabels", monthLabelsList);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}

