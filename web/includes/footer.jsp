<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.RestaurantSettingsDAO" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%
    // Load footer settings
    RestaurantSettingsDAO settingsDAO = new RestaurantSettingsDAO();
    Map<String, String> footerSettings = settingsDAO.getSettingsByPage("footer");
    if (footerSettings == null) {
        footerSettings = new HashMap<>();
    }
    request.setAttribute("footerSettings", footerSettings);
%>
<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3 class="footer-logo">
                <c:out value="${footerSettings['logoText'] != null ? footerSettings['logoText'] : 'HAH'}" />
                <span>.</span>
            </h3>
            <p><c:out value="${footerSettings['address'] != null ? footerSettings['address'] : 'A108 Adam Street<br>NY 535022, USA'}" escapeXml="false" /></p>
            <p><strong>Phone:</strong> <c:out value="${footerSettings['phone'] != null ? footerSettings['phone'] : '0865.787.333'}" /></p>
            <p><strong>Email:</strong> <c:out value="${footerSettings['email'] != null ? footerSettings['email'] : 'hah@gmail.com'}" /></p>
            <div class="social-icons">
                <a href="<c:out value='${footerSettings["twitterUrl"] != null ? footerSettings["twitterUrl"] : "#"}' />" target="_blank">
                    <i class="fa-brands fa-twitter"></i>
                </a>
                <a href="<c:out value='${footerSettings["facebookUrl"] != null ? footerSettings["facebookUrl"] : "#"}' />" target="_blank">
                    <i class="fa-brands fa-facebook"></i>
                </a>
                <a href="<c:out value='${footerSettings["instagramUrl"] != null ? footerSettings["instagramUrl"] : "#"}' />" target="_blank">
                    <i class="fa-brands fa-instagram"></i>
                </a>
                <a href="<c:out value='${footerSettings["youtubeUrl"] != null ? footerSettings["youtubeUrl"] : "#"}' />" target="_blank">
                    <i class="fa-brands fa-youtube"></i>
                </a>
                <a href="<c:out value='${footerSettings["linkedinUrl"] != null ? footerSettings["linkedinUrl"] : "#"}' />" target="_blank">
                    <i class="fa-brands fa-linkedin"></i>
                </a>
            </div>
        </div>
        <div class="footer-column">
            <h4>Liên kết</h4>
            <ul>
                <li><a href="home">Trang chủ</a></li>
                <li><a href="menu">Thực đơn</a></li>
                <li><a href="about">Giới thiệu</a></li>
                <li><a href="contact">Liên hệ</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h4>Hỗ trợ</h4>
            <ul>
                <li><a href="#">Điều khoản sử dụng</a></li>
                <li><a href="#">Hướng dẫn đặt bàn</a></li>
                <li><a href="#">Hướng dẫn đăng ký</a></li>
                <li><a href="#">Thẻ thành viên</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h4>Đăng ký nhận tin</h4>
            <p>Đăng ký để luôn cập nhật thông tin mới nhất về chúng tôi</p>
            <div class="subscribe">
                <input type="email" placeholder="Nhập email của bạn...">
                <button>Đăng ký</button>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <p><c:out value="${footerSettings['copyright'] != null ? footerSettings['copyright'] : '© 2025 HAH Restaurant. All Rights Reserved.'}" /></p>
    </div>
</footer>

