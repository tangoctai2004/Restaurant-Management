<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            color: #333 !important;
        }
        .dashboard-card, .data-table td, .data-table th {
            color: #333 !important;
        }
    </style>
</head>
<body>
    <style>
        .history-subtabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .history-subtab {
            padding: 12px 25px;
            background: transparent;
            border: none;
            border-bottom: 3px solid transparent;
            font-size: 16px;
            font-weight: 600;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .history-subtab:hover {
            color: #104c23;
            background: #f8f9fa;
        }
        
        .history-subtab.active {
            color: #104c23;
            border-bottom-color: #ffc107;
        }
    </style>
    
    <div class="page-description" style="margin-bottom: 20px; padding: 15px; background: #d4edda; border-radius: 8px; border-left: 4px solid #28a745;">
        <p style="margin: 0; color: #155724;">
            <i class="fa fa-info-circle"></i> 
            <strong>Lịch sử hóa đơn:</strong> Hiển thị tất cả các hóa đơn khách đã ăn xong và thanh toán hoàn tất.
        </p>
    </div>
    
    <div class="history-subtabs">
        <a href="orders?tab=history&amp;subTab=deposit" class="history-subtab ${orderType == 'deposit' || param.subTab == 'deposit' ? 'active' : ''}" data-subtab="deposit">
            <i class="fa fa-money-bill-wave"></i> Hóa đơn cọc bàn
        </a>
        <a href="orders?tab=history&amp;subTab=refund" class="history-subtab ${orderType == 'refund' || param.subTab == 'refund' ? 'active' : ''}" data-subtab="refund">
            <i class="fa fa-undo"></i> Hóa đơn hoàn tiền
        </a>
        <a href="orders?tab=history&amp;subTab=table" class="history-subtab ${orderType == 'table' || (orderType == null && param.subTab == null) || param.subTab == 'table' ? 'active' : ''}" data-subtab="table">
            <i class="fa fa-utensils"></i> Hóa đơn tại bàn
        </a>
    </div>
    
    <div class="search-bar" style="margin-bottom: 20px;">
        <input type="text" placeholder="Tìm kiếm theo mã đơn, tên khách..." id="searchInput" value="${searchKeyword != null ? searchKeyword : ''}">
        <button class="btn btn-primary" onclick="searchOrders()">
            <i class="fa fa-search"></i> Tìm kiếm
        </button>
    </div>
    
    <c:if test="${empty completedOrders}">
        <div class="dashboard-card">
            <div style="text-align: center; padding: 40px; color: #999;">
                <i class="fa fa-inbox" style="font-size: 48px; margin-bottom: 15px;"></i>
                <p style="font-size: 18px;">
                    <c:choose>
                        <c:when test="${orderType == 'deposit'}">Chưa có hóa đơn cọc bàn nào</c:when>
                        <c:when test="${orderType == 'refund'}">Chưa có hóa đơn hoàn tiền nào</c:when>
                        <c:when test="${orderType == 'table'}">Chưa có hóa đơn tại bàn nào</c:when>
                        <c:otherwise>Chưa có hóa đơn nào đã hoàn thành</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
    </c:if>
    
    <c:if test="${not empty completedOrders}">
        <div class="dashboard-card">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Phương thức thanh toán</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${completedOrders}">
                        <tr>
                            <td><strong>#${order.id}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.account != null}">
                                        ${order.account.fullName}<br>
                                        <small style="color: #999;">${order.account.phone}</small>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #999; font-style: italic;">Khách vãng lai</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <strong style="color: #28a745; font-size: 16px;">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </strong>
                                <c:if test="${order.note == 'DEPOSIT'}">
                                    <br><small style="color: #17a2b8;">(Tiền cọc)</small>
                                </c:if>
                                <c:if test="${order.note == 'REFUND'}">
                                    <br><small style="color: #dc3545;">(Hoàn tiền)</small>
                                </c:if>
                            </td>
                            <td>
                                <span class="badge" style="background: #17a2b8; color: white;">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'COD'}">Tiền mặt</c:when>
                                        <c:when test="${order.paymentMethod == 'VNPAY'}">VNPay</c:when>
                                        <c:when test="${order.paymentMethod == 'Bank Transfer'}">Chuyển khoản</c:when>
                                        <c:otherwise>${order.paymentMethod}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <a href="orders?action=view&id=${order.id}" class="btn btn-sm btn-primary">
                                    <i class="fa fa-eye"></i> Chi tiết
                                </a>
                                <button class="btn btn-sm btn-success" onclick="printInvoice(${order.id}, ${order.booking != null ? order.booking.id : 0})">
                                    <i class="fa fa-print"></i> In hóa đơn
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
    
    <script>
        // Cập nhật các link subtab để giữ search keyword
        document.addEventListener('DOMContentLoaded', function() {
            const searchKeyword = '${searchKeyword != null ? searchKeyword : ""}';
            if (searchKeyword) {
                const subtabs = document.querySelectorAll('.history-subtab');
                subtabs.forEach(function(tab) {
                    const href = tab.getAttribute('href');
                    if (href && !href.includes('search=')) {
                        tab.setAttribute('href', href + '&search=' + encodeURIComponent(searchKeyword));
                    }
                });
            }
        });
        
        function searchOrders() {
            const search = document.getElementById('searchInput').value;
            // Lấy subTab từ URL hoặc từ các tab đang active
            let subTab = new URLSearchParams(window.location.search).get('subTab');
            if (!subTab) {
                // Nếu không có subTab trong URL, xác định từ tab đang active
                const activeTab = document.querySelector('.history-subtab.active');
                if (activeTab) {
                    subTab = activeTab.getAttribute('data-subtab');
                }
                // Mặc định là 'table' nếu không tìm thấy
                if (!subTab) {
                    subTab = 'table';
                }
            }
            
            let url = 'orders?tab=history';
            if (subTab) {
                url += '&subTab=' + subTab;
            }
            if (search) {
                url += '&search=' + encodeURIComponent(search);
            }
            window.location.href = url;
        }
        
        // Tìm kiếm khi nhấn Enter
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchOrders();
                }
            });
        }
        
        function printInvoice(orderId, bookingId) {
            // Luôn dùng orderId để in, vì PrintInvoiceServlet sẽ tự động load booking từ order
                window.open('print-invoice?orderId=' + orderId, '_blank');
        }
    </script>
</body>
</html>

