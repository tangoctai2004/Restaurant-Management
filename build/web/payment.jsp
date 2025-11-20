<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .payment-page {
            padding: 100px 80px 60px;
            background: #f5f5f5;
            min-height: 80vh;
        }
        .payment-container {
            max-width: 1000px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }
        .payment-form, .order-summary {
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .section-title {
            color: #104c23;
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ffc107;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
            box-sizing: border-box;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: #ffc107;
            box-shadow: 0 0 8px rgba(255,193,7,0.3);
            outline: none;
        }
        .form-group textarea {
            height: 80px;
            resize: vertical;
        }
        .payment-methods {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-top: 10px;
        }
        .payment-method {
            border: 2px solid #eee;
            border-radius: 5px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .payment-method:hover {
            border-color: #ffc107;
        }
        .payment-method input[type="radio"] {
            display: none;
        }
        .payment-method input[type="radio"]:checked + label {
            color: #ffc107;
            font-weight: 700;
        }
        .payment-method label {
            cursor: pointer;
            display: block;
        }
        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .order-item:last-child {
            border-bottom: none;
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
            border-top: 2px solid #ffc107;
        }
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: #ffc107;
            color: #000;
            border: none;
            border-radius: 5px;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
        }
        .btn-submit:hover {
            background: #e0a800;
        }
        @media (max-width: 900px) {
            .payment-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="payment-page">
        <div class="payment-container">
            <div class="payment-form">
                <h2 class="section-title"><i class="fa fa-credit-card"></i> Thông tin thanh toán</h2>
                
                <c:if test="${not empty error}">
                    <div style="color: #dc3545; background: #f8d7da; border: 1px solid #f5c6cb; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
                        ${error}
                    </div>
                </c:if>
                
                <form action="payment" method="POST">
                    <div class="form-group">
                        <label for="customerName">Họ và tên:</label>
                        <input type="text" id="customerName" name="customerName" 
                               value="${sessionScope.account.fullName}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Số điện thoại:</label>
                        <input type="tel" id="phone" name="phone" 
                               value="${sessionScope.account.phone}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" 
                               value="${sessionScope.account.email}">
                    </div>
                    
                    <div class="form-group">
                        <label>Phương thức thanh toán:</label>
                        <div class="payment-methods">
                            <div class="payment-method">
                                <input type="radio" id="cod" name="paymentMethod" value="COD" checked>
                                <label for="cod">
                                    <i class="fa fa-money-bill" style="font-size: 24px; display: block; margin-bottom: 5px;"></i>
                                    Tiền mặt
                                </label>
                            </div>
                            <div class="payment-method">
                                <input type="radio" id="vnpay" name="paymentMethod" value="VNPAY">
                                <label for="vnpay">
                                    <i class="fa fa-credit-card" style="font-size: 24px; display: block; margin-bottom: 5px;"></i>
                                    VNPay
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="note">Ghi chú đơn hàng:</label>
                        <textarea id="note" name="note" placeholder="Yêu cầu đặc biệt..."></textarea>
                    </div>
                    
                    <button type="submit" class="btn-submit">
                        <i class="fa fa-check"></i> Xác nhận đặt hàng
                    </button>
                </form>
            </div>
            
            <div class="order-summary">
                <h2 class="section-title"><i class="fa fa-receipt"></i> Tóm tắt đơn hàng</h2>
                
                <c:forEach var="item" items="${cartItems}">
                    <div class="order-item">
                        <div>
                            <strong>${item.product.name}</strong>
                            <p style="margin: 5px 0; color: #666; font-size: 14px;">
                                x${item.quantity}
                            </p>
                        </div>
                        <div style="font-weight: 600; color: #e53935;">
                            <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                        </div>
                    </div>
                </c:forEach>
                
                <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
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
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>

