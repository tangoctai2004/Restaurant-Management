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
    <title>Liên hệ | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .contact-hero {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), 
                <c:choose>
                    <c:when test="${contactSettings != null && contactSettings['heroBackgroundImage'] != null}">
                        url('${pageContext.request.contextPath}/${contactSettings['heroBackgroundImage']}')
                    </c:when>
                    <c:otherwise>
                        url('${pageContext.request.contextPath}/images/contact-hero.jpg')
                    </c:otherwise>
                </c:choose>
                center/cover;
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding-top: 70px;
            position: relative;
        }
        .contact-hero-content h1 {
            font-size: 56px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 3px;
        }
        .contact-hero-content p {
            font-size: 20px;
            color: #ffc107;
            font-weight: 500;
        }
        
        .contact-main {
            padding: 80px 60px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .contact-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            margin-top: 60px;
        }
        
        .contact-info {
            background: linear-gradient(135deg, rgba(255,193,7,0.1) 0%, rgba(255,193,7,0.05) 100%);
            padding: 50px 40px;
            border-radius: 20px;
            border: 2px solid rgba(255,193,7,0.2);
        }
        .contact-info h3 {
            font-size: 32px;
            color: #ffc107;
            margin-bottom: 30px;
            text-transform: uppercase;
        }
        .contact-item {
            display: flex;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 30px;
            padding: 20px;
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        .contact-item:hover {
            background: rgba(255,255,255,0.1);
            transform: translateX(10px);
        }
        .contact-item i {
            font-size: 28px;
            color: #ffc107;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,193,7,0.2);
            border-radius: 50%;
            flex-shrink: 0;
        }
        .contact-item-content h4 {
            font-size: 20px;
            color: #fff;
            margin-bottom: 8px;
        }
        .contact-item-content p {
            font-size: 16px;
            color: #ccc;
            line-height: 1.6;
        }
        
        .contact-form-wrapper {
            background: linear-gradient(135deg, rgba(255,193,7,0.1) 0%, rgba(255,193,7,0.05) 100%);
            padding: 50px 40px;
            border-radius: 20px;
            border: 2px solid rgba(255,193,7,0.2);
        }
        .contact-form-wrapper h3 {
            font-size: 32px;
            color: #ffc107;
            margin-bottom: 30px;
            text-transform: uppercase;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            color: #fff;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 16px;
        }
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid rgba(255,193,7,0.3);
            border-radius: 10px;
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-size: 16px;
            font-family: inherit;
            transition: all 0.3s ease;
        }
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #ffc107;
            background: rgba(255,255,255,0.15);
            box-shadow: 0 0 0 3px rgba(255,193,7,0.2);
        }
        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #999;
        }
        .form-group textarea {
            min-height: 150px;
            resize: vertical;
        }
        .btn-submit {
            background: #ffc107;
            color: #000;
            border: none;
            padding: 15px 40px;
            font-size: 18px;
            font-weight: 600;
            border-radius: 30px;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-submit:hover {
            background: #e6b400;
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(255,193,7,0.4);
        }
        
        .map-section {
            margin-top: 80px;
        }
        .map-container {
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            height: 450px;
            background: #222;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ccc;
        }
        .map-container iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .section-header h2 {
            font-size: 42px;
            color: #fff;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        .section-header p {
            font-size: 18px;
            color: #ccc;
            max-width: 700px;
            margin: 0 auto;
        }
        
        @media (max-width: 968px) {
            .contact-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <!-- Hero Section -->
    <section class="contact-hero reveal">
        <div class="contact-hero-content">
            <h1><c:out value="${contactSettings != null && contactSettings['heroTitle'] != null ? contactSettings['heroTitle'] : 'Liên Hệ Với Chúng Tôi'}" /></h1>
            <p><c:out value="${contactSettings != null && contactSettings['heroSubtitle'] != null ? contactSettings['heroSubtitle'] : 'Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn'}" /></p>
        </div>
    </section>
    
    <!-- Main Content -->
    <div class="contact-main">
        <div class="section-header reveal">
            <h2><c:out value="${contactSettings != null && contactSettings['sectionTitle'] != null ? contactSettings['sectionTitle'] : 'Hãy Để Lại Lời Nhắn'}" /></h2>
            <p><c:out value="${contactSettings != null && contactSettings['sectionDescription'] != null ? contactSettings['sectionDescription'] : 'Mọi thắc mắc, góp ý hoặc yêu cầu của bạn đều được chúng tôi quan tâm và phản hồi sớm nhất'}" /></p>
        </div>
        
        <div class="contact-container">
            <!-- Contact Info -->
            <div class="contact-info reveal">
                <h3>Thông Tin Liên Hệ</h3>
                
                <c:if test="${not empty contactInfoItems}">
                    <c:set var="processedInfoIds" value="" />
                    <c:forEach var="setting" items="${contactInfoItems}">
                        <c:if test="${fn:endsWith(setting.key, '_title')}">
                            <c:set var="fullInfoId" value="${setting.key}" />
                            <c:set var="infoId" value="${fn:substringBefore(fullInfoId, '_title')}" />
                            <c:set var="infoDeletedKey" value="${infoId}_deleted" />
                            <c:set var="isDeleted" value="${contactInfoItems[infoDeletedKey] == 'true'}" />
                            
                            <c:if test="${!isDeleted}">
                                <c:set var="infoIdCheck" value="${infoId}," />
                                <c:if test="${!fn:contains(processedInfoIds, infoIdCheck)}">
                                    <c:set var="processedInfoIds" value="${processedInfoIds}${infoIdCheck}" />
                                    <c:set var="infoTitle" value="${setting.value}" />
                                    <c:set var="infoContentKey" value="${infoId}_content" />
                                    <c:set var="infoIconKey" value="${infoId}_icon" />
                                    <c:set var="infoContent" value="${contactInfoItems[infoContentKey]}" />
                                    <c:set var="infoIcon" value="${contactInfoItems[infoIconKey]}" />
                                    
                                    <c:if test="${infoTitle != null && !infoTitle.trim().isEmpty()}">
                                        <div class="contact-item">
                                            <i class="<c:out value='${infoIcon != null && !infoIcon.trim().isEmpty() ? infoIcon : "fa fa-star"}' />"></i>
                                            <div class="contact-item-content">
                                                <h4><c:out value="${infoTitle}" /></h4>
                                                <p><c:out value="${infoContent != null ? infoContent : ''}" escapeXml="false" /></p>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:if>
                            </c:if>
                        </c:if>
                    </c:forEach>
                </c:if>
            </div>
            
            <!-- Contact Form -->
            <div class="contact-form-wrapper reveal">
                <h3><c:out value="${contactSettings != null && contactSettings['formTitle'] != null ? contactSettings['formTitle'] : 'Gửi Tin Nhắn'}" /></h3>
                <form id="contactForm" method="POST" action="contact">
                    <div class="form-group">
                        <label for="name">Họ và tên *</label>
                        <input type="text" id="name" name="name" placeholder="Nhập họ và tên của bạn" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại của bạn">
                    </div>
                    
                    <div class="form-group">
                        <label for="subject">Chủ đề *</label>
                        <input type="text" id="subject" name="subject" placeholder="Nhập chủ đề tin nhắn" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="message">Nội dung tin nhắn *</label>
                        <textarea id="message" name="message" placeholder="Nhập nội dung tin nhắn của bạn" required></textarea>
                    </div>
                    
                    <button type="submit" class="btn-submit">
                        <i class="fa fa-paper-plane"></i> <c:out value="${contactSettings != null && contactSettings['submitButtonText'] != null ? contactSettings['submitButtonText'] : 'Gửi Tin Nhắn'}" />
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Map Section -->
        <section class="map-section reveal">
            <div class="section-header">
                <h2><c:out value="${contactSettings != null && contactSettings['mapSectionTitle'] != null ? contactSettings['mapSectionTitle'] : 'Vị Trí Của Chúng Tôi'}" /></h2>
                <p><c:out value="${contactSettings != null && contactSettings['mapSectionDescription'] != null ? contactSettings['mapSectionDescription'] : 'Tìm đường đến nhà hàng của chúng tôi'}" /></p>
            </div>
            
            <div class="map-container">
                <c:choose>
                    <c:when test="${contactSettings != null && contactSettings['mapEmbedUrl'] != null && !contactSettings['mapEmbedUrl'].trim().isEmpty()}">
                        <iframe 
                            src="<c:out value='${contactSettings["mapEmbedUrl"]}' escapeXml='false' />" 
                            allowfullscreen="" 
                            loading="lazy" 
                            referrerpolicy="no-referrer-when-downgrade"
                            style="width: 100%; height: 100%; border: none;">
                        </iframe>
                    </c:when>
                    <c:otherwise>
                        <iframe 
                            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3022.184133894008!2d-73.98811768459418!3d40.74844097932681!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c259a9b3117469%3A0xd134e199a405a163!2sEmpire%20State%20Building!5e0!3m2!1sen!2sus!4v1234567890123!5m2!1sen!2sus" 
                            allowfullscreen="" 
                            loading="lazy" 
                            referrerpolicy="no-referrer-when-downgrade"
                            style="width: 100%; height: 100%; border: none;">
                        </iframe>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </div>
    
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
        
        // Form validation
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const subject = document.getElementById('subject').value.trim();
            const message = document.getElementById('message').value.trim();
            
            if (!name || !email || !subject || !message) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ các trường bắt buộc!');
                return false;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Vui lòng nhập email hợp lệ!');
                return false;
            }
        });
    </script>
</body>
</html>

