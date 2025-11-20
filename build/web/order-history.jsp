<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đơn hàng | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .history-page {
            padding: 100px 80px 60px;
            background: #f5f5f5;
            min-height: 80vh;
        }
        .history-container {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .page-header {
            border-bottom: 2px solid #ffc107;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }
        .page-header h2 {
            color: #104c23;
            font-size: 24px;
        }
        .order-card {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            transition: box-shadow 0.3s;
        }
        .order-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .order-info h3 {
            margin: 0 0 5px;
            color: #222;
            font-size: 18px;
        }
        .order-info p {
            margin: 5px 0;
            color: #666;
            font-size: 14px;
        }
        .order-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d1ecf1; color: #0c5460; }
        .status-cooking { background: #d4edda; color: #155724; }
        .status-ready { background: #cce5ff; color: #004085; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-canceled { background: #f8d7da; color: #721c24; }
        .payment-status {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        .payment-unpaid { background: #f8d7da; color: #721c24; }
        .payment-paid { background: #d4edda; color: #155724; }
        .order-items {
            margin: 15px 0;
        }
        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #f5f5f5;
        }
        .order-item:last-child {
            border-bottom: none;
        }
        .order-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #ffc107;
        }
        .total-amount {
            font-size: 20px;
            font-weight: 700;
            color: #104c23;
        }
        .order-actions {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }
        .btn-action {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-view {
            background: #ffc107;
            color: #000;
        }
        .btn-view:hover {
            background: #e0a800;
        }
        .btn-cancel {
            background: #dc3545;
            color: white;
        }
        .btn-cancel:hover {
            background: #c82333;
        }
        .empty-history {
            text-align: center;
            padding: 60px 20px;
        }
        .empty-history i {
            font-size: 64px;
            color: #ccc;
            margin-bottom: 20px;
        }
        .empty-history h3 {
            color: #666;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="history-page">
        <div class="history-container">
            <div class="page-header">
                <h2><i class="fa fa-history"></i> Lịch sử đơn hàng</h2>
            </div>
            
            <c:if test="${empty orders || orders.size() == 0}">
                <div class="empty-history">
                    <i class="fa fa-shopping-bag"></i>
                    <h3>Chưa có đơn hàng nào</h3>
                    <p>Bạn chưa đặt đơn hàng nào. Hãy khám phá thực đơn của chúng tôi!</p>
                    <a href="menu" class="btn-action btn-view" style="margin-top: 20px;">
                        Xem thực đơn
                    </a>
                </div>
            </c:if>
            
            <c:forEach var="order" items="${orders}">
                <div class="order-card">
                    <div class="order-header">
                        <div class="order-info">
                            <h3>Đơn hàng #${order.id}</h3>
                            <p><i class="fa fa-calendar"></i> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
                            <p><i class="fa fa-money-bill"></i> 
                                <span class="payment-status payment-${order.paymentStatus.toLowerCase()}">
                                    ${order.paymentStatus == 'Paid' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                </span>
                            </p>
                        </div>
                        <div>
                            <span class="order-status status-${order.orderStatus.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${order.orderStatus == 'Pending'}">Chờ xác nhận</c:when>
                                    <c:when test="${order.orderStatus == 'Confirmed'}">Đã xác nhận</c:when>
                                    <c:when test="${order.orderStatus == 'Cooking'}">Đang chế biến</c:when>
                                    <c:when test="${order.orderStatus == 'Ready'}">Sẵn sàng</c:when>
                                    <c:when test="${order.orderStatus == 'Completed'}">Hoàn thành</c:when>
                                    <c:when test="${order.orderStatus == 'Canceled'}">Đã hủy</c:when>
                                    <c:otherwise>${order.orderStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    
                    <div class="order-items">
                        <c:forEach var="detail" items="${order.orderDetails}">
                            <div class="order-item">
                                <div>
                                    <strong>${detail.product.name}</strong>
                                    <span style="color: #666; margin-left: 10px;">x${detail.quantity}</span>
                                </div>
                                <div style="font-weight: 600; color: #e53935;">
                                    <fmt:formatNumber value="${detail.price * detail.quantity}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="order-total">
                        <div>
                            <c:if test="${order.discountAmount > 0}">
                                <p style="margin: 5px 0; color: #666; font-size: 14px;">
                                    Tạm tính: <fmt:formatNumber value="${order.subtotal}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </p>
                                <p style="margin: 5px 0; color: #28a745; font-size: 14px;">
                                    Giảm giá: -<fmt:formatNumber value="${order.discountAmount}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </p>
                            </c:if>
                        </div>
                        <div class="total-amount">
                            Tổng: <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                        </div>
                    </div>
                    
                    <div class="order-actions">
                        <a href="order?action=view&id=${order.id}" class="btn-action btn-view">
                            <i class="fa fa-eye"></i> Xem chi tiết
                        </a>
                        <c:if test="${order.orderStatus == 'Pending' || order.orderStatus == 'Confirmed'}">
                            <a href="order?action=cancel&id=${order.id}" class="btn-action btn-cancel"
                               onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                <i class="fa fa-times"></i> Hủy đơn
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>

