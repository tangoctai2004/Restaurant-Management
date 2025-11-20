<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết bài viết | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .post-detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .post-header {
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .post-title {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }
        .post-meta {
            display: flex;
            gap: 20px;
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .post-meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .status-badge {
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .status-published {
            background: #d4edda;
            color: #155724;
        }
        .status-draft {
            background: #fff3cd;
            color: #856404;
        }
        .featured-image {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .post-content {
            line-height: 1.8;
            color: #333;
            font-size: 16px;
        }
        .post-content img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
            margin: 20px 0;
        }
        .post-content p {
            margin-bottom: 15px;
        }
        .post-content h1, .post-content h2, .post-content h3 {
            margin-top: 30px;
            margin-bottom: 15px;
            color: #222;
        }
        .post-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e0e0e0;
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
            <div class="post-detail-container">
                <c:if test="${not empty post}">
                    <div class="post-header">
                        <h1 class="post-title">${post.title}</h1>
                        <div class="post-meta">
                            <div class="post-meta-item">
                                <i class="fa fa-utensils"></i>
                                <span><strong>Món ăn:</strong> ${post.productName}</span>
                            </div>
                            <div class="post-meta-item">
                                <i class="fa fa-user"></i>
                                <span><strong>Tác giả:</strong> ${post.authorName}</span>
                            </div>
                            <div class="post-meta-item">
                                <i class="fa fa-eye"></i>
                                <span><strong>Lượt xem:</strong> ${post.viewCount}</span>
                            </div>
                            <div class="post-meta-item">
                                <i class="fa fa-calendar"></i>
                                <span><strong>Ngày tạo:</strong> <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                            </div>
                        </div>
                        <div>
                            <span class="status-badge ${post.status == 'Published' ? 'status-published' : 'status-draft'}">
                                ${post.status == 'Published' ? 'Đã xuất bản' : 'Bản nháp'}
                            </span>
                        </div>
                    </div>
                    
                    <c:if test="${not empty post.featuredImage}">
                        <img src="${post.featuredImage}" alt="${post.title}" class="featured-image">
                    </c:if>
                    
                    <div class="post-content">
                        ${post.content}
                    </div>
                    
                    <div class="post-actions">
                        <button class="btn btn-primary" onclick="editPost(${post.id}, '${post.title}', ${post.productId}, '${post.status}', '${post.featuredImage != null ? post.featuredImage : ''}')">
                            <i class="fa fa-edit"></i> Sửa bài viết
                        </button>
                        <a href="posts" class="btn btn-secondary">
                            <i class="fa fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </c:if>
                <c:if test="${empty post}">
                    <div style="text-align: center; padding: 40px;">
                        <i class="fa fa-exclamation-circle" style="font-size: 48px; color: #999;"></i>
                        <p style="margin-top: 20px; font-size: 18px; color: #666;">Không tìm thấy bài viết!</p>
                        <a href="posts" class="btn btn-primary" style="margin-top: 20px;">
                            <i class="fa fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        function editPost(id, title, productId, status, featuredImage) {
            // Redirect to edit page or open modal
            window.location.href = 'posts?action=edit&id=' + id;
        }
    </script>
</body>
</html>


