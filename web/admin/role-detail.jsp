<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết vai trò | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .permission-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 20px;
        }
        
        .permission-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        
        .permission-item.granted {
            background: #d4edda;
            border-color: #28a745;
        }
        
        .permission-item .permission-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .permission-item .permission-desc {
            font-size: 13px;
            color: #666;
        }
        
        .btn-danger {
            font-size: inherit !important;
        }
    </style>
</head>
<body>
    <jsp:include page="admin-header.jsp" />
    
    <div class="admin-container">
        <div class="admin-sidebar">
            <jsp:include page="admin-sidebar.jsp" />
        </div>
        
        <div class="admin-content">
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h1><i class="fa fa-user-shield"></i> Chi tiết vai trò</h1>
                <a href="accounts?tab=roles" class="btn btn-secondary">
                    <i class="fa fa-arrow-left"></i> Quay lại
                </a>
            </div>
            
            <c:if test="${empty role}">
                <div class="dashboard-card">
                    <p style="color: #721c24;">Không tìm thấy vai trò!</p>
                </div>
            </c:if>
            
            <c:if test="${not empty role}">
                <div class="dashboard-card">
                    <h2 style="margin-bottom: 20px; color: #104c23;">Thông tin vai trò</h2>
                    
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 20px;">
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">ID:</label>
                            <p style="margin: 0; font-size: 16px;">${role.id}</p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Tên vai trò:</label>
                            <p style="margin: 0; font-size: 16px;"><strong>${role.name}</strong></p>
                        </div>
                        
                        <div style="grid-column: 1 / -1;">
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Mô tả:</label>
                            <p style="margin: 0; font-size: 16px;">${role.description != null && !role.description.isEmpty() ? role.description : 'Chưa có mô tả'}</p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Số tài khoản:</label>
                            <p style="margin: 0; font-size: 16px;">${role.accountCount}</p>
                        </div>
                        
                        <div>
                            <label style="font-weight: 600; color: #666; display: block; margin-bottom: 5px;">Ngày tạo:</label>
                            <p style="margin: 0; font-size: 16px;">
                                <c:if test="${not empty role.createdAt}">
                                    <fmt:formatDate value="${role.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:if>
                            </p>
                        </div>
                    </div>
                    
                    <c:if test="${not empty role.permissions}">
                        <c:set var="grantedCount" value="0" />
                        <c:forEach var="perm" items="${role.permissions}">
                            <c:if test="${perm.granted}">
                                <c:set var="grantedCount" value="${grantedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        <div style="margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;">
                            <h3 style="margin-bottom: 15px; color: #104c23;">Quyền truy cập (${grantedCount} quyền)</h3>
                            <div class="permission-grid">
                                <c:forEach var="perm" items="${role.permissions}">
                                    <c:if test="${perm.granted}">
                                        <div class="permission-item granted">
                                            <div class="permission-name">
                                                <i class="fa fa-check-circle" style="color: #28a745; margin-right: 5px;"></i>
                                                ${perm.name}
                                            </div>
                                            <c:if test="${not empty perm.description}">
                                                <div class="permission-desc">${perm.description}</div>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                    
                    <div style="display: flex; gap: 10px; margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;">
                        <button class="btn btn-primary" onclick="editRole(${role.id}, '${role.name}', '${role.description != null ? role.description : ''}')">
                            <i class="fa fa-edit"></i> Sửa vai trò
                        </button>
                        <c:if test="${role.accountCount == 0}">
                            <a href="${pageContext.request.contextPath}/admin/roles?action=delete&id=${role.id}" 
                               class="btn btn-danger"
                               onclick="return confirm('Bạn có chắc muốn xóa vai trò này?')">
                                <i class="fa fa-trash"></i> Xóa vai trò
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    
    <script>
        function editRole(id, name, description) {
            // Redirect về trang accounts với tab roles và mở modal edit
            window.location.href = 'accounts?tab=roles&edit=' + id;
        }
    </script>
</body>
</html>

