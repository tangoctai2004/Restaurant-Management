<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết tài khoản | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <jsp:include page="admin-header.jsp" />
    
    <div class="admin-container">
        <div class="admin-sidebar">
            <jsp:include page="admin-sidebar.jsp" />
        </div>
        
        <div class="admin-content">
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h1><i class="fa fa-user"></i> Chi tiết tài khoản</h1>
                <a href="accounts?tab=${account.role == 0 ? 'customers' : account.role == 2 ? 'staff' : 'customers'}" class="btn btn-secondary">
                    <i class="fa fa-arrow-left"></i> Quay lại
                </a>
            </div>
            
            <c:if test="${empty account}">
                <div class="dashboard-card">
                    <p style="color: #721c24;">Không tìm thấy tài khoản!</p>
                </div>
            </c:if>
            
            <c:if test="${not empty account}">
                <div class="dashboard-card">
                    <h2 style="margin-bottom: 20px; color: #104c23;">Thông tin tài khoản</h2>
                    
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 20px;">
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">ID:</label>
                            <p style="margin: 0; font-size: 16px;">${account.id}</p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Username:</label>
                            <p style="margin: 0; font-size: 16px;"><strong>${account.username}</strong></p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Họ và tên:</label>
                            <p style="margin: 0; font-size: 16px;">${account.fullName}</p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Email:</label>
                            <p style="margin: 0; font-size: 16px;">${account.email != null && !account.email.isEmpty() ? account.email : 'Chưa cập nhật'}</p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Số điện thoại:</label>
                            <p style="margin: 0; font-size: 16px;">${account.phone != null && !account.phone.isEmpty() ? account.phone : 'Chưa cập nhật'}</p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Vai trò:</label>
                            <p style="margin: 0;">
                                <span class="badge ${account.role == 1 ? 'status-canceled' : account.role == 2 ? 'status-confirmed' : 'status-completed'}">
                                    <c:choose>
                                        <c:when test="${not empty account.roleName}">${account.roleName}</c:when>
                                        <c:when test="${account.role == 1}">Admin</c:when>
                                        <c:when test="${account.role == 2}">Nhân viên</c:when>
                                        <c:otherwise>Khách hàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Trạng thái:</label>
                            <p style="margin: 0;">
                                <span class="badge ${account.active ? 'status-completed' : 'status-canceled'}">
                                    ${account.active ? 'Hoạt động' : 'Đã khóa'}
                                </span>
                            </p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Ngày tạo:</label>
                            <p style="margin: 0; font-size: 16px;">
                                <c:if test="${not empty account.createdAt}">
                                    <fmt:formatDate value="${account.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:if>
                            </p>
                        </div>
                    </div>
                    
                    <c:if test="${account.role == 2 && not empty permissions}">
                        <div style="margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;">
                            <h3 style="margin-bottom: 15px; color: #104c23;">Quyền truy cập</h3>
                            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px;">
                                <c:forEach var="perm" items="${permissions}">
                                    <div style="padding: 10px; background: #f8f9fa; border-radius: 5px; border: 1px solid #e0e0e0;">
                                        <strong>${perm.name}</strong>
                                        <c:if test="${not empty perm.description}">
                                            <br><small style="color: #666;">${perm.description}</small>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                    
                    <div style="display: flex; gap: 10px; margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;">
                        <button class="btn btn-primary" onclick="editAccount(${account.id}, '${account.username}', '${account.fullName}', '${account.email != null ? account.email : ''}', '${account.phone != null ? account.phone : ''}', ${account.roleId != null ? account.roleId : account.role}, ${account.active})">
                            <i class="fa fa-edit"></i> Sửa tài khoản
                        </button>
                        <c:if test="${account.id != sessionScope.account.id}">
                            <a href="accounts?action=toggleStatus&id=${account.id}&tab=${account.role == 0 ? 'customers' : account.role == 2 ? 'staff' : 'customers'}" 
                               class="btn ${account.active ? 'btn-danger' : 'btn-success'}">
                                <i class="fa fa-${account.active ? 'lock' : 'unlock'}"></i> ${account.active ? 'Khóa' : 'Mở khóa'}
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    
    <script>
        function editAccount(id, username, fullName, email, phone, role, isActive) {
            // Redirect đến trang accounts với modal mở
            const tab = role == 0 ? 'customers' : role == 2 ? 'staff' : 'customers';
            window.location.href = 'accounts?tab=' + tab + '&edit=' + id;
        }
    </script>
</body>
</html>

