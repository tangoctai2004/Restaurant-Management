<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt bàn | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservation.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* CSS trực tiếp trong trang - Đảm bảo hoạt động */
        body.reservation-page {
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%) !important;
            color: #333 !important;
        }
        
        .reservation-page-wrapper {
            padding: 120px 80px 60px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%) !important;
            min-height: calc(100vh - 200px) !important;
        }
        
        .reservation-container {
            max-width: 700px !important;
            margin: 0 auto !important;
            padding: 35px !important;
            background: #ffffff !important;
            border-radius: 20px !important;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08), 0 2px 8px rgba(0, 0, 0, 0.04) !important;
            border-top: 5px solid #ffc107 !important;
            position: relative !important;
        }
        
        .reservation-container::before {
            content: '' !important;
            position: absolute !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            height: 5px !important;
            background: linear-gradient(90deg, #ffc107 0%, #ffd54f 100%) !important;
        }
        
        .reservation-container h2 {
            text-align: center !important;
            color: #104c23 !important;
            margin-bottom: 30px !important;
            font-size: 28px !important;
            font-weight: 700 !important;
            letter-spacing: -0.5px !important;
            position: relative !important;
            padding-bottom: 15px !important;
        }
        
        .reservation-container h2::after {
            content: '' !important;
            position: absolute !important;
            bottom: 0 !important;
            left: 50% !important;
            transform: translateX(-50%) !important;
            width: 80px !important;
            height: 4px !important;
            background: linear-gradient(90deg, #ffc107, #ffd54f) !important;
            border-radius: 2px !important;
        }
        
        .reservation-container h2 i {
            margin-right: 12px !important;
            color: #ffc107 !important;
            font-size: 36px !important;
        }
        
        .reservation-container .form-title {
            font-size: 18px !important;
            font-weight: 700 !important;
            color: #104c23 !important;
            margin-top: 0 !important;
            margin-bottom: 20px !important;
            padding-bottom: 12px !important;
            border-bottom: 2px solid #f0f0f0 !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }
        
        .reservation-container .form-title i {
            color: #ffc107 !important;
            font-size: 22px !important;
        }
        
        .reservation-container form h3:first-of-type {
            margin-top: 0 !important;
        }
        
        .reservation-container form h3:not(:first-of-type) {
            margin-top: 40px !important;
        }
        
        .reservation-container .form-grid {
            display: grid !important;
            grid-template-columns: 1fr 1fr !important;
            gap: 20px !important;
        }
        
        .reservation-container .form-group {
            width: 100% !important;
        }
        
        .reservation-container .form-group.full-width {
            grid-column: 1 / -1 !important;
        }
        
        .reservation-container .form-group label {
            display: flex !important;
            align-items: center !important;
            gap: 8px !important;
            margin-bottom: 10px !important;
            font-weight: 600 !important;
            color: #333 !important;
            font-size: 15px !important;
        }
        
        .reservation-container .form-group label i {
            color: #ffc107 !important;
            font-size: 16px !important;
            width: 20px !important;
            text-align: center !important;
        }
        
        .reservation-container .form-group input[type="date"],
        .reservation-container .form-group input[type="time"],
        .reservation-container .form-group input[type="number"],
        .reservation-container .form-group input[type="text"],
        .reservation-container .form-group input[type="tel"],
        .reservation-container .form-group input[type="email"],
        .reservation-container .form-group select,
        .reservation-container .form-group textarea {
            width: 100% !important;
            padding: 12px 15px !important;
            border: 2px solid #e0e0e0 !important;
            border-radius: 10px !important;
            font-size: 14px !important;
            box-sizing: border-box !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            background: #ffffff !important;
            color: #333 !important;
            transition: all 0.3s ease !important;
            outline: none !important;
        }
        
        .reservation-container .form-group input:hover,
        .reservation-container .form-group select:hover,
        .reservation-container .form-group textarea:hover {
            border-color: #ffc107 !important;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.1) !important;
        }
        
        .reservation-container .form-group input:focus,
        .reservation-container .form-group select:focus,
        .reservation-container .form-group textarea:focus {
            border-color: #ffc107 !important;
            box-shadow: 0 0 0 4px rgba(255, 193, 7, 0.15), 0 2px 8px rgba(255, 193, 7, 0.1) !important;
            transform: translateY(-1px) !important;
        }
        
        .reservation-container .form-group textarea {
            height: 80px !important;
            resize: vertical !important;
            font-family: inherit !important;
            line-height: 1.6 !important;
        }
        
        .reservation-container .form-group select {
            cursor: pointer !important;
            appearance: none !important;
            -webkit-appearance: none !important;
            -moz-appearance: none !important;
            padding-right: 40px !important;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E") !important;
            background-repeat: no-repeat !important;
            background-position: right 15px center !important;
            background-size: 12px !important;
        }
        
        .reservation-container .submit-btn {
            width: 100% !important;
            padding: 14px !important;
            background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%) !important;
            border: none !important;
            border-radius: 12px !important;
            font-weight: 700 !important;
            font-size: 15px !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            cursor: pointer !important;
            margin-top: 30px !important;
            color: #000 !important;
            transition: all 0.3s ease !important;
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3) !important;
            letter-spacing: 0.5px !important;
            text-transform: uppercase !important;
        }
        
        .reservation-container .submit-btn:hover {
            background: linear-gradient(135deg, #ffb300 0%, #ffa000 100%) !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 6px 20px rgba(255, 193, 7, 0.4) !important;
        }
        
        .reservation-container .submit-btn:active {
            transform: translateY(0) !important;
        }
        
        .reservation-container .submit-btn i {
            margin-right: 10px !important;
            font-size: 18px !important;
        }
        
        .reservation-container .error-message {
            color: #dc3545 !important;
            text-align: center !important;
            font-weight: 600 !important;
            margin-bottom: 18px !important;
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%) !important;
            border: 2px solid #f5c6cb !important;
            padding: 12px 18px !important;
            border-radius: 12px !important;
            font-size: 14px !important;
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.1) !important;
        }
        
        .reservation-container .success-message {
            color: #155724 !important;
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%) !important;
            border: 2px solid #c3e6cb !important;
            padding: 15px 18px !important;
            border-radius: 12px !important;
            margin-bottom: 20px !important;
            text-align: center !important;
            font-weight: 600 !important;
            font-size: 14px !important;
            box-shadow: 0 2px 8px rgba(21, 87, 36, 0.1) !important;
        }
        
        .reservation-container .warning-box {
            background: linear-gradient(135deg, #fff3cd 0%, #ffe69c 100%) !important;
            border: 2px solid #ffc107 !important;
            padding: 15px 20px !important;
            border-radius: 12px !important;
            margin-bottom: 25px !important;
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.15) !important;
            position: relative !important;
        }
        
        .reservation-container .warning-box::before {
            content: '' !important;
            position: absolute !important;
            left: 0 !important;
            top: 0 !important;
            bottom: 0 !important;
            width: 4px !important;
            background: #ffc107 !important;
        }
        
        .reservation-container .warning-box p {
            margin: 0 !important;
            color: #856404 !important;
            font-weight: 600 !important;
            font-size: 15px !important;
            line-height: 1.6 !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }
        
        .reservation-container .warning-box i {
            font-size: 20px !important;
            color: #ffc107 !important;
        }
        
        @media (max-width: 768px) {
            .reservation-page-wrapper {
                padding: 100px 20px 40px !important;
            }
            .reservation-container {
                padding: 30px 20px !important;
                border-radius: 15px !important;
            }
            .reservation-container h2 {
                font-size: 26px !important;
            }
            .reservation-container .form-grid {
                grid-template-columns: 1fr !important;
            }
        }
    </style>
