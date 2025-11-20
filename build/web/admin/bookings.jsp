<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đặt bàn | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body, .admin-content, .dashboard-card, .data-table td, .data-table th {
            color: #333 !important;
        }
        .data-table td strong {
            color: #222 !important;
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
            <div class="page-header">
                <h1><i class="fa fa-calendar-check"></i> Quản lý đặt bàn</h1>
            </div>
            
            <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
            
            <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm theo tên, SĐT..." id="searchInput" value="${searchKeyword != null ? searchKeyword : ''}">
                <button class="btn btn-primary" onclick="searchBookings()">
                    <i class="fa fa-search"></i> Tìm kiếm
                </button>
            </div>
            
            <div class="dashboard-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Khách hàng</th>
                            <th>SĐT</th>
                            <th>Ngày giờ</th>
                            <th>Số người</th>
                            <th>Bàn</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td>${booking.id}</td>
                                <td>${booking.customerName}</td>
                                <td>${booking.phone}</td>
                                <td>
                                    <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/><br>
                                    <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/>
                                </td>
                                <td>${booking.numPeople}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty booking.tables}">
                                            <c:forEach var="table" items="${booking.tables}">
                                                ${table.name}<br>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999; font-style: italic;">Chưa có bàn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge status-${booking.status.toLowerCase()}">
                                        <c:choose>
                                            <c:when test="${booking.status == 'Pending'}">Chờ xác nhận</c:when>
                                            <c:when test="${booking.status == 'Confirmed' && not empty booking.order}">
                                                <span style="color: #28a745; font-weight: 600;">Khách đã nhận bàn</span>
                                            </c:when>
                                            <c:when test="${booking.status == 'Confirmed'}">Đã xác nhận</c:when>
                                            <c:when test="${booking.status == 'Canceled'}">Đã hủy</c:when>
                                            <c:when test="${booking.status == 'Completed'}">Hoàn thành</c:when>
                                            <c:when test="${booking.status == 'NoShow'}">Không đến</c:when>
                                            <c:otherwise>${booking.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${booking.status == 'Pending'}">
                                        <a href="assign-table?bookingId=${booking.id}" class="btn btn-sm btn-warning" 
                                           style="background: #ffc107; color: #000; border-color: #ffc107;">
                                            <i class="fa fa-chair"></i> Nhận bàn
                                        </a>
                                    </c:if>
                                    <c:if test="${booking.status == 'Confirmed' && empty booking.order}">
                                        <a href="assign-table?bookingId=${booking.id}" class="btn btn-sm btn-info" 
                                           style="background: #17a2b8; color: white; border-color: #17a2b8;">
                                            <i class="fa fa-edit"></i> Sửa bàn
                                        </a>
                                        <a href="bookings?action=activate&id=${booking.id}" class="btn btn-sm btn-success" 
                                           style="background: #28a745; color: white; border-color: #28a745;"
                                           onclick="return confirm('Xác nhận khách đã đến và nhận bàn? Hóa đơn sẽ được kích hoạt.')">
                                            <i class="fa fa-check-circle"></i> Khách nhận bàn
                                        </a>
                                    </c:if>
                                    <c:if test="${booking.status == 'Confirmed' && not empty booking.order}">
                                        <a href="assign-table?bookingId=${booking.id}" class="btn btn-sm btn-info" 
                                           style="background: #17a2b8; color: white; border-color: #17a2b8;">
                                            <i class="fa fa-edit"></i> Sửa bàn
                                        </a>
                                        <span class="btn btn-sm" style="background: #6c757d; color: white; border-color: #6c757d; cursor: default;">
                                            <i class="fa fa-check-circle"></i> Đã nhận bàn
                                        </span>
                                    </c:if>
                                    <c:if test="${booking.status != 'Canceled' && booking.status != 'Completed'}">
                                        <a href="bookings?action=cancel&id=${booking.id}" class="btn btn-sm btn-danger"
                                           onclick="return confirm('Bạn có chắc muốn hủy đặt bàn này?')">
                                            <i class="fa fa-times"></i> Hủy
                                        </a>
                                    </c:if>
                                    <c:if test="${booking.status == 'Canceled' && booking.note != null && booking.note.contains('CAN_REFUND')}">
                                        <a href="bookings?action=refund&id=${booking.id}" class="btn btn-sm" 
                                           style="background: #ff9800; color: white; border-color: #ff9800;"
                                           onclick="return confirm('Xác nhận hoàn tiền cọc 100,000 VNĐ cho khách hàng?')">
                                            <i class="fa fa-money-bill-wave"></i> Hoàn tiền
                                        </a>
                                    </c:if>
                                    <button class="btn btn-sm btn-primary" onclick="viewBooking(${booking.id})">
                                        <i class="fa fa-eye"></i> Chi tiết
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        function searchBookings() {
            const search = document.getElementById('searchInput').value;
            window.location.href = 'bookings?search=' + encodeURIComponent(search);
        }
        
        // Tìm kiếm khi nhấn Enter
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchBookings();
                }
            });
        }
        
        function viewBooking(id) {
            window.location.href = 'bookings?action=view&id=' + id;
        }
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

