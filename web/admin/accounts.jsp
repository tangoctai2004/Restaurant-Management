<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý tài khoản | HAH Restaurant</title>
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
        
        .tabs {
            display: flex;
            gap: 0;
            margin-bottom: 20px;
        }
        
        .tabs .tab {
            padding: 12px 24px;
            text-decoration: none;
            color: #666;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .tabs .tab:hover {
            color: #104c23;
            background: #f8f9fa;
        }
        
        .tabs .tab.active {
            color: #104c23;
            border-bottom-color: #28a745;
            font-weight: 600;
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
            gap: 12px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        
        .permission-item .toggle-switch {
            flex-shrink: 0;
        }
        
        .permission-item .permission-label {
            margin: 0;
            flex: 1;
            cursor: pointer;
            font-weight: 500;
            color: #333 !important;
            font-size: 14px;
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
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
            height: 18px;
            width: 18px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        .toggle-switch input:checked + .toggle-slider {
            background-color: #28a745;
        }
        
        .toggle-switch input:checked + .toggle-slider:before {
            transform: translateX(24px);
        }
        
        .btn-info {
            background-color: #0066cc !important;
            color: #ffffff !important;
            border: none !important;
        }
        
        .btn-info:hover {
            background-color: #0052a3 !important;
            color: #ffffff !important;
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
                <h1><i class="fa fa-users"></i> Quản lý tài khoản</h1>
            </div>
            
            <!-- Tabs -->
            <c:set var="activeTab" value="${param.tab != null ? param.tab : (canViewCustomers ? 'customers' : canViewStaff ? 'staff' : canViewRoles ? 'roles' : 'customers')}" />
            <div class="tabs" style="margin-bottom: 20px; border-bottom: 2px solid #e0e0e0;">
                <c:if test="${canViewCustomers}">
                    <a href="accounts?tab=customers" class="tab ${activeTab == 'customers' ? 'active' : ''}">
                        <i class="fa fa-user"></i> Khách hàng
                    </a>
                </c:if>
                <c:if test="${canViewRoles}">
                    <a href="accounts?tab=roles" class="tab ${activeTab == 'roles' ? 'active' : ''}">
                        <i class="fa fa-user-shield"></i> Quyền tài khoản
                    </a>
                </c:if>
                <c:if test="${canViewStaff}">
                    <a href="accounts?tab=staff" class="tab ${activeTab == 'staff' ? 'active' : ''}">
                        <i class="fa fa-user-tie"></i> Danh sách nhân viên
                    </a>
                </c:if>
            </div>
            
            <c:choose>
                <c:when test="${param.tab == 'roles'}">
                    <!-- Tab Quyền tài khoản -->
                    <div class="action-buttons">
                        <button class="btn btn-primary" onclick="openRoleModal('addRoleModal')">
                            <i class="fa fa-plus"></i> Thêm vai trò mới
                        </button>
                    </div>
                    
                    <div class="search-bar">
                        <input type="text" placeholder="Tìm kiếm vai trò..." id="roleSearchInput" value="${searchKeyword != null ? searchKeyword : ''}">
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
                                                    <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                                                        <a href="${pageContext.request.contextPath}/admin/roles?action=view&id=${role.id}" class="btn btn-sm btn-info">
                                                            <i class="fa fa-eye"></i> Chi tiết
                                                        </a>
                                                        <button class="btn btn-sm btn-primary" onclick="editRole(${role.id}, '${role.name}', '${role.description != null ? role.description : ''}')">
                                                            <i class="fa fa-edit"></i> Sửa
                                                        </button>
                                                        <c:if test="${role.accountCount == 0}">
                                                            <a href="${pageContext.request.contextPath}/admin/roles?action=delete&id=${role.id}" 
                                                               class="btn btn-sm btn-danger"
                                                               onclick="return confirm('Bạn có chắc muốn xóa vai trò này?')">
                                                                <i class="fa fa-trash"></i> Xóa
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Modal Thêm/Sửa vai trò -->
                    <div id="addRoleModal" class="modal">
                        <div class="modal-content" style="max-width: 700px;">
                            <div class="modal-header">
                                <h2 id="roleModalTitle">Thêm vai trò mới</h2>
                                <button class="close-modal" onclick="closeRoleModal('addRoleModal')">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/roles" method="POST" id="roleForm">
                                <input type="hidden" name="action" id="roleFormAction" value="add">
                                <input type="hidden" name="id" id="roleId">
                                
                                <div class="form-group">
                                    <label for="roleName">Tên vai trò (*):</label>
                                    <input type="text" id="roleName" name="name" placeholder="Nhập tên vai trò" required>
                                </div>
                                
                                <div class="form-group">
                                    <label for="roleDescription">Mô tả:</label>
                                    <textarea id="roleDescription" name="description" rows="3" placeholder="Nhập mô tả (tùy chọn)"></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label>Quyền truy cập:</label>
                                    <div id="permissionGrid" class="permission-grid"></div>
                                </div>
                                
                                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
                                    <button type="button" class="btn btn-secondary" onclick="closeRoleModal('addRoleModal')">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Lưu</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${param.tab != null}">
                            <c:set var="currentTab" value="${param.tab}" />
                        </c:when>
                        <c:when test="${canViewCustomers}">
                            <c:set var="currentTab" value="customers" />
                        </c:when>
                        <c:when test="${canViewStaff}">
                            <c:set var="currentTab" value="staff" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="currentTab" value="customers" />
                        </c:otherwise>
                    </c:choose>
                    <!-- Tab Khách hàng hoặc Nhân viên -->
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="openModal('addAccountModal')">
                            <i class="fa fa-plus"></i> Thêm ${currentTab == 'staff' ? 'nhân viên' : 'khách hàng'} mới
                </button>
            </div>
            
            <div class="search-bar">
                        <input type="text" placeholder="Tìm kiếm theo tên, username, email..." id="searchInput" value="${searchKeyword != null ? searchKeyword : ''}">
                <button class="btn btn-primary" onclick="searchAccounts()">
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
                            <th>Username</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="account" items="${accounts}">
                            <tr>
                                <td>${account.id}</td>
                                <td><strong>${account.username}</strong></td>
                                <td>${account.fullName}</td>
                                <td>${account.email}</td>
                                <td>${account.phone}</td>
                                <td>
                                    <span class="badge ${account.role == 1 ? 'status-canceled' : account.role == 2 ? 'status-confirmed' : 'status-completed'}">
                                        <c:choose>
                                            <c:when test="${not empty account.roleName}">${account.roleName}</c:when>
                                            <c:when test="${account.role == 1}">Admin</c:when>
                                            <c:when test="${account.role == 2}">Nhân viên</c:when>
                                            <c:otherwise>Khách hàng</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge ${account.active ? 'status-completed' : 'status-canceled'}">
                                        ${account.active ? 'Hoạt động' : 'Khóa'}
                                    </span>
                                </td>
                                <td><c:if test="${not empty account.createdAt}"><fmt:formatDate value="${account.createdAt}" pattern="dd/MM/yyyy"/></c:if></td>
                                <td>
                                    <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                                        <a href="accounts?action=view&id=${account.id}&tab=${currentTab}" class="btn btn-sm btn-info">
                                            <i class="fa fa-eye"></i> Chi tiết
                                        </a>
                                        <button class="btn btn-sm btn-primary" onclick="editAccount(${account.id}, '${account.username}', '${account.fullName}', '${account.email != null ? account.email : ''}', '${account.phone != null ? account.phone : ''}', ${account.role}, ${account.active})">
                                        <i class="fa fa-edit"></i> Sửa
                                    </button>
                                    <c:if test="${account.id != sessionScope.account.id}">
                                            <a href="accounts?action=toggleStatus&id=${account.id}&tab=${currentTab}" 
                                               class="btn btn-sm ${account.active ? 'btn-danger' : 'btn-success'}"
                                               onclick="return confirm('Bạn có chắc muốn ${account.active ? 'khóa' : 'mở khóa'} tài khoản này?')">
                                                <i class="fa fa-${account.active ? 'lock' : 'unlock'}"></i> ${account.active ? 'Khóa' : 'Mở khóa'}
                                        </a>
                                    </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- Modal Thêm/Sửa tài khoản -->
    <div id="addAccountModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Thêm tài khoản mới</h2>
                <button class="close-modal" onclick="closeModal('addAccountModal')">&times;</button>
            </div>
            <form action="accounts" method="POST" id="accountForm">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="accountId">
                <input type="hidden" name="tab" id="formTab" value="${currentTab}">
                
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group" id="passwordGroup">
                    <label for="password">Mật khẩu:</label>
                    <input type="password" id="password" name="password">
                    <small style="color: #666;">(Để trống nếu không đổi mật khẩu khi sửa)</small>
                </div>
                
                <div class="form-group">
                    <label for="fullName">Họ và tên:</label>
                    <input type="text" id="fullName" name="fullName" required>
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email">
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Số điện thoại:</label>
                        <input type="tel" id="phone" name="phone">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="role">Vai trò:</label>
                    <select id="role" name="role" required>
                        <c:choose>
                            <c:when test="${currentTab == 'staff'}">
                                <%-- Tab nhân viên: hiển thị các roles từ database (trừ Admin và Khách hàng) --%>
                                <c:forEach var="role" items="${allRoles}">
                                    <c:if test="${role.name != 'Admin' && role.name != 'Khách hàng'}">
                                        <option value="${role.id}">${role.name}</option>
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <%-- Tab khách hàng: chỉ hiển thị Khách hàng --%>
                                <c:forEach var="role" items="${allRoles}">
                                    <c:if test="${role.name == 'Khách hàng'}">
                                        <option value="${role.id}">${role.name}</option>
                                    </c:if>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>
                        <input type="checkbox" id="isActive" name="isActive" checked>
                        Kích hoạt
                    </label>
                </div>
                
                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addAccountModal')">Hủy</button>
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
            document.getElementById('accountForm').reset();
            document.getElementById('formAction').value = 'add';
            document.getElementById('modalTitle').textContent = 'Thêm tài khoản mới';
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('password').required = true;
        }
        
        function editAccount(id, username, fullName, email, phone, role, isActive) {
            document.getElementById('formAction').value = 'update';
            document.getElementById('accountId').value = id;
            document.getElementById('username').value = username || '';
            document.getElementById('fullName').value = fullName || '';
            document.getElementById('email').value = email || '';
            document.getElementById('phone').value = phone || '';
            document.getElementById('role').value = role || 0;
            document.getElementById('isActive').checked = isActive === true || isActive === 'true';
            document.getElementById('modalTitle').textContent = 'Sửa tài khoản';
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('password').required = false;
            document.getElementById('password').value = '';
            openModal('addAccountModal');
        }
        
        function filterAccounts() {
            const role = document.getElementById('roleFilter').value;
            window.location.href = 'accounts?role=' + role;
        }
        
        function searchAccounts() {
            const search = document.getElementById('searchInput').value;
            const tab = '${currentTab}';
            let url = 'accounts?tab=' + tab;
            if (search) {
                url += '&search=' + encodeURIComponent(search);
            }
            window.location.href = url;
        }
        
        // Tìm kiếm khi nhấn Enter
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchAccounts();
                }
            });
        }
        
        // ========== ROLE MANAGEMENT FUNCTIONS ==========
        const contextPath = '${pageContext.request.contextPath}';
        const rolesApiUrl = contextPath + '/admin/roles';
        
        // Permissions mặc định (fallback nếu API không hoạt động)
        const defaultPermissions = [
            {id: 1, code: 'DASHBOARD', name: 'Dashboard', description: 'Xem trang tổng quan và thống kê'},
            {id: 2, code: 'ORDERS', name: 'Đơn hàng', description: 'Quản lý đơn hàng và hóa đơn'},
            {id: 3, code: 'BOOKING', name: 'Đặt bàn', description: 'Quản lý đặt bàn'},
            {id: 4, code: 'TABLES', name: 'Quản lý bàn', description: 'Quản lý bàn ăn'},
            {id: 5, code: 'PRODUCTS', name: 'Món ăn', description: 'Quản lý món ăn'},
            {id: 6, code: 'CATEGORIES', name: 'Danh mục', description: 'Quản lý danh mục món ăn'},
            {id: 7, code: 'INGREDIENTS', name: 'Nguyên liệu', description: 'Quản lý nguyên liệu'},
            {id: 8, code: 'PROMOTIONS', name: 'Khuyến mãi', description: 'Quản lý khuyến mãi'},
            {id: 9, code: 'ACCOUNTS', name: 'Tài khoản', description: 'Quản lý tài khoản, vai trò và nhân viên'},
            {id: 10, code: 'RESTAURANT_SETUP', name: 'Thiết lập nhà hàng', description: 'Thiết lập thông tin nhà hàng'},
            {id: 11, code: 'POSTS', name: 'Bài viết', description: 'Quản lý bài viết'}
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
                    console.log('Loaded ' + data.length + ' permissions from server:', data);
                    grid.innerHTML = '';
                    // Hiển thị tất cả permissions
                    data.forEach(perm => {
                        const permName = perm.name || perm.code || 'Permission ' + perm.id;
                        console.log('Adding permission:', perm.id, permName);
                        const item = document.createElement('div');
                        item.className = 'permission-item';
                        
                        // Tạo toggle switch
                        const toggleLabel = document.createElement('label');
                        toggleLabel.className = 'toggle-switch';
                        const checkbox = document.createElement('input');
                        checkbox.type = 'checkbox';
                        checkbox.id = 'permission_' + perm.id;
                        checkbox.name = 'permission_' + perm.id;
                        checkbox.value = 'on';
                        const slider = document.createElement('span');
                        slider.className = 'toggle-slider';
                        toggleLabel.appendChild(checkbox);
                        toggleLabel.appendChild(slider);
                        
                        // Tạo label cho tên quyền
                        const nameLabel = document.createElement('label');
                        nameLabel.setAttribute('for', 'permission_' + perm.id);
                        nameLabel.className = 'permission-label';
                        nameLabel.textContent = permName;
                        nameLabel.style.cssText = 'margin: 0; flex: 1; cursor: pointer; font-weight: 500; color: #333; font-size: 14px; display: block;';
                        
                        item.appendChild(toggleLabel);
                        item.appendChild(nameLabel);
                        grid.appendChild(item);
                    });
                    
                    // Nếu có roleId, load permissions của role đó và check các permissions đã được grant
                    if (roleId) {
                        fetch(rolesApiUrl + '?action=getPermissions&id=' + roleId)
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('HTTP error! status: ' + response.status);
                                }
                                return response.json();
                            })
                            .then(rolePerms => {
                                console.log('Loaded role permissions:', rolePerms);
                                if (rolePerms && rolePerms.length > 0) {
                                    // Check các permissions đã được grant
                                    rolePerms.forEach(rp => {
                                        const checkbox = document.getElementById('permission_' + rp.id);
                                        if (checkbox) {
                                            checkbox.checked = rp.granted === true;
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
                    console.warn('Using default permissions. Make sure to run CreateTable-InsertData.sql to insert permissions into database.');
                    grid.innerHTML = '';
                    defaultPermissions.forEach(perm => {
                        const item = document.createElement('div');
                        item.className = 'permission-item';
                        
                        // Tạo toggle switch
                        const toggleLabel = document.createElement('label');
                        toggleLabel.className = 'toggle-switch';
                        const checkbox = document.createElement('input');
                        checkbox.type = 'checkbox';
                        checkbox.id = 'permission_' + perm.id;
                        checkbox.name = 'permission_' + perm.id;
                        checkbox.value = 'on';
                        const slider = document.createElement('span');
                        slider.className = 'toggle-slider';
                        toggleLabel.appendChild(checkbox);
                        toggleLabel.appendChild(slider);
                        
                        // Tạo label cho tên quyền
                        const nameLabel = document.createElement('label');
                        nameLabel.setAttribute('for', 'permission_' + perm.id);
                        nameLabel.className = 'permission-label';
                        nameLabel.textContent = perm.name;
                        nameLabel.style.cssText = 'margin: 0; flex: 1; cursor: pointer; font-weight: 500; color: #333; font-size: 14px; display: block;';
                        
                        item.appendChild(toggleLabel);
                        item.appendChild(nameLabel);
                        grid.appendChild(item);
                    });
                    console.warn('Using default permissions. Make sure to run CreateTable-InsertData.sql to insert permissions into database.');
                });
        }
        
        function openRoleModal(modalId) {
            document.getElementById(modalId).classList.add('active');
            if (modalId === 'addRoleModal') {
                loadPermissions();
            }
        }
        
        function closeRoleModal(modalId) {
            document.getElementById(modalId).classList.remove('active');
            const form = document.getElementById('roleForm');
            if (form) {
                form.reset();
            }
            document.getElementById('roleFormAction').value = 'add';
            document.getElementById('roleId').value = '';
            document.getElementById('roleModalTitle').textContent = 'Thêm vai trò mới';
        }
        
        function editRole(id, name, description) {
            document.getElementById('roleFormAction').value = 'update';
            document.getElementById('roleId').value = id;
            document.getElementById('roleName').value = name;
            document.getElementById('roleDescription').value = description || '';
            document.getElementById('roleModalTitle').textContent = 'Sửa vai trò';
            
            // Load permissions của role
            loadPermissions(id);
            
            openRoleModal('addRoleModal');
        }
        
        function searchRoles() {
            const search = document.getElementById('roleSearchInput').value;
            let url = contextPath + '/admin/accounts?tab=roles';
            if (search) {
                url += '&search=' + encodeURIComponent(search);
            }
            window.location.href = url;
        }
        
        // Tìm kiếm roles khi nhấn Enter
        const roleSearchInput = document.getElementById('roleSearchInput');
        if (roleSearchInput) {
            roleSearchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchRoles();
                }
            });
        }
        
        // Đóng modal khi click outside
        const addRoleModal = document.getElementById('addRoleModal');
        if (addRoleModal) {
            addRoleModal.addEventListener('click', function(e) {
                if (e.target === this) {
                    closeRoleModal('addRoleModal');
                }
            });
        }
        
        // Đóng modal bằng phím ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                const addRoleModal = document.getElementById('addRoleModal');
                if (addRoleModal && addRoleModal.classList.contains('active')) {
                    closeRoleModal('addRoleModal');
                }
            }
        });
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

