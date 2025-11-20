<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* CSS trực tiếp trong trang - Đảm bảo hoạt động */
        body.profile-body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%) !important;
            color: #333 !important;
        }
        
        .profile-page {
            padding: 120px 80px 60px !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%) !important;
            min-height: calc(100vh - 200px) !important;
        }
        
        .profile-container {
            max-width: 550px !important;
            margin: 0 auto !important;
            background: #ffffff !important;
            border-radius: 20px !important;
            padding: 35px !important;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08), 0 2px 8px rgba(0, 0, 0, 0.04) !important;
            border-top: 5px solid #ffc107 !important;
            position: relative !important;
        }
        
        .profile-container::before {
            content: '' !important;
            position: absolute !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            height: 5px !important;
            background: linear-gradient(90deg, #ffc107 0%, #ffd54f 100%) !important;
        }
        
        .profile-header {
            text-align: center !important;
            margin-bottom: 30px !important;
            padding-bottom: 20px !important;
            border-bottom: 2px solid #f0f0f0 !important;
            position: relative !important;
        }
        
        .profile-header::after {
            content: '' !important;
            position: absolute !important;
            bottom: -2px !important;
            left: 50% !important;
            transform: translateX(-50%) !important;
            width: 100px !important;
            height: 2px !important;
            background: linear-gradient(90deg, #ffc107, #ffd54f) !important;
        }
        
        .profile-header h2 {
            color: #104c23 !important;
            margin: 0 !important;
            font-size: 24px !important;
            font-weight: 700 !important;
            letter-spacing: -0.5px !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 12px !important;
        }
        
        .profile-header h2 i {
            color: #ffc107 !important;
            font-size: 32px !important;
        }
        
        .profile-container .form-group {
            margin-bottom: 20px !important;
        }
        
        .profile-container .form-group label {
            display: block !important;
            margin-bottom: 10px !important;
            font-weight: 600 !important;
            color: #333 !important;
            font-size: 14px !important;
            letter-spacing: 0.2px !important;
        }
        
        .profile-container .form-group input[type="text"],
        .profile-container .form-group input[type="email"],
        .profile-container .form-group input[type="tel"],
        .profile-container .form-group input[type="password"] {
            width: 100% !important;
            padding: 12px 15px !important;
            border: 2px solid #e0e0e0 !important;
            border-radius: 10px !important;
            box-sizing: border-box !important;
            font-size: 14px !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            background: #ffffff !important;
            color: #333 !important;
            transition: all 0.3s ease !important;
            outline: none !important;
        }
        
        .profile-container .form-group input[readonly] {
            background: #f8f9fa !important;
            cursor: not-allowed !important;
            border-color: #e0e0e0 !important;
            color: #666 !important;
        }
        
        .profile-container .form-group input:hover:not([readonly]) {
            border-color: #ffc107 !important;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.1) !important;
        }
        
        .profile-container .form-group input:focus:not([readonly]) {
            border-color: #ffc107 !important;
            box-shadow: 0 0 0 4px rgba(255, 193, 7, 0.15), 0 2px 8px rgba(255, 193, 7, 0.1) !important;
            transform: translateY(-1px) !important;
        }
        
        .profile-container .form-group small {
            display: block !important;
            color: #666 !important;
            font-size: 13px !important;
            margin-top: 6px !important;
            font-style: italic !important;
        }
        
        .profile-container .error {
            color: #dc3545 !important;
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%) !important;
            border: 2px solid #f5c6cb !important;
            padding: 12px 18px !important;
            border-radius: 12px !important;
            text-align: center !important;
            margin-bottom: 20px !important;
            font-size: 14px !important;
            font-weight: 600 !important;
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.1) !important;
        }
        
        .profile-container .success {
            color: #155724 !important;
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%) !important;
            border: 2px solid #c3e6cb !important;
            padding: 12px 18px !important;
            border-radius: 12px !important;
            text-align: center !important;
            margin-bottom: 20px !important;
            font-size: 14px !important;
            font-weight: 600 !important;
            box-shadow: 0 2px 8px rgba(21, 87, 36, 0.1) !important;
        }
        
        .btn-group {
            display: flex !important;
            gap: 12px !important;
            margin-top: 25px !important;
        }
        
        .btn-cancel {
            flex: 1 !important;
            padding: 12px !important;
            background: #6c757d !important;
            color: white !important;
            border: none !important;
            border-radius: 10px !important;
            font-weight: 600 !important;
            font-size: 14px !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            cursor: pointer !important;
            text-decoration: none !important;
            text-align: center !important;
            transition: all 0.3s ease !important;
            box-shadow: 0 2px 8px rgba(108, 117, 125, 0.2) !important;
        }
        
        .btn-cancel:hover {
            background: #5a6268 !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3) !important;
        }
        
        .profile-container .btn-submit {
            flex: 1 !important;
            padding: 12px !important;
            background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%) !important;
            color: #000 !important;
            border: none !important;
            border-radius: 10px !important;
            font-weight: 700 !important;
            font-size: 14px !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            cursor: pointer !important;
            transition: all 0.3s ease !important;
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3) !important;
            letter-spacing: 0.3px !important;
        }
        
        .profile-container .btn-submit:hover {
            background: linear-gradient(135deg, #ffb300 0%, #ffa000 100%) !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 6px 20px rgba(255, 193, 7, 0.4) !important;
        }
        
        .profile-container .btn-submit:active {
            transform: translateY(0) !important;
        }
        
        .profile-container hr {
            border: 0 !important;
            border-top: 2px solid #f0f0f0 !important;
            margin: 25px 0 !important;
            position: relative !important;
        }
        
        .profile-container hr::before {
            content: 'Hoặc' !important;
            position: absolute !important;
            top: -10px !important;
            left: 50% !important;
            transform: translateX(-50%) !important;
            background: #fff !important;
            padding: 0 15px !important;
            color: #999 !important;
            font-size: 13px !important;
        }
        
        @media (max-width: 768px) {
            .profile-page {
                padding: 100px 20px 40px !important;
            }
            .profile-container {
                padding: 35px 25px !important;
                border-radius: 15px !important;
            }
            .profile-header h2 {
                font-size: 24px !important;
            }
            .btn-group {
                flex-direction: column !important;
            }
        }
        
        @media (max-width: 480px) {
            .profile-container {
                padding: 25px 20px !important;
            }
            .profile-header h2 {
                font-size: 20px !important;
                flex-direction: column !important;
                gap: 8px !important;
            }
        }
    </style>
</head>
<body class="profile-body">
    <jsp:include page="header.jsp" />
    
    <c:if test="${sessionScope.account == null}">
        <script>
            window.location.href = 'login';
        </script>
    </c:if>
    
    <div class="profile-page">
        <div class="profile-container">
            <div class="profile-header">
                <h2><i class="fa fa-user-circle"></i> Thông tin cá nhân</h2>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            
            <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
            
            <form action="profile" method="POST">
                <div class="form-group">
                    <label for="username">Tên đăng nhập:</label>
                    <input type="text" id="username" name="username" 
                           value="${sessionScope.account.username}" readonly>
                    <small>Tên đăng nhập không thể thay đổi</small>
                </div>
                
                <div class="form-group">
                    <label for="fullName">Họ và tên:</label>
                    <input type="text" id="fullName" name="fullName" 
                           value="${sessionScope.account.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" 
                           value="${sessionScope.account.email}">
                </div>
                
                <div class="form-group">
                    <label for="phone">Số điện thoại:</label>
                    <input type="tel" id="phone" name="phone" 
                           value="${sessionScope.account.phone}">
                </div>
                
                <hr>
                
                <div class="form-group">
                    <label for="currentPassword">Mật khẩu hiện tại (để đổi mật khẩu):</label>
                    <input type="password" id="currentPassword" name="currentPassword" 
                           placeholder="Để trống nếu không đổi mật khẩu">
                </div>
                
                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới:</label>
                    <input type="password" id="newPassword" name="newPassword" 
                           placeholder="Để trống nếu không đổi mật khẩu">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu mới:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           placeholder="Để trống nếu không đổi mật khẩu">
                </div>
                
                <div class="btn-group">
                    <a href="home" class="btn-cancel">Hủy</a>
                    <button type="submit" class="btn-submit">Cập nhật thông tin</button>
                </div>
            </form>
            
            <div style="margin-top: 30px; padding-top: 25px; border-top: 2px solid #f0f0f0; text-align: center;">
                <a href="booking-history" 
                   style="display: inline-block; padding: 12px 30px; background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; text-decoration: none; border-radius: 8px; font-weight: 600; transition: all 0.3s; box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);">
                    <i class="fa fa-calendar-check"></i> Xem lịch sử đặt bàn
                </a>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    <jsp:include page="includes/toast-notification.jsp" />
</body>
</html>
