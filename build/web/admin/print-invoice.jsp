<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn #${order.id} | HAH Restaurant</title>
    <style>
        @media print {
            body * {
                visibility: hidden;
            }
            .invoice-container, .invoice-container * {
                visibility: visible;
            }
            .invoice-container {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
            .no-print {
                display: none !important;
            }
        }
        
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
            color: #333 !important; /* Override white color from style.css */
        }
        
        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            color: #333 !important; /* Ensure text is dark */
        }
        
        .invoice-header {
            text-align: center;
            border-bottom: 3px solid #104c23;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .invoice-header h1 {
            color: #104c23;
            margin: 0 0 10px;
            font-size: 32px;
            font-weight: 700;
        }
        
        .restaurant-info {
            margin: 15px 0;
            color: #666;
            font-size: 14px;
            line-height: 1.8;
        }
        
        .restaurant-info strong {
            color: #333;
        }
        
        .invoice-number {
            margin-top: 10px;
            font-size: 16px;
            color: #104c23;
            font-weight: 600;
        }
        
        .invoice-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .info-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }
        
        .info-section h3 {
            color: #104c23;
            margin: 0 0 15px;
            font-size: 16px;
            border-bottom: 2px solid #ffc107;
            padding-bottom: 5px;
        }
        
        .info-row {
            margin-bottom: 10px;
            font-size: 14px;
            display: flex;
            justify-content: space-between;
        }
        
        .info-label {
            font-weight: 600;
            color: #666;
        }
        
        .info-value {
            color: #333 !important;
            text-align: right;
        }
        
        table td {
            color: #333 !important;
        }
        
        .total-row {
            color: #333 !important;
        }
        
        .total-row.final {
            color: #28a745 !important;
        }
        
        .total-row.deposit {
            color: #dc3545 !important;
        }
        
        .invoice-items {
            margin-bottom: 30px;
        }
        
        .invoice-items h3 {
            color: #104c23;
            margin: 0 0 15px;
            font-size: 18px;
            border-bottom: 2px solid #ffc107;
            padding-bottom: 5px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        table th {
            background: #104c23;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }
        
        table td {
            padding: 10px 12px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        table tr:last-child td {
            border-bottom: none;
        }
        
        .text-right {
            text-align: right;
        }
        
        .text-center {
            text-align: center;
        }
        
        .invoice-total {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #104c23;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 16px;
            padding: 5px 0;
        }
        
        .total-row.deposit {
            color: #dc3545;
        }
        
        .total-row.final {
            font-size: 20px;
            font-weight: 700;
            color: #28a745;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 2px solid #e0e0e0;
        }
        
        .invoice-footer {
            margin-top: 40px;
            text-align: center;
            color: #666;
            font-size: 14px;
            border-top: 1px solid #e0e0e0;
            padding-top: 20px;
        }
        
        .invoice-footer .thank-you {
            font-size: 18px;
            font-weight: 600;
            color: #104c23;
            margin-bottom: 10px;
        }
        
        .print-actions {
            text-align: center;
            margin: 20px 0;
        }
        
        .btn-print {
            padding: 12px 30px;
            background: #17a2b8;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            margin: 0 10px;
        }
        
        .btn-print:hover {
            background: #138496;
        }
        
        .btn-back {
            padding: 12px 30px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            margin: 0 10px;
        }
        
        .btn-back:hover {
            background: #5a6268;
        }
    </style>
</head>
<body>
    <div class="print-actions no-print">
        <button class="btn-print" onclick="window.print()">
            <i class="fa fa-print"></i> In hóa đơn
        </button>
        <a href="orders?tab=history" class="btn-back">
            <i class="fa fa-arrow-left"></i> Quay lại
        </a>
    </div>
    
    <div class="invoice-container">
        <div class="invoice-header">
            <h1><c:out value="${invoiceSettings['restaurantName'] != null ? invoiceSettings['restaurantName'] : 'HAH RESTAURANT'}" /></h1>
            <div class="restaurant-info">
                <p style="margin: 5px 0;"><strong>Địa chỉ:</strong> <c:out value="${invoiceSettings['address'] != null ? invoiceSettings['address'] : 'Số 310/3, Ngọc Đại, Xã Đại Mỗ, Huyện Từ Liêm, Đai Mễ, Nam Từ Liêm, Hà Nội, Việt Nam'}" /></p>
                <p style="margin: 5px 0;"><strong>Hotline:</strong> <c:out value="${invoiceSettings['hotline'] != null ? invoiceSettings['hotline'] : '1900 1008'}" /></p>
            </div>
            <div class="invoice-number">
                <c:choose>
                    <c:when test="${order.note == 'REFUND'}">
                        HÓA ĐƠN HOÀN TIỀN #${order.id}
                    </c:when>
                    <c:otherwise>
                HÓA ĐƠN THANH TOÁN #${order.id}
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <div class="invoice-info">
            <div class="info-section">
                <h3>Thông tin khách hàng</h3>
                <c:choose>
                    <c:when test="${booking != null}">
                <div class="info-row">
                    <span class="info-label">Tên khách:</span>
                    <span class="info-value">${booking.customerName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Số điện thoại:</span>
                    <span class="info-value">${booking.phone}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Số bàn:</span>
                    <span class="info-value">
                        <c:forEach var="table" items="${booking.tables}" varStatus="loop">
                            ${table.name}<c:if test="${!loop.last}">, </c:if>
                        </c:forEach>
                        <c:if test="${empty booking.tables}">N/A</c:if>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Số hợp đồng:</span>
                    <span class="info-value">#${booking.id}</span>
                </div>
                    </c:when>
                    <c:otherwise>
                        <div class="info-row">
                            <span class="info-label">Tên khách:</span>
                            <span class="info-value">N/A</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Số điện thoại:</span>
                            <span class="info-value">N/A</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Số bàn:</span>
                            <span class="info-value">N/A</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Số hợp đồng:</span>
                            <span class="info-value">N/A</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="info-section">
                <h3>Thông tin hóa đơn</h3>
                <div class="info-row">
                    <span class="info-label">Nhân viên thu ngân:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${order.cashier != null}">
                                ${order.cashier.fullName != null ? order.cashier.fullName : order.cashier.username}
                            </c:when>
                            <c:otherwise>N/A</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Giờ vào:</span>
                    <span class="info-value">
                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Giờ ra:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${order.paidAt != null}">
                                <fmt:formatDate value="${order.paidAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Ngày giờ in:</span>
                    <span class="info-value">
                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss" />
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Phương thức:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'COD'}">Tiền mặt</c:when>
                            <c:when test="${order.paymentMethod == 'VNPAY'}">VNPay</c:when>
                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
        
        <div class="invoice-items">
            <h3>Chi tiết hóa đơn</h3>
            <c:choose>
                <c:when test="${order.note == 'DEPOSIT'}">
                    <!-- Hóa đơn cọc bàn -->
                    <table>
                        <thead>
                            <tr>
                                <th class="text-center">STT</th>
                                <th>Nội dung</th>
                                <th class="text-right">Số lượng</th>
                                <th class="text-right">Đơn giá</th>
                                <th class="text-right">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center" style="color: #333 !important;">1</td>
                                <td style="color: #333 !important;">Tiền cọc đặt bàn</td>
                                <td class="text-right" style="color: #333 !important;">1</td>
                                <td class="text-right" style="color: #333 !important;">
                                    <fmt:formatNumber value="100000" type="number" maxFractionDigits="0"/> đ
                                </td>
                                <td class="text-right" style="color: #333 !important;">
                                    <fmt:formatNumber value="100000" type="number" maxFractionDigits="0"/> đ
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </c:when>
                <c:when test="${order.note == 'REFUND'}">
                    <!-- Hóa đơn hoàn tiền -->
                    <table>
                        <thead>
                            <tr>
                                <th class="text-center">STT</th>
                                <th>Nội dung</th>
                                <th class="text-right">Số lượng</th>
                                <th class="text-right">Đơn giá</th>
                                <th class="text-right">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center" style="color: #333 !important;">1</td>
                                <td style="color: #333 !important;">Hoàn tiền cọc đặt bàn</td>
                                <td class="text-right" style="color: #333 !important;">1</td>
                                <td class="text-right" style="color: #333 !important;">
                                    <fmt:formatNumber value="100000" type="number" maxFractionDigits="0"/> đ
                                </td>
                                <td class="text-right" style="color: #333 !important;">
                                    <fmt:formatNumber value="100000" type="number" maxFractionDigits="0"/> đ
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <!-- Hóa đơn bàn ăn thông thường -->
            <table>
                <thead>
                    <tr>
                        <th class="text-center">STT</th>
                        <th>Tên món</th>
                        <th class="text-right">Số lượng</th>
                        <th class="text-right">Đơn giá</th>
                        <th class="text-right">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="detail" items="${order.orderDetails}" varStatus="loop">
                        <tr>
                            <td class="text-center" style="color: #333 !important;">${loop.index + 1}</td>
                            <td style="color: #333 !important;">${detail.product.name}</td>
                            <td class="text-right" style="color: #333 !important;">${detail.quantity}</td>
                            <td class="text-right" style="color: #333 !important;">
                                <fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/> đ
                            </td>
                            <td class="text-right" style="color: #333 !important;">
                                <fmt:formatNumber value="${detail.price * detail.quantity}" type="number" maxFractionDigits="0"/> đ
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty order.orderDetails}">
                        <tr>
                            <td colspan="5" style="text-align: center; color: #999; padding: 20px;">
                                Không có món nào trong hóa đơn
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="invoice-total">
            <div class="total-row">
                <span>Tạm tính:</span>
                <span>
                    <fmt:formatNumber value="${order.subtotal}" type="number" maxFractionDigits="0"/> đ
                </span>
            </div>
            <c:if test="${order.note != 'DEPOSIT' && order.note != 'REFUND'}">
                <!-- Chỉ hiển thị dòng trừ cọc cho hóa đơn bàn ăn, không hiển thị cho hóa đơn cọc và hoàn tiền -->
            <div class="total-row deposit">
                <span>Tiền cọc đã đặt:</span>
                <span>-100.000 đ</span>
            </div>
            </c:if>
            <div class="total-row final">
                <span>Tổng cộng:</span>
                <span>
                    <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ
                </span>
            </div>
        </div>
        
        <div class="invoice-footer">
            <p class="thank-you">Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi!</p>
            <p style="margin-top: 10px; font-size: 12px;">
                Hóa đơn được tạo tự động bởi hệ thống HAH Restaurant
            </p>
            <p style="margin-top: 5px; font-size: 12px; color: #999;">
                Hẹn gặp lại quý khách!
            </p>
        </div>
    </div>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</body>
</html>
