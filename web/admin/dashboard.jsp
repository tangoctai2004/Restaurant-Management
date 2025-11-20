<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        body, .admin-content, .dashboard-card, .data-table td, .data-table th, .stat-info, .stat-info h3, .stat-info p {
            color: #333 !important;
        }
        .data-table td strong {
            color: #222 !important;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h1><i class="fa fa-chart-line"></i> Dashboard</h1>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <select id="monthFilter" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;">
                        <option value="1" ${selectedMonth == 1 ? 'selected' : ''}>Tháng 1</option>
                        <option value="2" ${selectedMonth == 2 ? 'selected' : ''}>Tháng 2</option>
                        <option value="3" ${selectedMonth == 3 ? 'selected' : ''}>Tháng 3</option>
                        <option value="4" ${selectedMonth == 4 ? 'selected' : ''}>Tháng 4</option>
                        <option value="5" ${selectedMonth == 5 ? 'selected' : ''}>Tháng 5</option>
                        <option value="6" ${selectedMonth == 6 ? 'selected' : ''}>Tháng 6</option>
                        <option value="7" ${selectedMonth == 7 ? 'selected' : ''}>Tháng 7</option>
                        <option value="8" ${selectedMonth == 8 ? 'selected' : ''}>Tháng 8</option>
                        <option value="9" ${selectedMonth == 9 ? 'selected' : ''}>Tháng 9</option>
                        <option value="10" ${selectedMonth == 10 ? 'selected' : ''}>Tháng 10</option>
                        <option value="11" ${selectedMonth == 11 ? 'selected' : ''}>Tháng 11</option>
                        <option value="12" ${selectedMonth == 12 ? 'selected' : ''}>Tháng 12</option>
                    </select>
                    <select id="yearFilter" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;">
                        <c:forEach var="year" items="${availableYears}">
                            <option value="${year}" ${selectedYear == year ? 'selected' : ''}>${year}</option>
                        </c:forEach>
                    </select>
                    <button onclick="applyFilter()" style="padding: 8px 20px; background: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: 600;">
                        <i class="fa fa-filter"></i> Lọc
                    </button>
                </div>
            </div>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon" style="background: #ffc107;">
                        <i class="fa fa-shopping-cart"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${totalOrders}</h3>
                        <p>Tổng đơn hàng</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background: #28a745;">
                        <i class="fa fa-money-bill-wave"></i>
                    </div>
                    <div class="stat-info">
                        <h3><fmt:formatNumber value="${totalRevenue}" type="currency" currencyCode="VND" minFractionDigits="0"/></h3>
                        <p>Doanh thu</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background: #17a2b8;">
                        <i class="fa fa-chart-line"></i>
                    </div>
                    <div class="stat-info">
                        <h3><fmt:formatNumber value="${profit}" type="currency" currencyCode="VND" minFractionDigits="0"/></h3>
                        <p>Lợi nhuận</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background: #ff9800;">
                        <i class="fa fa-calendar-check"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${totalBookings}</h3>
                        <p>Đặt bàn</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background: #dc3545;">
                        <i class="fa fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${totalCustomers}</h3>
                        <p>Khách hàng (tháng ${selectedMonth}/${selectedYear})</p>
                    </div>
                </div>
            </div>
            
            <div class="dashboard-grid">
                <div class="dashboard-card" style="grid-column: 1 / -1;">
                    <h3><i class="fa fa-chart-bar"></i> Biểu đồ Doanh thu & Lợi nhuận (Năm ${selectedYear})</h3>
                    <canvas id="revenueChart" style="max-height: 400px;"></canvas>
                </div>
                
                <div class="dashboard-card">
                    <h3><i class="fa fa-list"></i> Đơn hàng gần đây</h3>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Khách hàng</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.account != null && not empty order.account.fullName}">
                                                ${order.account.fullName}
                                            </c:when>
                                            <c:when test="${order.booking != null && not empty order.booking.customerName}">
                                                ${order.booking.customerName} <span style="color: #999; font-size: 12px;">(khách vãng lai)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #999; font-style: italic;">Khách vãng lai</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="VND" minFractionDigits="0"/></td>
                                    <td><span class="badge status-${order.orderStatus.toLowerCase()}">${order.orderStatus}</span></td>
                                    <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <div class="dashboard-card">
                    <h3><i class="fa fa-calendar"></i> Đặt bàn gần đây</h3>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Khách hàng</th>
                                <th>SĐT</th>
                                <th>Ngày giờ</th>
                                <th>Số người</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${recentBookings}">
                                <tr>
                                    <td>${booking.customerName}</td>
                                    <td>${booking.phone}</td>
                                    <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/> <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/></td>
                                    <td>${booking.numPeople}</td>
                                    <td><span class="badge status-${booking.status.toLowerCase()}">${booking.status}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function applyFilter() {
            const month = document.getElementById('monthFilter').value;
            const year = document.getElementById('yearFilter').value;
            window.location.href = 'dashboard?month=' + month + '&year=' + year;
        }
        
        // Khởi tạo biểu đồ
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const revenueData = [
            <c:forEach var="revenue" items="${revenueData}" varStatus="loop">
            ${revenue}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const profitData = [
            <c:forEach var="profit" items="${profitData}" varStatus="loop">
            ${profit}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const monthLabels = [
            <c:forEach var="label" items="${monthLabels}" varStatus="loop">
            '${label}'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: monthLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: revenueData,
                    borderColor: 'rgb(40, 167, 69)',
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Lợi nhuận',
                    data: profitData,
                    borderColor: 'rgb(23, 162, 184)',
                    backgroundColor: 'rgba(23, 162, 184, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                label += new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND',
                                    minimumFractionDigits: 0
                                }).format(context.parsed.y);
                                return label;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND',
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 0
                                }).format(value);
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>

