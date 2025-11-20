<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hóa đơn #${order.id} | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body, .admin-content, .detail-card, .detail-card *, .detail-info, .detail-info * {
            color: #333 !important;
        }
        .order-detail-container {
            padding: 20px;
        }
        
        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .detail-header h1 {
            margin: 0;
            color: #104c23;
            font-size: 28px;
        }
        
        .header-actions {
            display: flex;
            gap: 10px;
        }
        
        .back-button, .print-button {
            padding: 10px 20px;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .back-button {
            background: #6c757d;
        }
        
        .back-button:hover {
            background: #5a6268;
        }
        
        .print-button {
            background: #28a745;
        }
        
        .print-button:hover {
            background: #218838;
        }
        
        .detail-card {
            background: #fff;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .detail-card h2 {
            margin: 0 0 20px;
            color: #104c23;
            font-size: 22px;
            padding-bottom: 15px;
            border-bottom: 2px solid #ffc107;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .detail-label {
            font-size: 13px;
            color: #999;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .detail-value {
            font-size: 16px;
            color: #333;
            font-weight: 600;
        }
        
        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .status-paid {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .payment-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            background: #17a2b8;
            color: white;
        }
        
        .order-type-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        
        .order-type-deposit {
            background: #17a2b8;
            color: white;
        }
        
        .order-type-refund {
            background: #dc3545;
            color: white;
        }
        
        .order-type-table {
            background: #28a745;
            color: white;
        }
        
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .items-table th {
            background: #104c23;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }
        
        .items-table td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .items-table tr:hover {
            background: #f8f9fa;
        }
        
        .text-right {
            text-align: right;
        }
        
        .text-center {
            text-align: center;
        }
        
        .total-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 16px;
        }
        
        .total-row.final {
            font-size: 20px;
            font-weight: 700;
            color: #28a745;
            padding-top: 15px;
            border-top: 2px solid #f0f0f0;
            margin-top: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
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
            <div class="order-detail-container">
                <c:if test="${empty order}">
                    <div class="detail-card">
                        <div class="empty-state">
                            <i class="fa fa-exclamation-circle"></i>
                            <p style="font-size: 18px;">Không tìm thấy hóa đơn!</p>
                            <a href="orders?tab=history" class="back-button">
                                <i class="fa fa-arrow-left"></i> Quay lại
                            </a>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty order}">
                    <div class="detail-header">
                        <h1>
                            <i class="fa fa-receipt"></i> Chi tiết hóa đơn #${order.id}
                            <c:if test="${order.note == 'DEPOSIT'}">
                                <span class="order-type-badge order-type-deposit">Hóa đơn cọc</span>
                            </c:if>
                            <c:if test="${order.note == 'REFUND'}">
                                <span class="order-type-badge order-type-refund">Hóa đơn hoàn tiền</span>
                            </c:if>
                            <c:if test="${order.note != 'DEPOSIT' && order.note != 'REFUND'}">
                                <span class="order-type-badge order-type-table">Hóa đơn tại bàn</span>
                            </c:if>
                        </h1>
                        <div class="header-actions">
                            <a href="orders?tab=history" class="back-button">
                                <i class="fa fa-arrow-left"></i> Quay lại
                            </a>
                            <button class="print-button" onclick="printInvoice(${order.id}, ${order.booking != null ? order.booking.id : 0})">
                                <i class="fa fa-print"></i> In hóa đơn
                            </button>
                        </div>
                    </div>
                    
                    <!-- Thông tin hóa đơn -->
                    <div class="detail-card">
                        <h2><i class="fa fa-info-circle"></i> Thông tin hóa đơn</h2>
                        <div class="detail-grid">
                            <div class="detail-item">
                                <span class="detail-label">Mã hóa đơn</span>
                                <span class="detail-value">#${order.id}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Ngày tạo</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Trạng thái đơn</span>
                                <span class="detail-value">
                                    <span class="status-badge status-completed">${order.orderStatus}</span>
                                </span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Trạng thái thanh toán</span>
                                <span class="detail-value">
                                    <span class="status-badge status-paid">${order.paymentStatus}</span>
                                </span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Phương thức thanh toán</span>
                                <span class="detail-value">
                                    <span class="payment-badge">
                                        <c:choose>
                                            <c:when test="${order.paymentMethod == 'COD'}">Tiền mặt</c:when>
                                            <c:when test="${order.paymentMethod == 'VNPAY'}">VNPay</c:when>
                                            <c:when test="${order.paymentMethod == 'Bank Transfer'}">Chuyển khoản</c:when>
                                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </span>
                            </div>
                            <c:if test="${not empty order.paidAt}">
                                <div class="detail-item">
                                    <span class="detail-label">Ngày thanh toán</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${order.paidAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                            </c:if>
                            <c:if test="${not empty order.transactionRef}">
                                <div class="detail-item">
                                    <span class="detail-label">Mã giao dịch</span>
                                    <span class="detail-value">${order.transactionRef}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Thông tin khách hàng -->
                    <div class="detail-card">
                        <h2><i class="fa fa-user"></i> Thông tin khách hàng</h2>
                        <div class="detail-grid">
                            <c:choose>
                                <c:when test="${order.account != null}">
                                    <div class="detail-item">
                                        <span class="detail-label">Tên khách hàng</span>
                                        <span class="detail-value">${order.account.fullName}</span>
                                    </div>
                                    <c:if test="${not empty order.account.phone}">
                                        <div class="detail-item">
                                            <span class="detail-label">Số điện thoại</span>
                                            <span class="detail-value">${order.account.phone}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty order.account.email}">
                                        <div class="detail-item">
                                            <span class="detail-label">Email</span>
                                            <span class="detail-value">${order.account.email}</span>
                                        </div>
                                    </c:if>
                                </c:when>
                                <c:when test="${order.booking != null}">
                                    <div class="detail-item">
                                        <span class="detail-label">Tên khách hàng</span>
                                        <span class="detail-value">${order.booking.customerName}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Số điện thoại</span>
                                        <span class="detail-value">${order.booking.phone}</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="detail-item">
                                        <span class="detail-label">Khách hàng</span>
                                        <span class="detail-value" style="color: #999; font-style: italic;">Khách vãng lai</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Thông tin đặt bàn (nếu có) -->
                    <c:if test="${order.booking != null}">
                        <div class="detail-card">
                            <h2><i class="fa fa-calendar-alt"></i> Thông tin đặt bàn</h2>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <span class="detail-label">Mã đặt bàn</span>
                                    <span class="detail-value">#${order.booking.id}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Ngày đặt</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${order.booking.bookingDate}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Giờ đặt</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${order.booking.bookingTime}" pattern="HH:mm" type="time"/>
                                    </span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Số người</span>
                                    <span class="detail-value">${order.booking.numPeople} người</span>
                                </div>
                                <c:if test="${not empty order.booking.tables}">
                                    <div class="detail-item">
                                        <span class="detail-label">Bàn</span>
                                        <span class="detail-value">
                                            <c:forEach var="table" items="${order.booking.tables}" varStatus="loop">
                                                ${table.name}<c:if test="${!loop.last}">, </c:if>
                                            </c:forEach>
                                        </span>
                                    </div>
                                </c:if>
                                <div class="detail-item">
                                    <span class="detail-label">Trạng thái</span>
                                    <span class="detail-value">
                                        <span class="status-badge status-${order.booking.status.toLowerCase()}">${order.booking.status}</span>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Chi tiết món ăn (chỉ cho hóa đơn tại bàn) -->
                    <c:if test="${order.note != 'DEPOSIT' && order.note != 'REFUND'}">
                        <div class="detail-card">
                            <h2><i class="fa fa-utensils"></i> Chi tiết món ăn</h2>
                            <c:choose>
                                <c:when test="${empty order.orderDetails}">
                                    <div class="empty-state">
                                        <i class="fa fa-shopping-cart"></i>
                                        <p>Không có món nào trong hóa đơn</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="items-table">
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Tên món</th>
                                                <th class="text-center">Số lượng</th>
                                                <th class="text-right">Đơn giá</th>
                                                <th class="text-right">Thành tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="detail" items="${order.orderDetails}" varStatus="loop">
                                                <tr>
                                                    <td>${loop.index + 1}</td>
                                                    <td>${detail.product.name}</td>
                                                    <td class="text-center">${detail.quantity}</td>
                                                    <td class="text-right">
                                                        <fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/> đ
                                                    </td>
                                                    <td class="text-right">
                                                        <fmt:formatNumber value="${detail.price * detail.quantity}" type="number" maxFractionDigits="0"/> đ
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                    
                    <!-- Thông tin thanh toán -->
                    <div class="detail-card">
                        <h2><i class="fa fa-money-bill-wave"></i> Thông tin thanh toán</h2>
                        <div class="total-section">
                            <c:if test="${order.note == 'DEPOSIT'}">
                                <div class="total-row">
                                    <span>Tiền cọc đặt bàn:</span>
                                    <span><fmt:formatNumber value="100000" type="number" maxFractionDigits="0"/> đ</span>
                                </div>
                            </c:if>
                            <c:if test="${order.note == 'REFUND'}">
                                <div class="total-row">
                                    <span>Tiền hoàn lại:</span>
                                    <span><fmt:formatNumber value="100000" type="number" maxFractionDigits="0"/> đ</span>
                                </div>
                            </c:if>
                            <c:if test="${order.note != 'DEPOSIT' && order.note != 'REFUND'}">
                                <div class="total-row">
                                    <span>Tạm tính:</span>
                                    <span><fmt:formatNumber value="${order.subtotal}" type="number" maxFractionDigits="0"/> đ</span>
                                </div>
                                <c:if test="${order.discountAmount > 0}">
                                    <div class="total-row">
                                        <span>Giảm giá:</span>
                                        <span style="color: #dc3545;">-<fmt:formatNumber value="${order.discountAmount}" type="number" maxFractionDigits="0"/> đ</span>
                                    </div>
                                </c:if>
                                <c:if test="${order.booking != null && order.note != 'DEPOSIT' && order.note != 'REFUND'}">
                                    <div class="total-row deposit">
                                        <span>Tiền cọc đã đặt:</span>
                                        <span>-100.000 đ</span>
                                    </div>
                                </c:if>
                            </c:if>
                            <div class="total-row final">
                                <span>Tổng cộng:</span>
                                <span><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thông tin nhân viên (nếu có) -->
                    <c:if test="${order.cashier != null}">
                        <div class="detail-card">
                            <h2><i class="fa fa-user-tie"></i> Nhân viên thu ngân</h2>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <span class="detail-label">Tên nhân viên</span>
                                    <span class="detail-value">${order.cashier.fullName}</span>
                                </div>
                                <c:if test="${not empty order.cashier.username}">
                                    <div class="detail-item">
                                        <span class="detail-label">Username</span>
                                        <span class="detail-value">${order.cashier.username}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Ghi chú (nếu có) -->
                    <c:if test="${not empty order.note && order.note != 'DEPOSIT' && order.note != 'REFUND'}">
                        <div class="detail-card">
                            <h2><i class="fa fa-sticky-note"></i> Ghi chú</h2>
                            <p style="color: #666; line-height: 1.6;">${order.note}</p>
                        </div>
                    </c:if>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        function printInvoice(orderId, bookingId) {
            window.open('print-invoice?orderId=' + orderId, '_blank');
        }
    </script>
</body>
</html>

