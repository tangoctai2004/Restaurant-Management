<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header class="admin-header">
    <div class="header-left">
        <div class="logo">HAH<span>.</span> Admin</div>
    </div>
    <div class="header-right">
        <c:if test="${sessionScope.account != null}">
            <span class="user-info">
                <i class="fa fa-user"></i> ${sessionScope.account.fullName}
                <span class="role-badge">${sessionScope.account.role == 1 ? 'Admin' : 'Staff'}</span>
            </span>
            <a href="${pageContext.request.contextPath}/home" class="btn-home">
                <i class="fa fa-home"></i> Về trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                <i class="fa fa-sign-out-alt"></i> Đăng xuất
            </a>
        </c:if>
    </div>
</header>

