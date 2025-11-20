<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhận bàn | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body, .admin-content, .booking-info-card, .booking-info-card *, .table-grid .table-item {
            color: #333 !important;
        }
        .assign-table-container {
            padding: 20px;
        }
        
        .booking-info-card {
            background: #fff;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #ffc107;
        }
        
        .booking-info-card h3 {
            margin: 0 0 15px;
            color: #104c23;
            font-size: 20px;
        }
        
        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .detail-label {
            font-size: 12px;
            color: #999;
            text-transform: uppercase;
            font-weight: 600;
        }
        
        .detail-value {
            font-size: 16px;
            color: #333;
            font-weight: 600;
        }
        
        .table-map-container {
            background: #fff;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .table-map-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .table-map-header h2 {
            margin: 0;
            color: #104c23;
            font-size: 24px;
        }
        
        .legend {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        
        .legend-color {
            width: 30px;
            height: 30px;
            border-radius: 8px;
            border: 2px solid #ddd;
        }
        
        .legend-available {
            background: #28a745;
        }
        
        .legend-reserved {
            background: #ffc107;
        }
        
        .legend-occupied {
            background: #dc3545;
        }
        
        .legend-maintenance {
            background: #6c757d;
        }
        
        .table-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .table-item {
            position: relative;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border: 3px solid transparent;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .table-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .table-item.available {
            background: #28a745;
            color: white;
        }
        
        .table-item.reserved {
            background: #ffc107;
            color: #000;
        }
        
        .table-item.occupied {
            background: #dc3545;
            color: white;
            cursor: not-allowed;
        }
        
        .table-item.maintenance {
            background: #6c757d;
            color: white;
            cursor: not-allowed;
        }
        
        .table-item.selected {
            border-color: #007bff;
            border-width: 4px;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
        }
        
        .table-item.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .table-item input[type="checkbox"] {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        
        .table-item.occupied input[type="checkbox"],
        .table-item.maintenance input[type="checkbox"] {
            display: none;
        }
        
        .table-name {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .table-capacity {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .table-location {
            font-size: 12px;
            margin-top: 5px;
            opacity: 0.8;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
        }
        
        .btn-submit {
            background: #28a745;
            color: white;
        }
        
        .btn-submit:hover {
            background: #218838;
        }
        
        .selected-count {
            margin-top: 15px;
            padding: 15px;
            background: #e7f3ff;
            border-radius: 8px;
            border-left: 4px solid #007bff;
            font-weight: 600;
            color: #004085;
        }
        
        .warning-message {
            margin-top: 15px;
            padding: 15px;
            background: #fff3cd;
            border-radius: 8px;
            border-left: 4px solid #ffc107;
            color: #856404;
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
            <div class="assign-table-container">
                <div class="booking-info-card">
                    <h3><i class="fa fa-calendar-check"></i> Thông tin đặt bàn</h3>
                    <div class="booking-details">
                        <div class="detail-item">
                            <span class="detail-label">Mã đặt bàn</span>
                            <span class="detail-value">#${booking.id}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Khách hàng</span>
                            <span class="detail-value">${booking.customerName}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Số điện thoại</span>
                            <span class="detail-value">${booking.phone}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Ngày đặt</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Giờ đặt</span>
                            <span class="detail-value">
                                <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Số người</span>
                            <span class="detail-value">${booking.numPeople} người</span>
                        </div>
                    </div>
                    <c:if test="${not empty booking.note}">
                        <div style="margin-top: 15px; padding: 10px; background: #f8f9fa; border-radius: 5px;">
                            <strong>Ghi chú:</strong> ${booking.note}
                        </div>
                    </c:if>
                </div>
                
                <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
                
                <form action="assign-table" method="POST" id="assignTableForm">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    
                    <div class="table-map-container">
                        <div class="table-map-header">
                            <h2><i class="fa fa-map"></i> Sơ đồ bàn</h2>
                            <div class="legend">
                                <div class="legend-item">
                                    <div class="legend-color legend-available"></div>
                                    <span>Trống (Available)</span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-color legend-reserved"></div>
                                    <span>Đã đặt (Reserved)</span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-color legend-occupied"></div>
                                    <span>Đang dùng (Occupied)</span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-color legend-maintenance"></div>
                                    <span>Bảo trì (Maintenance)</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="table-grid" id="tableGrid">
                            <c:forEach var="table" items="${allTables}">
                                <c:set var="isSelected" value="false" />
                                <c:forEach var="selectedId" items="${selectedTableIds}">
                                    <c:if test="${table.id == selectedId}">
                                        <c:set var="isSelected" value="true" />
                                    </c:if>
                                </c:forEach>
                                
                                <div class="table-item ${table.status.toLowerCase()} ${isSelected ? 'selected' : ''} 
                                     ${table.status == 'Occupied' || table.status == 'Maintenance' ? 'disabled' : ''}"
                                     onclick="toggleTable(${table.id}, '${table.status}')">
                                    <input type="checkbox" 
                                           name="tableIds" 
                                           value="${table.id}" 
                                           id="table_${table.id}"
                                           ${isSelected ? 'checked' : ''}
                                           ${table.status == 'Occupied' || table.status == 'Maintenance' ? 'disabled' : ''}
                                           onchange="updateSelectedCount()">
                                    <div class="table-name">${table.name}</div>
                                    <div class="table-capacity">
                                        <i class="fa fa-users"></i> ${table.capacity} người
                                    </div>
                                    <c:if test="${not empty table.locationArea}">
                                        <div class="table-location">
                                            <i class="fa fa-map-marker-alt"></i> ${table.locationArea}
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="selected-count" id="selectedCount" style="display: none;">
                            <i class="fa fa-check-circle"></i> Đã chọn bàn: <span id="selectedTableName" style="font-weight: 700;"></span>
                        </div>
                        
                        <div class="warning-message">
                            <i class="fa fa-info-circle"></i> 
                            Chỉ có thể chọn <strong>1 bàn duy nhất</strong> và chỉ các bàn trống (màu xanh lá). Bàn đang dùng (màu đỏ) và bàn bảo trì (màu xám) không thể chọn.
                        </div>
                        
                        <div class="form-actions">
                            <a href="bookings" class="btn btn-cancel">
                                <i class="fa fa-times"></i> Hủy
                            </a>
                            <button type="submit" class="btn btn-submit">
                                <i class="fa fa-check"></i> Xác nhận nhận bàn
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function toggleTable(tableId, status) {
            if (status === 'Occupied' || status === 'Maintenance') {
                return; // Không cho phép chọn bàn đang dùng hoặc bảo trì
            }
            
            const checkbox = document.getElementById('table_' + tableId);
            const tableItem = checkbox.closest('.table-item');
            
            // Nếu đang bỏ chọn bàn này
            if (checkbox.checked) {
                checkbox.checked = false;
                tableItem.classList.remove('selected');
            } else {
                // Bỏ chọn tất cả các bàn khác trước
                const allCheckboxes = document.querySelectorAll('input[name="tableIds"]:not([disabled])');
                const allTableItems = document.querySelectorAll('.table-item:not(.disabled)');
                
                allCheckboxes.forEach(cb => {
                    cb.checked = false;
                });
                allTableItems.forEach(item => {
                    item.classList.remove('selected');
                });
                
                // Chọn bàn này
                checkbox.checked = true;
                tableItem.classList.add('selected');
            }
            
            updateSelectedCount();
        }
        
        function updateSelectedCount() {
            const checkboxes = document.querySelectorAll('input[name="tableIds"]:checked:not([disabled])');
            const selectedCountDiv = document.getElementById('selectedCount');
            const selectedTableNameSpan = document.getElementById('selectedTableName');
            
            if (checkboxes.length > 0) {
                // Lấy tên bàn đã chọn
                const selectedCheckbox = checkboxes[0];
                const tableItem = selectedCheckbox.closest('.table-item');
                const tableName = tableItem.querySelector('.table-name').textContent;
                selectedTableNameSpan.textContent = tableName;
                selectedCountDiv.style.display = 'block';
            } else {
                selectedCountDiv.style.display = 'none';
            }
        }
        
        // Xử lý khi click trực tiếp vào checkbox (không qua toggleTable)
        document.addEventListener('DOMContentLoaded', function() {
            updateSelectedCount();
            
            // Thêm event listener cho tất cả checkbox
            const allCheckboxes = document.querySelectorAll('input[name="tableIds"]:not([disabled])');
            allCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function(e) {
                    // Ngăn event bubble để không gọi toggleTable 2 lần
                    e.stopPropagation();
                    
                    if (this.checked) {
                        // Bỏ chọn tất cả các bàn khác
                        allCheckboxes.forEach(cb => {
                            if (cb !== this) {
                                cb.checked = false;
                                const item = cb.closest('.table-item');
                                if (item) {
                                    item.classList.remove('selected');
                                }
                            }
                        });
                        
                        // Đánh dấu bàn này là selected
                        const tableItem = this.closest('.table-item');
                        if (tableItem) {
                            tableItem.classList.add('selected');
                        }
                    } else {
                        // Bỏ chọn bàn này
                        const tableItem = this.closest('.table-item');
                        if (tableItem) {
                            tableItem.classList.remove('selected');
                        }
                    }
                    
                    updateSelectedCount();
                });
            });
        });
        
        // Xử lý submit form
        document.getElementById('assignTableForm').addEventListener('submit', function(e) {
            const checkboxes = document.querySelectorAll('input[name="tableIds"]:checked:not([disabled])');
            if (checkboxes.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn một bàn!');
                return false;
            }
            if (checkboxes.length > 1) {
                e.preventDefault();
                alert('Chỉ được chọn 1 bàn duy nhất!');
                return false;
            }
        });
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

