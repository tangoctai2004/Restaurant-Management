<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .cart-page {
            padding: 100px 80px 60px;
            background: #f5f5f5;
            min-height: 80vh;
        }
        .cart-container {
            max-width: 1000px;
            margin: 0 auto;
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .cart-header {
            border-bottom: 2px solid #ffc107;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .cart-header h2 {
            color: #104c23;
            font-size: 24px;
        }
        .cart-item {
            display: grid;
            grid-template-columns: 80px 1fr auto auto auto;
            gap: 15px;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        .cart-item img {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            object-fit: cover;
        }
        .item-info h4 {
            margin: 0 0 5px;
            color: #222;
            font-size: 16px;
        }
        .item-info p {
            margin: 0;
            color: #666;
            font-size: 14px;
        }
        .item-price {
            font-weight: 600;
            color: #e53935;
            font-size: 16px;
        }
        .qty-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .qty-control button {
            width: 30px;
            height: 30px;
            border: 1px solid #ccc;
            background: #f6f6f6;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .qty-control button:hover {
            background: #ffc107;
            border-color: #ffc107;
        }
        .qty-control span {
            min-width: 30px;
            text-align: center;
            font-weight: 600;
        }
        .item-total {
            font-weight: 700;
            color: #222;
            font-size: 18px;
        }
        .remove-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .remove-btn:hover {
            background: #c82333;
        }
        .cart-summary {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #ffc107;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 16px;
        }
        .summary-row.total {
            font-size: 20px;
            font-weight: 700;
            color: #104c23;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .promo-section {
            margin: 20px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
        }
        .promo-input {
            display: flex;
            gap: 10px;
        }
        .promo-input input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .promo-input button {
            padding: 10px 20px;
            background: #ffc107;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
        }
        .cart-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        .btn-continue {
            flex: 1;
            padding: 12px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
        }
        .btn-checkout {
            flex: 1;
            padding: 12px;
            background: #ffc107;
            color: #000;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 700;
            font-size: 16px;
        }
        .btn-checkout:hover {
            background: #e0a800;
        }
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
        }
        .empty-cart i {
            font-size: 64px;
            color: #ccc;
            margin-bottom: 20px;
        }
        .empty-cart h3 {
            color: #666;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="cart-page">
        <div class="cart-container">
            <div class="cart-header">
                <h2><i class="fa fa-shopping-cart"></i> Giỏ hàng của bạn</h2>
            </div>
            
            <c:if test="${empty cartItems || cartItems.size() == 0}">
                <div class="empty-cart">
                    <i class="fa fa-shopping-cart"></i>
                    <h3>Giỏ hàng trống</h3>
                    <p>Bạn chưa có món nào trong giỏ hàng</p>
                    <a href="menu" class="btn-continue" style="display: inline-block; margin-top: 20px; max-width: 200px;">
                        Tiếp tục mua sắm
                    </a>
                </div>
            </c:if>
            
            <c:if test="${not empty cartItems && cartItems.size() > 0}">
                <c:forEach var="item" items="${cartItems}">
                    <div class="cart-item">
                        <img src="${item.product.imageUrl}" alt="${item.product.name}">
                        <div class="item-info">
                            <h4>${item.product.name}</h4>
                            <p><fmt:formatNumber value="${item.price}" type="currency" currencyCode="VND" minFractionDigits="0"/></p>
                        </div>
                        <div class="item-price">
                            <fmt:formatNumber value="${item.price}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                        </div>
                        <div class="qty-control">
                            <button onclick="updateQuantity(${item.product.id}, ${item.quantity - 1})">-</button>
                            <span>${item.quantity}</span>
                            <button onclick="updateQuantity(${item.product.id}, ${item.quantity + 1})">+</button>
                        </div>
                        <div class="item-total">
                            <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                        </div>
                        <button class="remove-btn" onclick="removeItem(${item.product.id})">
                            <i class="fa fa-trash"></i>
                        </button>
                    </div>
                </c:forEach>
                
                <div class="cart-summary">
                    <div class="promo-section">
                        <label style="display: block; margin-bottom: 8px; font-weight: 600;">Mã khuyến mãi:</label>
                        <div class="promo-input">
                            <input type="text" id="promoCode" placeholder="Nhập mã khuyến mãi">
                            <button onclick="applyPromo()">Áp dụng</button>
                        </div>
                        <c:if test="${not empty promoError}">
                            <p style="color: #dc3545; margin-top: 8px; font-size: 14px;">${promoError}</p>
                        </c:if>
                        <c:if test="${not empty appliedPromo}">
                            <p style="color: #28a745; margin-top: 8px; font-size: 14px;">
                                Đã áp dụng: ${appliedPromo.code} - Giảm <fmt:formatNumber value="${discountAmount}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                            </p>
                        </c:if>
                    </div>
                    
                    <div class="summary-row">
                        <span>Tạm tính:</span>
                        <span><fmt:formatNumber value="${subtotal}" type="currency" currencyCode="VND" minFractionDigits="0"/></span>
                    </div>
                    <c:if test="${discountAmount > 0}">
                        <div class="summary-row" style="color: #28a745;">
                            <span>Giảm giá:</span>
                            <span>-<fmt:formatNumber value="${discountAmount}" type="currency" currencyCode="VND" minFractionDigits="0"/></span>
                        </div>
                    </c:if>
                    <div class="summary-row total">
                        <span>Tổng cộng:</span>
                        <span><fmt:formatNumber value="${totalAmount}" type="currency" currencyCode="VND" minFractionDigits="0"/></span>
                    </div>
                    
                    <div class="cart-actions">
                        <a href="menu" class="btn-continue">Tiếp tục mua sắm</a>
                        <button class="btn-checkout" onclick="checkout()">
                            <i class="fa fa-credit-card"></i> Thanh toán
                        </button>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script>
        function updateQuantity(productId, newQuantity) {
            if (newQuantity < 1) return;
            window.location.href = 'orderitem?action=update&productId=' + productId + '&quantity=' + newQuantity;
        }
        
        function removeItem(productId) {
            if (confirm('Bạn có chắc muốn xóa món này khỏi giỏ hàng?')) {
                window.location.href = 'orderitem?action=remove&productId=' + productId;
            }
        }
        
        function applyPromo() {
            const code = document.getElementById('promoCode').value;
            if (code) {
                window.location.href = 'cart?action=applyPromo&code=' + code;
            }
        }
        
        function checkout() {
            window.location.href = 'payment';
        }
    </script>
</body>
</html>

