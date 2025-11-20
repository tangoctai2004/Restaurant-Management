
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // Logic này của bạn vẫn đúng, nó sẽ lấy "home" từ URL /home
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <style>
        #toast-container {
            position: fixed;
            bottom: 25px;
            right: 25px;
            z-index: 2000;
            display: flex; /* Thêm dòng này */
            flex-direction: column; /* Thêm dòng này */
            gap: 10px; /* Thêm dòng này */
        }
        .toast-item {
            background-color: #28a745; /* Màu xanh lá */
            color: white;
            padding: 16px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.4s ease;
        }
        .toast-item.show {
            opacity: 1;
            transform: translateX(0);
        }
        
        /* === THÊM CSS CHO TOAST MÀU ĐỎ === */
        .toast-item.error {
            background-color: #dc3545; /* Màu đỏ */
        }
    </style>
</head>
<body>
    <header class="navbar 
        <%= "menu".equals(pageName) ? "gray-bg" : "" %>
        <%= "reservation".equals(pageName) ? "gray-bg" : "" %>
        <%= "payment".equals(pageName) ? "gray-bg" : "" %>
    ">
        <div class="logo">HAH<span>.</span></div>
        <nav>
            <a href="home" class="<%= "home".equals(pageName) ? "active" : "" %>">Trang chủ</a>
            <a href="menu" class="<%= "menu".equals(pageName) ? "active" : "" %>">Thực đơn</a>
            <a href="reservation" class="<%= "reservation".equals(pageName) ? "active" : "" %>">Đặt bàn</a>
            <a href="about" class="<%= "about".equals(pageName) ? "active" : "" %>">Giới thiệu</a>
            <a href="contact" class="<%= "contact".equals(pageName) ? "active" : "" %>">Liên hệ</a>
        </nav>
        <div class="right-menu">
            <c:if test="${sessionScope.account == null}">
                <button class="login" onclick="window.location.href='login'">Đăng nhập</button>
            </c:if>
            
            <c:if test="${sessionScope.account != null}">
                <span class="user-greeting">
                    Chào, ${sessionScope.account.fullName}
                </span>
                <button class="btn-edit-profile" onclick="window.location.href='profile'">
                    <i class="fa fa-user-edit"></i> 
                </button>
                <button class="btn-logout" onclick="window.location.href='logout'">
                    <i class="fa fa-sign-out-alt"></i>
                </button>
            </c:if>
        </div>
    </header>

    <section id="hero" class="hero" 
             <c:if test="${homeSettings['heroBackgroundImage'] != null}">
                 style="background-image: url('${pageContext.request.contextPath}/${homeSettings['heroBackgroundImage']}');"
             </c:if>>
        <div class="overlay"></div>
        <div class="hero-content">
            <h1>${homeSettings['heroTitle'] != null ? homeSettings['heroTitle'] : 'HAH Restaurant'}<span>.</span></h1>
            <p>${homeSettings['heroSubtitle'] != null ? homeSettings['heroSubtitle'] : 'Chúng tôi hân hạnh được phục vụ quý khách'}</p>
            <div class="buttons">
                <a href="menu" class="btn">${homeSettings['menuButtonText'] != null ? homeSettings['menuButtonText'] : 'Thực đơn'}</a>
                <a href="reservation" class="btn">${homeSettings['reservationButtonText'] != null ? homeSettings['reservationButtonText'] : 'Đặt bàn'}</a>
            </div>
        </div>
    </section>

 <section class="menu-section">
    <h2 class="section-title reveal">${homeSettings['menuSectionTitle'] != null ? homeSettings['menuSectionTitle'] : 'THỰC ĐƠN'}</h2>
    <h3 class="section-subtitle reveal">${homeSettings['menuSectionSubtitle'] != null ? homeSettings['menuSectionSubtitle'] : 'BẠN MUỐN ĂN GÌ?'}</h3>

    <c:if test="${not empty categoryList}">
        <div class="menu-categories reveal">
            <c:forEach var="cat" items="${categoryList}" varStatus="loop">
                <button class="menu-btn ${loop.first ? 'active' : ''}" onclick="showCategory('cat-${cat.id}', this)">
                    ${cat.name}
                </button>
            </c:forEach>
        </div>

        <div class="menu-container">
            <c:forEach var="cat" items="${categoryList}" varStatus="loop">
                <div class="menu-category" id="cat-${cat.id}" style="${loop.first ? 'display:flex;' : 'display:none;'}">
                    <c:set var="categoryProducts" value="${productsByCategory[cat.id]}" />
                    <c:if test="${not empty categoryProducts}">
                        <c:forEach var="p" items="${categoryProducts}">
                            <div class="menu-item reveal">
                                <img src="${p.imageUrl}" alt="${p.name}">
                                <h4>${p.name}</h4> 
                                <p><fmt:formatNumber value="${p.price}" type="currency" currencyCode="VND" minFractionDigits="0"/></p>
                                <div class="menu-buttons">
                                    <a href="product-detail?id=${p.id}" class="btn">Xem chi tiết</a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </c:forEach>
        </div>

        <div class="menu-viewall reveal">
            <button class="btn-viewall" onclick="window.location.href='menu'">
                ${homeSettings['viewAllButtonText'] != null ? homeSettings['viewAllButtonText'] : 'Xem tất cả'}
            </button>
        </div>
    </c:if>
