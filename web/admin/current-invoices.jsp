<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Chỉ override body để tránh màu trắng từ style.css, không override các màu cụ thể */
        body {
            color: #333 !important;
        }
        .tables-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .table-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: all 0.3s;
            position: relative;
        }
        
        .table-card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            transform: translateY(-2px);
        }
        
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .table-location {
            color: #666;
            font-size: 14px;
            font-weight: 500;
        }
        
        .table-capacity {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #666;
            font-size: 14px;
        }
        
        .table-number {
            text-align: center;
            font-size: 48px;
            font-weight: 700;
            color: #104c23;
            margin: 20px 0;
            line-height: 1;
        }
        
        .table-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px 0;
            border-top: 1px solid #f0f0f0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .timer-section {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #666;
            font-size: 14px;
        }
        
        .timer-value {
            font-weight: 600;
            color: #104c23;
            font-family: 'Courier New', monospace;
        }
        
        .amount-section {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: #28a745;
            font-size: 16px;
        }
        
        .table-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-payment {
            flex: 1;
            padding: 10px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-payment:hover {
            background: #218838;
        }
        
        .btn-more {
            width: 40px;
            padding: 10px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            position: relative;
        }
        
        .btn-more:hover {
            background: #5a6268;
        }
        
        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            min-width: 200px;
            z-index: 1000;
            display: none;
            margin-top: 5px;
        }
        
        .dropdown-menu.show {
            display: block;
        }
        
        .dropdown-item {
            padding: 12px 20px;
            cursor: pointer;
            transition: all 0.2s;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .dropdown-item:last-child {
            border-bottom: none;
        }
        
        .dropdown-item:hover {
            background: #f8f9fa;
        }
        
        .dropdown-item i {
            margin-right: 10px;
            width: 20px;
        }
        
        .payment-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }
        
        .payment-modal.show {
            display: flex;
        }
        
        .payment-modal-content {
            background: white;
            border-radius: 12px;
            padding: 30px;
            max-width: 400px;
            width: 90%;
        }
        
        .payment-options {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        
        .payment-option {
            flex: 1;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            transition: all 0.3s;
        }
        
        .payment-option:hover {
            border-color: #28a745;
            background: #f8fff9;
        }
        
        .payment-option.selected {
            border-color: #28a745;
            background: #e7f3ff;
        }
    </style>
</head>
<body>
    <div class="page-description" style="margin-bottom: 20px; padding: 15px; background: #e7f3ff; border-radius: 8px; border-left: 4px solid #007bff;">
        <p style="margin: 0; color: #004085;">
            <i class="fa fa-info-circle"></i> 
            <strong>Hóa đơn hiện tại:</strong> Hiển thị các bàn đã được đặt và các bàn đang có khách ăn.
        </p>
    </div>
    
    <c:if test="${empty activeBookings}">
        <div class="dashboard-card">
            <div style="text-align: center; padding: 40px; color: #999;">
                <i class="fa fa-inbox" style="font-size: 48px; margin-bottom: 15px;"></i>
                <p style="font-size: 18px;">Hiện tại không có bàn nào đang được sử dụng</p>
            </div>
        </div>
    </c:if>
    
    <c:if test="${not empty activeBookings}">
        <div class="tables-grid">
            <c:forEach var="booking" items="${activeBookings}">
                <c:choose>
                    <c:when test="${not empty booking.tables}">
                        <c:forEach var="table" items="${booking.tables}">
                            <div class="table-card" data-table-id="${table.id}" data-booking-id="${booking.id}" data-table-name="${table.name}">
                                <div class="table-header">
                                    <span class="table-location">${not empty table.locationArea ? table.locationArea : 'Sảnh chính'}</span>
                                    <span class="table-capacity">
                                        <i class="fa fa-users"></i> ${table.capacity}
                                    </span>
                                </div>
                                
                                <div class="table-number" style="cursor: pointer;" onclick="viewOrderDetails(${booking.id}, ${table.id})" title="Click để xem chi tiết hóa đơn">${table.name}</div>
                        
                        <div class="table-info">
                            <div class="timer-section">
                                <i class="fa fa-clock"></i>
                                <span class="timer-value" data-start-time="<c:if test="${not empty booking.order && booking.order.createdAt != null}">${booking.order.createdAt.time}</c:if>">00:00:00</span>
                            </div>
                            <div class="amount-section">
                                <i class="fa fa-money-bill-wave"></i>
                                <span data-total-amount="<c:choose><c:when test="${not empty booking.order}">${booking.order.totalAmount}</c:when><c:otherwise>0</c:otherwise></c:choose>">
                                    <c:choose>
                                        <c:when test="${not empty booking.order}">
                                            <fmt:formatNumber value="${booking.order.totalAmount}" type="number" maxFractionDigits="0"/> đ
                                        </c:when>
                                        <c:otherwise>0 đ</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        
                        <div class="table-actions">
                            <button class="btn-payment" onclick="openPaymentModal(${table.id}, ${booking.id}, <c:choose><c:when test="${not empty booking.order}">${booking.order.totalAmount}</c:when><c:otherwise>0</c:otherwise></c:choose>)">
                                <i class="fa fa-credit-card"></i> Thanh toán
                            </button>
                            <div style="position: relative;">
                                <button class="btn-more" onclick="toggleDropdown(${table.id})">
                                    <i class="fa fa-ellipsis-v"></i>
                                </button>
                                <div class="dropdown-menu" id="dropdown-${table.id}">
                                    <div class="dropdown-item" onclick="viewOrderDetails(${booking.id}, ${table.id})">
                                        <i class="fa fa-receipt"></i> Chi tiết hóa đơn
                                    </div>
                                    <div class="dropdown-item" onclick="changeTable(${booking.id}, ${table.id})">
                                        <i class="fa fa-exchange-alt"></i> Đổi bàn
                                    </div>
                                    <div class="dropdown-item" onclick="cancelTable(${booking.id}, ${table.id})" style="color: #dc3545;">
                                        <i class="fa fa-times"></i> Hủy bàn
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Hiển thị booking không có bàn (nếu có) -->
                        <div class="table-card" data-booking-id="${booking.id}" style="border: 2px dashed #ffc107;">
                            <div class="table-header">
                                <span class="table-location">Chưa có bàn</span>
                                <span class="table-capacity">
                                    <i class="fa fa-users"></i> ${booking.numPeople}
                                </span>
                            </div>
                            
                            <div class="table-number" style="color: #ffc107;">Booking #${booking.id}</div>
                            
                            <div class="table-info">
                                <div class="timer-section">
                                    <i class="fa fa-clock"></i>
                                    <span class="timer-value" data-start-time="<c:if test="${not empty booking.order && booking.order.createdAt != null}">${booking.order.createdAt.time}</c:if>">00:00:00</span>
                                </div>
                                <div class="amount-section">
                                    <i class="fa fa-money-bill-wave"></i>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty booking.order}">
                                                <fmt:formatNumber value="${booking.order.totalAmount}" type="number" maxFractionDigits="0"/> đ
                                            </c:when>
                                            <c:otherwise>0 đ</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            
                            <div style="padding: 10px; background: #fff3cd; border-radius: 5px; margin-top: 10px; text-align: center; color: #856404;">
                                <i class="fa fa-exclamation-triangle"></i> Cần gán bàn cho booking này
                            </div>
                            
                            <div class="table-actions">
                                <a href="assign-table?bookingId=${booking.id}" class="btn-payment" style="text-decoration: none; text-align: center; display: block;">
                                    <i class="fa fa-chair"></i> Gán bàn
                                </a>
                                <div style="position: relative;">
                                    <button class="btn-more" onclick="toggleDropdown(${booking.id})">
                                        <i class="fa fa-ellipsis-v"></i>
                                    </button>
                                    <div class="dropdown-menu" id="dropdown-${booking.id}">
                                        <div class="dropdown-item" onclick="viewOrderDetails(${booking.id}, 0)">
                                            <i class="fa fa-receipt"></i> Chi tiết hóa đơn
                                        </div>
                                        <div class="dropdown-item" onclick="cancelTable(${booking.id}, 0)" style="color: #dc3545;">
                                            <i class="fa fa-times"></i> Hủy bàn
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
    </c:if>
    
    <!-- Payment Modal -->
    <!-- Modal thanh toán -->
    <div class="payment-modal" id="paymentModal">
        <div class="payment-modal-content">
            <h3 style="margin: 0 0 20px;">Chọn phương thức thanh toán</h3>
            
            <div id="paymentAmountInfo" style="margin-bottom: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px; text-align: center;">
                <div style="font-size: 14px; color: #666; margin-bottom: 5px;">Tổng tiền cần thanh toán:</div>
                <div id="paymentAmount" style="font-size: 24px; font-weight: 700; color: #28a745;">0 đ</div>
            </div>
            
            <div class="payment-options">
                <div class="payment-option" onclick="selectPaymentMethod('COD')">
                    <i class="fa fa-money-bill-wave" style="font-size: 24px; margin-bottom: 10px;"></i>
                    <div>Tiền mặt</div>
                </div>
                <div class="payment-option" onclick="selectPaymentMethod('VNPAY')">
                    <i class="fa fa-credit-card" style="font-size: 24px; margin-bottom: 10px;"></i>
                    <div>VNPay</div>
                </div>
            </div>
            <div style="margin-top: 20px; display: flex; gap: 10px;">
                <button onclick="closePaymentModal()" style="flex: 1; padding: 10px; background: #6c757d; color: white; border: none; border-radius: 8px; cursor: pointer;">
                    Hủy
                </button>
                <button onclick="processPayment()" style="flex: 1; padding: 10px; background: #28a745; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;">
                    Xác nhận
                </button>
            </div>
        </div>
    </div>
    
    <!-- Modal thanh toán thành công (COD) -->
    <div class="payment-modal" id="paymentSuccessModal">
        <div class="payment-modal-content" style="max-width: 500px;">
            <div style="text-align: center; margin-bottom: 20px;">
                <i class="fa fa-check-circle" style="font-size: 64px; color: #28a745; margin-bottom: 15px;"></i>
                <h3 style="margin: 0 0 10px; color: #28a745;">Thanh toán thành công!</h3>
                <div id="successMessage" style="color: #666; margin-bottom: 20px;"></div>
            </div>
            <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                    <span>Bàn:</span>
                    <strong id="successTableName"></strong>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                    <span>Hóa đơn:</span>
                    <strong id="successOrderId"></strong>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                    <span>Số tiền:</span>
                    <strong id="successAmount" style="color: #28a745; font-size: 18px;"></strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span>Phương thức:</span>
                    <strong id="successMethod"></strong>
                </div>
            </div>
            <div style="display: flex; gap: 10px;">
                <button onclick="printInvoice()" style="flex: 1; padding: 12px; background: #17a2b8; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;">
                    <i class="fa fa-print"></i> In hóa đơn
                </button>
                <button onclick="closeSuccessModal()" style="flex: 1; padding: 12px; background: #28a745; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;">
                    Đóng
                </button>
            </div>
        </div>
    </div>
    
    <script>
        let currentTableId = null;
        let currentBookingId = null;
        let selectedPaymentMethod = null;
        let currentOriginalAmount = 0;
        let currentTableName = '';
        
        // Update timers
        function updateTimers() {
            const now = new Date().getTime();
            
            document.querySelectorAll('.timer-value').forEach(timer => {
                let startTimeStr = timer.getAttribute('data-start-time');
                
                // Nếu không có startTime hoặc rỗng, bắt đầu từ thời điểm hiện tại
                if (!startTimeStr || startTimeStr === 'null' || startTimeStr === '' || startTimeStr.trim() === '') {
                    // Set startTime = thời điểm hiện tại để bắt đầu từ 00:00:00
                    timer.setAttribute('data-start-time', now.toString());
                    timer.textContent = '00:00:00';
                    return;
                }
                
                let startTime = parseInt(startTimeStr);
                
                // Nếu startTime không hợp lệ, set bằng thời điểm hiện tại
                if (isNaN(startTime) || startTime <= 0) {
                    timer.setAttribute('data-start-time', now.toString());
                    timer.textContent = '00:00:00';
                    return;
                }
                
                // Tính elapsed time
                let elapsed = Math.floor((now - startTime) / 1000);
                
                // Nếu elapsed < 0 (startTime trong tương lai), reset về hiện tại
                if (elapsed < 0) {
                    timer.setAttribute('data-start-time', now.toString());
                    timer.textContent = '00:00:00';
                    return;
                }
                
                // Nếu elapsed > 24 giờ, có thể là dữ liệu cũ, nhưng vẫn hiển thị
                // (không reset vì có thể là booking thật sự đã kéo dài)
                
                const hours = Math.floor(elapsed / 3600);
                const minutes = Math.floor((elapsed % 3600) / 60);
                const seconds = elapsed % 60;
                
                timer.textContent = 
                    String(hours).padStart(2, '0') + ':' +
                    String(minutes).padStart(2, '0') + ':' +
                    String(seconds).padStart(2, '0');
            });
        }
        
        // Update timers every second
        setInterval(updateTimers, 1000);
        updateTimers();
        
        // Toggle dropdown
        function toggleDropdown(tableId) {
            const dropdown = document.getElementById('dropdown-' + tableId);
            // Close all other dropdowns
            document.querySelectorAll('.dropdown-menu').forEach(menu => {
                if (menu !== dropdown) {
                    menu.classList.remove('show');
                }
            });
            dropdown.classList.toggle('show');
        }
        
        // Close dropdowns when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.btn-more') && !e.target.closest('.dropdown-menu')) {
                document.querySelectorAll('.dropdown-menu').forEach(menu => {
                    menu.classList.remove('show');
                });
            }
        });
        
        // Open payment modal
        function openPaymentModal(tableId, bookingId, totalAmount) {
            currentTableId = tableId;
            currentBookingId = bookingId;
            selectedPaymentMethod = null;
            
            // Lấy tên bàn từ data attribute của card
            let card = document.querySelector(`[data-table-id="${tableId}"][data-booking-id="${bookingId}"]`);
            console.log('Looking for card with tableId:', tableId, 'bookingId:', bookingId);
            
            if (card) {
                currentTableName = card.getAttribute('data-table-name');
                console.log('Found card, data-table-name:', currentTableName);
                if (!currentTableName || currentTableName === '') {
                    // Nếu không có data attribute, thử lấy từ text
                    const tableNumberElement = card.querySelector('.table-number');
                    if (tableNumberElement) {
                        currentTableName = tableNumberElement.textContent.trim();
                        console.log('Got table name from text:', currentTableName);
                    } else {
                        currentTableName = 'N/A';
                    }
                }
            } else {
                // Fallback: thử tìm bằng bookingId hoặc tableId
                card = document.querySelector(`[data-booking-id="${bookingId}"]`);
                if (!card) {
                    card = document.querySelector(`[data-table-id="${tableId}"]`);
                }
                
                if (card) {
                    currentTableName = card.getAttribute('data-table-name');
                    console.log('Found fallback card, data-table-name:', currentTableName);
                    if (!currentTableName || currentTableName === '') {
                        const tableNumberElement = card.querySelector('.table-number');
                        if (tableNumberElement) {
                            currentTableName = tableNumberElement.textContent.trim();
                            console.log('Got table name from fallback text:', currentTableName);
                        } else {
                            currentTableName = 'N/A';
                        }
                    }
                } else {
                    currentTableName = 'N/A';
                    console.log('Could not find any card');
                }
            }
            
            console.log('Final currentTableName:', currentTableName);
            
            // Lưu vào window để đảm bảo không bị mất
            window.currentTableName = currentTableName;
            
            // Tính số tiền ban đầu (trừ 100k tiền cọc)
            const DEPOSIT_AMOUNT = 100000; // 100k tiền cọc đã đặt
            const total = parseFloat(totalAmount) || 0;
            currentOriginalAmount = Math.max(0, total - DEPOSIT_AMOUNT);
            
            // Hiển thị số tiền
            updatePaymentAmount();
            
            document.getElementById('paymentModal').classList.add('show');
            document.querySelectorAll('.payment-option').forEach(opt => {
                opt.classList.remove('selected');
            });
        }
        
        // Update payment amount display
        function updatePaymentAmount() {
            document.getElementById('paymentAmount').textContent = 
                Math.round(currentOriginalAmount).toLocaleString('vi-VN') + ' đ';
        }
        
        // Close payment modal
        function closePaymentModal() {
            document.getElementById('paymentModal').classList.remove('show');
            currentTableId = null;
            currentBookingId = null;
            selectedPaymentMethod = null;
        }
        
        // Select payment method
        function selectPaymentMethod(method) {
            selectedPaymentMethod = method;
            document.querySelectorAll('.payment-option').forEach(opt => {
                opt.classList.remove('selected');
            });
            event.target.closest('.payment-option').classList.add('selected');
        }
        
        // Process payment
        function processPayment() {
            if (!selectedPaymentMethod) {
                alert('Vui lòng chọn phương thức thanh toán!');
                return;
            }
            
            if (!currentBookingId) {
                alert('Lỗi: Không tìm thấy thông tin đặt bàn!');
                return;
            }
            
            if (selectedPaymentMethod === 'COD') {
                // Thanh toán tiền mặt - xử lý trực tiếp
                if (confirm('Xác nhận thanh toán bằng tiền mặt?')) {
                    // Lưu tên bàn trước khi gọi API (đảm bảo không bị mất)
                    const savedTableName = window.currentTableName || currentTableName;
                    console.log('Saving table name before API call:', savedTableName);
                    
                    fetch('table-payment?bookingId=' + currentBookingId + '&tableId=' + currentTableId + '&method=COD', {
                        method: 'GET'
                    })
                    .then(response => {
                        if (response.ok) {
                            return response.json();
                        } else {
                            throw new Error('Payment failed');
                        }
                    })
                    .then(data => {
                        if (data.success) {
                            // Lấy số tiền từ modal
                            const amount = document.getElementById('paymentAmount').textContent;
                            
                            // Lấy tên bàn từ response (giống như VNPay)
                            const displayTableName = data.tableName || 'N/A';
                            
                            // Hiển thị modal thành công
                            document.getElementById('paymentModal').classList.remove('show');
                            document.getElementById('successTableName').textContent = displayTableName;
                            document.getElementById('successOrderId').textContent = 'Hóa đơn #' + currentBookingId;
                            document.getElementById('successAmount').textContent = amount;
                            document.getElementById('successMethod').textContent = 'Tiền mặt';
                            document.getElementById('successMessage').textContent = 'Khách hàng đã thanh toán thành công bằng tiền mặt.';
                            
                            // Lưu thông tin để in hóa đơn
                            window.currentPaymentBookingId = currentBookingId;
                            window.currentPaymentTableId = currentTableId;
                            
                            document.getElementById('paymentSuccessModal').classList.add('show');
                        } else {
                            alert(data.error || 'Có lỗi xảy ra khi thanh toán!');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi thanh toán!');
                    });
                }
            } else if (selectedPaymentMethod === 'VNPAY') {
                // Thanh toán VNPay - redirect đến VNPay
                // Số tiền cuối cùng (đã trừ cọc)
                const finalAmount = Math.round(currentOriginalAmount);
                window.location.href = 'table-payment?bookingId=' + currentBookingId + '&tableId=' + currentTableId + '&method=VNPAY&finalAmount=' + finalAmount;
            }
        }
        
        // Close success modal
        function closeSuccessModal() {
            document.getElementById('paymentSuccessModal').classList.remove('show');
            // Reload trang để cập nhật danh sách
            window.location.reload();
        }
        
        // Print invoice
        function printInvoice() {
            if (window.currentPaymentBookingId) {
                window.open('print-invoice?bookingId=' + window.currentPaymentBookingId + '&tableId=' + (window.currentPaymentTableId || 0), '_blank');
            } else {
                alert('Không tìm thấy thông tin hóa đơn!');
            }
        }
        
        // View order details (chọn món)
        function viewOrderDetails(bookingId, tableId) {
            window.location.href = 'order-details?bookingId=' + bookingId + '&tableId=' + tableId;
        }
        
        // Change table
        function changeTable(bookingId, tableId) {
            if (confirm('Bạn có muốn đổi bàn này không?')) {
                window.location.href = 'assign-table?bookingId=' + bookingId;
            }
        }
        
        // Cancel table
        function cancelTable(bookingId, tableId) {
            if (confirm('Bạn có chắc muốn hủy bàn này? Khách sẽ phải thanh toán toàn bộ giá trị hóa đơn hiện tại.')) {
                window.location.href = 'cancel-table?bookingId=' + bookingId + '&tableId=' + tableId;
            }
        }
    </script>
</body>
</html>
