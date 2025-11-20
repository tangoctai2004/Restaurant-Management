package controller;

import dao.AccountDAO;
import dao.RoleDAO;
import model.Account;
import model.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAccountsServlet", urlPatterns = {"/admin/accounts"})
public class AdminAccountsServlet extends HttpServlet {
    
    private AccountDAO accountDAO = new AccountDAO();
    private RoleDAO roleDAO = new RoleDAO();
    
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
        
        // Kiểm tra permission ACCOUNTS, ACCOUNTS-STAFF, hoặc ACCOUNTS-CUSTOMER
        boolean hasAccountsPermission = account.getRole() == 1 || 
            util.PermissionHelper.hasPermission(session, "ACCOUNTS") ||
            util.PermissionHelper.hasPermission(session, "ACCOUNTS-STAFF") ||
            util.PermissionHelper.hasPermission(session, "ACCOUNTS-CUSTOMER");
        
        if (!hasAccountsPermission) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Tài khoản!");
            return;
        }
        
        // Xác định các tabs được phép truy cập
        boolean canViewCustomers = account.getRole() == 1 || 
            util.PermissionHelper.hasPermission(session, "ACCOUNTS") ||
            util.PermissionHelper.hasPermission(session, "ACCOUNTS-CUSTOMER");
        
        boolean canViewStaff = account.getRole() == 1 || 
            util.PermissionHelper.hasPermission(session, "ACCOUNTS") ||
            util.PermissionHelper.hasPermission(session, "ACCOUNTS-STAFF");
        
        boolean canViewRoles = account.getRole() == 1 || 
            util.PermissionHelper.hasPermission(session, "ACCOUNTS");
        
        request.setAttribute("canViewCustomers", canViewCustomers);
        request.setAttribute("canViewStaff", canViewStaff);
        request.setAttribute("canViewRoles", canViewRoles);
        
        String action = request.getParameter("action");
        String tab = request.getParameter("tab");
        String search = request.getParameter("search");
        String idStr = request.getParameter("id");
        
        // Xử lý toggle status
        if ("toggleStatus".equals(action) && idStr != null) {
            try {
                int accountId = Integer.parseInt(idStr);
                Account currentAccount = (Account) session.getAttribute("account");
                
                // Không cho phép khóa chính mình
                if (currentAccount != null && currentAccount.getId() == accountId) {
                    session.setAttribute("error", "Bạn không thể khóa tài khoản của chính mình!");
                } else {
                    boolean success = accountDAO.toggleStatus(accountId);
                    if (success) {
                        session.setAttribute("successMessage", "Đã cập nhật trạng thái tài khoản thành công!");
                    } else {
                        session.setAttribute("error", "Không thể cập nhật trạng thái tài khoản!");
                    }
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID tài khoản không hợp lệ!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            }
            
            // Redirect về tab hiện tại
            String redirectUrl = "accounts";
            if (tab != null) {
                redirectUrl += "?tab=" + tab;
            }
            response.sendRedirect(redirectUrl);
            return;
        }
        
        // Xử lý xem chi tiết account
        if ("view".equals(action) && idStr != null) {
            try {
                int accountId = Integer.parseInt(idStr);
                Account viewAccount = accountDAO.getById(accountId);
                
                if (viewAccount == null) {
                    session.setAttribute("error", "Không tìm thấy tài khoản!");
                    response.sendRedirect("accounts" + (tab != null ? "?tab=" + tab : ""));
                    return;
                }
                
                // Load permissions nếu là staff
                if (viewAccount.getRole() == 2) {
                    List<model.Permission> permissions = accountDAO.getPermissionsByAccountId(accountId);
                    request.setAttribute("permissions", permissions);
                }
                
                request.setAttribute("account", viewAccount);
                request.getRequestDispatcher("/admin/account-detail.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID tài khoản không hợp lệ!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            }
            response.sendRedirect("accounts" + (tab != null ? "?tab=" + tab : ""));
            return;
        }
        
        // Nếu tab là roles, load dữ liệu roles và forward đến accounts.jsp (giữ nguyên header và tabs)
        if ("roles".equals(tab)) {
            // Kiểm tra quyền xem roles
            if (!canViewRoles) {
                session.setAttribute("error", "Bạn không có quyền xem Quyền tài khoản!");
                // Redirect về tab đầu tiên có quyền
                if (canViewCustomers) {
                    response.sendRedirect("accounts?tab=customers");
                } else if (canViewStaff) {
                    response.sendRedirect("accounts?tab=staff");
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
                }
                return;
            }
            
            List<Role> roles;
            if (search != null && !search.trim().isEmpty()) {
                roles = roleDAO.search(search.trim());
                request.setAttribute("searchKeyword", search);
            } else {
                roles = roleDAO.getAll();
            }
            request.setAttribute("roles", roles);
            
            // Lấy flash messages từ session
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("error");
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
            if (errorMessage != null) {
                request.setAttribute("error", errorMessage);
                session.removeAttribute("error");
            }
            
            // Forward đến accounts.jsp để giữ nguyên header và tabs
            request.getRequestDispatcher("/admin/accounts.jsp").forward(request, response);
            return;
        }
        
        // Lấy danh sách accounts theo tab
        List<Account> accounts;
        if (search != null && !search.trim().isEmpty()) {
            accounts = accountDAO.search(search.trim());
            request.setAttribute("searchKeyword", search);
        } else {
            accounts = accountDAO.getAll();
        }
        
        // Kiểm tra quyền và filter theo tab
        if ("customers".equals(tab) || tab == null) {
            // Kiểm tra quyền xem customers
            if (!canViewCustomers) {
                // Nếu không có quyền customers, redirect về tab đầu tiên có quyền
                if (canViewStaff) {
                    response.sendRedirect("accounts?tab=staff");
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem Khách hàng!");
                }
                return;
            }
            // Chỉ lấy khách hàng (role = 0)
            accounts.removeIf(acc -> acc.getRole() != 0);
        } else if ("staff".equals(tab)) {
            // Kiểm tra quyền xem staff
            if (!canViewStaff) {
                // Nếu không có quyền staff, redirect về tab đầu tiên có quyền
                if (canViewCustomers) {
                    response.sendRedirect("accounts?tab=customers");
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem Danh sách nhân viên!");
                }
                return;
            }
            // Chỉ lấy nhân viên (role = 2)
            accounts.removeIf(acc -> acc.getRole() != 2);
        }
        // Nếu không có tab hoặc tab khác, hiển thị tất cả
        
        // Load danh sách roles để hiển thị trong dropdown (cho tab staff)
        List<Role> allRoles = roleDAO.getAll();
        request.setAttribute("allRoles", allRoles);
        
        request.setAttribute("accounts", accounts);
        
        request.getRequestDispatcher("/admin/accounts.jsp").forward(request, response);
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
        
        // Kiểm tra permission ACCOUNTS, ACCOUNTS-STAFF, hoặc ACCOUNTS-CUSTOMER
        boolean hasAccountsPermission = account.getRole() == 1 || 
            util.PermissionHelper.hasPermission(session, "ACCOUNTS") ||
            util.PermissionHelper.hasPermission(session, "ACCOUNTS-STAFF") ||
            util.PermissionHelper.hasPermission(session, "ACCOUNTS-CUSTOMER");
        
        if (!hasAccountsPermission) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Tài khoản!");
            return;
        }
        
        String action = request.getParameter("action");
        String tab = request.getParameter("tab");
        
        if ("add".equals(action)) {
            // Thêm tài khoản mới
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roleStr = request.getParameter("role");
            String isActiveStr = request.getParameter("isActive");
            
            if (username == null || username.trim().isEmpty() || 
                fullName == null || fullName.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
                response.sendRedirect("accounts" + (tab != null ? "?tab=" + tab : ""));
                return;
            }
            
            // Kiểm tra username đã tồn tại chưa
            if (accountDAO.checkUsernameExists(username)) {
                session.setAttribute("error", "Username đã tồn tại!");
                response.sendRedirect("accounts" + (tab != null ? "?tab=" + tab : ""));
                return;
            }
            
            try {
                Account newAccount = new Account();
                newAccount.setUsername(username.trim());
                newAccount.setPassword(password);
                newAccount.setFullName(fullName.trim());
                newAccount.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
                newAccount.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
                
                // roleStr giờ là role_id từ Roles table (dropdown)
                int roleId = roleStr != null ? Integer.parseInt(roleStr) : 1; // Mặc định là Khách hàng (role_id = 1)
                newAccount.setRole(roleId); // Lưu role_id vào field role (AccountDAO sẽ xử lý)
                
                newAccount.setActive(isActiveStr != null && "on".equals(isActiveStr));
                
                boolean success = accountDAO.register(newAccount);
                if (success) {
                    session.setAttribute("successMessage", "Đã thêm tài khoản thành công!");
                } else {
                    session.setAttribute("error", "Không thể thêm tài khoản!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Dữ liệu không hợp lệ!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            }
            
        } else if ("update".equals(action)) {
            // Cập nhật tài khoản
            String idStr = request.getParameter("id");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roleStr = request.getParameter("role");
            String isActiveStr = request.getParameter("isActive");
            
            if (idStr == null || username == null || username.trim().isEmpty() || 
                fullName == null || fullName.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
                response.sendRedirect("accounts" + (tab != null ? "?tab=" + tab : ""));
                return;
            }
            
            try {
                int accountId = Integer.parseInt(idStr);
                
                // Kiểm tra username đã tồn tại chưa (trừ account hiện tại)
                if (accountDAO.checkUsernameExists(username, accountId)) {
                    session.setAttribute("error", "Username đã tồn tại!");
                    response.sendRedirect("accounts" + (tab != null ? "?tab=" + tab : ""));
                    return;
                }
                
                Account updateAccount = new Account();
                updateAccount.setId(accountId);
                updateAccount.setUsername(username.trim());
                updateAccount.setPassword(password != null && !password.trim().isEmpty() ? password.trim() : null);
                updateAccount.setFullName(fullName.trim());
                updateAccount.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
                updateAccount.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
                
                // roleStr giờ là role_id từ Roles table
                int roleId = roleStr != null ? Integer.parseInt(roleStr) : 1; // Mặc định là Khách hàng
                updateAccount.setRole(roleId); // Lưu role_id vào field role (tạm thời, AccountDAO sẽ xử lý)
                
                updateAccount.setActive(isActiveStr != null && "on".equals(isActiveStr));
                
                boolean success = accountDAO.update(updateAccount);
                if (success) {
                    session.setAttribute("successMessage", "Đã cập nhật tài khoản thành công!");
                } else {
                    session.setAttribute("error", "Không thể cập nhật tài khoản!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID tài khoản không hợp lệ!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            }
        }
        
        // Redirect về tab hiện tại
        String redirectUrl = "accounts";
        if (tab != null) {
            redirectUrl += "?tab=" + tab;
        }
        response.sendRedirect(redirectUrl);
    }
}

