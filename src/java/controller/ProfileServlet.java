package controller;

import dao.AccountDAO;
import model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    
    private AccountDAO accountDAO = new AccountDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Họ và tên không được để trống!");
            doGet(request, response);
            return;
        }
        
        // Cập nhật thông tin cơ bản
        account.setFullName(fullName);
        account.setEmail(email);
        account.setPhone(phone);
        
        // Xử lý đổi mật khẩu (nếu có)
        if (currentPassword != null && !currentPassword.trim().isEmpty()) {
            // Kiểm tra mật khẩu hiện tại
            Account checkAccount = accountDAO.login(account.getUsername(), currentPassword);
            if (checkAccount == null) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
                doGet(request, response);
                return;
            }
            
            // Kiểm tra mật khẩu mới
            if (newPassword == null || newPassword.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập mật khẩu mới!");
                doGet(request, response);
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                doGet(request, response);
                return;
            }
            
            account.setPassword(newPassword); // Trong thực tế nên hash password
        }
        
        // Cập nhật vào database
        if (updateAccount(account)) {
            // Cập nhật lại session
            session.setAttribute("account", account);
            request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("error", "Cập nhật thông tin thất bại! Vui lòng thử lại.");
        }
        
        doGet(request, response);
    }
    
    private boolean updateAccount(Account account) {
        String sql = "UPDATE Accounts SET full_name = ?, email = ?, phone = ?";
        boolean changePassword = account.getPassword() != null && !account.getPassword().equals("");
        
        if (changePassword) {
            sql += ", password = ?";
        }
        sql += " WHERE id = ?";
        
        try (java.sql.Connection conn = dao.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, account.getFullName());
            ps.setString(2, account.getEmail());
            ps.setString(3, account.getPhone());
            
            if (changePassword) {
                ps.setString(4, account.getPassword());
                ps.setInt(5, account.getId());
            } else {
                ps.setInt(4, account.getId());
            }
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}



