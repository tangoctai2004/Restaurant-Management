<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hóa đơn | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Chỉ override body để tránh màu trắng từ style.css, không override các màu cụ thể */
        body {
            color: #333 !important;
        }
        .order-details-container {
            display: flex;
            gap: 20px;
            height: calc(100vh - 200px);
            min-height: 600px;
        }
        
        .menu-section {
            flex: 1;
            background: white;
            border-radius: 12px;
            padding: 25px;
            overflow-y: auto;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .menu-section h2 {
            margin-bottom: 20px;
            font-size: 24px;
        }
        
        .order-section {
            flex: 0 0 400px;
            background: white;
            border-radius: 12px;
            padding: 20px;
            overflow-y: auto;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
        }
        
        .menu-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .menu-tab {
            padding: 10px 20px;
            background: transparent;
            border: none;
            border-bottom: 3px solid transparent;
            font-size: 16px;
            font-weight: 600;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .menu-tab:hover {
            color: #104c23;
        }
        
        .menu-tab.active {
            color: #104c23;
            border-bottom-color: #ffc107;
        }
        
        .menu-items-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            padding: 10px 0;
        }
        
        .menu-item-card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
        }
        
        .menu-item-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            border-color: #ffc107;
        }
        
        .menu-item-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            background: #f5f5f5;
        }
        
        .menu-item-card-content {
            padding: 15px;
            text-align: center;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .menu-item-card h4 {
            margin: 0 0 10px;
            font-size: 16px;
            font-weight: 600;
            color: #333;
            line-height: 1.4;
            min-height: 44px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .menu-item-card .price {
            color: #e53935;
            font-weight: 700;
            font-size: 18px;
            margin: 0;
        }
        
        .order-header {
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }
        
        .order-header h3 {
            margin: 0 0 10px;
            color: #104c23;
        }
        
        .order-info {
            font-size: 14px;
            color: #666;
        }
        
        .order-items-list {
            flex: 1;
            overflow-y: auto;
            margin-bottom: 15px;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        
        .order-item.completed {
            background: #d4edda;
            border-left: 4px solid #28a745;
        }
        
        .order-item.completed .order-item-name {
            text-decoration: line-through;
            color: #6c757d;
        }
        
        .order-item.completed .quantity-btn:disabled,
        .order-item.completed .quantity-btn[disabled] {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .btn-delete-all:hover {
            background: #c82333 !important;
        }
        
        .order-item-checkbox {
            width: 22px;
            height: 22px;
            cursor: pointer;
            accent-color: #28a745;
            flex-shrink: 0;
        }
        
        .order-item-checkbox:checked {
            background-color: #28a745;
        }
        
        .order-item-info {
            flex: 1;
        }
        
        .order-item-name {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .order-item-details {
            font-size: 12px;
            color: #666;
            display: flex;
            justify-content: space-between;
        }
        
        .order-item-actions {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 8px;
            background: white;
            border-radius: 5px;
            padding: 5px;
        }
        
        .quantity-btn {
            width: 24px;
            height: 24px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .quantity-btn:hover {
            background: #f0f0f0;
        }
        
        .quantity-value {
            min-width: 30px;
            text-align: center;
            font-weight: 600;
        }
        
        .order-total {
            border-top: 2px solid #f0f0f0;
            padding-top: 15px;
            margin-top: 15px;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        
        .total-amount {
            font-size: 20px;
            font-weight: 700;
            color: #28a745;
        }
        
        .order-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-save {
            flex: 1;
            padding: 12px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }
        
        .btn-save:hover {
            background: #218838;
        }
        
        .btn-back {
            padding: 12px 20px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        
        .btn-back:hover {
            background: #5a6268;
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
                <h1><i class="fa fa-receipt"></i> Chi tiết hóa đơn</h1>
            </div>
            
            <c:if test="${empty order}">
                <div class="dashboard-card">
                    <div style="text-align: center; padding: 40px; color: #999;">
                        <i class="fa fa-exclamation-triangle" style="font-size: 48px; margin-bottom: 15px;"></i>
                        <p style="font-size: 18px;">Hóa đơn chưa được kích hoạt cho booking này</p>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${not empty order}">
                <div class="order-details-container">
                    <!-- Menu Section (Left) -->
                    <div class="menu-section">
                        <h2 style="margin-top: 0; color: #104c23; font-weight: 700;">
                            <i class="fa fa-utensils"></i> Thực đơn
                        </h2>
                        
                        <div class="menu-tabs">
                            <button class="menu-tab active" onclick="showCategory('all', this)" data-category="all">Tất cả</button>
                            <c:forEach var="cat" items="${categories}">
                                <button class="menu-tab" onclick="showCategory('cat-${cat.id}', this)" data-category="cat-${cat.id}">${cat.name}</button>
                            </c:forEach>
                        </div>
                        
                        <div class="menu-items-grid">
                            <c:forEach var="product" items="${products}">
                                <div class="menu-item-card menu-category-item cat-${product.categoryId}" 
                                     onclick="addToOrder(${product.id}, '${product.name}', ${product.price})"
                                     title="Click để thêm vào hóa đơn">
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
                                            <img src="${imgSrc}" 
                                                 alt="${product.name}" 
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-food.jpg';"
                                                 style="display: block; width: 100%; height: 180px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/images/default-food.jpg" 
                                                 alt="${product.name}" 
                                                 style="display: block; width: 100%; height: 180px; object-fit: cover; background: #f5f5f5;">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="menu-item-card-content">
                                        <h4>${product.name}</h4>
                                        <p class="price">
                                            <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> ₫
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <c:if test="${empty products}">
                            <div style="text-align: center; padding: 40px; color: #999;">
                                <i class="fa fa-utensils" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>
                                <p style="font-size: 16px;">Chưa có món ăn nào trong hệ thống</p>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Order Section (Right) -->
                    <div class="order-section">
                        <div class="order-header">
                            <h3>Hóa đơn #${order.id}</h3>
                            <div class="order-info">
                                <p style="margin: 5px 0;"><strong>Bàn:</strong> 
                                    <c:forEach var="table" items="${booking.tables}">
                                        ${table.name}
                                    </c:forEach>
                                </p>
                                <p style="margin: 5px 0;"><strong>Khách:</strong> ${booking.customerName}</p>
                                <p style="margin: 5px 0;"><strong>SĐT:</strong> ${booking.phone}</p>
                            </div>
                        </div>
                        
                        <div style="margin-bottom: 10px; padding: 10px; background: #f8f9fa; border-radius: 8px;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div>
                                    <strong style="color: #104c23;">
                                        <i class="fa fa-list"></i> Danh sách món đã order
                                    </strong>
                                    <p style="margin: 5px 0 0; font-size: 12px; color: #666;">
                                        ✓ Tick vào checkbox khi món đã lên
                                    </p>
                                </div>
                                <button class="btn-delete-all" onclick="deleteAllUncompleted()" style="padding: 6px 12px; background: #dc3545; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 12px;">
                                    <i class="fa fa-trash"></i> Xóa món chưa lên
                                </button>
                            </div>
                        </div>
                        
                        <div class="order-items-list" id="orderItemsList">
                            <c:choose>
                                <c:when test="${empty order.orderDetails}">
                                    <div style="text-align: center; padding: 40px; color: #999;">
                                        <i class="fa fa-shopping-cart" style="font-size: 48px; margin-bottom: 15px;"></i>
                                        <p>Chưa có món nào trong hóa đơn</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="detail" items="${order.orderDetails}">
                                        <div class="order-item ${detail.completed ? 'completed' : ''}" data-detail-id="${detail.id}" id="item-${detail.id}">
                                            <input type="checkbox" class="order-item-checkbox" 
                                                   data-detail-id="${detail.id}"
                                                   onchange="toggleItemCompleted(${detail.id}, this.checked)"
                                                   <c:if test="${detail.completed}">checked disabled</c:if>>
                                            <div class="order-item-info">
                                                <div class="order-item-name">${detail.product.name}</div>
                                                <div class="order-item-details">
                                                    <span>
                                                        <fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/> đ x ${detail.quantity}
                                                    </span>
                                                    <span style="font-weight: 600; color: #e53935;">
                                                        <fmt:formatNumber value="${detail.price * detail.quantity}" type="number" maxFractionDigits="0"/> đ
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="order-item-actions">
                                                <div class="quantity-control">
                                                    <button class="quantity-btn" 
                                                            onclick="updateQuantity(${detail.id}, ${detail.quantity - 1})"
                                                            <c:if test="${detail.completed}">disabled style="opacity: 0.5; cursor: not-allowed;"</c:if>>-</button>
                                                    <span class="quantity-value">${detail.quantity}</span>
                                                    <button class="quantity-btn" onclick="updateQuantity(${detail.id}, ${detail.quantity + 1})">+</button>
                                                </div>
                                                <button class="quantity-btn" 
                                                        onclick="removeItem(${detail.id})" 
                                                        style="color: #dc3545; margin-left: 10px;"
                                                        <c:if test="${detail.completed}">disabled style="opacity: 0.5; cursor: not-allowed; color: #999;"</c:if>>
                                                    <i class="fa fa-times"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="order-total">
                            <div class="total-row">
                                <span>Tạm tính:</span>
                                <span id="subtotal">
                                    <fmt:formatNumber value="${order.subtotal}" type="number" maxFractionDigits="0"/> đ
                                </span>
                            </div>
                            <c:if test="${order.discountAmount > 0}">
                                <div class="total-row">
                                    <span>Giảm giá:</span>
                                    <span style="color: #28a745;">
                                        -<fmt:formatNumber value="${order.discountAmount}" type="number" maxFractionDigits="0"/> đ
                                    </span>
                                </div>
                            </c:if>
                            <div class="total-row total-amount">
                                <span>Tổng tiền:</span>
                                <span id="totalAmount">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ
                                </span>
                            </div>
                        </div>
                        
                        <div class="order-actions">
                            <button class="btn-back" onclick="window.location.href='orders?tab=current'">
                                <i class="fa fa-arrow-left"></i> Quay lại
                            </button>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    
    <script>
        let orderId = ${order.id};
        let bookingId = ${booking.id};
        
        // Show category
        function showCategory(categoryId, element) {
            // Lưu tab đang chọn vào sessionStorage
            sessionStorage.setItem('selectedCategory', categoryId);
            
            // Update active tab
            document.querySelectorAll('.menu-tab').forEach(tab => {
                tab.classList.remove('active');
            });
            if (element) {
                element.classList.add('active');
            }
            
            // Show/hide items
            document.querySelectorAll('.menu-category-item').forEach(item => {
                if (categoryId === 'all') {
                    item.style.display = 'block';
                } else {
                    if (item.classList.contains(categoryId)) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                }
            });
        }
        
        // Lưu và restore tab đang chọn sau khi trang load
        (function() {
            function restoreCategory() {
                const savedCategory = sessionStorage.getItem('selectedCategory');
                if (savedCategory) {
                    const tabElement = document.querySelector(`.menu-tab[data-category="${savedCategory}"]`);
                    if (tabElement) {
                        // Remove active từ tab mặc định
                        document.querySelectorAll('.menu-tab').forEach(tab => {
                            tab.classList.remove('active');
                        });
                        // Set active cho tab đã lưu
                        tabElement.classList.add('active');
                        // Show/hide items
                        document.querySelectorAll('.menu-category-item').forEach(item => {
                            if (savedCategory === 'all') {
                                item.style.display = 'block';
                            } else {
                                if (item.classList.contains(savedCategory)) {
                                    item.style.display = 'block';
                                } else {
                                    item.style.display = 'none';
                                }
                            }
                        });
                    }
                }
            }
            
            // Thử restore ngay lập tức
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', restoreCategory);
            } else {
                // DOM đã sẵn sàng
                setTimeout(restoreCategory, 100);
            }
        })();
        
        // Add product to order
        function addToOrder(productId, productName, price) {
            fetch('order-details?action=addItem', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'orderId=' + orderId + '&productId=' + productId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi thêm món!');
            });
        }
        
        // Update quantity
        function updateQuantity(detailId, newQuantity) {
            // Kiểm tra nếu món đã lên và đang giảm số lượng
            const itemElement = document.getElementById('item-' + detailId);
            if (itemElement) {
                const isCompleted = itemElement.classList.contains('completed');
                const currentQuantity = parseInt(itemElement.querySelector('.quantity-value').textContent);
                
                if (isCompleted && newQuantity < currentQuantity) {
                    alert('Không thể giảm số lượng món đã lên!');
                    return;
                }
            }
            
            if (newQuantity < 1) {
                // Nếu giảm về 0, chỉ xóa nếu món chưa lên
                const itemElement = document.getElementById('item-' + detailId);
                if (itemElement && itemElement.classList.contains('completed')) {
                    alert('Không thể xóa món đã lên!');
                    return;
                }
                
                if (confirm('Xóa món này khỏi hóa đơn?')) {
                    removeItem(detailId);
                }
                return;
            }
            
            fetch('order-details?action=updateQuantity', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'detailId=' + detailId + '&quantity=' + newQuantity
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi cập nhật số lượng!');
            });
        }
        
        // Remove item
        function removeItem(detailId) {
            if (confirm('Xóa món này khỏi hóa đơn?')) {
                fetch('order-details?action=removeItem', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'detailId=' + detailId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra: ' + (data.message || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa món!');
                });
            }
        }
        
        // Toggle item completed status
        function toggleItemCompleted(detailId, isCompleted) {
            fetch('order-details?action=toggleCompleted', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'detailId=' + detailId + '&completed=' + isCompleted
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const itemElement = document.getElementById('item-' + detailId);
                    const checkbox = document.querySelector('input[data-detail-id="' + detailId + '"]');
                    const decreaseBtn = itemElement.querySelector('.quantity-control .quantity-btn:first-child');
                    const deleteBtn = itemElement.querySelector('.order-item-actions .quantity-btn:last-child');
                    
                    if (isCompleted) {
                        itemElement.classList.add('completed');
                        checkbox.disabled = true;
                        if (decreaseBtn) decreaseBtn.disabled = true;
                        if (deleteBtn) deleteBtn.disabled = true;
                    } else {
                        itemElement.classList.remove('completed');
                        checkbox.disabled = false;
                        if (decreaseBtn) decreaseBtn.disabled = false;
                        if (deleteBtn) deleteBtn.disabled = false;
                    }
                } else {
                    alert('Có lỗi xảy ra: ' + (data.message || 'Unknown error'));
                    // Revert checkbox
                    document.querySelector('input[data-detail-id="' + detailId + '"]').checked = !isCompleted;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi cập nhật trạng thái!');
                // Revert checkbox
                document.querySelector('input[data-detail-id="' + detailId + '"]').checked = !isCompleted;
            });
        }
        
        // Delete all uncompleted items
        function deleteAllUncompleted() {
            if (!confirm('Xóa tất cả món chưa lên khỏi hóa đơn?')) {
                return;
            }
            
            fetch('order-details?action=deleteAllUncompleted', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'orderId=' + orderId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi xóa món!');
            });
        }
    </script>
</body>
</html>

