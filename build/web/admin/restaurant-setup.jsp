<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thiết lập nhà hàng | HAH Restaurant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body, .admin-content, .dashboard-card, .data-table td, .data-table th {
            color: #333 !important;
        }
        
        .setup-container {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }
        
        .setup-tabs {
            display: flex;
            flex-direction: column;
            gap: 10px;
            width: 250px;
            flex-shrink: 0;
        }
        
        .setup-tab {
            padding: 15px 20px;
            background: #fff;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            color: #333;
        }
        
        .setup-tab:hover {
            background: #f8f9fa;
            border-color: #ffc107;
        }
        
        .setup-tab.active {
            background: #fff8e1;
            border-color: #ffc107;
            color: #104c23;
            font-weight: 600;
        }
        
        .setup-tab i {
            width: 20px;
            text-align: center;
            color: #ffc107;
        }
        
        .setup-content {
            flex: 1;
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .tab-panel {
            display: none;
        }
        
        .tab-panel.active {
            display: block;
        }
        
        .tab-panel h2 {
            color: #104c23;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #ffc107;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .form-section h3 {
            color: #104c23;
            font-size: 18px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-section h3 i {
            color: #ffc107;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group input[type="text"],
        .form-group input[type="url"],
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s;
            color: #333;
            background: #fff;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255,193,7,0.1);
        }
        
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        .form-group small {
            display: block;
            margin-top: 5px;
            color: #666;
            font-size: 13px;
        }
        
        .save-button {
            background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%);
            color: #000;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .save-button:hover {
            background: linear-gradient(135deg, #ffb300 0%, #ffa000 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255,193,7,0.3);
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 2px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 2px solid #f5c6cb;
        }
        
        .preview-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            border-left: 4px solid #ffc107;
        }
        
        .preview-section h4 {
            color: #104c23;
            margin-bottom: 10px;
        }
        
        .preview-section p {
            color: #666;
            font-size: 14px;
        }
        
        .section-form {
            margin-bottom: 40px;
            padding: 25px;
            background: #f8f9fa;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
        }
        
        .file-input {
            width: 100%;
            padding: 10px;
            border: 2px dashed #ccc;
            border-radius: 8px;
            background: #fff;
            cursor: pointer;
        }
        
        .file-input:hover {
            border-color: #ffc107;
        }
        
        .current-image {
            margin-top: 10px;
            padding: 10px;
            background: #fff;
            border-radius: 5px;
        }
        
        .current-image p {
            margin: 0 0 10px 0;
            font-weight: 600;
            color: #333;
        }
        
        .checkbox-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-height: 200px;
            overflow-y: auto;
            padding: 15px;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
        }
        
        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            padding: 8px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .checkbox-label:hover {
            background: #f0f0f0;
        }
        
        .checkbox-label input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        /* Custom Checkbox Style - Giống ảnh (nền vàng, checkmark xám đậm) */
        .custom-checkbox {
            width: 24px !important;
            height: 24px !important;
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-color: #ffc107;
            border: 2px solid #ffc107;
            border-radius: 6px;
            position: relative;
            transition: all 0.2s;
            flex-shrink: 0;
        }
        
        .custom-checkbox:hover {
            background-color: #ffb300;
            border-color: #ffb300;
            transform: scale(1.05);
        }
        
        .custom-checkbox:checked {
            background-color: #ffc107;
            border-color: #ffc107;
        }
        
        .custom-checkbox:checked::after {
            content: '';
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -60%) rotate(45deg);
            width: 5px;
            height: 10px;
            border: solid #2c2c2c;
            border-width: 0 3px 3px 0;
            border-radius: 0;
        }
        
        .custom-checkbox:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.3);
        }
        
        /* Menu Tab - Category Cards */
        .categories-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .category-card {
            background: #fff;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .category-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .category-card:has(.category-checkbox:checked) {
            border-color: #ffc107;
            background: #fffef5;
        }
        
        .category-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 20px;
            cursor: pointer;
            background: #f8f9fa;
            transition: background 0.3s;
        }
        
        .category-header:hover {
            background: #f0f0f0;
        }
        
        .category-header-left {
            display: flex;
            align-items: center;
            gap: 15px;
            flex: 1;
        }
        
        .category-checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: #ffc107;
        }
        
        .category-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        
        .category-name {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            color: #104c23;
        }
        
        .category-count {
            font-size: 13px;
            color: #666;
        }
        
        .category-header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .selected-count {
            background: #ffc107;
            color: #000;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            min-width: 30px;
            text-align: center;
            display: inline-block;
        }
        
        .selected-count:empty {
            display: none;
        }
        
        .accordion-icon {
            color: #666;
            transition: transform 0.3s;
            font-size: 14px;
        }
        
        .category-card.expanded .accordion-icon {
            transform: rotate(180deg);
        }
        
        .category-content {
            padding: 20px;
            background: #fff;
            border-top: 1px solid #e0e0e0;
        }
        
        .category-toolbar {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .search-box-wrapper {
            flex: 1;
            min-width: 250px;
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .search-box-wrapper i {
            position: absolute;
            left: 12px;
            color: #999;
            z-index: 1;
        }
        
        .product-search {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .product-search:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 0 3px rgba(255,193,7,0.1);
        }
        
        .select-all-buttons {
            display: flex;
            gap: 10px;
        }
        
        .btn-select-all {
            padding: 8px 16px;
            border: 2px solid #e0e0e0;
            background: #fff;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            color: #333;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .btn-select-all:hover {
            border-color: #ffc107;
            background: #fffef5;
            color: #104c23;
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 10px;
            max-height: 400px;
            overflow-y: auto;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        
        .products-grid::-webkit-scrollbar {
            width: 8px;
        }
        
        .products-grid::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }
        
        .products-grid::-webkit-scrollbar-thumb {
            background: #ccc;
            border-radius: 4px;
        }
        
        .products-grid::-webkit-scrollbar-thumb:hover {
            background: #999;
        }
        
        .product-item {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            transition: all 0.2s;
        }
        
        .product-item:hover {
            border-color: #ffc107;
            box-shadow: 0 2px 6px rgba(255,193,7,0.2);
        }
        
        .product-checkbox-label {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            cursor: pointer;
            margin: 0;
        }
        
        .product-checkbox {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #ffc107;
            flex-shrink: 0;
        }
        
        .product-name {
            font-size: 14px;
            color: #333;
            flex: 1;
        }
        
        .product-item:has(.product-checkbox:checked) {
            background: #fffef5;
            border-color: #ffc107;
        }
        
        .product-item.hidden {
            display: none;
        }
        
        .category-footer {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
        }
        
        .category-footer small {
            color: #666;
            font-size: 12px;
        }
        
        .feature-item {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            margin-bottom: 15px;
        }
        
        .feature-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .feature-form {
            margin: 0;
        }
        
        .icon-picker-input-wrapper {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .icon-preview {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f0f0f0;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 20px;
            color: #333;
        }
        
        .icon-picker-input {
            flex: 1;
        }
        
        .icon-picker-btn {
            padding: 10px 15px;
            background: #ffc107;
            color: #333;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
        }
        
        .icon-picker-btn:hover {
            background: #ffb300;
        }
        
        .icon-picker-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 20000; /* Cao hơn field modal để hiển thị phía trên */
            justify-content: center;
            align-items: center;
        }
        
        .icon-picker-modal.active {
            display: flex;
        }
        
        .icon-picker-content {
            background: white;
            border-radius: 10px;
            padding: 25px;
            max-width: 600px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        .icon-picker-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #eee;
        }
        
        .icon-picker-header h3 {
            margin: 0;
            color: #333;
        }
        
        .icon-picker-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #666;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .icon-picker-close:hover {
            color: #333;
        }
        
        .icon-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 10px;
        }
        
        .icon-item {
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: #fff;
        }
        
        .icon-item:hover {
            border-color: #ffc107;
            background: #fffbf0;
            transform: translateY(-2px);
        }
        
        .icon-item.selected {
            border-color: #ffc107;
            background: #fff9e6;
        }
        
        .icon-item i {
            font-size: 24px;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        
        .icon-item span {
            font-size: 11px;
            color: #666;
            display: block;
            word-break: break-word;
        }
        
        @media (max-width: 768px) {
            .icon-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }
        
        @media (max-width: 968px) {
            .setup-container {
                flex-direction: column;
            }
            
            .setup-tabs {
                width: 100%;
                flex-direction: row;
                overflow-x: auto;
            }
            
            .setup-tab {
                min-width: 150px;
            }
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
                <h1><i class="fa fa-cog"></i> Thiết lập nhà hàng</h1>
            </div>
            
            <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>
            
            <div class="setup-container">
                <div class="setup-tabs">
                    <div class="setup-tab active" onclick="showTab('home')">
                        <i class="fa fa-home"></i>
                        <span>Trang chủ</span>
                    </div>
                    <div class="setup-tab" onclick="showTab('menu')">
                        <i class="fa fa-utensils"></i>
                        <span>Thực đơn</span>
                    </div>
                    <div class="setup-tab" onclick="showTab('reservation')">
                        <i class="fa fa-calendar-check"></i>
                        <span>Đặt bàn</span>
                    </div>
                    <div class="setup-tab" onclick="showTab('about')">
                        <i class="fa fa-info-circle"></i>
                        <span>Giới thiệu</span>
                    </div>
                    <div class="setup-tab" onclick="showTab('contact')">
                        <i class="fa fa-phone"></i>
                        <span>Liên hệ</span>
                    </div>
                    <div class="setup-tab" onclick="showTab('footer')">
                        <i class="fa fa-window-maximize"></i>
                        <span>Footer</span>
                    </div>
                    <div class="setup-tab" onclick="showTab('invoice')">
                        <i class="fa fa-receipt"></i>
                        <span>Hóa đơn</span>
                    </div>
                </div>
                
                <div class="setup-content">
                    <!-- Tab Trang chủ -->
                    <div id="home-tab" class="tab-panel active">
                        <h2><i class="fa fa-home"></i> Tùy chỉnh Trang chủ</h2>
                        
                        <!-- Hero Section -->
                        <form action="restaurant-setup" method="POST" enctype="multipart/form-data" class="section-form">
                            <input type="hidden" name="pageName" value="home">
                            <input type="hidden" name="section" value="hero">
                            <input type="hidden" name="activeTab" value="home">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-image"></i> Hero Section</h3>
                                <div class="form-group">
                                    <label>Tiêu đề chính:</label>
                                    <input type="text" name="setting_heroTitle" 
                                           value="${homeSettings['heroTitle'] != null ? homeSettings['heroTitle'] : 'HAH Restaurant'}"
                                           placeholder="VD: HAH Restaurant">
                                    <small>Tiêu đề hiển thị ở phần hero của trang chủ</small>
                                </div>
                                <div class="form-group">
                                    <label>Phụ đề:</label>
                                    <input type="text" name="setting_heroSubtitle" 
                                           value="${homeSettings['heroSubtitle'] != null ? homeSettings['heroSubtitle'] : 'Chúng tôi hân hạnh được phục vụ quý khách'}"
                                           placeholder="VD: Chúng tôi hân hạnh được phục vụ quý khách">
                                    <small>Dòng mô tả ngắn dưới tiêu đề</small>
                                </div>
                                <div class="form-group">
                                    <label>Nút "Thực đơn":</label>
                                    <input type="text" name="setting_menuButtonText" 
                                           value="${homeSettings['menuButtonText'] != null ? homeSettings['menuButtonText'] : 'Thực đơn'}"
                                           placeholder="VD: Thực đơn">
                                </div>
                                <div class="form-group">
                                    <label>Nút "Đặt bàn":</label>
                                    <input type="text" name="setting_reservationButtonText" 
                                           value="${homeSettings['reservationButtonText'] != null ? homeSettings['reservationButtonText'] : 'Đặt bàn'}"
                                           placeholder="VD: Đặt bàn">
                                </div>
                                <div class="form-group">
                                    <label>Ảnh nền Hero:</label>
                                    <input type="file" name="setting_heroBackgroundImage" accept="image/*" class="file-input">
                                    <input type="hidden" name="imageFieldName" value="setting_heroBackgroundImage">
                                    <small>Chọn ảnh từ máy tính (JPG, PNG, GIF)</small>
                                    <c:if test="${homeSettings['heroBackgroundImage'] != null}">
                                        <div class="current-image">
                                            <p>Ảnh hiện tại:</p>
                                            <img src="${pageContext.request.contextPath}/${homeSettings['heroBackgroundImage']}" 
                                                 alt="Hero background" style="max-width: 200px; margin-top: 10px; border-radius: 5px;">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Hero Section
                            </button>
                        </form>
                        
                        <!-- Menu Section -->
                        <form action="restaurant-setup" method="POST" enctype="multipart/form-data" class="section-form">
                            <input type="hidden" name="pageName" value="home">
                            <input type="hidden" name="section" value="menuSection">
                            <input type="hidden" name="activeTab" value="home">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-list"></i> Section Thực đơn</h3>
                                <div class="form-group">
                                    <label>Tiêu đề section:</label>
                                    <input type="text" name="setting_menuSectionTitle" 
                                           value="${homeSettings['menuSectionTitle'] != null ? homeSettings['menuSectionTitle'] : 'THỰC ĐƠN'}"
                                           placeholder="VD: THỰC ĐƠN">
                                </div>
                                <div class="form-group">
                                    <label>Phụ đề section:</label>
                                    <input type="text" name="setting_menuSectionSubtitle" 
                                           value="${homeSettings['menuSectionSubtitle'] != null ? homeSettings['menuSectionSubtitle'] : 'BẠN MUỐN ĂN GÌ?'}"
                                           placeholder="VD: BẠN MUỐN ĂN GÌ?">
                                </div>
                                <div class="form-group">
                                    <label>Nút "Xem tất cả":</label>
                                    <input type="text" name="setting_viewAllButtonText" 
                                           value="${homeSettings['viewAllButtonText'] != null ? homeSettings['viewAllButtonText'] : 'Xem tất cả'}"
                                           placeholder="VD: Xem tất cả">
                                </div>
                                
                                <div class="form-group">
                                    <label>Chọn danh mục hiển thị:</label>
                                    <div class="checkbox-group">
                                        <c:forEach var="cat" items="${categories}">
                                            <c:set var="selectedCategories" value="${homeSettings['selectedCategories']}" />
                                            <c:set var="isSelected" value="false" />
                                            <c:if test="${selectedCategories != null}">
                                                <c:forEach var="selectedId" items="${fn:split(selectedCategories, ',')}">
                                                    <c:if test="${selectedId == cat.id}">
                                                        <c:set var="isSelected" value="true" />
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>
                                            <label class="checkbox-label">
                                                <input type="checkbox" name="selectedCategories" value="${cat.id}" 
                                                       ${isSelected ? 'checked' : ''}>
                                                ${cat.name} (${cat.productCount} món)
                                            </label>
                                        </c:forEach>
                                    </div>
                                    <small>Chọn các danh mục muốn hiển thị trên trang chủ</small>
                                </div>
                                
                                <div class="form-group">
                                    <label>Số lượng món hiển thị mỗi danh mục:</label>
                                    <input type="number" name="setting_itemsPerCategory" 
                                           value="${homeSettings['itemsPerCategory'] != null ? homeSettings['itemsPerCategory'] : '6'}"
                                           min="1" max="20" placeholder="VD: 6">
                                    <small>Số lượng card món ăn hiển thị cho mỗi danh mục (1-20)</small>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Section Thực đơn
                            </button>
                        </form>
                        
                        <!-- About Section -->
                        <form action="restaurant-setup" method="POST" enctype="multipart/form-data" class="section-form">
                            <input type="hidden" name="pageName" value="home">
                            <input type="hidden" name="section" value="aboutSection">
                            <input type="hidden" name="activeTab" value="home">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-info"></i> Section Giới thiệu</h3>
                                <div class="form-group">
                                    <label>Tiêu đề section:</label>
                                    <input type="text" name="setting_aboutSectionTitle" 
                                           value="${homeSettings['aboutSectionTitle'] != null ? homeSettings['aboutSectionTitle'] : 'LỰA CHỌN CHÚNG TÔI?'}"
                                           placeholder="VD: LỰA CHỌN CHÚNG TÔI?">
                                </div>
                                <div class="form-group">
                                    <label>Phụ đề section:</label>
                                    <input type="text" name="setting_aboutSectionSubtitle" 
                                           value="${homeSettings['aboutSectionSubtitle'] != null ? homeSettings['aboutSectionSubtitle'] : 'GIỚI THIỆU'}"
                                           placeholder="VD: GIỚI THIỆU">
                                </div>
                                
                                <div class="form-group">
                                    <label>Ảnh section:</label>
                                    <input type="file" name="setting_aboutSectionImage" accept="image/*" class="file-input">
                                    <input type="hidden" name="imageFieldName" value="setting_aboutSectionImage">
                                    <small>Chọn ảnh từ máy tính</small>
                                    <c:if test="${homeSettings['aboutSectionImage'] != null}">
                                        <div class="current-image">
                                            <p>Ảnh hiện tại:</p>
                                            <img src="${pageContext.request.contextPath}/${homeSettings['aboutSectionImage']}" 
                                                 alt="About section" style="max-width: 200px; margin-top: 10px; border-radius: 5px;">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Section Giới thiệu
                            </button>
                        </form>
                        
                        <!-- About Features Section -->
                        <div class="form-section">
                            <h3><i class="fa fa-star"></i> Các phần thông tin (Features)</h3>
                            <p style="color: #666; margin-bottom: 20px;">Quản lý các phần thông tin hiển thị trong section Giới thiệu (ví dụ: Thực đơn phong phú, Không gian rộng rãi, Phục vụ tận tâm)</p>
                            
                            <div id="features-list">
                                <c:choose>
                                    <c:when test="${not empty aboutFeatures}">
                                        <c:set var="featureIds" value="" />
                                        <c:forEach var="setting" items="${aboutFeatures}">
                                            <c:if test="${fn:endsWith(setting.key, '_title')}">
                                                <c:set var="fullFeatureId" value="${setting.key}" />
                                                <c:set var="featureId" value="${fn:substringBefore(fullFeatureId, '_title')}" />
                                                <c:set var="featureDeletedKey" value="${featureId}_deleted" />
                                                <c:set var="isDeleted" value="${aboutFeatures[featureDeletedKey] == 'true'}" />
                                                
                                                <c:if test="${!isDeleted}">
                                                    <c:set var="featureIdCheck" value="${featureId}," />
                                                    <c:if test="${!fn:contains(featureIds, featureIdCheck)}">
                                                        <c:set var="featureIds" value="${featureIds}${featureIdCheck}" />
                                                        <c:set var="featureTitle" value="${setting.value}" />
                                                        <c:set var="featureDescKey" value="${featureId}_description" />
                                                        <c:set var="featureIconKey" value="${featureId}_icon" />
                                                        <c:set var="featureDesc" value="${aboutFeatures[featureDescKey]}" />
                                                        <c:set var="featureIcon" value="${aboutFeatures[featureIconKey]}" />
                                                        <c:set var="featureIdShort" value="${fn:replace(featureId, 'feature_', '')}" />
                                                        
                                                        <c:if test="${featureTitle != null && !featureTitle.trim().isEmpty()}">
                                                            <div class="feature-item" data-feature-id="${featureIdShort}">
                                                        <form action="restaurant-setup" method="POST" class="feature-form">
                                                            <input type="hidden" name="pageName" value="about">
                                                            <input type="hidden" name="section" value="aboutFeatures">
                                                            <input type="hidden" name="featureAction" value="update">
                                                            <input type="hidden" name="activeTab" value="home">
                                                            <input type="hidden" name="featureId" value="${featureIdShort}">
                                                            
                                                            <div class="form-group">
                                                                <label>Tiêu đề:</label>
                                                                <input type="text" name="featureTitle" value="<c:out value='${featureTitle}' />" required>
                                                            </div>
                                                            <div class="form-group">
                                                                <label>Mô tả:</label>
                                                                <textarea name="featureDescription" required><c:out value="${featureDesc != null ? featureDesc : ''}" /></textarea>
                                                            </div>
                                                            <div class="form-group">
                                                                <label>Icon:</label>
                                                                <div class="icon-picker-container">
                                                                    <div class="icon-picker-input-wrapper">
                                                                        <div class="icon-preview">
                                                                            <i class="<c:out value='${featureIcon != null ? featureIcon : "fa fa-star"}' />"></i>
                                                                        </div>
                                                                        <input type="text" name="featureIcon" class="icon-picker-input" 
                                                                               value="<c:out value='${featureIcon != null ? featureIcon : "fa fa-star"}' />" 
                                                                               placeholder="fa fa-star" readonly>
                                                                        <button type="button" class="icon-picker-btn" onclick="openIconPicker(this)">
                                                                            <i class="fa fa-search"></i> Chọn icon
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            
                                                            <div class="feature-actions">
                                                                <button type="submit" class="btn btn-sm btn-primary">
                                                                    <i class="fa fa-save"></i> Cập nhật
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-danger" onclick="deleteFeature('${featureIdShort}')">
                                                                    <i class="fa fa-trash"></i> Xóa
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                        </c:if>
                                                    </c:if>
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: #666; font-style: italic;">Chưa có phần thông tin nào. Hãy thêm phần mới bằng nút bên dưới.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <button type="button" class="btn btn-primary" onclick="addNewFeature()" style="margin-top: 20px;">
                                <i class="fa fa-plus"></i> Thêm phần mới
                            </button>
                        </div>
                    </div>
                    
                    <!-- Tab Thực đơn -->
                    <div id="menu-tab" class="tab-panel">
                        <h2><i class="fa fa-utensils"></i> Tùy chỉnh Trang Thực đơn</h2>
                        <form action="restaurant-setup" method="POST">
                            <input type="hidden" name="pageName" value="menu">
                            <input type="hidden" name="activeTab" value="menu">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-list"></i> Chọn danh mục và món ăn hiển thị</h3>
                                <p style="color: #666; margin-bottom: 20px; padding: 12px; background: #f0f7ff; border-left: 4px solid #ffc107; border-radius: 5px;">
                                    <i class="fa fa-info-circle"></i> Tích chọn danh mục để mở rộng và chọn các món ăn trong danh mục đó. Bạn có thể tìm kiếm món ăn trong mỗi danh mục.
                                </p>
                                
                                <div class="categories-container">
                                    <c:forEach var="cat" items="${categories}">
                                        <c:set var="selectedMenuCategories" value="${menuSettings['selectedCategories']}" />
                                        <c:set var="isSelected" value="false" />
                                        <c:if test="${selectedMenuCategories != null}">
                                            <c:forEach var="selectedId" items="${fn:split(selectedMenuCategories, ',')}">
                                                <c:if test="${selectedId == cat.id}">
                                                    <c:set var="isSelected" value="true" />
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                        
                                        <div class="category-card" data-category-id="${cat.id}">
                                            <div class="category-header" onclick="toggleCategoryAccordion(${cat.id})">
                                                <div class="category-header-left">
                                                    <input type="checkbox" 
                                                           name="selectedCategories" 
                                                           value="${cat.id}" 
                                                           ${isSelected ? 'checked' : ''}
                                                           onclick="event.stopPropagation(); toggleCategoryProducts(${cat.id}, this.checked);"
                                                           class="category-checkbox">
                                                    <div class="category-info">
                                                        <h4 class="category-name">${cat.name}</h4>
                                                        <span class="category-count">${cat.productCount} món</span>
                                                    </div>
                                                </div>
                                                <div class="category-header-right">
                                                    <span class="selected-count" id="selected-count-${cat.id}">0</span>
                                                    <i class="fa fa-chevron-down accordion-icon" id="accordion-icon-${cat.id}"></i>
                                                </div>
                                            </div>
                                            
                                            <div class="category-content" id="category-content-${cat.id}" style="display: ${isSelected ? 'block' : 'none'};">
                                                <div class="category-toolbar">
                                                    <div class="search-box-wrapper">
                                                        <i class="fa fa-search"></i>
                                                        <input type="text" 
                                                               class="product-search" 
                                                               placeholder="Tìm kiếm món ăn..." 
                                                               onkeyup="filterProducts(${cat.id}, this.value)">
                                                    </div>
                                                    <div class="select-all-buttons">
                                                        <button type="button" class="btn-select-all" onclick="selectAllProducts(${cat.id}, true)">
                                                            <i class="fa fa-check-square"></i> Chọn tất cả
                                                        </button>
                                                        <button type="button" class="btn-select-all" onclick="selectAllProducts(${cat.id}, false)">
                                                            <i class="fa fa-square"></i> Bỏ chọn tất cả
                                                        </button>
                                                    </div>
                                                </div>
                                                
                                                <c:set var="selectedProductsKey" value="selectedProducts_cat_${cat.id}" />
                                                <c:set var="selectedProducts" value="${menuSettings[selectedProductsKey]}" />
                                                
                                                <div class="products-grid" id="products-grid-${cat.id}">
                                                    <c:forEach var="p" items="${allProducts}">
                                                        <c:if test="${p.categoryId == cat.id}">
                                                            <c:set var="isProductSelected" value="false" />
                                                            <c:if test="${selectedProducts != null}">
                                                                <c:forEach var="selectedProductId" items="${fn:split(selectedProducts, ',')}">
                                                                    <c:if test="${selectedProductId == p.id}">
                                                                        <c:set var="isProductSelected" value="true" />
                                                                    </c:if>
                                                                </c:forEach>
                                                            </c:if>
                                                            <div class="product-item" data-product-name="${fn:toLowerCase(p.name)}">
                                                                <label class="product-checkbox-label">
                                                                    <input type="checkbox" 
                                                                           name="selectedProducts_cat_${cat.id}" 
                                                                           value="${p.id}" 
                                                                           ${isProductSelected ? 'checked' : ''}
                                                                           onchange="updateSelectedCount(${cat.id})"
                                                                           class="product-checkbox">
                                                                    <span class="product-name">${p.name}</span>
                                                                </label>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                                
                                                <div class="category-footer">
                                                    <small><i class="fa fa-info-circle"></i> Nếu không chọn món nào, tất cả món trong danh mục sẽ được hiển thị</small>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h3><i class="fa fa-columns"></i> Bố cục hiển thị</h3>
                                <div class="form-group">
                                    <label>Số lượng món ăn mỗi dòng:</label>
                                    <input type="number" name="setting_itemsPerRow" 
                                           value="${menuSettings['itemsPerRow'] != null ? menuSettings['itemsPerRow'] : '4'}"
                                           min="1" max="6" placeholder="VD: 4">
                                    <small>Số lượng card món ăn hiển thị trên mỗi dòng (1-6)</small>
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h3><i class="fa fa-toggle-on"></i> Tùy chọn hiển thị</h3>
                                <div class="form-group">
                                    <label class="checkbox-label">
                                        <input type="checkbox" name="setting_showSearchBox" value="true" class="custom-checkbox"
                                               ${menuSettings['showSearchBox'] == 'true' || menuSettings['showSearchBox'] == null ? 'checked' : ''}>
                                        Hiển thị khung tìm kiếm món ăn
                                    </label>
                                </div>
                                <div class="form-group">
                                    <label class="checkbox-label">
                                        <input type="checkbox" name="setting_showDetailButton" value="true" class="custom-checkbox"
                                               ${menuSettings['showDetailButton'] == 'true' || menuSettings['showDetailButton'] == null ? 'checked' : ''}>
                                        Hiển thị nút "Xem chi tiết"
                                    </label>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu thiết lập Thực đơn
                            </button>
                        </form>
                    </div>
                    
                    <!-- Tab Đặt bàn -->
                    <div id="reservation-tab" class="tab-panel">
                        <h2><i class="fa fa-calendar-check"></i> Tùy chỉnh Trang Đặt bàn</h2>
                        
                        <form action="restaurant-setup" method="POST">
                            <input type="hidden" name="pageName" value="reservation">
                            <input type="hidden" name="activeTab" value="reservation">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-heading"></i> Tiêu đề và Nội dung</h3>
                                <div class="form-group">
                                    <label>Tiêu đề trang:</label>
                                    <input type="text" name="setting_pageTitle" 
                                           value="${reservationSettings['pageTitle'] != null ? reservationSettings['pageTitle'] : 'ĐẶT BÀN'}"
                                           placeholder="VD: ĐẶT BÀN">
                                    <small>Tiêu đề chính hiển thị ở đầu trang</small>
                                </div>
                                <div class="form-group">
                                    <label>Tiêu đề form:</label>
                                    <input type="text" name="setting_formTitle" 
                                           value="${reservationSettings['formTitle'] != null ? reservationSettings['formTitle'] : 'THÔNG TIN ĐẶT BÀN'}"
                                           placeholder="VD: THÔNG TIN ĐẶT BÀN">
                                    <small>Tiêu đề hiển thị trên form</small>
                                </div>
                                <div class="form-group">
                                    <label>Thông báo lưu ý:</label>
                                    <textarea name="setting_warningMessage" rows="3"
                                              placeholder="Thông báo hiển thị trên form đặt bàn">${reservationSettings['warningMessage'] != null ? reservationSettings['warningMessage'] : 'Lưu ý: Đặt bàn cần thanh toán tiền cọc 100,000 VNĐ qua VNPay để đảm bảo. Nhân viên sẽ liên hệ và sắp xếp bàn phù hợp cho bạn sau khi nhận được yêu cầu.'}</textarea>
                                    <small>Thông báo hiển thị trong khung cảnh báo</small>
                                </div>
                                <div class="form-group">
                                    <label>Text nút submit:</label>
                                    <input type="text" name="setting_submitButtonText" 
                                           value="${reservationSettings['submitButtonText'] != null ? reservationSettings['submitButtonText'] : 'Thanh toán tiền cọc và đặt bàn'}"
                                           placeholder="VD: Thanh toán tiền cọc và đặt bàn">
                                    <small>Text hiển thị trên nút gửi form</small>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu thiết lập Đặt bàn
                            </button>
                        </form>
                    </div>
                    
                    <!-- Tab Giới thiệu -->
                    <div id="about-tab" class="tab-panel">
                        <h2><i class="fa fa-info-circle"></i> Tùy chỉnh Trang Giới thiệu</h2>
                        
                        <!-- Hero Section -->
                        <form action="restaurant-setup" method="POST" enctype="multipart/form-data" class="section-form">
                            <input type="hidden" name="pageName" value="about">
                            <input type="hidden" name="section" value="hero">
                            <input type="hidden" name="activeTab" value="about">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-image"></i> Hero Section</h3>
                                <div class="form-group">
                                    <label>Tiêu đề:</label>
                                    <input type="text" name="setting_heroTitle" 
                                           value="${aboutSettings['heroTitle'] != null ? aboutSettings['heroTitle'] : 'Về Chúng Tôi'}"
                                           placeholder="VD: Về Chúng Tôi">
                                </div>
                                <div class="form-group">
                                    <label>Phụ đề:</label>
                                    <input type="text" name="setting_heroSubtitle" 
                                           value="${aboutSettings['heroSubtitle'] != null ? aboutSettings['heroSubtitle'] : 'Hành trình ẩm thực đầy đam mê'}"
                                           placeholder="VD: Hành trình ẩm thực đầy đam mê">
                                </div>
                                <div class="form-group">
                                    <label>Ảnh nền Hero:</label>
                                    <input type="file" name="setting_heroBackgroundImage" accept="image/*" class="file-input">
                                    <input type="hidden" name="imageFieldName" value="setting_heroBackgroundImage">
                                    <small>Chọn ảnh từ máy tính (JPG, PNG, GIF)</small>
                                    <c:if test="${aboutSettings['heroBackgroundImage'] != null}">
                                        <div class="current-image">
                                            <p>Ảnh hiện tại:</p>
                                            <img src="${pageContext.request.contextPath}/${aboutSettings['heroBackgroundImage']}" 
                                                 alt="Hero background" style="max-width: 200px; margin-top: 10px; border-radius: 5px;">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Hero Section
                            </button>
                        </form>
                        
                        <!-- Story Section -->
                        <form action="restaurant-setup" method="POST" enctype="multipart/form-data" class="section-form">
                            <input type="hidden" name="pageName" value="about">
                            <input type="hidden" name="section" value="story">
                            <input type="hidden" name="activeTab" value="about">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-book"></i> Story Section</h3>
                                <div class="form-group">
                                    <label>Tiêu đề section:</label>
                                    <input type="text" name="setting_storySectionTitle" 
                                           value="${aboutSettings['storySectionTitle'] != null ? aboutSettings['storySectionTitle'] : 'Câu Chuyện Của Chúng Tôi'}"
                                           placeholder="VD: Câu Chuyện Của Chúng Tôi">
                                </div>
                                <div class="form-group">
                                    <label>Mô tả section:</label>
                                    <textarea name="setting_storySectionDescription" rows="2"
                                              placeholder="Mô tả ngắn về câu chuyện">${aboutSettings['storySectionDescription'] != null ? aboutSettings['storySectionDescription'] : 'HAH Restaurant được thành lập với tình yêu và đam mê dành cho ẩm thực, mang đến những trải nghiệm ẩm thực tuyệt vời nhất cho thực khách.'}</textarea>
                                </div>
                                <div class="form-group">
                                    <label>Tiêu đề nội dung:</label>
                                    <input type="text" name="setting_storyContentTitle" 
                                           value="${aboutSettings['storyContentTitle'] != null ? aboutSettings['storyContentTitle'] : 'Khởi Đầu Từ Đam Mê'}"
                                           placeholder="VD: Khởi Đầu Từ Đam Mê">
                                </div>
                                <div class="form-group">
                                    <label>Nội dung (đoạn 1):</label>
                                    <textarea name="setting_storyContentParagraph1" rows="3"
                                              placeholder="Đoạn văn đầu tiên">${aboutSettings['storyContentParagraph1'] != null ? aboutSettings['storyContentParagraph1'] : 'Với hơn 10 năm kinh nghiệm trong ngành ẩm thực, chúng tôi tự hào mang đến những món ăn chất lượng cao, được chế biến từ những nguyên liệu tươi ngon nhất.'}</textarea>
                                </div>
                                <div class="form-group">
                                    <label>Nội dung (đoạn 2):</label>
                                    <textarea name="setting_storyContentParagraph2" rows="3"
                                              placeholder="Đoạn văn thứ hai">${aboutSettings['storyContentParagraph2'] != null ? aboutSettings['storyContentParagraph2'] : 'Đội ngũ đầu bếp giàu kinh nghiệm của chúng tôi luôn tận tâm, sáng tạo để tạo ra những món ăn độc đáo, hấp dẫn và đậm đà hương vị Việt Nam.'}</textarea>
                                </div>
                                <div class="form-group">
                                    <label>Nội dung (đoạn 3):</label>
                                    <textarea name="setting_storyContentParagraph3" rows="3"
                                              placeholder="Đoạn văn thứ ba">${aboutSettings['storyContentParagraph3'] != null ? aboutSettings['storyContentParagraph3'] : 'Không gian nhà hàng được thiết kế hiện đại, ấm cúng, tạo cảm giác thoải mái và thư giãn cho mọi thực khách.'}</textarea>
                                </div>
                                <div class="form-group">
                                    <label>Ảnh Story:</label>
                                    <input type="file" name="setting_storyImage" accept="image/*" class="file-input">
                                    <input type="hidden" name="imageFieldName" value="setting_storyImage">
                                    <small>Chọn ảnh từ máy tính</small>
                                    <c:if test="${aboutSettings['storyImage'] != null}">
                                        <div class="current-image">
                                            <p>Ảnh hiện tại:</p>
                                            <img src="${pageContext.request.contextPath}/${aboutSettings['storyImage']}" 
                                                 alt="Story image" style="max-width: 200px; margin-top: 10px; border-radius: 5px;">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Story Section
                            </button>
                        </form>
                        
                        <!-- Values Section -->
                        <form action="restaurant-setup" method="POST" class="section-form">
                            <input type="hidden" name="pageName" value="about">
                            <input type="hidden" name="section" value="values">
                            <input type="hidden" name="activeTab" value="about">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-heart"></i> Values Section</h3>
                                <div class="form-group">
                                    <label>Tiêu đề section:</label>
                                    <input type="text" name="setting_valuesSectionTitle" 
                                           value="${aboutSettings['valuesSectionTitle'] != null ? aboutSettings['valuesSectionTitle'] : 'Giá Trị Cốt Lõi'}"
                                           placeholder="VD: Giá Trị Cốt Lõi">
                                </div>
                                <div class="form-group">
                                    <label>Mô tả section:</label>
                                    <textarea name="setting_valuesSectionDescription" rows="2"
                                              placeholder="Mô tả ngắn về giá trị">${aboutSettings['valuesSectionDescription'] != null ? aboutSettings['valuesSectionDescription'] : 'Những điều chúng tôi luôn hướng tới và cam kết thực hiện'}</textarea>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Values Section
                            </button>
                        </form>
                        
                        <!-- Values Items Management -->
                        <div class="form-section">
                            <h3><i class="fa fa-star"></i> Quản lý các Value Cards</h3>
                            <p style="color: #666; margin-bottom: 20px;">Quản lý các value cards hiển thị trong Values Section (ví dụ: Chất Lượng, Phục Vụ, Đổi Mới)</p>
                            
                            <div id="values-list">
                                <c:choose>
                                    <c:when test="${not empty values}">
                                        <c:set var="valueIds" value="" />
                                        <c:forEach var="setting" items="${values}">
                                            <c:if test="${fn:endsWith(setting.key, '_title')}">
                                                <c:set var="fullValueId" value="${setting.key}" />
                                                <c:set var="valueId" value="${fn:substringBefore(fullValueId, '_title')}" />
                                                <c:set var="valueDeletedKey" value="${valueId}_deleted" />
                                                <c:set var="isDeleted" value="${values[valueDeletedKey] == 'true'}" />
                                                
                                                <c:if test="${!isDeleted}">
                                                    <c:set var="valueIdCheck" value="${valueId}," />
                                                    <c:if test="${!fn:contains(valueIds, valueIdCheck)}">
                                                        <c:set var="valueIds" value="${valueIds}${valueIdCheck}" />
                                                        <c:set var="valueTitle" value="${setting.value}" />
                                                        <c:set var="valueDescKey" value="${valueId}_description" />
                                                        <c:set var="valueIconKey" value="${valueId}_icon" />
                                                        <c:set var="valueDesc" value="${values[valueDescKey]}" />
                                                        <c:set var="valueIcon" value="${values[valueIconKey]}" />
                                                        <c:set var="valueIdShort" value="${fn:replace(valueId, 'value_', '')}" />
                                                        
                                                        <c:if test="${valueTitle != null && !valueTitle.trim().isEmpty()}">
                                                            <div class="feature-item" data-value-id="${valueIdShort}">
                                                                <form action="restaurant-setup" method="POST" class="feature-form">
                                                                    <input type="hidden" name="pageName" value="about">
                                                                    <input type="hidden" name="section" value="aboutValues">
                                                                    <input type="hidden" name="valueAction" value="update">
                                                                    <input type="hidden" name="activeTab" value="about">
                                                                    <input type="hidden" name="valueId" value="${valueIdShort}">
                                                                    
                                                                    <div class="form-group">
                                                                        <label>Tiêu đề:</label>
                                                                        <input type="text" name="valueTitle" value="<c:out value='${valueTitle}' />" required>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label>Mô tả:</label>
                                                                        <textarea name="valueDescription" required><c:out value="${valueDesc != null ? valueDesc : ''}" /></textarea>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label>Icon:</label>
                                                                        <div class="icon-picker-container">
                                                                            <div class="icon-picker-input-wrapper">
                                                                                <div class="icon-preview">
                                                                                    <i class="<c:out value='${valueIcon != null ? valueIcon : "fa fa-star"}' />"></i>
                                                                                </div>
                                                                                <input type="text" name="valueIcon" class="icon-picker-input" 
                                                                                       value="<c:out value='${valueIcon != null ? valueIcon : "fa fa-star"}' />" 
                                                                                       placeholder="fa fa-star" readonly>
                                                                                <button type="button" class="icon-picker-btn" onclick="openIconPicker(this)">
                                                                                    <i class="fa fa-search"></i> Chọn icon
                                                                                </button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <div class="feature-actions">
                                                                        <button type="submit" class="btn btn-sm btn-primary">
                                                                            <i class="fa fa-save"></i> Cập nhật
                                                                        </button>
                                                                        <button type="button" class="btn btn-sm btn-danger" onclick="deleteValue('${valueIdShort}')">
                                                                            <i class="fa fa-trash"></i> Xóa
                                                                        </button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </c:if>
                                                    </c:if>
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: #666; font-style: italic;">Chưa có value card nào. Hãy thêm value card mới bằng nút bên dưới.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <button type="button" class="btn btn-primary" onclick="addNewValue()" style="margin-top: 20px;">
                                <i class="fa fa-plus"></i> Thêm Value Card mới
                            </button>
                        </div>
                        
                        <!-- Gallery Section -->
                        <form action="restaurant-setup" method="POST" class="section-form">
                            <input type="hidden" name="pageName" value="about">
                            <input type="hidden" name="section" value="gallery">
                            <input type="hidden" name="activeTab" value="about">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-images"></i> Gallery Section</h3>
                                <div class="form-group">
                                    <label>Tiêu đề section:</label>
                                    <input type="text" name="setting_gallerySectionTitle" 
                                           value="${aboutSettings['gallerySectionTitle'] != null ? aboutSettings['gallerySectionTitle'] : 'Không Gian Nhà Hàng'}"
                                           placeholder="VD: Không Gian Nhà Hàng">
                                </div>
                                <div class="form-group">
                                    <label>Mô tả section:</label>
                                    <textarea name="setting_gallerySectionDescription" rows="2"
                                              placeholder="Mô tả ngắn về gallery">${aboutSettings['gallerySectionDescription'] != null ? aboutSettings['gallerySectionDescription'] : 'Những khoảnh khắc đẹp tại HAH Restaurant'}</textarea>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Gallery Section
                            </button>
                        </form>
                        
                        <!-- Gallery Images Management -->
                        <div class="form-section">
                            <h3><i class="fa fa-image"></i> Quản lý Gallery Images</h3>
                            <p style="color: #666; margin-bottom: 20px;">Quản lý các ảnh hiển thị trong Gallery Section</p>
                            
                            <div id="gallery-list">
                                <c:choose>
                                    <c:when test="${not empty galleryImages}">
                                        <c:set var="galleryIds" value="" />
                                        <c:forEach var="setting" items="${galleryImages}">
                                            <c:if test="${fn:endsWith(setting.key, '_image')}">
                                                <c:set var="fullGalleryId" value="${setting.key}" />
                                                <c:set var="galleryId" value="${fn:substringBefore(fullGalleryId, '_image')}" />
                                                <c:set var="galleryDeletedKey" value="${galleryId}_deleted" />
                                                <c:set var="isDeleted" value="${galleryImages[galleryDeletedKey] == 'true'}" />
                                                
                                                <c:if test="${!isDeleted}">
                                                    <c:set var="galleryIdCheck" value="${galleryId}," />
                                                    <c:if test="${!fn:contains(galleryIds, galleryIdCheck)}">
                                                        <c:set var="galleryIds" value="${galleryIds}${galleryIdCheck}" />
                                                        <c:set var="galleryImage" value="${setting.value}" />
                                                        <c:set var="galleryIdShort" value="${fn:replace(galleryId, 'gallery_', '')}" />
                                                        
                                                        <c:if test="${galleryImage != null && !galleryImage.trim().isEmpty()}">
                                                            <div class="feature-item" data-gallery-id="${galleryIdShort}">
                                                                <form action="restaurant-setup" method="POST" enctype="multipart/form-data" class="feature-form">
                                                                    <input type="hidden" name="pageName" value="about">
                                                                    <input type="hidden" name="section" value="aboutGallery">
                                                                    <input type="hidden" name="galleryAction" value="update">
                                                                    <input type="hidden" name="activeTab" value="about">
                                                                    <input type="hidden" name="galleryId" value="${galleryIdShort}">
                                                                    
                                                                    <div class="form-group">
                                                                        <label>Ảnh:</label>
                                                                        <input type="file" name="galleryImage" accept="image/*" class="file-input">
                                                                        <input type="hidden" name="imageFieldName" value="galleryImage">
                                                                        <small>Chọn ảnh từ máy tính</small>
                                                                        <c:if test="${galleryImage != null}">
                                                                            <div class="current-image">
                                                                                <p>Ảnh hiện tại:</p>
                                                                                <img src="${pageContext.request.contextPath}/${galleryImage}" 
                                                                                     alt="Gallery image" style="max-width: 200px; margin-top: 10px; border-radius: 5px;">
                                                                            </div>
                                                                        </c:if>
                                                                    </div>
                                                                    
                                                                    <div class="feature-actions">
                                                                        <button type="submit" class="btn btn-sm btn-primary">
                                                                            <i class="fa fa-save"></i> Cập nhật
                                                                        </button>
                                                                        <button type="button" class="btn btn-sm btn-danger" onclick="deleteGalleryImage('${galleryIdShort}')">
                                                                            <i class="fa fa-trash"></i> Xóa
                                                                        </button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </c:if>
                                                    </c:if>
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: #666; font-style: italic;">Chưa có ảnh nào. Hãy thêm ảnh mới bằng nút bên dưới.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <button type="button" class="btn btn-primary" onclick="addNewGalleryImage()" style="margin-top: 20px;">
                                <i class="fa fa-plus"></i> Thêm ảnh mới
                            </button>
                        </div>
                    </div>
                    
                    <!-- Tab Liên hệ -->
                    <div id="contact-tab" class="tab-panel">
                        <h2><i class="fa fa-phone"></i> Tùy chỉnh Trang Liên hệ</h2>
                        
                        <!-- Hero Section -->
                        <form action="restaurant-setup" method="POST" enctype="multipart/form-data" class="section-form">
                            <input type="hidden" name="pageName" value="contact">
                            <input type="hidden" name="section" value="hero">
                            <input type="hidden" name="activeTab" value="contact">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-image"></i> Hero Section</h3>
                                <div class="form-group">
                                    <label>Tiêu đề:</label>
                                    <input type="text" name="setting_heroTitle" 
                                           value="${contactSettings['heroTitle'] != null ? contactSettings['heroTitle'] : 'Liên Hệ Với Chúng Tôi'}"
                                           placeholder="VD: Liên Hệ Với Chúng Tôi">
                                </div>
                                <div class="form-group">
                                    <label>Phụ đề:</label>
                                    <input type="text" name="setting_heroSubtitle" 
                                           value="${contactSettings['heroSubtitle'] != null ? contactSettings['heroSubtitle'] : 'Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn'}"
                                           placeholder="VD: Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn">
                                </div>
                                <div class="form-group">
                                    <label>Ảnh nền Hero:</label>
                                    <input type="file" name="setting_heroBackgroundImage" accept="image/*" class="file-input">
                                    <input type="hidden" name="imageFieldName" value="setting_heroBackgroundImage">
                                    <small>Chọn ảnh từ máy tính (JPG, PNG, GIF)</small>
                                    <c:if test="${contactSettings['heroBackgroundImage'] != null}">
                                        <div class="current-image">
                                            <p>Ảnh hiện tại:</p>
                                            <img src="${pageContext.request.contextPath}/${contactSettings['heroBackgroundImage']}" 
                                                 alt="Hero background" style="max-width: 200px; margin-top: 10px; border-radius: 5px;">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Hero Section
                            </button>
                        </form>
                        
                        <!-- Section Header -->
                        <form action="restaurant-setup" method="POST" class="section-form">
                            <input type="hidden" name="pageName" value="contact">
                            <input type="hidden" name="section" value="section">
                            <input type="hidden" name="activeTab" value="contact">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-heading"></i> Section Header</h3>
                                <div class="form-group">
                                    <label>Tiêu đề section:</label>
                                    <input type="text" name="setting_sectionTitle" 
                                           value="${contactSettings['sectionTitle'] != null ? contactSettings['sectionTitle'] : 'Hãy Để Lại Lời Nhắn'}"
                                           placeholder="VD: Hãy Để Lại Lời Nhắn">
                                </div>
                                <div class="form-group">
                                    <label>Mô tả section:</label>
                                    <textarea name="setting_sectionDescription" rows="2"
                                              placeholder="Mô tả ngắn về form liên hệ">${contactSettings['sectionDescription'] != null ? contactSettings['sectionDescription'] : 'Mọi thắc mắc, góp ý hoặc yêu cầu của bạn đều được chúng tôi quan tâm và phản hồi sớm nhất'}</textarea>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Section Header
                            </button>
                        </form>
                        
                        <!-- Contact Form Section -->
                        <form action="restaurant-setup" method="POST" class="section-form">
                            <input type="hidden" name="pageName" value="contact">
                            <input type="hidden" name="section" value="form">
                            <input type="hidden" name="activeTab" value="contact">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-envelope"></i> Contact Form</h3>
                                <div class="form-group">
                                    <label>Tiêu đề form:</label>
                                    <input type="text" name="setting_formTitle" 
                                           value="${contactSettings['formTitle'] != null ? contactSettings['formTitle'] : 'Gửi Tin Nhắn'}"
                                           placeholder="VD: Gửi Tin Nhắn">
                                </div>
                                <div class="form-group">
                                    <label>Text nút submit:</label>
                                    <input type="text" name="setting_submitButtonText" 
                                           value="${contactSettings['submitButtonText'] != null ? contactSettings['submitButtonText'] : 'Gửi Tin Nhắn'}"
                                           placeholder="VD: Gửi Tin Nhắn">
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Contact Form
                            </button>
                        </form>
                        
                        <!-- Contact Info Items Management -->
                        <div class="form-section">
                            <h3><i class="fa fa-info-circle"></i> Quản lý các Contact Info Items</h3>
                            <p style="color: #666; margin-bottom: 20px;">Quản lý các thông tin liên hệ hiển thị (ví dụ: Địa chỉ, Điện thoại, Email, Giờ mở cửa)</p>
                            
                            <div id="contact-info-list">
                                <c:choose>
                                    <c:when test="${not empty contactInfoItems}">
                                        <c:set var="infoIds" value="" />
                                        <c:forEach var="setting" items="${contactInfoItems}">
                                            <c:if test="${fn:endsWith(setting.key, '_title')}">
                                                <c:set var="fullInfoId" value="${setting.key}" />
                                                <c:set var="infoId" value="${fn:substringBefore(fullInfoId, '_title')}" />
                                                <c:set var="infoDeletedKey" value="${infoId}_deleted" />
                                                <c:set var="isDeleted" value="${contactInfoItems[infoDeletedKey] == 'true'}" />
                                                
                                                <c:if test="${!isDeleted}">
                                                    <c:set var="infoIdCheck" value="${infoId}," />
                                                    <c:if test="${!fn:contains(infoIds, infoIdCheck)}">
                                                        <c:set var="infoIds" value="${infoIds}${infoIdCheck}" />
                                                        <c:set var="infoTitle" value="${setting.value}" />
                                                        <c:set var="infoContentKey" value="${infoId}_content" />
                                                        <c:set var="infoIconKey" value="${infoId}_icon" />
                                                        <c:set var="infoContent" value="${contactInfoItems[infoContentKey]}" />
                                                        <c:set var="infoIcon" value="${contactInfoItems[infoIconKey]}" />
                                                        <c:set var="infoIdShort" value="${fn:replace(infoId, 'info_', '')}" />
                                                        
                                                        <c:if test="${infoTitle != null && !infoTitle.trim().isEmpty()}">
                                                            <div class="feature-item" data-info-id="${infoIdShort}">
                                                                <form action="restaurant-setup" method="POST" class="feature-form">
                                                                    <input type="hidden" name="pageName" value="contact">
                                                                    <input type="hidden" name="section" value="contactInfo">
                                                                    <input type="hidden" name="infoAction" value="update">
                                                                    <input type="hidden" name="infoId" value="${infoIdShort}">
                                                                    <input type="hidden" name="activeTab" value="contact">
                                                                    
                                                                    <div class="form-group">
                                                                        <label>Tiêu đề:</label>
                                                                        <input type="text" name="infoTitle" value="<c:out value='${infoTitle}' />" required>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label>Nội dung (có thể dùng &lt;br&gt; để xuống dòng):</label>
                                                                        <textarea name="infoContent" required><c:out value="${infoContent != null ? infoContent : ''}" /></textarea>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label>Icon:</label>
                                                                        <div class="icon-picker-container">
                                                                            <div class="icon-picker-input-wrapper">
                                                                                <div class="icon-preview">
                                                                                    <i class="<c:out value='${infoIcon != null ? infoIcon : "fa fa-star"}' />"></i>
                                                                                </div>
                                                                                <input type="text" name="infoIcon" class="icon-picker-input" 
                                                                                       value="<c:out value='${infoIcon != null ? infoIcon : "fa fa-star"}' />" 
                                                                                       placeholder="fa fa-star" readonly>
                                                                                <button type="button" class="icon-picker-btn" onclick="openIconPicker(this)">
                                                                                    <i class="fa fa-search"></i> Chọn icon
                                                                                </button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <div class="feature-actions">
                                                                        <button type="submit" class="btn btn-sm btn-primary">
                                                                            <i class="fa fa-save"></i> Cập nhật
                                                                        </button>
                                                                        <button type="button" class="btn btn-sm btn-danger" onclick="deleteContactInfo('${infoIdShort}')">
                                                                            <i class="fa fa-trash"></i> Xóa
                                                                        </button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </c:if>
                                                    </c:if>
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: #666; font-style: italic;">Chưa có contact info item nào. Hãy thêm item mới bằng nút bên dưới.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <button type="button" class="btn btn-primary" onclick="addNewContactInfo()" style="margin-top: 20px;">
                                <i class="fa fa-plus"></i> Thêm Contact Info mới
                            </button>
                        </div>
                        
                        <!-- Map Section -->
                        <form action="restaurant-setup" method="POST" class="section-form">
                            <input type="hidden" name="pageName" value="contact">
                            <input type="hidden" name="section" value="map">
                            <input type="hidden" name="activeTab" value="contact">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-map"></i> Map Section</h3>
                                <div class="form-group">
                                    <label>Tiêu đề section:</label>
                                    <input type="text" name="setting_mapSectionTitle" 
                                           value="${contactSettings['mapSectionTitle'] != null ? contactSettings['mapSectionTitle'] : 'Vị Trí Của Chúng Tôi'}"
                                           placeholder="VD: Vị Trí Của Chúng Tôi">
                                </div>
                                <div class="form-group">
                                    <label>Mô tả section:</label>
                                    <textarea name="setting_mapSectionDescription" rows="2"
                                              placeholder="Mô tả ngắn về map">${contactSettings['mapSectionDescription'] != null ? contactSettings['mapSectionDescription'] : 'Tìm đường đến nhà hàng của chúng tôi'}</textarea>
                                </div>
                                <div class="form-group">
                                    <label>Google Maps Embed URL:</label>
                                    <textarea id="mapEmbedUrlInput" name="setting_mapEmbedUrl" rows="4"
                                              placeholder="Dán URL embed từ Google Maps (chỉ cần URL trong src của iframe, hoặc dán cả iframe - hệ thống sẽ tự động lấy URL)"
                                              onpaste="handleMapUrlPaste(event)">${contactSettings['mapEmbedUrl'] != null ? contactSettings['mapEmbedUrl'] : 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3022.184133894008!2d-73.98811768459418!3d40.74844097932681!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c259a9b3117469%3A0xd134e199a405a163!2sEmpire%20State%20Building!5e0!3m2!1sen!2sus!4v1234567890123!5m2!1sen!2sus'}</textarea>
                                    <small>
                                        <strong>Hướng dẫn:</strong><br>
                                        1. Vào Google Maps → Tìm địa chỉ → Chia sẻ → Nhúng bản đồ<br>
                                        2. Copy toàn bộ iframe code HOẶC chỉ copy URL trong src="..."<br>
                                        3. Dán vào ô trên (hệ thống sẽ tự động lấy URL nếu bạn dán cả iframe)
                                    </small>
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu Map Section
                            </button>
                        </form>
                    </div>
                    
                    <!-- Tab Footer -->
                    <div id="footer-tab" class="tab-panel">
                        <h2><i class="fa fa-footer"></i> Tùy chỉnh Footer</h2>
                        <form action="restaurant-setup" method="POST">
                            <input type="hidden" name="pageName" value="footer">
                            <input type="hidden" name="activeTab" value="footer">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-cog"></i> Thông tin Footer</h3>
                                <div class="form-group">
                                    <label>Logo text:</label>
                                    <input type="text" name="setting_logoText" 
                                           value="${footerSettings['logoText'] != null ? footerSettings['logoText'] : 'HAH'}"
                                           placeholder="VD: HAH">
                                </div>
                                <div class="form-group">
                                    <label>Địa chỉ:</label>
                                    <textarea name="setting_address" placeholder="Địa chỉ nhà hàng">
                                        <c:choose>
                                            <c:when test="${footerSettings['address'] != null}">${footerSettings['address']}</c:when>
                                            <c:otherwise>A108 Adam Street
NY 535022, USA</c:otherwise>
                                        </c:choose>
                                    </textarea>
                                </div>
                                <div class="form-group">
                                    <label>Số điện thoại:</label>
                                    <input type="text" name="setting_phone" 
                                           value="${footerSettings['phone'] != null ? footerSettings['phone'] : '0865.787.333'}"
                                           placeholder="VD: 0865.787.333">
                                </div>
                                <div class="form-group">
                                    <label>Email:</label>
                                    <input type="text" name="setting_email" 
                                           value="${footerSettings['email'] != null ? footerSettings['email'] : 'hah@gmail.com'}"
                                           placeholder="VD: hah@gmail.com">
                                </div>
                                <div class="form-group">
                                    <label>Copyright text:</label>
                                    <input type="text" name="setting_copyright" 
                                           value="${footerSettings['copyright'] != null ? footerSettings['copyright'] : '© 2025 HAH Restaurant. All Rights Reserved.'}"
                                           placeholder="VD: © 2025 HAH Restaurant. All Rights Reserved.">
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h3><i class="fa fa-share-alt"></i> Social Media Links</h3>
                                <div class="form-group">
                                    <label>Facebook URL:</label>
                                    <input type="url" name="setting_facebookUrl" 
                                           value="${footerSettings['facebookUrl'] != null ? footerSettings['facebookUrl'] : '#'}"
                                           placeholder="VD: https://facebook.com/...">
                                </div>
                                <div class="form-group">
                                    <label>Instagram URL:</label>
                                    <input type="url" name="setting_instagramUrl" 
                                           value="${footerSettings['instagramUrl'] != null ? footerSettings['instagramUrl'] : '#'}"
                                           placeholder="VD: https://instagram.com/...">
                                </div>
                                <div class="form-group">
                                    <label>Twitter URL:</label>
                                    <input type="url" name="setting_twitterUrl" 
                                           value="${footerSettings['twitterUrl'] != null ? footerSettings['twitterUrl'] : '#'}"
                                           placeholder="VD: https://twitter.com/...">
                                </div>
                                <div class="form-group">
                                    <label>YouTube URL:</label>
                                    <input type="url" name="setting_youtubeUrl" 
                                           value="${footerSettings['youtubeUrl'] != null ? footerSettings['youtubeUrl'] : '#'}"
                                           placeholder="VD: https://youtube.com/...">
                                </div>
                                <div class="form-group">
                                    <label>LinkedIn URL:</label>
                                    <input type="url" name="setting_linkedinUrl" 
                                           value="${footerSettings['linkedinUrl'] != null ? footerSettings['linkedinUrl'] : '#'}"
                                           placeholder="VD: https://linkedin.com/...">
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu thiết lập Footer
                            </button>
                        </form>
                    </div>
                    
                    <!-- Tab Hóa đơn -->
                    <div id="invoice-tab" class="tab-panel">
                        <h2><i class="fa fa-receipt"></i> Tùy chỉnh Hóa đơn</h2>
                        <form action="restaurant-setup" method="POST">
                            <input type="hidden" name="pageName" value="invoice">
                            <input type="hidden" name="activeTab" value="invoice">
                            
                            <div class="form-section">
                                <h3><i class="fa fa-cog"></i> Thông tin nhà hàng trên hóa đơn</h3>
                                <div class="form-group">
                                    <label>Tên nhà hàng:</label>
                                    <input type="text" name="setting_restaurantName" 
                                           value="${invoiceSettings['restaurantName'] != null ? invoiceSettings['restaurantName'] : 'HAH RESTAURANT'}"
                                           placeholder="VD: HAH RESTAURANT">
                                </div>
                                <div class="form-group">
                                    <label>Địa chỉ:</label>
                                    <textarea name="setting_address" placeholder="Địa chỉ nhà hàng" rows="3"><c:choose><c:when test="${invoiceSettings['address'] != null}"><c:out value="${invoiceSettings['address']}" /></c:when><c:otherwise>Số 310/3, Ngọc Đại, Xã Đại Mỗ, Huyện Từ Liêm, Đai Mễ, Nam Từ Liêm, Hà Nội, Việt Nam</c:otherwise></c:choose></textarea>
                                </div>
                                <div class="form-group">
                                    <label>Hotline:</label>
                                    <input type="text" name="setting_hotline" 
                                           value="${invoiceSettings['hotline'] != null ? invoiceSettings['hotline'] : '1900 1008'}"
                                           placeholder="VD: 1900 1008">
                                </div>
                            </div>
                            
                            <button type="submit" class="save-button">
                                <i class="fa fa-save"></i> Lưu thiết lập Hóa đơn
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function showTab(tabName) {
            // Ẩn tất cả tabs
            document.querySelectorAll('.tab-panel').forEach(panel => {
                panel.classList.remove('active');
            });
            
            // Ẩn active class từ tất cả tab buttons
            document.querySelectorAll('.setup-tab').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Hiển thị tab được chọn
            document.getElementById(tabName + '-tab').classList.add('active');
            
            // Thêm active class cho tab button
            event.currentTarget.classList.add('active');
            
            // Cập nhật tất cả hidden input activeTab trong các form
            document.querySelectorAll('input[name="activeTab"]').forEach(input => {
                input.value = tabName;
            });
        }
        
        // Tự động mở tab từ session sau khi reload
        document.addEventListener('DOMContentLoaded', function() {
            const activeTabValue = '${activeTab != null ? activeTab : "home"}';
            if (activeTabValue && activeTabValue !== 'home') {
                // Tìm tab button và trigger showTab
                const tabButtons = document.querySelectorAll('.setup-tab');
                let found = false;
                tabButtons.forEach(button => {
                    const onclickAttr = button.getAttribute('onclick');
                    if (onclickAttr && onclickAttr.includes("showTab('" + activeTabValue + "')")) {
                        // Trigger showTab function
                        showTab(activeTabValue);
                        // Cập nhật active class cho button
                        button.classList.add('active');
                        found = true;
                    }
                });
                
                // Nếu không tìm thấy bằng onclick, thử tìm bằng cách khác
                if (!found) {
                    // Tìm tab panel và kích hoạt nó
                    const tabPanel = document.getElementById(activeTabValue + '-tab');
                    if (tabPanel) {
                        // Ẩn tất cả tabs
                        document.querySelectorAll('.tab-panel').forEach(panel => {
                            panel.classList.remove('active');
                        });
                        document.querySelectorAll('.setup-tab').forEach(tab => {
                            tab.classList.remove('active');
                        });
                        // Hiển thị tab được chọn
                        tabPanel.classList.add('active');
                        // Tìm và kích hoạt button tương ứng
                        tabButtons.forEach(button => {
                            const onclickAttr = button.getAttribute('onclick');
                            if (onclickAttr && onclickAttr.includes(activeTabValue)) {
                                button.classList.add('active');
                            }
                        });
                    }
                }
            }
        });
        
        let featureCounter = ${fn:length(aboutFeatures) > 0 ? (fn:length(aboutFeatures) / 3) : 0};
        
        function addNewFeature() {
            featureCounter++;
            const featuresList = document.getElementById('features-list');
            const newFeature = document.createElement('div');
            newFeature.className = 'feature-item';
            newFeature.setAttribute('data-feature-id', 'new_' + featureCounter);
            newFeature.innerHTML = `
                <form action="restaurant-setup" method="POST" class="feature-form">
                    <input type="hidden" name="pageName" value="about">
                    <input type="hidden" name="section" value="aboutFeatures">
                    <input type="hidden" name="featureAction" value="add">
                    <input type="hidden" name="activeTab" value="home">
                    <input type="hidden" name="featureId" value="new_${featureCounter}">
                    
                    <div class="form-group">
                        <label>Tiêu đề:</label>
                        <input type="text" name="featureTitle" required>
                    </div>
                    <div class="form-group">
                        <label>Mô tả:</label>
                        <textarea name="featureDescription" required></textarea>
                    </div>
                                                    <div class="form-group">
                                                        <label>Icon:</label>
                                                        <div class="icon-picker-container">
                                                            <div class="icon-picker-input-wrapper">
                                                                <div class="icon-preview">
                                                                    <i class="fa fa-star"></i>
                                                                </div>
                                                                <input type="text" name="featureIcon" class="icon-picker-input" 
                                                                       value="fa fa-star" placeholder="fa fa-star" readonly>
                                                                <button type="button" class="icon-picker-btn" onclick="openIconPicker(this)">
                                                                    <i class="fa fa-search"></i> Chọn icon
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                    
                    <div class="feature-actions">
                        <button type="submit" class="btn btn-sm btn-primary">
                            <i class="fa fa-save"></i> Lưu
                        </button>
                        <button type="button" class="btn btn-sm btn-secondary" onclick="this.closest('.feature-item').remove()">
                            <i class="fa fa-times"></i> Hủy
                        </button>
                    </div>
                </form>
            `;
            featuresList.appendChild(newFeature);
        }
        
        function deleteFeature(featureId) {
            if (confirm('Bạn có chắc muốn xóa phần này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'restaurant-setup';
                
                form.appendChild(createHiddenInput('pageName', 'about'));
                form.appendChild(createHiddenInput('section', 'aboutFeatures'));
                form.appendChild(createHiddenInput('featureAction', 'delete'));
                form.appendChild(createHiddenInput('featureId', featureId));
                form.appendChild(createHiddenInput('activeTab', 'home'));
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // ========== Values Management ==========
        let valueCounter = 0;
        
        function addNewValue() {
            valueCounter++;
            const valuesList = document.getElementById('values-list');
            const newValue = document.createElement('div');
            newValue.className = 'feature-item';
            newValue.setAttribute('data-value-id', 'new_' + valueCounter);
            newValue.innerHTML = `
                <form action="restaurant-setup" method="POST" class="feature-form">
                    <input type="hidden" name="pageName" value="about">
                    <input type="hidden" name="section" value="aboutValues">
                    <input type="hidden" name="valueAction" value="add">
                    <input type="hidden" name="activeTab" value="about">
                    <input type="hidden" name="valueId" value="new_${valueCounter}">
                    
                    <div class="form-group">
                        <label>Tiêu đề:</label>
                        <input type="text" name="valueTitle" required>
                    </div>
                    <div class="form-group">
                        <label>Mô tả:</label>
                        <textarea name="valueDescription" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>Icon:</label>
                        <div class="icon-picker-container">
                            <div class="icon-picker-input-wrapper">
                                <div class="icon-preview">
                                    <i class="fa fa-star"></i>
                                </div>
                                <input type="text" name="valueIcon" class="icon-picker-input" 
                                       value="fa fa-star" placeholder="fa fa-star" readonly>
                                <button type="button" class="icon-picker-btn" onclick="openIconPicker(this)">
                                    <i class="fa fa-search"></i> Chọn icon
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="feature-actions">
                        <button type="submit" class="btn btn-sm btn-primary">
                            <i class="fa fa-save"></i> Lưu
                        </button>
                        <button type="button" class="btn btn-sm btn-secondary" onclick="this.closest('.feature-item').remove()">
                            <i class="fa fa-times"></i> Hủy
                        </button>
                    </div>
                </form>
            `;
            valuesList.appendChild(newValue);
        }
        
        function deleteValue(valueId) {
            if (confirm('Bạn có chắc muốn xóa value card này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'restaurant-setup';
                
                form.appendChild(createHiddenInput('pageName', 'about'));
                form.appendChild(createHiddenInput('section', 'aboutValues'));
                form.appendChild(createHiddenInput('valueAction', 'delete'));
                form.appendChild(createHiddenInput('valueId', valueId));
                form.appendChild(createHiddenInput('activeTab', 'about'));
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // ========== Gallery Management ==========
        let galleryCounter = 0;
        
        function addNewGalleryImage() {
            galleryCounter++;
            const galleryList = document.getElementById('gallery-list');
            const newGallery = document.createElement('div');
            newGallery.className = 'feature-item';
            newGallery.setAttribute('data-gallery-id', 'new_' + galleryCounter);
            newGallery.innerHTML = `
                <form action="restaurant-setup" method="POST" enctype="multipart/form-data" class="feature-form">
                    <input type="hidden" name="pageName" value="about">
                    <input type="hidden" name="section" value="aboutGallery">
                    <input type="hidden" name="galleryAction" value="add">
                    <input type="hidden" name="activeTab" value="about">
                    <input type="hidden" name="galleryId" value="new_${galleryCounter}">
                    
                    <div class="form-group">
                        <label>Ảnh:</label>
                        <input type="file" name="galleryImage" accept="image/*" class="file-input" required>
                        <input type="hidden" name="imageFieldName" value="galleryImage">
                        <small>Chọn ảnh từ máy tính</small>
                    </div>
                    
                    <div class="feature-actions">
                        <button type="submit" class="btn btn-sm btn-primary">
                            <i class="fa fa-save"></i> Lưu
                        </button>
                        <button type="button" class="btn btn-sm btn-secondary" onclick="this.closest('.feature-item').remove()">
                            <i class="fa fa-times"></i> Hủy
                        </button>
                    </div>
                </form>
            `;
            galleryList.appendChild(newGallery);
        }
        
        function deleteGalleryImage(galleryId) {
            if (confirm('Bạn có chắc muốn xóa ảnh này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'restaurant-setup';
                
                form.appendChild(createHiddenInput('pageName', 'about'));
                form.appendChild(createHiddenInput('section', 'aboutGallery'));
                form.appendChild(createHiddenInput('galleryAction', 'delete'));
                form.appendChild(createHiddenInput('galleryId', galleryId));
                form.appendChild(createHiddenInput('activeTab', 'about'));
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        let contactInfoCounter = ${fn:length(contactInfoItems) > 0 ? (fn:length(contactInfoItems) / 3) : 0};
        
        function addNewContactInfo() {
            contactInfoCounter++;
            const contactInfoList = document.getElementById('contact-info-list');
            const newContactInfo = document.createElement('div');
            newContactInfo.className = 'feature-item';
            newContactInfo.setAttribute('data-info-id', 'new_' + contactInfoCounter);
            newContactInfo.innerHTML = `
                <form action="restaurant-setup" method="POST" class="feature-form">
                    <input type="hidden" name="pageName" value="contact">
                    <input type="hidden" name="section" value="contactInfo">
                    <input type="hidden" name="infoAction" value="add">
                    <input type="hidden" name="activeTab" value="contact">
                    <input type="hidden" name="infoId" value="new_${contactInfoCounter}">
                    
                    <div class="form-group">
                        <label>Tiêu đề:</label>
                        <input type="text" name="infoTitle" required>
                    </div>
                    <div class="form-group">
                        <label>Nội dung (có thể dùng &lt;br&gt; để xuống dòng):</label>
                        <textarea name="infoContent" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>Icon:</label>
                        <div class="icon-picker-container">
                            <div class="icon-picker-input-wrapper">
                                <div class="icon-preview">
                                    <i class="fa fa-star"></i>
                                </div>
                                <input type="text" name="infoIcon" class="icon-picker-input" 
                                       value="fa fa-star" placeholder="fa fa-star" readonly>
                                <button type="button" class="icon-picker-btn" onclick="openIconPicker(this)">
                                    <i class="fa fa-search"></i> Chọn icon
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="feature-actions">
                        <button type="submit" class="btn btn-sm btn-primary">
                            <i class="fa fa-save"></i> Lưu
                        </button>
                        <button type="button" class="btn btn-sm btn-secondary" onclick="this.closest('.feature-item').remove()">
                            <i class="fa fa-times"></i> Hủy
                        </button>
                    </div>
                </form>
            `;
            contactInfoList.appendChild(newContactInfo);
        }
        
        function deleteContactInfo(infoId) {
            if (confirm('Bạn có chắc muốn xóa contact info này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'restaurant-setup';
                
                form.appendChild(createHiddenInput('pageName', 'contact'));
                form.appendChild(createHiddenInput('section', 'contactInfo'));
                form.appendChild(createHiddenInput('infoAction', 'delete'));
                form.appendChild(createHiddenInput('infoId', infoId));
                form.appendChild(createHiddenInput('activeTab', 'contact'));
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Hàm tự động extract URL từ iframe nếu người dùng paste cả iframe code
        function handleMapUrlPaste(event) {
            setTimeout(() => {
                const textarea = document.getElementById('mapEmbedUrlInput');
                if (!textarea) return;
                
                let pastedText = textarea.value;
                
                // Kiểm tra xem có phải là iframe code không
                if (pastedText.includes('<iframe') || pastedText.includes('iframe')) {
                    // Tìm URL trong src="..."
                    const srcMatch = pastedText.match(/src=["']([^"']+)["']/i);
                    if (srcMatch && srcMatch[1]) {
                        // Extract URL từ src
                        const extractedUrl = srcMatch[1];
                        textarea.value = extractedUrl;
                        console.log('✅ Đã tự động lấy URL từ iframe:', extractedUrl);
                    } else {
                        // Thử tìm URL trực tiếp trong text
                        const urlMatch = pastedText.match(/https?:\/\/[^\s<>"']+/i);
                        if (urlMatch && urlMatch[0]) {
                            textarea.value = urlMatch[0];
                            console.log('✅ Đã tự động lấy URL:', urlMatch[0]);
                        }
                    }
                } else if (pastedText.includes('https://www.google.com/maps/embed')) {
                    // Nếu đã là URL rồi, chỉ cần trim
                    textarea.value = pastedText.trim();
                }
            }, 10);
        }
        
        function createHiddenInput(name, value) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = value;
            return input;
        }
    </script>
    
    <!-- Icon Picker Modal -->
    <div id="iconPickerModal" class="icon-picker-modal">
        <div class="icon-picker-content">
            <div class="icon-picker-header">
                <h3><i class="fa fa-icons"></i> Chọn Icon</h3>
                <button type="button" class="icon-picker-close" onclick="closeIconPicker()">
                    <i class="fa fa-times"></i>
                </button>
            </div>
            <div class="icon-grid" id="iconGrid">
                <!-- Icons sẽ được thêm bằng JavaScript -->
            </div>
        </div>
    </div>
    
    <script>
        // Danh sách các icon phổ biến cho nhà hàng
        const popularIcons = [
            // Food & Restaurant
            { class: 'fa fa-utensils', name: 'Utensils' },
            { class: 'fa fa-coffee', name: 'Coffee' },
            { class: 'fa fa-wine-glass', name: 'Wine' },
            { class: 'fa fa-birthday-cake', name: 'Cake' },
            { class: 'fa fa-pizza-slice', name: 'Pizza' },
            { class: 'fa fa-hamburger', name: 'Burger' },
            { class: 'fa fa-fish', name: 'Fish' },
            { class: 'fa fa-drumstick-bite', name: 'Chicken' },
            { class: 'fa fa-ice-cream', name: 'Ice Cream' },
            { class: 'fa fa-cookie', name: 'Cookie' },
            { class: 'fa fa-bread-slice', name: 'Bread' },
            { class: 'fa fa-cheese', name: 'Cheese' },
            
            // Common Icons
            { class: 'fa fa-star', name: 'Star' },
            { class: 'fa fa-heart', name: 'Heart' },
            { class: 'fa fa-thumbs-up', name: 'Thumbs Up' },
            { class: 'fa fa-smile', name: 'Smile' },
            { class: 'fa fa-award', name: 'Award' },
            { class: 'fa fa-trophy', name: 'Trophy' },
            { class: 'fa fa-medal', name: 'Medal' },
            { class: 'fa fa-gem', name: 'Gem' },
            { class: 'fa fa-crown', name: 'Crown' },
            { class: 'fa fa-fire', name: 'Fire' },
            
            // Space & Environment
            { class: 'fa fa-chair', name: 'Chair' },
            { class: 'fa fa-home', name: 'Home' },
            { class: 'fa fa-building', name: 'Building' },
            { class: 'fa fa-users', name: 'Users' },
            { class: 'fa fa-user-friends', name: 'Friends' },
            { class: 'fa fa-spa', name: 'Spa' },
            
            // Nature
            { class: 'fa fa-sun', name: 'Sun' },
            { class: 'fa fa-moon', name: 'Moon' },
            { class: 'fa fa-leaf', name: 'Leaf' },
            { class: 'fa fa-seedling', name: 'Seedling' },
            
            // Services
            { class: 'fa fa-clock', name: 'Clock' },
            { class: 'fa fa-calendar', name: 'Calendar' },
            { class: 'fa fa-bell', name: 'Bell' },
            { class: 'fa fa-envelope', name: 'Envelope' },
            { class: 'fa fa-phone', name: 'Phone' },
            { class: 'fa fa-map-marker-alt', name: 'Location' },
            { class: 'fa fa-globe', name: 'Globe' },
            { class: 'fa fa-wifi', name: 'WiFi' },
            
            // Quality & Trust
            { class: 'fa fa-shield-alt', name: 'Shield' },
            { class: 'fa fa-lock', name: 'Lock' },
            { class: 'fa fa-check-circle', name: 'Check' },
            { class: 'fa fa-certificate', name: 'Certificate' },
            
            // Actions
            { class: 'fa fa-gift', name: 'Gift' },
            { class: 'fa fa-shopping-bag', name: 'Shopping' },
            { class: 'fa fa-credit-card', name: 'Credit Card' },
            { class: 'fa fa-money-bill', name: 'Money' },
            { class: 'fa fa-chart-line', name: 'Chart' },
            { class: 'fa fa-trending-up', name: 'Trending' },
            
            // Media & Entertainment
            { class: 'fa fa-music', name: 'Music' },
            { class: 'fa fa-camera', name: 'Camera' },
            { class: 'fa fa-video', name: 'Video' },
            
            // Design & Style
            { class: 'fa fa-palette', name: 'Palette' },
            { class: 'fa fa-paint-brush', name: 'Paint' },
            { class: 'fa fa-lightbulb', name: 'Lightbulb' },
            
            // Navigation
            { class: 'fa fa-arrow-right', name: 'Arrow Right' },
            { class: 'fa fa-arrow-left', name: 'Arrow Left' },
            { class: 'fa fa-chevron-right', name: 'Chevron Right' },
            { class: 'fa fa-chevron-left', name: 'Chevron Left' },
            
            // Status
            { class: 'fa fa-check', name: 'Check Mark' },
            { class: 'fa fa-times-circle', name: 'Close' },
            { class: 'fa fa-exclamation-circle', name: 'Warning' },
            { class: 'fa fa-info-circle', name: 'Info' },
            { class: 'fa fa-question-circle', name: 'Question' },
        ];
        
        let currentIconInput = null;
        let currentIconPreview = null;
        
        // Khởi tạo icon grid
        function initIconGrid() {
            const grid = document.getElementById('iconGrid');
            grid.innerHTML = '';
            
            popularIcons.forEach(icon => {
                const iconItem = document.createElement('div');
                iconItem.className = 'icon-item';
                iconItem.innerHTML = '<i class="' + icon.class + '"></i><span>' + icon.name + '</span>';
                iconItem.onclick = function() { selectIcon(icon.class); };
                grid.appendChild(iconItem);
            });
        }
        
        // Mở icon picker
        function openIconPicker(btn) {
            const container = btn.closest('.icon-picker-container');
            currentIconInput = container.querySelector('.icon-picker-input');
            currentIconPreview = container.querySelector('.icon-preview i');
            
            // Đánh dấu icon hiện tại
            const currentIcon = currentIconInput.value;
            document.querySelectorAll('.icon-item').forEach(item => {
                const iconClass = item.querySelector('i').className;
                if (iconClass === currentIcon) {
                    item.classList.add('selected');
                } else {
                    item.classList.remove('selected');
                }
            });
            
            document.getElementById('iconPickerModal').classList.add('active');
        }
        
        // Đóng icon picker
        function closeIconPicker() {
            document.getElementById('iconPickerModal').classList.remove('active');
            currentIconInput = null;
            currentIconPreview = null;
        }
        
        // Chọn icon
        function selectIcon(iconClass) {
            if (currentIconInput && currentIconPreview) {
                currentIconInput.value = iconClass;
                currentIconPreview.className = iconClass;
                
                // Cập nhật selected state
                document.querySelectorAll('.icon-item').forEach(item => {
                    item.classList.remove('selected');
                    if (item.querySelector('i').className === iconClass) {
                        item.classList.add('selected');
                    }
                });
            }
        }
        
        // Đóng modal khi click bên ngoài
        document.getElementById('iconPickerModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeIconPicker();
            }
        });
        
        // Khởi tạo khi trang load
        document.addEventListener('DOMContentLoaded', function() {
            initIconGrid();
            initCategoryProductsVisibility();
        });
        
        // Toggle accordion cho category
        function toggleCategoryAccordion(categoryId) {
            const categoryCard = document.querySelector('.category-card[data-category-id="' + categoryId + '"]');
            const categoryContent = document.getElementById('category-content-' + categoryId);
            const categoryCheckbox = categoryCard.querySelector('.category-checkbox');
            
            // Chỉ mở accordion nếu category đã được chọn
            if (categoryCheckbox && !categoryCheckbox.checked) {
                // Tự động chọn category khi click vào header
                categoryCheckbox.checked = true;
                toggleCategoryProducts(categoryId, true);
                return;
            }
            
            const isExpanded = categoryContent.style.display === 'block';
            categoryContent.style.display = isExpanded ? 'none' : 'block';
            categoryCard.classList.toggle('expanded', !isExpanded);
        }
        
        // Toggle hiển thị danh sách món ăn khi chọn/bỏ chọn category
        function toggleCategoryProducts(categoryId, isChecked) {
            const categoryContent = document.getElementById('category-content-' + categoryId);
            const categoryCard = document.querySelector('.category-card[data-category-id="' + categoryId + '"]');
            
            if (categoryContent) {
                if (isChecked) {
                    categoryContent.style.display = 'block';
                    categoryCard.classList.add('expanded');
                } else {
                    categoryContent.style.display = 'none';
                    categoryCard.classList.remove('expanded');
                    // Bỏ chọn tất cả products trong category này
                    const productCheckboxes = categoryContent.querySelectorAll('.product-checkbox');
                    productCheckboxes.forEach(cb => cb.checked = false);
                    updateSelectedCount(categoryId);
                }
            }
            
            updateSelectedCount(categoryId);
        }
        
        // Lọc món ăn theo từ khóa tìm kiếm
        function filterProducts(categoryId, searchTerm) {
            const productsGrid = document.getElementById('products-grid-' + categoryId);
            if (!productsGrid) return;
            
            const searchLower = searchTerm.toLowerCase().trim();
            const productItems = productsGrid.querySelectorAll('.product-item');
            
            productItems.forEach(item => {
                const productName = item.getAttribute('data-product-name') || '';
                if (productName.includes(searchLower)) {
                    item.classList.remove('hidden');
                } else {
                    item.classList.add('hidden');
                }
            });
        }
        
        // Chọn tất cả / Bỏ chọn tất cả món ăn trong category
        function selectAllProducts(categoryId, selectAll) {
            const productsGrid = document.getElementById('products-grid-' + categoryId);
            if (!productsGrid) return;
            
            // Chỉ chọn các món đang hiển thị (không bị filter ẩn)
            const productItems = productsGrid.querySelectorAll('.product-item:not(.hidden)');
            productItems.forEach(item => {
                const checkbox = item.querySelector('.product-checkbox');
                if (checkbox) {
                    checkbox.checked = selectAll;
                }
            });
            
            updateSelectedCount(categoryId);
        }
        
        // Cập nhật số lượng món đã chọn
        function updateSelectedCount(categoryId) {
            const productsGrid = document.getElementById('products-grid-' + categoryId);
            if (!productsGrid) return;
            
            // Đếm tất cả checkbox đã checked (kể cả đang bị ẩn do filter)
            const allCheckboxes = productsGrid.querySelectorAll('.product-checkbox');
            let checkedCount = 0;
            allCheckboxes.forEach(cb => {
                if (cb.checked) checkedCount++;
            });
            
            const countElement = document.getElementById('selected-count-' + categoryId);
            if (countElement) {
                countElement.textContent = checkedCount;
            }
        }
        
        // Khởi tạo hiển thị danh sách món ăn cho các category đã được chọn
        function initCategoryProductsVisibility() {
            document.querySelectorAll('input[name="selectedCategories"]').forEach(function(checkbox) {
                const categoryId = checkbox.value;
                if (checkbox.checked) {
                    toggleCategoryProducts(categoryId, true);
                }
                // Cập nhật count cho tất cả categories (kể cả chưa chọn)
                updateSelectedCount(categoryId);
            });
        }
        
        // Cập nhật icon preview khi thay đổi input (nếu có)
        document.addEventListener('input', function(e) {
            if (e.target.classList.contains('icon-picker-input')) {
                const preview = e.target.closest('.icon-picker-input-wrapper').querySelector('.icon-preview i');
                if (preview) {
                    preview.className = e.target.value;
                }
            }
        });
        
    </script>
    
    <jsp:include page="../includes/toast-notification.jsp" />
</body>
</html>

