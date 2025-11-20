package controller;

import dao.AccountDAO;
import model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    
    private AccountDAO accountDAO = new AccountDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // Validation
        if (username == null || password == null || fullName == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(repassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (accountDAO.checkUsernameExists(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        Account account = new Account();
        account.setUsername(username);
        account.setPassword(password); // Password sẽ được hash trong AccountDAO.register()
        account.setFullName(fullName);
        account.setEmail(email);
        account.setPhone(phone);
        account.setRole(1); // role_id = 1 là Khách hàng trong Roles table
        account.setActive(true);
        
        if (accountDAO.register(account)) {
            request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}



