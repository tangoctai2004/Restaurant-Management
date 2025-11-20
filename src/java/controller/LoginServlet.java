package controller;

import dao.AccountDAO;
import model.Account;
import util.PermissionHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    
    private AccountDAO accountDAO = new AccountDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập, chuyển về trang chủ
        HttpSession session = request.getSession();
        if (session.getAttribute("account") != null) {
            response.sendRedirect("home");
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        Account account = accountDAO.login(username, password);
        
        if (account != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            
            // Chuyển hướng theo role
            if (account.getRole() == 1 || account.getRole() == 2) {
                // Load permissions vào session (chỉ cho Admin và Staff)
                PermissionHelper.loadPermissionsToSession(session, account.getId());
                
                // Redirect đến trang đầu tiên có quyền
                String redirectUrl = PermissionHelper.getFirstAllowedPage(session);
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect("home");
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}



