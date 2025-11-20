package controller;

import dao.RoleDAO;
import model.Account;
import model.Role;
import model.Permission;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminRolesServlet", urlPatterns = {"/admin/roles"})
public class AdminRolesServlet extends HttpServlet {
    
    private RoleDAO roleDAO = new RoleDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Chỉ admin mới có quyền truy cập
        if (account == null || account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String search = request.getParameter("search");
        
        // Xử lý API lấy tất cả permissions (JSON)
        if ("getAllPermissions".equals(action)) {
            try {
                List<Permission> permissions = roleDAO.getAllPermissions();
                
                System.out.println("🔍 Loading permissions. Found: " + permissions.size() + " permissions");
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                if (permissions.isEmpty()) {
                    System.out.println("⚠️ No permissions found in database!");
                    response.getWriter().write("[]");
                    return;
                }
                
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < permissions.size(); i++) {
                    Permission p = permissions.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                         .append("\"id\":").append(p.getId()).append(",")
                         .append("\"code\":\"").append(escapeJson(p.getCode())).append("\",")
                         .append("\"name\":\"").append(escapeJson(p.getName())).append("\",")
                         .append("\"description\":\"").append(escapeJson(p.getDescription() != null ? p.getDescription() : "")).append("\"")
                         .append("}");
                }
                json.append("]");
                
                System.out.println("✅ Returning permissions JSON: " + json.toString());
                response.getWriter().write(json.toString());
                return;
            } catch (Exception e) {
                System.err.println("❌ Error loading permissions: " + e.getMessage());
                e.printStackTrace();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
                return;
            }
        }
        
        // Xử lý API lấy permissions của role (JSON)
        if ("getPermissions".equals(action) && idStr != null) {
            try {
                int roleId = Integer.parseInt(idStr);
                List<Permission> permissions = roleDAO.getAllPermissionsWithGranted(roleId);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < permissions.size(); i++) {
                    Permission p = permissions.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                         .append("\"id\":").append(p.getId()).append(",")
                         .append("\"code\":\"").append(escapeJson(p.getCode())).append("\",")
                         .append("\"name\":\"").append(escapeJson(p.getName())).append("\",")
                         .append("\"granted\":").append(p.isGranted())
                         .append("}");
                }
                json.append("]");
                
                response.getWriter().write(json.toString());
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
                return;
            }
        }
        
        // Xử lý xem chi tiết role
        if ("view".equals(action) && idStr != null) {
            try {
                int roleId = Integer.parseInt(idStr);
                Role role = roleDAO.getById(roleId);
                
                if (role == null) {
                    session.setAttribute("error", "Không tìm thấy vai trò!");
                    // Kiểm tra referer để redirect về đúng URL
                    String referer = request.getHeader("Referer");
                    if (referer != null && referer.contains("accounts?tab=roles")) {
                        response.sendRedirect(request.getContextPath() + "/admin/accounts?tab=roles");
                    } else {
                        response.sendRedirect("roles");
                    }
                    return;
                }
                
                // Load tất cả permissions với trạng thái granted
                List<Permission> allPermissions = roleDAO.getAllPermissionsWithGranted(roleId);
                role.setPermissions(allPermissions);
                
                request.setAttribute("role", role);
                request.getRequestDispatcher("/admin/role-detail.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID vai trò không hợp lệ!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            }
            // Kiểm tra referer để redirect về đúng URL
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("accounts?tab=roles")) {
                response.sendRedirect(request.getContextPath() + "/admin/accounts?tab=roles");
            } else {
                response.sendRedirect("roles");
            }
            return;
        }
        
        // Xử lý xóa role
        if ("delete".equals(action) && idStr != null) {
            try {
                int roleId = Integer.parseInt(idStr);
                boolean success = roleDAO.delete(roleId);
                
                if (success) {
                    session.setAttribute("successMessage", "Đã xóa vai trò thành công!");
                } else {
                    session.setAttribute("error", "Không thể xóa vai trò! Có thể có tài khoản đang sử dụng vai trò này.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID vai trò không hợp lệ!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            }
            // Kiểm tra referer để redirect về đúng URL
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("accounts?tab=roles")) {
                response.sendRedirect(request.getContextPath() + "/admin/accounts?tab=roles");
            } else {
                response.sendRedirect("roles");
            }
            return;
        }
        
        // Lấy danh sách roles
        List<Role> roles;
        if (search != null && !search.trim().isEmpty()) {
            roles = roleDAO.search(search.trim());
            request.setAttribute("searchKeyword", search);
        } else {
            roles = roleDAO.getAll();
        }
        
        request.setAttribute("roles", roles);
        
        // Lấy flash messages
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        
        String error = (String) session.getAttribute("error");
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }
        
        request.getRequestDispatcher("/admin/roles.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Chỉ admin mới có quyền truy cập
        if (account == null || account.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String idStr = request.getParameter("id");
        
        if (name == null || name.trim().isEmpty()) {
            session.setAttribute("error", "Tên vai trò không được để trống!");
            // Kiểm tra referer để redirect về đúng URL
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("accounts?tab=roles")) {
                response.sendRedirect(request.getContextPath() + "/admin/accounts?tab=roles");
            } else {
                response.sendRedirect("roles");
            }
            return;
        }
        
        try {
            // Lấy danh sách permissions được chọn
            List<Permission> permissions = new ArrayList<>();
            List<Permission> allPermissions = roleDAO.getAllPermissions();
            
            for (Permission perm : allPermissions) {
                String permValue = request.getParameter("permission_" + perm.getId());
                if (permValue != null && "on".equals(permValue)) {
                    perm.setGranted(true);
                    permissions.add(perm);
                }
            }
            
            if ("add".equals(action)) {
                // Thêm role mới
                Role role = new Role();
                role.setName(name.trim());
                role.setDescription(description != null ? description.trim() : null);
                role.setPermissions(permissions);
                
                boolean success = roleDAO.create(role);
                if (success) {
                    session.setAttribute("successMessage", "Đã thêm vai trò '" + role.getName() + "' thành công!");
                } else {
                    session.setAttribute("error", "Không thể thêm vai trò! Có thể tên vai trò đã tồn tại.");
                }
            } else if ("update".equals(action) && idStr != null) {
                // Cập nhật role
                int id = Integer.parseInt(idStr);
                Role role = new Role();
                role.setId(id);
                role.setName(name.trim());
                role.setDescription(description != null ? description.trim() : null);
                role.setPermissions(permissions);
                
                boolean success = roleDAO.update(role);
                if (success) {
                    session.setAttribute("successMessage", "Đã cập nhật vai trò thành công!");
                } else {
                    session.setAttribute("error", "Không thể cập nhật vai trò!");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID vai trò không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Kiểm tra referer để redirect về đúng URL
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("accounts?tab=roles")) {
            response.sendRedirect(request.getContextPath() + "/admin/accounts?tab=roles");
        } else {
            response.sendRedirect("roles");
        }
    }
    
    // Helper method để escape JSON
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}