</section>

<section class="about-section reveal">
    <div class="about-container">
        <div class="about-image">
            <c:choose>
                <c:when test="${homeSettings['aboutSectionImage'] != null}">
                    <img src="${pageContext.request.contextPath}/${homeSettings['aboutSectionImage']}" alt="Không gian nhà hàng">
                </c:when>
                <c:otherwise>
                    <img src="images/about.jpg" alt="Không gian nhà hàng">
                </c:otherwise>
            </c:choose>
        </div>
        <div class="about-content">
            <h3 class="about-subtitle">${homeSettings['aboutSectionSubtitle'] != null ? homeSettings['aboutSectionSubtitle'] : 'GIỚI THIỆU'}</h3>
            <h2 class="about-title">${homeSettings['aboutSectionTitle'] != null ? homeSettings['aboutSectionTitle'] : 'LỰA CHỌN CHÚNG TÔI?'}</h2>
            
            <c:if test="${not empty aboutFeatures}">
                <c:set var="processedFeatureIds" value="" />
                <c:forEach var="setting" items="${aboutFeatures}">
                    <c:if test="${fn:endsWith(setting.key, '_title')}">
                        <c:set var="fullFeatureId" value="${setting.key}" />
                        <c:set var="featureId" value="${fn:substringBefore(fullFeatureId, '_title')}" />
                        <c:set var="featureDeletedKey" value="${featureId}_deleted" />
                        <c:set var="isDeleted" value="${aboutFeatures[featureDeletedKey] == 'true'}" />
                        
                        <c:if test="${!isDeleted}">
                            <c:set var="featureIdCheck" value="${featureId}," />
                            <c:if test="${!fn:contains(processedFeatureIds, featureIdCheck)}">
                                <c:set var="processedFeatureIds" value="${processedFeatureIds}${featureIdCheck}" />
                                <c:set var="featureTitle" value="${setting.value}" />
                                <c:set var="featureDescKey" value="${featureId}_description" />
                                <c:set var="featureIconKey" value="${featureId}_icon" />
                                <c:set var="featureDesc" value="${aboutFeatures[featureDescKey]}" />
                                <c:set var="featureIcon" value="${aboutFeatures[featureIconKey]}" />
                                
                                <c:if test="${featureTitle != null && !featureTitle.trim().isEmpty()}">
                                    <div class="about-feature">
                                        <i class="<c:out value='${featureIcon != null && !featureIcon.trim().isEmpty() ? featureIcon : "fa fa-star"}' /> icon"></i>
                                        <div class="text">
                                            <h4><c:out value="${featureTitle}" /></h4>
                                            <p><c:out value="${featureDesc != null ? featureDesc : ''}" /></p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:if>
                        </c:if>
                    </c:if>
                </c:forEach>
            </c:if>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />

<div id="toast-container">
        <c:if test="${not empty flashSuccess}">
            <div id="toastNotificationSuccess" class="toast-item">
                <i class="fa-solid fa-circle-check"></i>
                <span>${flashSuccess}</span>
            </div>
        </c:if>
        
        <c:if test="${not empty flashError}">
            <div id="toastNotificationError" class="toast-item error">
                <i class="fa-solid fa-circle-info"></i>
                <span>${flashError}</span>
            </div>
        </c:if>
    </div>

<script>
    // Hàm reveal (Giữ nguyên)
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

    // Hàm showCategory (Giữ nguyên)
    function showCategory(id, btn) {
        const categories = document.querySelectorAll(".menu-category");
        const buttons = document.querySelectorAll(".menu-btn");
        categories.forEach(cat => {
            cat.style.display = "none";
            cat.classList.remove("fadeIn");
        });
        const selectedCategory = document.getElementById(id);
        if (selectedCategory) {
            selectedCategory.style.display = "flex";
            selectedCategory.classList.add("fadeIn");
        }
        buttons.forEach(b => b.classList.remove("active"));
        btn.classList.add("active");
    }
    
    // === SỬA ĐỔI LOGIC KÍCH HOẠT ===
        document.addEventListener("DOMContentLoaded", () => {
            // Kích hoạt tab (code cũ của bạn)
            const firstCategoryLink = document.querySelector(".menu-sidebar li.active a");
            if (firstCategoryLink) {
                 showCategory('all', firstCategoryLink, null);
            }
            
            // Logic hiển thị TẤT CẢ thông báo (cả xanh và đỏ)
            const toasts = document.querySelectorAll(".toast-item");
            toasts.forEach((toast, index) => {
                // 1. Hiển thị (so le 100ms)
                setTimeout(() => {
                    toast.classList.add("show");
                }, 100 * (index + 1)); 

                // 2. Ẩn sau 5 giây
                setTimeout(() => {
                    toast.classList.remove("show");
                    setTimeout(() => { toast.remove(); }, 400); 
                }, 5000 + (100 * index)); 
            });
        });
</script>

</body>
</html>