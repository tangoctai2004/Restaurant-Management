<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giới thiệu | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: #fff;
        }
        
        .about-hero {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), center/cover;
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding-top: 70px;
            position: relative;
        }
        .about-hero-content h1 {
            font-size: 56px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 3px;
        }
        .about-hero-content p {
            font-size: 20px;
            color: #ffc107;
            font-weight: 500;
        }
        
        /* Story Section - Nền trắng */
        .story-section {
            background: #fff;
            color: #333;
            padding: 100px 80px;
            text-align: center;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }
        .section-header h2 {
            font-size: 42px;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        .section-header p {
            font-size: 18px;
            max-width: 700px;
            margin: 0 auto;
        }
        
        /* Story section - màu chữ cho nền trắng */
        .story-section .section-header h2 {
            color: #1a1a1a;
        }
        .story-section .section-header p {
            color: #666;
        }
        
        .about-story {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }
        .about-story-image {
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        .about-story-image img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .about-story-image:hover img {
            transform: scale(1.05);
        }
        .about-story-content h3 {
            font-size: 32px;
            color: #ffc107;
            margin-bottom: 20px;
            text-transform: uppercase;
        }
        .about-story-content p {
            font-size: 16px;
            line-height: 1.8;
            margin-bottom: 15px;
        }
        /* Story content - màu chữ cho nền trắng */
        .story-section .about-story-content p {
            color: #555;
        }
        
        /* Values Section - Nền đen */
        .values-section {
            background: #111;
            color: #fff;
            padding: 100px 80px;
            text-align: center;
        }
        .values-section .section-header h2 {
            color: #fff;
        }
        .values-section .section-header p {
            color: #ccc;
        }
        
        .values-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 40px;
            margin-top: 60px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }
        .value-card {
            background: rgba(255,255,255,0.05);
            padding: 40px 30px;
            border-radius: 15px;
            text-align: center;
            border: 2px solid rgba(255,193,7,0.3);
            transition: all 0.3s ease;
        }
        .value-card:hover {
            transform: translateY(-10px);
            border-color: #ffc107;
            box-shadow: 0 10px 30px rgba(255,193,7,0.3);
            background: rgba(255,255,255,0.08);
        }
        .value-card i {
            font-size: 48px;
            color: #ffc107;
            margin-bottom: 20px;
        }
        .value-card h4 {
            font-size: 22px;
            color: #fff;
            margin-bottom: 15px;
            text-transform: uppercase;
        }
        .value-card p {
            font-size: 15px;
            color: #ccc;
            line-height: 1.6;
        }
        
        /* Gallery Section - Nền trắng */
        .gallery-section {
            background: #fff;
            color: #333;
            padding: 100px 80px;
            text-align: center;
        }
        .gallery-section .section-header h2 {
            color: #1a1a1a;
        }
        .gallery-section .section-header p {
            color: #666;
        }
        
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-top: 40px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }
        .gallery-item {
            border-radius: 15px;
            overflow: hidden;
            height: 250px;
            position: relative;
            cursor: pointer;
            transition: transform 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .gallery-item:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        @media (max-width: 968px) {
            .story-section,
            .values-section,
            .gallery-section {
                padding: 60px 40px;
            }
            .about-story {
                grid-template-columns: 1fr;
            }
            .values-grid {
                grid-template-columns: 1fr;
            }
            .gallery-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <!-- Hero Section -->
    <section class="about-hero reveal" 
             style="background-image: url('${pageContext.request.contextPath}/${aboutSettings != null && aboutSettings['heroBackgroundImage'] != null ? aboutSettings['heroBackgroundImage'] : 'images/about-hero.jpg'}');">
        <div class="about-hero-content">
            <h1><c:out value="${aboutSettings != null && aboutSettings['heroTitle'] != null ? aboutSettings['heroTitle'] : 'Về Chúng Tôi'}" /></h1>
            <p><c:out value="${aboutSettings != null && aboutSettings['heroSubtitle'] != null ? aboutSettings['heroSubtitle'] : 'Hành trình ẩm thực đầy đam mê'}" /></p>
        </div>
    </section>
    
    <!-- Story Section - Nền trắng -->
    <section class="story-section reveal">
        <div class="section-header">
            <h2><c:out value="${aboutSettings != null && aboutSettings['storySectionTitle'] != null ? aboutSettings['storySectionTitle'] : 'Câu Chuyện Của Chúng Tôi'}" /></h2>
            <p><c:out value="${aboutSettings != null && aboutSettings['storySectionDescription'] != null ? aboutSettings['storySectionDescription'] : 'HAH Restaurant được thành lập với tình yêu và đam mê dành cho ẩm thực, mang đến những trải nghiệm ẩm thực tuyệt vời nhất cho thực khách.'}" /></p>
        </div>
        
        <div class="about-story">
            <div class="about-story-image reveal">
                <img src="${pageContext.request.contextPath}/${aboutSettings != null && aboutSettings['storyImage'] != null ? aboutSettings['storyImage'] : 'images/restaurant-interior.jpg'}" alt="Không gian nhà hàng">
            </div>
            <div class="about-story-content reveal">
                <h3><c:out value="${aboutSettings != null && aboutSettings['storyContentTitle'] != null ? aboutSettings['storyContentTitle'] : 'Khởi Đầu Từ Đam Mê'}" /></h3>
                <c:if test="${aboutSettings != null && aboutSettings['storyContentParagraph1'] != null && !aboutSettings['storyContentParagraph1'].trim().isEmpty()}">
                    <p><c:out value="${aboutSettings['storyContentParagraph1']}" /></p>
                </c:if>
                <c:if test="${aboutSettings != null && aboutSettings['storyContentParagraph2'] != null && !aboutSettings['storyContentParagraph2'].trim().isEmpty()}">
                    <p><c:out value="${aboutSettings['storyContentParagraph2']}" /></p>
                </c:if>
                <c:if test="${aboutSettings != null && aboutSettings['storyContentParagraph3'] != null && !aboutSettings['storyContentParagraph3'].trim().isEmpty()}">
                    <p><c:out value="${aboutSettings['storyContentParagraph3']}" /></p>
                </c:if>
            </div>
        </div>
    </section>
    
    <!-- Values Section - Nền đen -->
    <section class="values-section reveal">
        <div class="section-header">
            <h2><c:out value="${aboutSettings != null && aboutSettings['valuesSectionTitle'] != null ? aboutSettings['valuesSectionTitle'] : 'Giá Trị Cốt Lõi'}" /></h2>
            <p><c:out value="${aboutSettings != null && aboutSettings['valuesSectionDescription'] != null ? aboutSettings['valuesSectionDescription'] : 'Những điều chúng tôi luôn hướng tới và cam kết thực hiện'}" /></p>
        </div>
        
        <div class="values-grid">
            <c:if test="${not empty values}">
                <c:set var="processedValueIds" value="" />
                <c:forEach var="setting" items="${values}">
                    <c:if test="${fn:endsWith(setting.key, '_title') && values[fn:substringBefore(setting.key, '_title') += '_deleted'] != 'true'}">
                        <c:set var="fullValueId" value="${setting.key}" />
                        <c:set var="valueId" value="${fn:substringBefore(fullValueId, '_title')}" />
                        <c:set var="valueIdCheck" value="${valueId}," />
                        <c:if test="${!fn:contains(processedValueIds, valueIdCheck)}">
                            <c:set var="processedValueIds" value="${processedValueIds}${valueIdCheck}" />
                            <c:set var="valueTitle" value="${setting.value}" />
                            <c:set var="valueDescKey" value="${valueId}_description" />
                            <c:set var="valueIconKey" value="${valueId}_icon" />
                            <c:set var="valueDesc" value="${values[valueDescKey]}" />
                            <c:set var="valueIcon" value="${values[valueIconKey]}" />
                            
                            <c:if test="${valueTitle != null && !valueTitle.trim().isEmpty()}">
                                <div class="value-card reveal">
                                    <i class="<c:out value='${valueIcon != null && !valueIcon.trim().isEmpty() ? valueIcon : "fa fa-star"}' />"></i>
                                    <h4><c:out value="${valueTitle}" /></h4>
                                    <p><c:out value="${valueDesc != null ? valueDesc : ''}" /></p>
                                </div>
                            </c:if>
                        </c:if>
                    </c:if>
                </c:forEach>
            </c:if>
        </div>
    </section>
    
    <!-- Gallery Section - Nền trắng -->
    <section class="gallery-section reveal">
        <div class="section-header">
            <h2><c:out value="${aboutSettings != null && aboutSettings['gallerySectionTitle'] != null ? aboutSettings['gallerySectionTitle'] : 'Không Gian Nhà Hàng'}" /></h2>
            <p><c:out value="${aboutSettings != null && aboutSettings['gallerySectionDescription'] != null ? aboutSettings['gallerySectionDescription'] : 'Những khoảnh khắc đẹp tại HAH Restaurant'}" /></p>
        </div>
        
        <div class="gallery-grid">
            <c:if test="${not empty galleryImages}">
                <c:set var="processedGalleryIds" value="" />
                <c:forEach var="setting" items="${galleryImages}">
                    <c:if test="${fn:endsWith(setting.key, '_image') && galleryImages[fn:substringBefore(setting.key, '_image') += '_deleted'] != 'true'}">
                        <c:set var="fullGalleryId" value="${setting.key}" />
                        <c:set var="galleryId" value="${fn:substringBefore(fullGalleryId, '_image')}" />
                        <c:set var="galleryIdCheck" value="${galleryId}," />
                        <c:if test="${!fn:contains(processedGalleryIds, galleryIdCheck)}">
                            <c:set var="processedGalleryIds" value="${processedGalleryIds}${galleryIdCheck}" />
                            <c:set var="galleryImage" value="${setting.value}" />
                            
                            <c:if test="${galleryImage != null && !galleryImage.trim().isEmpty()}">
                                <div class="gallery-item reveal">
                                    <img src="${pageContext.request.contextPath}/${galleryImage}" alt="Không gian nhà hàng">
                                </div>
                            </c:if>
                        </c:if>
                    </c:if>
                </c:forEach>
            </c:if>
        </div>
    </section>
    
    <jsp:include page="includes/footer.jsp" />
    
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

