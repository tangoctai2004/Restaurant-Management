<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body, .admin-content, .success-container, .success-container *, .info-item, .info-item * {
            color: #333 !important;
        }
        .success-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .success-icon {
            font-size: 80px;
            color: #28a745;
            margin-bottom: 20px;
        }
        
        .success-title {
            font-size: 28px;
            font-weight: 700;
            color: #28a745;
            margin-bottom: 10px;
        }
        
        .success-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
        }
        
        .payment-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #666;
            font-weight: 500;
        }
        
        .info-value {
            color: #333;
            font-weight: 600;
        }
        
        .amount-value {
            color: #28a745;
            font-size: 20px;
            font-weight: 700;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .btn-print {
            padding: 12px 30px;
            background: #17a2b8;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-print:hover {
            background: #138496;
        }
        
        .btn-back {
            padding: 12px 30px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
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
            <div class="success-container">
                <div class="success-icon">
                    <i class="fa fa-check-circle"></i>
                </div>
                <h1 class="success-title">Thanh toán thành công!</h1>
                <p class="success-message">
                    Khách hàng đã thanh toán thành công qua ${paymentMethod}.
                </p>
                
                <div class="payment-info">
                    <div class="info-row">
                        <span class="info-label">Bàn:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty tableName}">
                                    ${tableName}
                                </c:when>
                                <c:when test="${not empty booking.tables}">
                                    <c:forEach var="table" items="${booking.tables}" varStatus="loop">
                                        ${table.name}<c:if test="${!loop.last}">, </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Hóa đơn:</span>
                        <span class="info-value">#${order.id}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Khách hàng:</span>
                        <span class="info-value">${booking.customerName}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Số tiền:</span>
                        <span class="info-value amount-value">
                            <fmt:formatNumber value="${amount}" type="number" maxFractionDigits="0"/> đ
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phương thức:</span>
                        <span class="info-value">${paymentMethod}</span>
                    </div>
                    <c:if test="${not empty transactionNo}">
                        <div class="info-row">
                            <span class="info-label">Mã giao dịch:</span>
                            <span class="info-value">${transactionNo}</span>
                        </div>
                    </c:if>
                </div>
                
                <div class="action-buttons">
                    <a href="print-invoice?bookingId=${booking.id}&tableId=${tableId != null ? tableId : 0}" 
                       target="_blank" 
                       class="btn-print">
                        <i class="fa fa-print"></i> In hóa đơn
                    </a>
                    <a href="orders?tab=current" class="btn-back">
                        <i class="fa fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

