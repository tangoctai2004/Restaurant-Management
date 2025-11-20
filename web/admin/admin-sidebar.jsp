<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Set" %>
<%
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
    
    // Lấy permissions từ session
    @SuppressWarnings("unchecked")
    Set<String> permissions = (Set<String>) session.getAttribute("permissions");
    
    // Admin (role = 1) có tất cả quyền
    boolean isAdmin = session.getAttribute("account") != null && 
                     ((model.Account) session.getAttribute("account")).getRole() == 1;
    
    // Helper functions để check permission
    pageContext.setAttribute("isAdmin", isAdmin);
    pageContext.setAttribute("permissions", permissions);
%>
<nav class="admin-sidebar-nav">
    <c:if test="${isAdmin || (permissions != null && permissions.contains('DASHBOARD'))}">
        <a href="dashboard" class="<%= pageName.contains("dashboard") ? "active" : "" %>">
            <i class="fa fa-chart-line"></i> Dashboard
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('ORDERS'))}">
        <a href="orders" class="<%= pageName.contains("orders") ? "active" : "" %>">
            <i class="fa fa-shopping-cart"></i> Đơn hàng
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('BOOKING'))}">
        <a href="bookings" class="<%= pageName.contains("bookings") || pageName.contains("assign-table") ? "active" : "" %>">
            <i class="fa fa-calendar-check"></i> Đặt bàn
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('TABLES'))}">
        <a href="tables" class="<%= pageName.contains("tables") ? "active" : "" %>">
            <i class="fa fa-chair"></i> Quản lý bàn
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('PRODUCTS'))}">
        <a href="products" class="<%= pageName.contains("products") ? "active" : "" %>">
            <i class="fa fa-utensils"></i> Món ăn
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('CATEGORIES'))}">
        <a href="categories" class="<%= pageName.contains("categories") ? "active" : "" %>">
            <i class="fa fa-list"></i> Danh mục
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('INGREDIENTS'))}">
        <a href="ingredients" class="<%= pageName.contains("ingredients") ? "active" : "" %>">
            <i class="fa fa-box"></i> Nguyên liệu
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('PROMOTIONS'))}">
        <a href="promotions" class="<%= pageName.contains("promotions") ? "active" : "" %>">
            <i class="fa fa-tag"></i> Khuyến mãi
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && (permissions.contains('ACCOUNTS') || permissions.contains('ACCOUNTS-STAFF') || permissions.contains('ACCOUNTS-CUSTOMER')))}">
        <a href="accounts" class="<%= pageName.contains("accounts") ? "active" : "" %>">
            <i class="fa fa-users"></i> Tài khoản
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('POSTS'))}">
        <a href="posts" class="<%= pageName.contains("posts") ? "active" : "" %>">
            <i class="fa fa-newspaper"></i> Bài viết
        </a>
    </c:if>
    <c:if test="${isAdmin || (permissions != null && permissions.contains('RESTAURANT_SETUP'))}">
        <a href="restaurant-setup" class="<%= pageName.contains("restaurant-setup") ? "active" : "" %>">
            <i class="fa fa-cog"></i> Thiết lập nhà hàng
        </a>
    </c:if>
</nav>

