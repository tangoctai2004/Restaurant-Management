package util;

import dao.AccountDAO;
import model.Account;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

public class PermissionHelper {
    
    private static AccountDAO accountDAO = new AccountDAO();
    
    /**
     * Kiểm tra account có permission không
     */
    public static boolean hasPermission(HttpSession session, String permissionCode) {
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            return false;
        }
        
        // Admin (role = 1) có tất cả quyền
        if (account.getRole() == 1) {
            return true;
        }
        
        // Lấy permissions từ session cache hoặc từ database
        @SuppressWarnings("unchecked")
        Set<String> permissions = (Set<String>) session.getAttribute("permissions");
        if (permissions == null) {
            // Load permissions từ database và cache vào session
            permissions = loadPermissionsToSession(session, account.getId());
        }
        
        return permissions != null && permissions.contains(permissionCode);
    }
    
    /**
     * Load permissions vào session để cache
     */
    public static Set<String> loadPermissionsToSession(HttpSession session, int accountId) {
        List<model.Permission> permissions = accountDAO.getPermissionsByAccountId(accountId);
        Set<String> permissionCodes = new HashSet<>();
        
        for (model.Permission perm : permissions) {
            permissionCodes.add(perm.getCode());
        }
        
        session.setAttribute("permissions", permissionCodes);
        return permissionCodes;
    }
    
    /**
     * Lấy danh sách permission codes từ session
     */
    @SuppressWarnings("unchecked")
    public static Set<String> getPermissions(HttpSession session) {
        return (Set<String>) session.getAttribute("permissions");
    }
    
    /**
     * Kiểm tra permission và trả về lỗi nếu không có quyền
     * @return true nếu có quyền, false nếu không có quyền (đã gửi response error)
     */
    public static boolean checkPermission(HttpSession session, HttpServletResponse response, String permissionCode) throws IOException {
        if (!hasPermission(session, permissionCode)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này!");
            return false;
        }
        return true;
    }
    
    /**
     * Lấy URL trang đầu tiên mà account có quyền truy cập
     * @return URL trang đầu tiên có quyền, hoặc "dashboard" nếu có quyền DASHBOARD
     */
    public static String getFirstAllowedPage(HttpSession session) {
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            return "login";
        }
        
        // Admin có tất cả quyền, luôn vào dashboard
        if (account.getRole() == 1) {
            return "admin/dashboard";
        }
        
        // Thứ tự ưu tiên các trang (theo thứ tự sidebar)
        String[][] pages = {
            {"DASHBOARD", "admin/dashboard"},
            {"ORDERS", "admin/orders"},
            {"BOOKING", "admin/bookings"},
            {"TABLES", "admin/tables"},
            {"PRODUCTS", "admin/products"},
            {"CATEGORIES", "admin/categories"},
            {"INGREDIENTS", "admin/ingredients"},
            {"PROMOTIONS", "admin/promotions"},
            {"ACCOUNTS", "admin/accounts"},
            {"ACCOUNTS-STAFF", "admin/accounts?tab=staff"},
            {"ACCOUNTS-CUSTOMER", "admin/accounts?tab=customers"},
            {"RESTAURANT_SETUP", "admin/restaurant-setup"},
            {"POSTS", "admin/posts"}
        };
        
        // Tìm trang đầu tiên có quyền
        for (String[] page : pages) {
            if (hasPermission(session, page[0])) {
                return page[1];
            }
        }
        
        // Nếu không có quyền nào, trả về dashboard (sẽ bị chặn bởi servlet)
        return "admin/dashboard";
    }
}

