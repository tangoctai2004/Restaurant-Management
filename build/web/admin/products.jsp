<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý món ăn | HAH Restaurant</title>
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
                <h1><i class="fa fa-utensils"></i> Quản lý món ăn</h1>
            </div>
            
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="openModal('addProductModal')">
                    <i class="fa fa-plus"></i> Thêm món ăn mới
                </button>
            </div>
            
            <div class="search-bar">
                <select id="categoryFilter" onchange="filterProducts()">
                    <option value="">Tất cả danh mục</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${selectedCategoryId != null && selectedCategoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
                <input type="text" placeholder="Tìm kiếm món ăn..." id="searchInput" value="${searchKeyword != null ? searchKeyword : ''}">
                <button class="btn btn-primary" onclick="searchProducts()">
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
                            <th>Hình ảnh</th>
                            <th>Tên món</th>
                            <th>Danh mục</th>
                            <th>Giá bán</th>
                            <th>Giá vốn</th>
                            <th>Lợi nhuận</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${products}">
                            <tr>
                                <td>${product.id}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty product.imageUrl}">
                                            <c:set var="imgSrc" value="${product.imageUrl}" />
                                            <c:choose>
                                                <c:when test="${fn:startsWith(product.imageUrl, 'http://') || fn:startsWith(product.imageUrl, 'https://')}">
                                                    <c:set var="imgSrc" value="${product.imageUrl}" />
                                                </c:when>
                                                <c:when test="${fn:startsWith(product.imageUrl, '/')}">
                                                    <c:set var="imgSrc" value="${pageContext.request.contextPath}${product.imageUrl}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="imgSrc" value="${pageContext.request.contextPath}/${product.imageUrl}" />
                                                </c:otherwise>
                                            </c:choose>
                                            <img src="${imgSrc}" alt="${product.name}" 
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-food.jpg';"
                                                 style="width: 60px; height: 60px; object-fit: cover; border-radius: 5px;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/images/default-food.jpg" alt="${product.name}" 
                                                 style="width: 60px; height: 60px; object-fit: cover; border-radius: 5px; background: #f5f5f5;">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><strong>${product.name}</strong></td>
                                <td>${product.categoryName}</td>
                                <td>
                                    <strong style="color: #28a745;">
                                        <fmt:formatNumber value="${product.price}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                    </strong>
                                </td>
                                <td>
                                    <span style="color: #dc3545;">
                                        <fmt:formatNumber value="${product.costPrice}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                    </span>
                                </td>
                                <td>
                                    <c:set var="profit" value="${product.price - product.costPrice}" />
                                    <span style="color: ${profit >= 0 ? '#17a2b8' : '#dc3545'}; font-weight: 600;">
                                        <fmt:formatNumber value="${profit}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                    </span>
                                    <br>
                                    <small style="color: #666;">
                                        (<fmt:formatNumber value="${product.costPrice > 0 ? (profit / product.costPrice * 100) : 0}" maxFractionDigits="1"/>%)
                                    </small>
                                </td>
                                <td>
                                    <span class="badge ${product.active ? 'status-completed' : 'status-canceled'}">
                                        ${product.active ? 'Đang bán' : 'Tạm dừng món'}
                                    </span>
                                </td>
                                <td>
                                    <a href="product-ingredients?productId=${product.id}" class="btn btn-sm btn-info" 
                                       style="background: #17a2b8; color: white; border-color: #17a2b8; margin-right: 5px; text-decoration: none; display: inline-block; padding: 5px 10px; border-radius: 4px; font-size: 13px;">
                                        <i class="fa fa-list"></i> Nguyên liệu
                                    </a>
                                    <button class="btn btn-sm btn-primary" onclick="editProduct(${product.id}, '${product.name}', ${product.categoryId}, '${fn:replace(product.description, "'", "\\'")}', ${product.price}, '${product.imageUrl}', ${product.active}, ${product.costPrice})">
                                        <i class="fa fa-edit"></i> Sửa
                                    </button>
                                    <a href="products?action=delete&id=${product.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc muốn xóa món ăn này?')">
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
    
    <!-- Modal Thêm/Sửa món ăn -->
    <div id="addProductModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Thêm món ăn mới</h2>
                <button class="close-modal" onclick="closeModal('addProductModal')">&times;</button>
            </div>
            <form action="products" method="POST" id="productForm" enctype="multipart/form-data">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="productId">
                <input type="hidden" name="imageUrl" id="imageUrl" value="">
                
                <div class="form-group">
                    <label for="name">Tên món ăn:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="categoryId">Danh mục:</label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}">${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="description">Mô tả:</label>
                    <textarea id="description" name="description"></textarea>
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="price">Giá bán (VND):</label>
                        <input type="number" id="price" name="price" min="0" step="1000" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="costPrice">Giá vốn (VND):</label>
                        <input type="number" id="costPrice" name="costPrice" min="0" step="1000" readonly style="background: #f5f5f5; cursor: not-allowed;">
                        <small style="color: #666;">Tự động tính từ nguyên liệu</small>
                        <button type="button" class="btn btn-sm" onclick="calculateCostPrice()" style="margin-top: 5px; background: #17a2b8; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer;">
                            <i class="fa fa-calculator"></i> Tính lại giá vốn
                        </button>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="imageFile">Hình ảnh:</label>
                    <input type="file" id="imageFile" name="imageFile" accept="image/*" onchange="previewImage(this)">
                    <small style="color: #666;">Chọn ảnh từ máy tính (JPG, PNG, GIF - tối đa 10MB)</small>
                    <div id="imagePreview" style="margin-top: 10px; display: none;">
                        <img id="previewImg" src="" alt="Preview" style="max-width: 200px; max-height: 200px; border-radius: 5px; border: 1px solid #ddd;">
                        <p id="currentImageName" style="margin-top: 5px; color: #666; font-size: 12px;"></p>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>
                        <input type="checkbox" id="isActive" name="isActive" checked>
                        Đang bán
                    </label>
                </div>
                
                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addProductModal')">Hủy</button>
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
            document.getElementById('productForm').reset();
            document.getElementById('formAction').value = 'add';
            document.getElementById('productId').value = '';
            document.getElementById('imageUrl').value = '';
            document.getElementById('modalTitle').textContent = 'Thêm món ăn mới';
            document.getElementById('costPrice').value = '0';
            document.getElementById('imagePreview').style.display = 'none';
            document.getElementById('previewImg').src = '';
            document.getElementById('currentImageName').textContent = '';
        }
        
        function editProduct(id, name, categoryId, description, price, imageUrl, isActive, costPrice) {
            document.getElementById('formAction').value = 'update';
            document.getElementById('productId').value = id;
            document.getElementById('name').value = name || '';
            document.getElementById('categoryId').value = categoryId || '';
            document.getElementById('description').value = description || '';
            document.getElementById('price').value = price || 0;
            document.getElementById('costPrice').value = costPrice || 0;
            document.getElementById('imageUrl').value = imageUrl || '';
            
            // Hiển thị ảnh hiện tại nếu có
            if (imageUrl && imageUrl.trim() !== '') {
                const contextPath = '${pageContext.request.contextPath}';
                let imgSrc = imageUrl;
                if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
                    if (imageUrl.startsWith('/')) {
                        imgSrc = contextPath + imageUrl;
                    } else {
                        imgSrc = contextPath + '/' + imageUrl;
                    }
                }
                document.getElementById('previewImg').src = imgSrc;
                document.getElementById('currentImageName').textContent = 'Ảnh hiện tại: ' + imageUrl;
                document.getElementById('imagePreview').style.display = 'block';
            } else {
                document.getElementById('imagePreview').style.display = 'none';
            }
            
            // Reset file input
            document.getElementById('imageFile').value = '';
            
            // Xử lý boolean: có thể là true/false hoặc 'true'/'false'
            const activeValue = (isActive === true || isActive === 'true' || isActive === 1);
            document.getElementById('isActive').checked = activeValue;
            document.getElementById('modalTitle').textContent = 'Sửa món ăn';
            openModal('addProductModal');
        }
        
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                    document.getElementById('currentImageName').textContent = 'Ảnh mới: ' + input.files[0].name;
                    document.getElementById('imagePreview').style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                // Nếu không chọn file, hiển thị lại ảnh cũ (nếu có)
                const imageUrl = document.getElementById('imageUrl').value;
                if (imageUrl && imageUrl.trim() !== '') {
                    const contextPath = '${pageContext.request.contextPath}';
                    let imgSrc = imageUrl;
                    if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
                        if (imageUrl.startsWith('/')) {
                            imgSrc = contextPath + imageUrl;
                        } else {
                            imgSrc = contextPath + '/' + imageUrl;
                        }
                    }
                    document.getElementById('previewImg').src = imgSrc;
                    document.getElementById('currentImageName').textContent = 'Ảnh hiện tại: ' + imageUrl;
                    document.getElementById('imagePreview').style.display = 'block';
                } else {
                    document.getElementById('imagePreview').style.display = 'none';
                }
            }
        }
        
        function calculateCostPrice() {
            const productId = document.getElementById('productId').value;
            if (!productId) {
                alert('Vui lòng lưu món ăn trước khi tính giá vốn!');
                return;
            }
            
            // Gọi AJAX để tính giá vốn
            fetch('products?action=calculateCost&id=' + productId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('costPrice').value = data.costPrice;
                        alert('Đã tính lại giá vốn: ' + new Intl.NumberFormat('vi-VN').format(data.costPrice) + ' đ');
                    } else {
                        alert('Không thể tính giá vốn: ' + (data.message || 'Lỗi không xác định'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi tính giá vốn!');
                });
        }
        
        function filterProducts() {
            const categoryId = document.getElementById('categoryFilter').value;
            const search = document.getElementById('searchInput').value;
            let url = 'products?';
            if (categoryId) {
                url += 'categoryId=' + categoryId;
            }
            if (search) {
                url += (categoryId ? '&' : '') + 'search=' + encodeURIComponent(search);
            }
            window.location.href = url;
        }
        
        function searchProducts() {
            const search = document.getElementById('searchInput').value;
            const categoryId = document.getElementById('categoryFilter').value;
            let url = 'products?';
            if (search) {
                url += 'search=' + encodeURIComponent(search);
            }
            if (categoryId) {
                url += (search ? '&' : '') + 'categoryId=' + categoryId;
            }
            window.location.href = url;
        }
        
        // Tìm kiếm khi nhấn Enter
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchProducts();
                }
            });
        }
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

