<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý danh mục | HAH Restaurant</title>
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
                <h1><i class="fa fa-list"></i> Quản lý danh mục</h1>
            </div>
            
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="openModal('addCategoryModal')">
                    <i class="fa fa-plus"></i> Thêm danh mục mới
                </button>
            </div>
            
            <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm danh mục..." id="searchInput" value="${searchKeyword != null ? searchKeyword : ''}">
                <button class="btn btn-primary" onclick="searchCategories()">
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
                            <th>Tên danh mục</th>
                            <th>Mô tả</th>
                            <th>Số món</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="category" items="${categories}">
                            <tr>
                                <td>${category.id}</td>
                                <td><strong>${category.name}</strong></td>
                                <td>${category.description}</td>
                                <td>${category.productCount}</td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="editCategory(${category.id}, '${category.name}', '${category.description}')">
                                        <i class="fa fa-edit"></i> Sửa
                                    </button>
                                    <a href="categories?action=delete&id=${category.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc muốn xóa danh mục này? Lưu ý: Các món ăn trong danh mục sẽ bị ảnh hưởng.')">
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
    
    <!-- Modal Thêm/Sửa danh mục -->
    <div id="addCategoryModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Thêm danh mục mới</h2>
                <button class="close-modal" onclick="closeModal('addCategoryModal')">&times;</button>
            </div>
            <form action="categories" method="POST" id="categoryForm">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="categoryId">
                
                <div class="form-group">
                    <label for="name">Tên danh mục:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Mô tả:</label>
                    <textarea id="description" name="description"></textarea>
                </div>
                
                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addCategoryModal')">Hủy</button>
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
            document.getElementById('categoryForm').reset();
            document.getElementById('formAction').value = 'add';
            document.getElementById('categoryId').value = '';
            document.getElementById('modalTitle').textContent = 'Thêm danh mục mới';
        }
        
        function editCategory(id, name, description) {
            document.getElementById('formAction').value = 'update';
            document.getElementById('categoryId').value = id;
            document.getElementById('name').value = name;
            document.getElementById('description').value = description || '';
            document.getElementById('modalTitle').textContent = 'Sửa danh mục';
            openModal('addCategoryModal');
        }
        
        // Đóng modal khi click outside
        document.getElementById('addCategoryModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal('addCategoryModal');
            }
        });
        
        // Đóng modal bằng phím ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal('addCategoryModal');
            }
        });
        
        function searchCategories() {
            const search = document.getElementById('searchInput').value;
            window.location.href = 'categories?search=' + encodeURIComponent(search);
        }
        
        // Tìm kiếm khi nhấn Enter
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchCategories();
                }
            });
        }
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

