<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<header class="navbar 
    <%= "menu".equals(pageName) ? "gray-bg" : "" %>
    <%= "reservation".equals(pageName) ? "gray-bg" : "" %>
    <%= "payment".equals(pageName) ? "gray-bg" : "" %>
">
    <div class="logo" style="color: white">HAH<span style="color: #ffb300">.</span></div>

    <nav>
        <a href="home" class="<%= "home".equals(pageName) ? "active" : "" %>">Trang chủ</a>
        <a href="menu" class="<%= "menu".equals(pageName) ? "active" : "" %>">Thực đơn</a>
        <a href="reservation" class="<%= "reservation".equals(pageName) ? "active" : "" %>">Đặt bàn</a>
        <a href="about" class="<%= "about".equals(pageName) ? "active" : "" %>">Giới thiệu</a>
        <a href="contact" class="<%= "contact".equals(pageName) ? "active" : "" %>">Liên hệ</a>
    </nav>

    <div class="right-menu">
        <c:if test="${sessionScope.account == null}">
            <button class="login" onclick="window.location.href='login'">Đăng nhập</button>
        </c:if>

        <c:if test="${sessionScope.account != null}">
            <span class="user-greeting">
                Chào, ${sessionScope.account.fullName}
            </span>
            <% if ("reservation".equals(pageName) || "reservation.jsp".equals(pageName) || uri.contains("reservation")) { %>
                <button class="btn-booking-history" onclick="window.location.href='booking-history'">
                    <i class="fa fa-calendar-check"></i> Lịch sử đặt bàn
                </button>
            <% } %>
            <button class="btn-edit-profile" onclick="window.location.href='profile'">
                <i class="fa fa-user-edit"></i> 
            </button>
            <button class="btn-logout" onclick="window.location.href='logout'">
                <i class="fa fa-sign-out-alt"></i>
            </button>
        </c:if>
    </div>
</header>
