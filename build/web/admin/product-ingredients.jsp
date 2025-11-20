<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý nguyên liệu - ${product.name} | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body, .admin-content, .dashboard-card, .data-table td, .data-table th {
            color: #333 !important;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .page-header h1 {
            margin: 0;
            color: #104c23;
            font-size: 28px;
        }
        
        .product-info-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border-left: 5px solid #28a745;
        }
        
        .product-info-card h3 {
            margin: 0 0 20px 0;
            color: #104c23;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .product-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .info-item {
            padding: 15px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .info-item strong {
            display: block;
            color: #666;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .info-item .value {
            font-size: 20px;
            font-weight: 700;
        }
        
        .ingredients-section {
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 25px;
        }
        
        .ingredients-list, .add-ingredient-form {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        
        .ingredients-list h3, .add-ingredient-form h3 {
            margin: 0 0 20px 0;
            color: #104c23;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .ingredient-item {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 18px;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .ingredient-item:hover {
            background: #e9ecef;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .ingredient-item-info {
            flex: 1;
            margin-right: 20px;
        }
        
        .ingredient-item-info .name {
            display: block;
            font-size: 17px;
            font-weight: 700;
            color: #104c23;
            margin-bottom: 10px;
        }
        
        .ingredient-item-info .details {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            color: #666;
            font-size: 14px;
        }
        
        .ingredient-item-info .details span {
            padding: 4px 8px;
            background: white;
            border-radius: 4px;
        }
        
        .ingredient-item-actions {
            display: flex;
            gap: 8px;
            flex-shrink: 0;
        }
        
        .btn-action {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
            text-decoration: none;
        }
        
        .btn-edit {
            background: #17a2b8;
            color: white;
        }
        
        .btn-edit:hover {
            background: #138496;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(23, 162, 184, 0.3);
        }
        
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        
        .btn-delete:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
        }
        
        .cost-summary {
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border-radius: 10px;
            padding: 20px;
            margin-top: 25px;
            border-left: 5px solid #28a745;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .cost-summary strong {
            font-size: 16px;
            color: #155724;
        }
        
        .cost-summary .amount {
            color: #dc3545;
            font-size: 24px;
            font-weight: 700;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        
        .form-group select,
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        
        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #28a745;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
        }
        
        .form-group small {
            display: block;
            margin-top: 6px;
            color: #666;
            font-size: 13px;
        }
        
        .cost-preview {
            background: #fff3cd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
            border-left: 4px solid #ffc107;
        }
        
        .cost-preview strong {
            color: #856404;
        }
        
        .cost-preview .amount {
            color: #856404;
            font-weight: 700;
            font-size: 18px;
        }
        
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.3);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        .empty-state p {
            font-size: 16px;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }
        
        .modal.active {
            display: flex;
        }
        
        .modal-content {
            background: white;
            border-radius: 12px;
            padding: 30px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .modal-header h2 {
            margin: 0;
            color: #104c23;
            font-size: 22px;
        }
        
        .close-modal {
            background: none;
            border: none;
            font-size: 28px;
            color: #999;
            cursor: pointer;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.3s ease;
        }
        
        .close-modal:hover {
            background: #f0f0f0;
            color: #333;
        }
        
        .modal-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 25px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-primary {
            background: #28a745;
            color: white;
        }
        
        .btn-primary:hover {
            background: #218838;
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
                <h1><i class="fa fa-list"></i> Quản lý nguyên liệu - ${product.name}</h1>
                <a href="products" class="btn btn-secondary" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                    <i class="fa fa-arrow-left"></i> Quay lại
                </a>
            </div>
            
            <div class="product-info-card">
                <h3>
                    <i class="fa fa-utensils"></i> ${product.name}
                </h3>
                <div class="product-info-grid">
                    <div class="info-item">
                        <strong>Giá bán</strong>
                        <span class="value" style="color: #28a745;">
                            <fmt:formatNumber value="${product.price}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                        </span>
                    </div>
                    <div class="info-item">
                        <strong>Giá vốn</strong>
                        <span class="value" style="color: #dc3545;">
                            <fmt:formatNumber value="${product.costPrice}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                        </span>
                    </div>
                    <div class="info-item">
                        <strong>Lợi nhuận</strong>
                        <c:set var="profit" value="${product.price - product.costPrice}" />
                        <span class="value" style="color: ${profit >= 0 ? '#17a2b8' : '#dc3545'};">
                            <fmt:formatNumber value="${profit}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                        </span>
                        <small style="color: #666; display: block; margin-top: 5px;">
                            (<fmt:formatNumber value="${product.costPrice > 0 ? (profit / product.costPrice * 100) : 0}" maxFractionDigits="1"/>%)
                        </small>
                    </div>
                </div>
            </div>
            
            <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
            
            <div class="ingredients-section">
                <div class="ingredients-list">
                    <h3>
                        <i class="fa fa-list"></i> Danh sách nguyên liệu
                    </h3>
                    
                    <c:choose>
                        <c:when test="${not empty productIngredients}">
                            <c:forEach var="pi" items="${productIngredients}">
                                <div class="ingredient-item">
                                    <div class="ingredient-item-info">
                                        <span class="name">${pi.ingredientName}</span>
                                        <div class="details">
                                            <span><i class="fa fa-balance-scale"></i> Số lượng: ${pi.quantityNeeded} ${pi.unit}</span>
                                            <span><i class="fa fa-tag"></i> Giá: <fmt:formatNumber value="${pi.price}" type="currency" currencyCode="VND" minFractionDigits="0"/>/${pi.unit}</span>
                                            <span><i class="fa fa-money-bill-wave"></i> Thành tiền: <fmt:formatNumber value="${pi.price * pi.quantityNeeded}" type="currency" currencyCode="VND" minFractionDigits="0"/></span>
                                        </div>
                                    </div>
                                    <div class="ingredient-item-actions">
                                        <button class="btn-action btn-edit" onclick="editIngredientQuantity(${pi.ingredientId}, ${pi.quantityNeeded})" title="Sửa số lượng">
                                            <i class="fa fa-edit"></i>
                                        </button>
                                        <a href="product-ingredients?productId=${product.id}&action=remove&ingredientId=${pi.ingredientId}" 
                                           class="btn-action btn-delete"
                                           onclick="return confirm('Bạn có chắc muốn xóa nguyên liệu ${pi.ingredientName}?')"
                                           title="Xóa nguyên liệu">
                                            <i class="fa fa-trash"></i>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <div class="cost-summary">
                                <strong><i class="fa fa-calculator"></i> Tổng giá vốn:</strong>
                                <c:set var="totalCost" value="0" />
                                <c:forEach var="pi" items="${productIngredients}">
                                    <c:set var="totalCost" value="${totalCost + (pi.price * pi.quantityNeeded)}" />
                                </c:forEach>
                                <span class="amount">
                                    <fmt:formatNumber value="${totalCost}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fa fa-box-open"></i>
                                <p>Chưa có nguyên liệu nào cho món ăn này</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="add-ingredient-form">
                    <h3>
                        <i class="fa fa-plus-circle"></i> Thêm nguyên liệu
                    </h3>
                    <form action="product-ingredients" method="POST" onsubmit="return validateAddQuantity(this)">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.id}">
                        
                        <div class="form-group">
                            <label for="ingredientId"><i class="fa fa-list"></i> Chọn nguyên liệu:</label>
                            <select id="ingredientId" name="ingredientId" required>
                                <option value="">-- Chọn nguyên liệu --</option>
                                <c:forEach var="ingredient" items="${allIngredients}">
                                    <option value="${ingredient.id}" data-price="${ingredient.price}" data-unit="${ingredient.unit}">
                                        ${ingredient.name} - <fmt:formatNumber value="${ingredient.price}" type="currency" currencyCode="VND" minFractionDigits="0"/>/${ingredient.unit}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="quantity"><i class="fa fa-balance-scale"></i> Số lượng cần:</label>
                            <input type="number" id="quantity" name="quantity" min="0.001" step="0.001" required>
                            <small id="quantityUnit"></small>
                        </div>
                        
                        <div id="costPreview" class="cost-preview">
                            <strong><i class="fa fa-money-bill-wave"></i> Thành tiền:</strong>
                            <span class="amount" id="costAmount"></span>
                        </div>
                        
                        <button type="submit" class="btn-submit">
                            <i class="fa fa-plus"></i> Thêm nguyên liệu
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal Sửa số lượng -->
    <div id="editQuantityModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fa fa-edit"></i> Sửa số lượng nguyên liệu</h2>
                <button class="close-modal" onclick="closeEditModal()">&times;</button>
            </div>
            <form action="product-ingredients" method="POST" id="editQuantityForm" onsubmit="return validateQuantity(this)">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="productId" value="${product.id}">
                <input type="hidden" name="ingredientId" id="editIngredientId">
                
                <div class="form-group">
                    <label for="editQuantity"><i class="fa fa-balance-scale"></i> Số lượng cần:</label>
                    <input type="number" id="editQuantity" name="quantity" min="0.001" step="0.001" required>
                    <small>Số lượng phải lớn hơn 0. Nếu muốn xóa nguyên liệu, vui lòng sử dụng nút xóa.</small>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Hiển thị đơn vị và tính thành tiền khi chọn nguyên liệu
        document.getElementById('ingredientId').addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const unit = selectedOption.getAttribute('data-unit');
            const price = parseFloat(selectedOption.getAttribute('data-price')) || 0;
            
            document.getElementById('quantityUnit').textContent = 'Đơn vị: ' + (unit || '');
            
            const quantityInput = document.getElementById('quantity');
            const costPreview = document.getElementById('costPreview');
            const costAmount = document.getElementById('costAmount');
            
            // Xóa event listener cũ nếu có
            const newQuantityInput = quantityInput.cloneNode(true);
            quantityInput.parentNode.replaceChild(newQuantityInput, quantityInput);
            
            newQuantityInput.addEventListener('input', function() {
                const quantity = parseFloat(this.value) || 0;
                const total = price * quantity;
                if (quantity > 0 && price > 0) {
                    costPreview.style.display = 'block';
                    costAmount.textContent = new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND',
                        minimumFractionDigits: 0
                    }).format(total);
                } else {
                    costPreview.style.display = 'none';
                }
            });
        });
        
        function editIngredientQuantity(ingredientId, currentQuantity) {
            document.getElementById('editIngredientId').value = ingredientId;
            document.getElementById('editQuantity').value = currentQuantity;
            document.getElementById('editQuantityModal').classList.add('active');
        }
        
        function closeEditModal() {
            document.getElementById('editQuantityModal').classList.remove('active');
        }
        
        // Đóng modal khi click outside
        document.getElementById('editQuantityModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeEditModal();
            }
        });
        
        // Validation số lượng khi thêm
        function validateAddQuantity(form) {
            const quantityInput = form.querySelector('#quantity');
            const quantity = parseFloat(quantityInput.value);
            
            if (quantity <= 0 || isNaN(quantity)) {
                alert('Số lượng phải lớn hơn 0! Nếu muốn xóa nguyên liệu, vui lòng sử dụng nút xóa.');
                quantityInput.focus();
                return false;
            }
            
            return true;
        }
        
        // Validation số lượng khi sửa
        function validateQuantity(form) {
            const quantityInput = form.querySelector('#editQuantity');
            const quantity = parseFloat(quantityInput.value);
            
            if (quantity <= 0 || isNaN(quantity)) {
                alert('Số lượng phải lớn hơn 0! Nếu muốn xóa nguyên liệu, vui lòng sử dụng nút xóa.');
                quantityInput.focus();
                return false;
            }
            
            return true;
        }
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>