</head>
<body class="reservation-page">
    <jsp:include page="header.jsp" />
    
    <div class="reservation-page-wrapper">
        <div class="reservation-container reveal">
            <h2>
                <i class="fa fa-calendar-check"></i> ${reservationSettings['pageTitle'] != null ? reservationSettings['pageTitle'] : 'ĐẶT BÀN'}
            </h2>
            
            <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
            
            <form action="reservation" method="POST" class="reveal">
                <h3 class="form-title">
                    <i class="fa fa-clock"></i> ${reservationSettings['formTitle'] != null ? reservationSettings['formTitle'] : 'THÔNG TIN ĐẶT BÀN'}
                </h3>
                
                <div class="form-grid">
                    <%-- Hiển thị các fields mặc định --%>
                    <div class="form-group">
                        <label for="customerName"><i class="fa fa-user"></i> Họ và tên:</label>
                        <input type="text" id="customerName" name="customerName" 
                               value="${sessionScope.account != null ? sessionScope.account.fullName : param.customerName}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone"><i class="fa fa-phone"></i> Số điện thoại:</label>
                        <input type="tel" id="phone" name="phone" 
                               value="${sessionScope.account != null ? sessionScope.account.phone : param.phone}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="bookingDate"><i class="fa fa-calendar"></i> Ngày đặt:</label>
                        <input type="date" id="bookingDate" name="bookingDate" 
                               value="${param.bookingDate}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="bookingTime"><i class="fa fa-clock"></i> Giờ đặt:</label>
                        <input type="time" id="bookingTime" name="bookingTime" 
                               value="${param.bookingTime}" required>
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="numPeople"><i class="fa fa-users"></i> Số người:</label>
                        <input type="number" id="numPeople" name="numPeople" 
                               value="${param.numPeople}" min="1" required>
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="note"><i class="fa fa-comment"></i> Ghi chú:</label>
                        <textarea id="note" name="note" placeholder="Yêu cầu đặc biệt, dịp kỷ niệm...">${param.note}</textarea>
                    </div>
                </div>
                
                <c:if test="${reservationSettings['warningMessage'] != null && !reservationSettings['warningMessage'].isEmpty()}">
                    <div class="warning-box">
                        <p>
                            <i class="fa fa-info-circle"></i> ${reservationSettings['warningMessage']}
                        </p>
                    </div>
                </c:if>
                
                <button type="submit" class="submit-btn">
                    <i class="fa fa-credit-card"></i> ${reservationSettings['submitButtonText'] != null ? reservationSettings['submitButtonText'] : 'Thanh toán tiền cọc và đặt bàn'}
                </button>
            </form>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    <jsp:include page="includes/toast-notification.jsp" />
    
    <script>
        // Reveal animation
        function reveal() {
            const reveals = document.querySelectorAll(".reveal");
            for (let i = 0; i < reveals.length; i++) {
                const windowHeight = window.innerHeight;
                const revealTop = reveals[i].getBoundingClientRect().top;
                const revealPoint = 100;
                if (revealTop < windowHeight - revealPoint) {
                    reveals[i].classList.add("active");
                }
            }
        }
        window.addEventListener("scroll", reveal);
        reveal();
    </script>
</body>
</html>
