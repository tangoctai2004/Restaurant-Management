<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product != null ? product.name : 'Chi tiết món ăn'} | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background-color: #111;
            color: white;
            padding-top: 80px;
        }
        
        .product-detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 60px 20px;
            min-height: calc(100vh - 200px);
        }
        
        .product-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .product-header h1 {
            font-size: 48px;
            color: #fff;
            margin-bottom: 40px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        
        .product-image-wrapper {
            width: 100%;
            max-width: 800px;
            margin: 0 auto 40px;
            text-align: center;
        }
        
        .product-image {
            width: 100%;
            max-width: 800px;
            height: 500px;
            object-fit: cover;
            border-radius: 20px;
            display: block;
            margin: 0 auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
            border: 4px solid rgba(255,255,255,0.15);
        }
        
        .price-section {
            text-align: center;
            margin: 40px 0 50px;
            padding: 30px;
            background: linear-gradient(135deg, rgba(255,193,7,0.15) 0%, rgba(255,193,7,0.05) 100%);
            border-radius: 15px;
            border: 2px solid rgba(255,193,7,0.3);
            backdrop-filter: blur(10px);
        }
        
        .price-label {
            font-size: 18px;
            color: #ccc;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .product-price {
            font-size: 48px;
            color: #ffc107;
            font-weight: 800;
            text-shadow: 0 2px 10px rgba(255,193,7,0.5);
            margin: 0;
        }
        
        .product-price::after {
            content: ' đ';
            font-size: 36px;
            font-weight: 600;
        }
        
        .post-content {
            line-height: 2;
            color: #e0e0e0;
            font-size: 17px;
            margin-top: 40px;
            padding: 40px;
            background: rgba(255,255,255,0.03);
            border-radius: 15px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .post-content img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
            margin: 30px 0;
            box-shadow: 0 6px 15px rgba(0,0,0,0.4);
        }
        
        /* Ẩn ảnh đầu tiên trong post-content nếu nó giống với ảnh chính */
        .post-content > img:first-child {
            display: none;
        }
        
        .post-content p {
            margin-bottom: 20px;
            color: #e0e0e0;
        }
        
        .post-content h1, .post-content h2, .post-content h3, .post-content h4 {
            margin-top: 40px;
            margin-bottom: 20px;
            color: #fff;
            font-weight: 600;
        }
        
        .post-content h1 {
            font-size: 32px;
            margin-top: 0;
        }
        
        .post-content h2 {
            font-size: 28px;
        }
        
        .post-content h3 {
            font-size: 24px;
        }
        
        .post-content ul, .post-content ol {
            margin: 20px 0;
            padding-left: 30px;
            color: #e0e0e0;
        }
        
        .post-content li {
            margin-bottom: 10px;
        }
        
        .post-content strong {
            color: #ffc107;
            font-weight: 600;
        }
        
        .post-content blockquote {
            border-left: 4px solid #ffc107;
            padding-left: 20px;
            margin: 20px 0;
            color: #ccc;
            font-style: italic;
        }
        
        .post-content table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        
        .post-content table td, .post-content table th {
            border: 1px solid rgba(255,255,255,0.2);
            padding: 10px;
            color: #e0e0e0;
        }
        
        .post-content table th {
            background: rgba(255,193,7,0.2);
            color: #ffc107;
        }
        
        .no-post-message {
            text-align: center;
            padding: 80px 40px;
            background: rgba(255,193,7,0.1);
            border: 2px solid #ffc107;
            border-radius: 15px;
            margin-top: 40px;
        }
        
        .no-post-message i {
            font-size: 72px;
            color: #ffc107;
            margin-bottom: 25px;
        }
        
        .no-post-message h2 {
            color: #ffc107;
            margin-bottom: 15px;
            font-size: 28px;
        }
        
        .no-post-message p {
            color: #ccc;
            font-size: 18px;
            line-height: 1.6;
        }
        
        .back-button {
            display: inline-block;
            margin-top: 30px;
            padding: 14px 35px;
            background: #ffc107;
            color: #111;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
            font-weight: 600;
            font-size: 16px;
        }
        
        .back-button:hover {
            background: #ffb300;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255,193,7,0.4);
        }
        
        .back-button i {
            margin-right: 8px;
        }
        
        .action-buttons {
            text-align: center;
            margin-top: 50px;
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .action-buttons .back-button {
            margin-top: 0;
        }
        
        .action-buttons .back-button.secondary {
            background: rgba(255,255,255,0.1);
            color: #fff;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .action-buttons .back-button.secondary:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="product-detail-container">
        <c:choose>
            <c:when test="${not empty error}">
                <div class="no-post-message">
                    <i class="fa fa-exclamation-triangle"></i>
                    <h2>Lỗi</h2>
                    <p>${error}</p>
                    <a href="home" class="back-button">
                        <i class="fa fa-arrow-left"></i> Về trang chủ
                    </a>
                </div>
            </c:when>
            <c:when test="${not empty product}">
                <!-- Tên món -->
                <div class="product-header">
                    <h1>${product.name}</h1>
                </div>
                
                <!-- Ảnh món (ưu tiên featuredImage của post, nếu không có thì dùng ảnh product) -->
                <div class="product-image-wrapper">
                    <c:choose>
                        <c:when test="${not empty post && not empty post.featuredImage}">
                            <img src="${post.featuredImage}" alt="${product.name}" class="product-image">
                        </c:when>
                        <c:when test="${not empty product.imageUrl}">
                            <c:choose>
                                <c:when test="${fn:startsWith(product.imageUrl, 'http://') || fn:startsWith(product.imageUrl, 'https://')}">
                                    <img src="${product.imageUrl}" alt="${product.name}" class="product-image">
                                </c:when>
                                <c:when test="${fn:startsWith(product.imageUrl, '/')}">
                                    <img src="${pageContext.request.contextPath}${product.imageUrl}" alt="${product.name}" class="product-image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.name}" class="product-image">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                    </c:choose>
                </div>
                
                <!-- Giá tiền -->
                <div class="price-section">
                    <div class="price-label">Giá</div>
                    <div class="product-price">
                        <fmt:formatNumber value="${product.price}" type="number" minFractionDigits="0"/>
                    </div>
                </div>
                
                <!-- Nội dung -->
                <c:choose>
                    <c:when test="${not empty post}">
                        <!-- Hiển thị bài viết nếu có -->
                        <div class="post-content">
                            ${post.content}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Hiển thị thông báo nếu chưa có bài viết -->
                        <div class="no-post-message">
                            <i class="fa fa-info-circle"></i>
                            <h2>Chi tiết món ăn chưa được cập nhật</h2>
                            <p>Chúng tôi đang cập nhật thông tin chi tiết cho món ăn này. Vui lòng quay lại sau!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="action-buttons">
                    <a href="home" class="back-button">
                        <i class="fa fa-arrow-left"></i> Về trang chủ
                    </a>
                    <a href="menu" class="back-button secondary">
                        <i class="fa fa-utensils"></i> Xem thực đơn
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-post-message">
                    <i class="fa fa-exclamation-triangle"></i>
                    <h2>Không tìm thấy món ăn</h2>
                    <p>Món ăn bạn đang tìm không tồn tại hoặc đã bị xóa.</p>
                    <a href="home" class="back-button">
                        <i class="fa fa-arrow-left"></i> Về trang chủ
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>

