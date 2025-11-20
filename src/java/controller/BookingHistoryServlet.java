package controller;

import dao.BookingDAO;
import model.Account;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookingHistoryServlet", urlPatterns = {"/booking-history"})
public class BookingHistoryServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Lấy danh sách booking theo số điện thoại của account
        List<Booking> bookings = bookingDAO.getByPhone(account.getPhone());
        request.setAttribute("bookings", bookings);
        
        request.getRequestDispatcher("booking-history.jsp").forward(request, response);
    }
}

