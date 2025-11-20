<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .data-table td strong {
            color: #222 !important;
        }
        .orders-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .tab-button {
            padding: 12px 25px;
            background: transparent;
            border: none;
            border-bottom: 3px solid transparent;
            font-size: 16px;
            font-weight: 600;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .tab-button:hover {
            color: #104c23;
            background: #f8f9fa;
        }
        
        .tab-button.active {
            color: #104c23;
            border-bottom-color: #ffc107;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
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
                <h1><i class="fa fa-shopping-cart"></i> Quản lý đơn hàng</h1>
            </div>
            
            <div class="orders-tabs">
                <a href="orders?tab=current" class="tab-button ${param.tab == 'current' || param.tab == null ? 'active' : ''}">
                    <i class="fa fa-receipt"></i> Hóa đơn hiện tại
                </a>
                <a href="orders?tab=history" class="tab-button ${param.tab == 'history' ? 'active' : ''}">
                    <i class="fa fa-history"></i> Lịch sử hóa đơn
                </a>
            </div>
            
            <c:choose>
                <c:when test="${param.tab == 'history'}">
                    <jsp:include page="order-history.jsp" />
                </c:when>
                <c:otherwise>
                    <jsp:include page="current-invoices.jsp" />
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
