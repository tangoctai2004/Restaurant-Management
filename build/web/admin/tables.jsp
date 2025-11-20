<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý bàn | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body, .admin-content, .dashboard-card, .data-table td, .data-table th {
            color: #333 !important;
        }
        .data-table td strong {
            color: #222 !important;
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
            <div class="page-header">
                <h1><i class="fa fa-chair"></i> Quản lý bàn</h1>
            </div>
            
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="openModal('addTableModal')">
                    <i class="fa fa-plus"></i> Thêm bàn mới
                </button>
            </div>
            
            <c:if test="${not empty error}">
                <div style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #dc3545;">
                    <i class="fa fa-exclamation-triangle"></i> ${errorMessage}
                </div>
            </c:if>
            
            <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
            
            <div class="dashboard-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên bàn</th>
                            <th>Sức chứa</th>
                            <th>Khu vực</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="table" items="${tables}">
                            <tr>
                                <td>${table.id}</td>
                                <td>${table.name}</td>
                                <td>${table.capacity} người</td>
                                <td>${table.locationArea}</td>
                                <td>
                                    <span class="badge status-${table.status.toLowerCase()}">
                                        <c:choose>
                                            <c:when test="${table.status == 'Available'}">Trống</c:when>
                                            <c:when test="${table.status == 'Occupied'}">Đang dùng</c:when>
                                            <c:when test="${table.status == 'Reserved'}">Đã đặt</c:when>
                                            <c:when test="${table.status == 'Maintenance'}">Bảo trì</c:when>
                                            <c:otherwise>${table.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="editTable(${table.id}, '${table.name}', ${table.capacity}, '${table.locationArea}', '${table.status}')">
                                        <i class="fa fa-edit"></i> Sửa
                                    </button>
                                    <a href="tables?action=delete&id=${table.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc muốn xóa bàn này?')">
                                        <i class="fa fa-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Modal Thêm/Sửa bàn -->
    <div id="addTableModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Thêm bàn mới</h2>
                <button class="close-modal" onclick="closeModal('addTableModal')">&times;</button>
            </div>
            <form action="tables" method="POST" id="tableForm">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="tableId">
                
                <div class="form-group">
                    <label for="name">Tên bàn:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="capacity">Sức chứa:</label>
                    <input type="number" id="capacity" name="capacity" min="1" required>
                </div>
                
                <div class="form-group">
                    <label for="locationArea">Khu vực:</label>
                    <input type="text" id="locationArea" name="locationArea">
                </div>
                
                <div class="form-group">
                    <label for="status">Trạng thái:</label>
                    <select id="status" name="status">
                        <option value="Available">Trống</option>
                        <option value="Occupied">Đang dùng</option>
                        <option value="Reserved">Đã đặt</option>
                        <option value="Maintenance">Bảo trì</option>
                    </select>
                </div>
                
                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addTableModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function openModal(modalId) {
            document.getElementById(modalId).classList.add('active');
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('active');
            document.getElementById('tableForm').reset();
            document.getElementById('formAction').value = 'add';
            document.getElementById('modalTitle').textContent = 'Thêm bàn mới';
        }
        
        function editTable(id, name, capacity, locationArea, status) {
            document.getElementById('formAction').value = 'update';
            document.getElementById('tableId').value = id;
            document.getElementById('name').value = name;
            document.getElementById('capacity').value = capacity;
            document.getElementById('locationArea').value = locationArea;
            document.getElementById('status').value = status;
            document.getElementById('modalTitle').textContent = 'Sửa thông tin bàn';
            openModal('addTableModal');
        }
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

