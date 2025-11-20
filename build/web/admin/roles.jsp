<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý quyền tài khoản | HAH Restaurant</title>
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
        
        .permission-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 20px;
        }
        
        .permission-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        
        .permission-item label {
            margin: 0;
            flex: 1;
            cursor: pointer;
        }
        
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 26px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 26px;
        }
        
        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .toggle-slider {
            background-color: #28a745;
        }
        
        input:checked + .toggle-slider:before {
            transform: translateX(24px);
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
                <h1><i class="fa fa-user-shield"></i> Quản lý quyền tài khoản</h1>
            </div>
            
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="openModal('addRoleModal')">
                    <i class="fa fa-plus"></i> Thêm vai trò mới
                </button>
            </div>
            
            <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm vai trò..." id="searchInput" value="${searchKeyword != null ? searchKeyword : ''}">
                <button class="btn btn-primary" onclick="searchRoles()">
                    <i class="fa fa-search"></i> Tìm kiếm
                </button>
            </div>
            
            <c:if test="${not empty error}">
                <div style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
                    ${error}
                </div>
            </c:if>
            
            <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
            
            <div class="dashboard-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên vai trò</th>
                            <th>Mô tả</th>
                            <th>Số tài khoản</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty roles}">
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 40px; color: #666;">
                                        <i class="fa fa-inbox" style="font-size: 48px; color: #ccc; margin-bottom: 10px;"></i>
                                        <p>Không có vai trò nào</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="role" items="${roles}">
                                    <tr>
                                        <td>${role.id}</td>
                                        <td><strong>${role.name}</strong></td>
                                        <td>${role.description}</td>
                                        <td>${role.accountCount}</td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" onclick="editRole(${role.id}, '${role.name}', '${role.description}')">
                                                <i class="fa fa-edit"></i> Sửa
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/roles?action=view&id=${role.id}" class="btn btn-sm btn-info">
                                                <i class="fa fa-eye"></i> Chi tiết
                                            </a>
                                            <c:if test="${role.accountCount == 0}">
                                                <a href="${pageContext.request.contextPath}/admin/roles?action=delete&id=${role.id}" class="btn btn-sm btn-danger"
                                                   onclick="return confirm('Bạn có chắc muốn xóa vai trò này?')">
                                                    <i class="fa fa-trash"></i> Xóa
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Modal Thêm/Sửa vai trò -->
    <div id="addRoleModal" class="modal">
        <div class="modal-content" style="max-width: 700px;">
            <div class="modal-header">
                <h2 id="modalTitle">Thêm vai trò mới</h2>
                <button class="close-modal" onclick="closeModal('addRoleModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/roles" method="POST" id="roleForm">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="roleId">
                
                <div class="form-group">
                    <label for="name">Tên vai trò (*):</label>
                    <input type="text" id="name" name="name" required placeholder="Nhập tên vai trò">
                </div>
                
                <div class="form-group">
                    <label for="description">Mô tả:</label>
                    <textarea id="description" name="description" placeholder="Nhập mô tả (tùy chọn)"></textarea>
                </div>
                
                <div class="form-group">
                    <label>Quyền truy cập:</label>
                    <div class="permission-grid" id="permissionGrid">
                        <!-- Permissions will be loaded here -->
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addRoleModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Context path cho API calls
        const contextPath = '${pageContext.request.contextPath}';
        const rolesApiUrl = contextPath + '/admin/roles';
        
        // Permissions mặc định (fallback nếu API không hoạt động)
        const defaultPermissions = [
            {id: 1, code: 'STATISTICS', name: 'Thống kê', description: 'Xem thống kê và báo cáo'},
            {id: 2, code: 'BOOKING', name: 'Đặt bàn', description: 'Quản lý đặt bàn'},
            {id: 3, code: 'MENU', name: 'Thực đơn', description: 'Quản lý thực đơn'},
            {id: 4, code: 'STAFF', name: 'Nhân viên', description: 'Quản lý nhân viên'},
            {id: 5, code: 'PROMOTION', name: 'Khuyến mãi', description: 'Quản lý khuyến mãi'},
            {id: 6, code: 'SYSTEM', name: 'Hệ thống', description: 'Cài đặt hệ thống'},
            {id: 7, code: 'INVOICE', name: 'Hóa đơn', description: 'Quản lý hóa đơn'},
            {id: 8, code: 'PRODUCT', name: 'Mặt hàng', description: 'Quản lý sản phẩm'},
            {id: 9, code: 'COMBO', name: 'Combo', description: 'Quản lý combo'},
            {id: 10, code: 'CUSTOMER', name: 'Khách hàng', description: 'Quản lý khách hàng'},
            {id: 11, code: 'POST', name: 'Bài viết', description: 'Quản lý bài viết'},
            {id: 12, code: 'RESTAURANT_SETUP', name: 'Thiết lập nhà hàng', description: 'Thiết lập thông tin nhà hàng'}
        ];
        
        function loadPermissions(roleId = null) {
            const grid = document.getElementById('permissionGrid');
            if (!grid) {
                console.error('Permission grid not found!');
                return;
            }
            grid.innerHTML = '<div style="padding: 20px; text-align: center; color: #666;">Đang tải quyền...</div>';
            
            // Load permissions từ server
            fetch(rolesApiUrl + '?action=getAllPermissions')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    if (!data || data.length === 0) {
                        throw new Error('No permissions found');
                    }
                    grid.innerHTML = '';
                    data.forEach(perm => {
                        const item = document.createElement('div');
                        item.className = 'permission-item';
                        item.innerHTML = `
                            <label for="permission_${perm.id}">${perm.name}</label>
                            <label class="toggle-switch">
                                <input type="checkbox" id="permission_${perm.id}" name="permission_${perm.id}">
                                <span class="toggle-slider"></span>
                            </label>
                        `;
                        grid.appendChild(item);
                    });
                    
                    // Nếu có roleId, load permissions của role đó
                    if (roleId) {
                        fetch(rolesApiUrl + '?action=getPermissions&id=' + roleId)
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('HTTP error! status: ' + response.status);
                                }
                                return response.json();
                            })
                            .then(rolePerms => {
                                if (rolePerms && rolePerms.length > 0) {
                                    rolePerms.forEach(rp => {
                                        if (rp.granted) {
                                            const checkbox = document.getElementById('permission_' + rp.id);
                                            if (checkbox) {
                                                checkbox.checked = true;
                                            }
                                        }
                                    });
                                }
                            })
                            .catch(error => {
                                console.error('Error loading role permissions:', error);
                            });
                    }
                })
                .catch(error => {
                    console.error('Error loading permissions from server:', error);
                    // Fallback: dùng permissions mặc định
                    grid.innerHTML = '';
                    defaultPermissions.forEach(perm => {
                        const item = document.createElement('div');
                        item.className = 'permission-item';
                        item.innerHTML = `
                            <label for="permission_${perm.id}">${perm.name}</label>
                            <label class="toggle-switch">
                                <input type="checkbox" id="permission_${perm.id}" name="permission_${perm.id}">
                                <span class="toggle-slider"></span>
                            </label>
                        `;
                        grid.appendChild(item);
                    });
                    console.warn('Using default permissions. Make sure to run CreateTable-InsertData.sql to insert permissions into database.');
                });
        }
        
        function openModal(modalId) {
            document.getElementById(modalId).classList.add('active');
            if (modalId === 'addRoleModal') {
                loadPermissions();
            }
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('active');
            document.getElementById('roleForm').reset();
            document.getElementById('formAction').value = 'add';
            document.getElementById('roleId').value = '';
            document.getElementById('modalTitle').textContent = 'Thêm vai trò mới';
        }
        
        function editRole(id, name, description) {
            document.getElementById('formAction').value = 'update';
            document.getElementById('roleId').value = id;
            document.getElementById('name').value = name;
            document.getElementById('description').value = description || '';
            document.getElementById('modalTitle').textContent = 'Sửa vai trò';
            
            // Load permissions của role
            loadPermissions(id);
            
            // Fetch permissions từ server
            fetch(rolesApiUrl + '?action=view&id=' + id)
                .then(response => response.text())
                .then(html => {
                    // Parse permissions từ response (tạm thời)
                    // Cần tạo API endpoint riêng để lấy permissions dạng JSON
                });
            
            openModal('addRoleModal');
        }
        
        function searchRoles() {
            const search = document.getElementById('searchInput').value;
            // Kiểm tra xem đang ở URL nào
            const currentUrl = window.location.href;
            let targetUrl;
            
            if (currentUrl.includes('accounts?tab=roles') || currentUrl.includes('accounts?tab=roles&')) {
                // Đang ở trang accounts với tab=roles
                targetUrl = contextPath + '/admin/accounts?tab=roles';
                if (search) {
                    targetUrl += '&search=' + encodeURIComponent(search);
                }
            } else {
                // Đang ở trang roles trực tiếp
                targetUrl = contextPath + '/admin/roles';
                if (search) {
                    targetUrl += '?search=' + encodeURIComponent(search);
                }
            }
            
            window.location.href = targetUrl;
        }
        
        // Tìm kiếm khi nhấn Enter
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchRoles();
                }
            });
        }
        
        // Đóng modal khi click outside
        document.getElementById('addRoleModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal('addRoleModal');
            }
        });
        
        // Đóng modal bằng phím ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal('addRoleModal');
            }
        });
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

