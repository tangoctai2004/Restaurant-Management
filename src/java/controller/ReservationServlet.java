package controller;

import dao.BookingDAO;
import dao.RestaurantSettingsDAO;
import model.Account;
import model.Booking;
import util.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReservationServlet", urlPatterns = {"/reservation"})
public class ReservationServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private RestaurantSettingsDAO settingsDAO = new RestaurantSettingsDAO();
    private static final long DEPOSIT_AMOUNT = 100000; // 100k tiền cọc
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load settings cho trang đặt bàn
        // Load từ cả "reservation" và "reservation_general" (nếu có) để đảm bảo có tất cả settings
        Map<String, String> reservationSettings = settingsDAO.getSettingsByPage("reservation");
        Map<String, String> reservationGeneralSettings = settingsDAO.getSettingsByPage("reservation_general");
        
        // Merge settings (ưu tiên reservation_general nếu có)
        if (reservationGeneralSettings != null && !reservationGeneralSettings.isEmpty()) {
            reservationSettings.putAll(reservationGeneralSettings);
        }
        
        request.setAttribute("reservationSettings", reservationSettings);
        
        request.getRequestDispatcher("reservation.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String bookingDateStr = request.getParameter("bookingDate");
        String bookingTimeStr = request.getParameter("bookingTime");
        String numPeopleStr = request.getParameter("numPeople");
        String note = request.getParameter("note");
        
        // Validation
        if (customerName == null || phone == null || bookingDateStr == null || 
            bookingTimeStr == null || numPeopleStr == null ||
            customerName.trim().isEmpty() || phone.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            doGet(request, response);
            return;
        }
        
        try {
            // Lưu thông tin đặt bàn vào session để dùng sau khi thanh toán
            HttpSession session = request.getSession();
            Booking tempBooking = new Booking();
            tempBooking.setCustomerName(customerName);
            tempBooking.setPhone(phone);
            tempBooking.setBookingDate(Date.valueOf(bookingDateStr));
            tempBooking.setBookingTime(Time.valueOf(bookingTimeStr + ":00"));
            tempBooking.setNumPeople(Integer.parseInt(numPeopleStr));
            tempBooking.setNote(note);
            tempBooking.setStatus("Pending");
            
            // Lưu account nếu khách đã đăng nhập
            Account account = (Account) session.getAttribute("account");
            if (account != null) {
                tempBooking.setAccount(account);
            }
            
            // Không cần lưu tableIds nữa vì khách hàng không chọn bàn
            // Lưu vào session
            session.setAttribute("tempBooking", tempBooking);
            
            // Tạo orderId cho VNPay
            String orderId = "BOOKING_" + System.currentTimeMillis();
            session.setAttribute("bookingOrderId", orderId);
            
            // Tạo URL thanh toán VNPay
            String orderInfo = "Dat ban - " + customerName + " - " + phone;
            String paymentUrl = VNPayUtil.createPaymentUrl(request, DEPOSIT_AMOUNT, orderInfo, orderId);
            
            if (paymentUrl != null) {
                // Redirect đến VNPay
                response.sendRedirect(paymentUrl);
            } else {
                request.setAttribute("error", "Không thể tạo link thanh toán! Vui lòng thử lại.");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra! Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}

