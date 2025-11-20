<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đặt bàn | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body, .admin-content, .detail-card, .detail-card *, .detail-info, .detail-info * {
            color: #333 !important;
        }
        .booking-detail-container {
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
        
        .back-button {
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .back-button:hover {
            background: #5a6268;
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
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-canceled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .status-noshow {
            background: #e2e3e5;
            color: #383d41;
        }
        
        .tables-section {
            margin-top: 20px;
        }
        
        .table-list {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 15px;
        }
        
        .table-badge {
            padding: 10px 20px;
            background: #e7f3ff;
            border: 2px solid #007bff;
            border-radius: 8px;
            font-weight: 600;
            color: #004085;
        }
        
        .no-table {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            color: #6c757d;
            font-style: italic;
        }
        
        .note-section {
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #ffc107;
        }
        
        .note-section p {
            margin: 0;
            color: #555;
            line-height: 1.6;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0056b3;
        }
        
        .btn-warning {
            background: #ffc107;
            color: #000;
        }
        
        .btn-warning:hover {
            background: #e0a800;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        .btn-info {
            background: #17a2b8;
            color: white;
        }
        
        .btn-info:hover {
            background: #138496;
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
            <div class="booking-detail-container">
                <div class="detail-header">
                    <h1><i class="fa fa-calendar-check"></i> Chi tiết đặt bàn</h1>
                    <a href="bookings" class="back-button">
                        <i class="fa fa-arrow-left"></i> Quay lại
                    </a>
                </div>
                
                <c:if test="${empty booking}">
                    <div class="detail-card">
                        <p style="color: #dc3545; font-size: 18px;">Không tìm thấy thông tin đặt bàn!</p>
                        <a href="bookings" class="btn btn-primary">Quay lại danh sách</a>
                    </div>
                </c:if>
                
                <c:if test="${not empty booking}">
                    <div class="detail-card">
                        <h2><i class="fa fa-info-circle"></i> Thông tin đặt bàn</h2>
                        
                        <div class="detail-grid">
                            <div class="detail-item">
                                <span class="detail-label">Mã đặt bàn</span>
                                <span class="detail-value">#${booking.id}</span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Khách hàng</span>
                                <span class="detail-value">${booking.customerName}</span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Số điện thoại</span>
                                <span class="detail-value">${booking.phone}</span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Ngày đặt</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Giờ đặt</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/>
                                </span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Số người</span>
                                <span class="detail-value">${booking.numPeople} người</span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Trạng thái</span>
                                <span class="status-badge status-${booking.status.toLowerCase()}">
                                    <c:choose>
                                        <c:when test="${booking.status == 'Pending'}">Chờ xác nhận</c:when>
                                        <c:when test="${booking.status == 'Confirmed'}">Đã xác nhận</c:when>
                                        <c:when test="${booking.status == 'Canceled'}">Đã hủy</c:when>
                                        <c:when test="${booking.status == 'Completed'}">Hoàn thành</c:when>
                                        <c:when test="${booking.status == 'NoShow'}">Không đến</c:when>
                                        <c:otherwise>${booking.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            
                            <div class="detail-item">
                                <span class="detail-label">Ngày tạo</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                        </div>
                        
                        <div class="tables-section">
                            <h3 style="margin: 0 0 15px; color: #333; font-size: 18px;">
                                <i class="fa fa-chair"></i> Bàn đã gán
                            </h3>
                            <c:choose>
                                <c:when test="${not empty booking.tables}">
                                    <div class="table-list">
                                        <c:forEach var="table" items="${booking.tables}">
                                            <div class="table-badge">
                                                <i class="fa fa-table"></i> ${table.name} 
                                                <span style="font-size: 12px; color: #666;">
                                                    (${table.capacity} người - ${table.status})
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-table">
                                        <i class="fa fa-info-circle"></i> Chưa có bàn được gán cho đặt bàn này
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <c:if test="${not empty booking.note}">
                            <div class="note-section">
                                <h3 style="margin: 0 0 10px; color: #333; font-size: 16px;">
                                    <i class="fa fa-comment"></i> Ghi chú
                                </h3>
                                <p>${booking.note}</p>
                            </div>
                        </c:if>
                        
                        <div class="action-buttons">
                            <c:if test="${booking.status == 'Pending'}">
                                <a href="assign-table?bookingId=${booking.id}" class="btn btn-warning">
                                    <i class="fa fa-chair"></i> Nhận bàn
                                </a>
                            </c:if>
                            
                            <c:if test="${booking.status == 'Confirmed'}">
                                <a href="assign-table?bookingId=${booking.id}" class="btn btn-info">
                                    <i class="fa fa-edit"></i> Sửa bàn
                                </a>
                            </c:if>
                            
                            <c:if test="${booking.status != 'Canceled' && booking.status != 'Completed'}">
                                <a href="bookings?action=cancel&id=${booking.id}" 
                                   class="btn btn-danger"
                                   onclick="return confirm('Bạn có chắc muốn hủy đặt bàn này? Hành động này sẽ giải phóng bàn đã gán (nếu có).')">
                                    <i class="fa fa-times"></i> Hủy đặt bàn
                                </a>
                            </c:if>
                            
                            <c:if test="${booking.status == 'Canceled' && booking.note != null && booking.note.contains('CAN_REFUND')}">
                                <a href="bookings?action=refund&id=${booking.id}" 
                                   class="btn" 
                                   style="background: #ff9800; color: white;"
                                   onclick="return confirm('Xác nhận hoàn tiền cọc 100,000 VNĐ cho khách hàng? Hóa đơn hoàn tiền sẽ được tạo.')">
                                    <i class="fa fa-money-bill-wave"></i> Hoàn tiền
                                </a>
                            </c:if>
                            
                            <a href="bookings" class="btn btn-primary">
                                <i class="fa fa-list"></i> Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>

