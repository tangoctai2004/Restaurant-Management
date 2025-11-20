<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
    <style>
        /* Inline style để đảm bảo CSS được áp dụng */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html, body {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%) !important;
            display: flex !important;
            justify-content: center !important;
            align-items: center !important;
            min-height: 100vh !important;
            color: #333 !important;
        }
        .login-container {
            background: #ffffff !important;
            max-width: 450px !important;
            width: 100% !important;
            margin: 20px !important;
            padding: 40px !important;
            border-radius: 10px !important;
            border-top: 4px solid #ffc107 !important;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1) !important;
        }
        .login-container h2 {
            text-align: center !important;
            color: #1a1a1a !important;
            font-weight: 700 !important;
            font-size: 24px !important;
            margin-top: 0 !important;
            margin-bottom: 30px !important;
        }
        .form-group {
            margin-bottom: 20px !important;
        }
        .form-group label {
            display: block !important;
            margin-bottom: 8px !important;
            font-weight: 600 !important;
            color: #555 !important;
            font-size: 14px !important;
        }
        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"],
        .form-group input[type="tel"] {
            width: 100% !important;
            padding: 12px 15px !important;
            border: 1px solid #ccc !important;
            border-radius: 5px !important;
            box-sizing: border-box !important;
            font-size: 16px !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            background: #ffffff !important;
            color: #333333 !important;
        }
        .form-group input:focus {
            outline: none !important;
            border-color: #ffc107 !important;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2) !important;
        }
        .btn-submit {
            background: #ffc107 !important;
            color: #000000 !important;
            width: 100% !important;
            padding: 12px !important;
            border: none !important;
            border-radius: 5px !important;
            font-weight: bold !important;
            font-size: 16px !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            cursor: pointer !important;
        }
        .btn-submit:hover {
            background: #e0a800 !important;
        }
        .error {
            color: #dc3545 !important;
            background: #f8d7da !important;
            border: 1px solid #f5c6cb !important;
            padding: 10px 15px !important;
            border-radius: 5px !important;
            text-align: center !important;
            margin-bottom: 20px !important;
            font-size: 15px !important;
            display: block !important;
        }
        .auth-switch {
            text-align: center !important;
            margin-top: 25px !important;
            font-size: 15px !important;
            color: #555 !important;
        }
        .auth-switch a {
            color: #ffc107 !important;
            font-weight: 600 !important;
            text-decoration: none !important;
        }
        .auth-switch a:hover {
            text-decoration: underline !important;
        }
        hr {
            border: 0 !important;
            border-top: 1px solid #eeeeee !important;
            margin: 25px 0 !important;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Đăng ký tài khoản</h2>
        
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        
        <form action="register" method="POST">
            <div class="form-group">
                <label for="username">Tên đăng nhập:</label>
                <input type="text" id="username" name="username" value="${param.username}" required>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="repassword">Nhập lại mật khẩu:</label>
                <input type="password" id="repassword" name="repassword" required>
            </div>
            <hr>
            <div class="form-group">
                <label for="fullName">Họ và tên:</label>
                <input type="text" id="fullName" name="fullName" value="${param.fullName}" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="${param.email}">
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại:</label>
                <input type="tel" id="phone" name="phone" value="${param.phone}">
            </div>
            
            <button type="submit" class="btn-submit">Đăng ký</button>
        </form>
        
        <p class="auth-switch">
            Đã có tài khoản? <a href="login">Đăng nhập ngay</a>
        </p>
    </div>
</body>
</html>
