<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý nguyên liệu | HAH Restaurant</title>
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
                <h1><i class="fa fa-box"></i> Quản lý nguyên liệu</h1>
            </div>
            
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="openModal('addIngredientModal')">
                    <i class="fa fa-plus"></i> Thêm nguyên liệu mới
                </button>
            </div>
            
            <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm nguyên liệu..." id="searchInput" value="${searchKeyword != null ? searchKeyword : ''}">
                <button class="btn btn-primary" onclick="searchIngredients()">
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
                            <th>Tên nguyên liệu</th>
                            <th>Đơn vị</th>
                            <th>Giá mua</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ingredient" items="${ingredients}">
                            <tr>
                                <td>${ingredient.id}</td>
                                <td><strong>${ingredient.name}</strong></td>
                                <td>${ingredient.unit}</td>
                                <td>
                                    <strong style="color: #28a745;">
                                        <fmt:formatNumber value="${ingredient.price}" type="number" maxFractionDigits="0"/> đ/${ingredient.unit}
                                    </strong>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="editIngredient(${ingredient.id}, '${ingredient.name}', '${ingredient.unit}', ${ingredient.price})">
                                        <i class="fa fa-edit"></i> Sửa
                                    </button>
                                    <a href="ingredients?action=delete&id=${ingredient.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc muốn xóa nguyên liệu này?')">
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
    
    <!-- Modal Thêm/Sửa nguyên liệu -->
    <div id="addIngredientModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Thêm nguyên liệu mới</h2>
                <button class="close-modal" onclick="closeModal('addIngredientModal')">&times;</button>
            </div>
            <form action="ingredients" method="POST" id="ingredientForm">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="ingredientId">
                
                <div class="form-group">
                    <label for="name">Tên nguyên liệu:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="unit">Đơn vị:</label>
                        <select id="unit" name="unit" required>
                            <option value="kg">kg</option>
                            <option value="gram">gram</option>
                            <option value="con">con</option>
                            <option value="chai">chai</option>
                            <option value="lít">lít</option>
                            <option value="ml">ml</option>
                            <option value="gói">gói</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="price">Giá mua (VND/đơn vị):</label>
                        <input type="number" id="price" name="price" min="0" step="1000" value="0" required>
                        <small style="color: #666;">Giá mua nguyên liệu (ví dụ: 50000 đ/kg)</small>
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addIngredientModal')">Hủy</button>
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
            document.getElementById('ingredientForm').reset();
            document.getElementById('formAction').value = 'add';
            document.getElementById('modalTitle').textContent = 'Thêm nguyên liệu mới';
        }
        
        function editIngredient(id, name, unit, price) {
            document.getElementById('formAction').value = 'update';
            document.getElementById('ingredientId').value = id;
            document.getElementById('name').value = name || '';
            document.getElementById('unit').value = unit || 'kg';
            document.getElementById('price').value = price || 0;
            document.getElementById('modalTitle').textContent = 'Sửa nguyên liệu';
            openModal('addIngredientModal');
        }
        
        function searchIngredients() {
            const search = document.getElementById('searchInput').value;
            window.location.href = 'ingredients?search=' + encodeURIComponent(search);
        }
        
        // Tìm kiếm khi nhấn Enter
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchIngredients();
                }
            });
        }
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

