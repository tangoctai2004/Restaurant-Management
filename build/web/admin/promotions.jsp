<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý khuyến mãi | HAH Restaurant</title>
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
                <h1><i class="fa fa-tag"></i> Quản lý khuyến mãi</h1>
            </div>
            
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="openModal('addPromoModal')">
                    <i class="fa fa-plus"></i> Thêm khuyến mãi mới
                </button>
            </div>
            
            <c:if test="${not empty error}">
                <div style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
                    ${error}
                </div>
            </c:if>
            
            <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
            
            <div class="dashboard-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Mã KM</th>
                            <th>Mô tả</th>
                            <th>Loại giảm</th>
                            <th>Giá trị</th>
                            <th>Giảm tối đa</th>
                            <th>Đơn tối thiểu</th>
                            <th>Ngày bắt đầu</th>
                            <th>Ngày kết thúc</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="promo" items="${promotions}">
                            <tr>
                                <td>${promo.id}</td>
                                <td><strong>${promo.code}</strong></td>
                                <td>${promo.description}</td>
                                <td>${promo.discountType == 'Percent' ? 'Phần trăm' : 'Số tiền'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${promo.discountType == 'Percent'}">
                                            ${promo.discountValue}%
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${promo.discountValue}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${promo.discountType == 'Percent' && promo.maxDiscountAmount != null}">
                                            <fmt:formatNumber value="${promo.maxDiscountAmount}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatNumber value="${promo.minOrderValue}" type="currency" currencyCode="VND" minFractionDigits="0"/></td>
                                <td><fmt:formatDate value="${promo.startDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${promo.endDate}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <span class="badge ${promo.active ? 'status-completed' : 'status-canceled'}">
                                        ${promo.active ? 'Hoạt động' : 'Tạm dừng'}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="editPromo(${promo.id}, '${promo.code}', '${fn:replace(promo.description, "'", "\\'")}', '${promo.discountType}', ${promo.discountValue}, ${promo.minOrderValue}, ${promo.maxDiscountAmount != null ? promo.maxDiscountAmount : 'null'}, '${promo.startDate}', '${promo.endDate}', ${promo.active})">
                                        <i class="fa fa-edit"></i> Sửa
                                    </button>
                                    <a href="promotions?action=delete&id=${promo.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc muốn xóa khuyến mãi này?')">
                                        <i class="fa fa-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Modal Thêm/Sửa khuyến mãi -->
    <div id="addPromoModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Thêm khuyến mãi mới</h2>
                <button class="close-modal" onclick="closeModal('addPromoModal')">&times;</button>
            </div>
            <form action="promotions" method="POST" id="promoForm">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="promoId">
                
                <div class="form-group">
                    <label for="code">Mã khuyến mãi:</label>
                    <input type="text" id="code" name="code" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Mô tả:</label>
                    <textarea id="description" name="description"></textarea>
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="discountType">Loại giảm giá:</label>
                        <select id="discountType" name="discountType" required>
                            <option value="Percent">Phần trăm (%)</option>
                            <option value="FixedAmount">Số tiền cố định</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="discountValue">Giá trị giảm:</label>
                        <input type="number" id="discountValue" name="discountValue" min="0" step="0.01" required>
                    </div>
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="minOrderValue">Đơn hàng tối thiểu (VND):</label>
                        <input type="number" id="minOrderValue" name="minOrderValue" min="0" step="1000" value="0">
                    </div>
                    
                    <div class="form-group" id="maxDiscountGroup" style="display: none;">
                        <label for="maxDiscountAmount">Giảm tối đa (VND):</label>
                        <input type="number" id="maxDiscountAmount" name="maxDiscountAmount" min="0" step="1000">
                        <small style="color: #666;">Chỉ áp dụng cho loại Phần trăm</small>
                    </div>
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="startDate">Ngày bắt đầu:</label>
                        <input type="datetime-local" id="startDate" name="startDate" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="endDate">Ngày kết thúc:</label>
                        <input type="datetime-local" id="endDate" name="endDate" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>
                        <input type="checkbox" id="isActive" name="isActive" checked>
                        Kích hoạt (Bật = Hoạt động, Tắt = Tạm dừng)
                    </label>
                </div>
                
                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addPromoModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function openModal(modalId) {
            document.getElementById(modalId).classList.add('active');
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('active');
            document.getElementById('promoForm').reset();
            document.getElementById('formAction').value = 'add';
            document.getElementById('promoId').value = '';
            document.getElementById('modalTitle').textContent = 'Thêm khuyến mãi mới';
            document.getElementById('maxDiscountGroup').style.display = 'none';
        }
        
        function editPromo(id, code, description, discountType, discountValue, minOrderValue, maxDiscountAmount, startDate, endDate, isActive) {
            document.getElementById('formAction').value = 'update';
            document.getElementById('promoId').value = id;
            document.getElementById('code').value = code || '';
            document.getElementById('description').value = description || '';
            document.getElementById('discountType').value = discountType || 'Percent';
            document.getElementById('discountValue').value = discountValue || 0;
            document.getElementById('minOrderValue').value = minOrderValue || 0;
            document.getElementById('maxDiscountAmount').value = (maxDiscountAmount && maxDiscountAmount !== 'null') ? maxDiscountAmount : '';
            
            // Format dates for datetime-local input
            if (startDate) {
                const start = new Date(startDate);
                document.getElementById('startDate').value = start.toISOString().slice(0, 16);
            }
            if (endDate) {
                const end = new Date(endDate);
                document.getElementById('endDate').value = end.toISOString().slice(0, 16);
            }
            
            document.getElementById('isActive').checked = isActive === true || isActive === 'true' || isActive === 1;
            document.getElementById('modalTitle').textContent = 'Sửa khuyến mãi';
            
            // Hiển thị/ẩn maxDiscountAmount dựa trên discountType
            toggleMaxDiscount();
            
            openModal('addPromoModal');
        }
        
        // Hiển thị/ẩn trường "Giảm tối đa" dựa trên loại giảm giá
        document.getElementById('discountType').addEventListener('change', toggleMaxDiscount);
        
        function toggleMaxDiscount() {
            const discountType = document.getElementById('discountType').value;
            const maxDiscountGroup = document.getElementById('maxDiscountGroup');
            if (discountType === 'Percent') {
                maxDiscountGroup.style.display = 'block';
            } else {
                maxDiscountGroup.style.display = 'none';
                document.getElementById('maxDiscountAmount').value = '';
            }
        }
    </script>
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

