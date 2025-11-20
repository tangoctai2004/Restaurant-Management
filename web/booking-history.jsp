<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đặt bàn | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .history-page {
            padding: 100px 80px 60px;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
            min-height: 80vh;
        }
        .history-container {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08), 0 2px 8px rgba(0,0,0,0.04);
        }
        .page-header {
            border-bottom: 3px solid #ffc107;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .page-header h2 {
            color: #104c23;
            font-size: 28px;
            margin: 0;
        }
        .booking-card {
            border: 1px solid #eee;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s;
            background: #fff;
            border-left: 4px solid #ffc107;
        }
        .booking-card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
            transform: translateY(-2px);
        }
        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f5f5f5;
        }
        .booking-info h3 {
            margin: 0 0 10px;
            color: #222;
            font-size: 20px;
        }
        .booking-info p {
            margin: 8px 0;
            color: #666;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .booking-info i {
            color: #ffc107;
            width: 18px;
        }
        .booking-status {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
        }
        .status-pending { 
            background: #fff3cd; 
            color: #856404; 
        }
        .status-confirmed { 
            background: #d1ecf1; 
            color: #0c5460; 
        }
        .status-completed { 
            background: #d4edda; 
            color: #155724; 
        }
        .status-canceled { 
            background: #f8d7da; 
            color: #721c24; 
        }
        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .detail-label {
            font-size: 12px;
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
        .booking-note {
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid #ffc107;
        }
        .booking-note p {
            margin: 0;
            color: #555;
            font-style: italic;
        }
        .booking-note.empty {
            color: #999;
            font-style: italic;
        }
        .empty-history {
            text-align: center;
            padding: 80px 20px;
        }
        .empty-history i {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 25px;
        }
        .empty-history h3 {
            color: #666;
            margin-bottom: 15px;
            font-size: 24px;
        }
        .empty-history p {
            color: #999;
            margin-bottom: 30px;
            font-size: 16px;
        }
        .btn-action {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        .btn-reserve {
            background: #ffc107;
            color: #000;
        }
        .btn-reserve:hover {
            background: #e0a800;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.3);
        }
        @media (max-width: 768px) {
            .history-page {
                padding: 100px 20px 40px;
            }
            .history-container {
                padding: 25px;
            }
            .booking-header {
                flex-direction: column;
                gap: 15px;
            }
            .booking-details {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="history-page">
        <div class="history-container">
            <div class="page-header">
                <h2><i class="fa fa-calendar-check"></i> Lịch sử đặt bàn</h2>
            </div>
            
            <c:if test="${empty bookings || bookings.size() == 0}">
                <div class="empty-history">
                    <i class="fa fa-calendar-times"></i>
                    <h3>Chưa có đặt bàn nào</h3>
                    <p>Bạn chưa có đặt bàn nào. Hãy đặt bàn ngay để trải nghiệm dịch vụ của chúng tôi!</p>
                    <a href="reservation" class="btn-action btn-reserve">
                        <i class="fa fa-calendar-plus"></i> Đặt bàn ngay
                    </a>
                </div>
            </c:if>
            
            <c:forEach var="booking" items="${bookings}">
                <div class="booking-card">
                    <div class="booking-header">
                        <div class="booking-info">
                            <h3><i class="fa fa-calendar-alt"></i> Đặt bàn #${booking.id}</h3>
                            <p>
                                <i class="fa fa-user"></i>
                                <strong>${booking.customerName}</strong>
                            </p>
                            <p>
                                <i class="fa fa-phone"></i>
                                ${booking.phone}
                            </p>
                            <p>
                                <i class="fa fa-clock"></i>
                                Đặt lúc: <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </p>
                        </div>
                        <div>
                            <span class="booking-status status-${booking.status.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${booking.status == 'Pending'}">Chờ xác nhận</c:when>
                                    <c:when test="${booking.status == 'Confirmed'}">Đã xác nhận</c:when>
                                    <c:when test="${booking.status == 'Completed'}">Hoàn thành</c:when>
                                    <c:when test="${booking.status == 'Canceled'}">Đã hủy</c:when>
                                    <c:otherwise>${booking.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    
                    <div class="booking-details">
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa fa-calendar"></i> Ngày đặt</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa fa-clock"></i> Giờ đặt</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fa fa-users"></i> Số người</span>
                            <span class="detail-value">${booking.numPeople} người</span>
                        </div>
                    </div>
                    
                    <c:if test="${not empty booking.note}">
                        <div class="booking-note">
                            <p><i class="fa fa-comment"></i> <strong>Ghi chú:</strong> ${booking.note}</p>
                        </div>
                    </c:if>
                    <c:if test="${empty booking.note}">
                        <div class="booking-note empty">
                            <p><i class="fa fa-comment"></i> Không có ghi chú</p>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>

