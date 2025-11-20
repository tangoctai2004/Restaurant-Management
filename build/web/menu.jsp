<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thực đơn | HAH Restaurant</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <style>
        /* CSS GỐC CỦA BẠN */
        .menu-layout{display:flex;align-items:flex-start;gap:30px;padding:40px 80px;}
        .menu-sidebar{flex:0 0 220px;background:#f8f8f8;padding:20px;border-radius:10px;}
        .menu-sidebar ul{list-style:none;padding:0;margin:0}
        .menu-sidebar li{margin:12px 0}
        .menu-sidebar a{text-decoration:none;color:#222;font-weight:600;transition:.3s}
        .menu-sidebar li.active a,.menu-sidebar a:hover{color:#d39e00}
        .menu-items{display:grid;grid-template-columns:repeat(var(--items-per-row, 4), 1fr);gap:25px;flex:1}
        .menu-card{background:#fff;border-radius:10px;overflow:hidden;width:100%;text-align:center;box-shadow:0 2px 10px rgba(0,0,0,.1);transition:.3s}
        .menu-card:hover{transform:translateY(-5px)}
        .menu-card img{width:100%;height:180px;object-fit:cover}
        .menu-card h4{margin:12px 0 4px;color:#333}
        .price{color:#e53935;font-weight:700;margin-bottom:12px}
        .buttons{margin-bottom:15px}
        .buttons .btn{padding:6px 12px;border:1px solid #ffc107;border-radius:20px;margin:0 4px;background:none;cursor:pointer;transition:.3s}
        .buttons .btn:hover{background:#ffc107;color:#fff}
        .menu-category-item { display: block; }
        
        /* === THÊM CSS CHO THÔNG BÁO (TOAST) === */
        /* (Bạn đã có CSS này, nhưng tôi thêm container) */
        #toast-container {
            position: fixed;
            bottom: 25px;
            right: 25px;
            z-index: 2000;
            display: flex;
            flex-direction: column; /* Xếp chồng */
            gap: 10px; 
        }
        .toast-notification {
            background-color: #28a745; 
            color: white;
            padding: 16px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.4s ease;
        }
        .toast-notification.show {
            opacity: 1;
            transform: translateX(0);
        }
        .menu-sidebar .btn-view-cart {
            display: block;
            width: 100%;
            padding: 12px 10px; /* Tăng padding 1 chút */
            margin-top: 20px;
            
            /* Thay đổi chính: Nền vàng, chữ đen */
            background: #ffc107;
            color: #000; 
            
            border: none; /* Bỏ viền */
            font-weight: 700; /* Chữ đậm hơn */
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            font-size: 14px;
            
            transition: all 0.3s ease; /* Giữ nguyên transition */
        }

        .menu-sidebar .btn-view-cart:hover {
            background: #e0a800; /* Màu vàng đậm hơn khi hover */
            color: #000;
            transform: translateY(-2px); /* Hiệu ứng nhấc lên */
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Thêm bóng đổ nhẹ */
        }

        /* Thêm khoảng cách cho icon (nếu có) */
        .menu-sidebar .btn-view-cart i {
            margin-right: 8px; 
        }
    </style>
</head>

<body>
    <jsp:include page="header.jsp" /> 

    <div style="padding:16px 80px;color:#888">Trang chủ / <span>Thực đơn</span></div>

    <section class="menu-page">
        <div class="menu-layout">
            <aside class="menu-sidebar reveal">
                <h3 class="sidebar-title" style="margin-top:0">THỰC ĐƠN</h3>
                <ul>
                    <li class="active"><a href="#" onclick="showCategory('all', this, event)">Tất cả</a></li>
                    <c:forEach var="cat" items="${categories}">
                        <li><a href="#" onclick="showCategory('cat-${cat.id}', this, event)">${cat.name}</a></li>
                    </c:forEach>
                </ul>
                <c:if test="${hasActiveOrder == true}">
                    <a href="cart" class="btn-view-cart">
                        <i class="fa fa-shopping-cart"></i> Xem thực đơn đã đặt
                    </a>
                </c:if>
            </aside>

            <div style="flex: 1;">
                <!-- Thanh tìm kiếm -->
                <c:if test="${menuSettings['showSearchBox'] != 'false'}">
                    <div class="search-box reveal" style="margin-bottom: 30px;">
                        <div style="position: relative; max-width: 500px; width: 176%;">
                            <input type="text" id="searchInput" placeholder="Tìm kiếm món ăn..." 
                                   style="width: 100%; padding: 12px 45px 12px 15px; border: 1px solid #ddd; border-radius: 10px; outline: none; font-size: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                            <i class="fa fa-search" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #888; pointer-events: none; font-size: 16px;"></i>
                        </div>
                    </div>
                </c:if>
                
                <style>
                    #menuItems {
                        grid-template-columns: repeat(<c:out value='${itemsPerRow != null ? itemsPerRow : 4}'/>, 1fr);
                    }
                </style>
                <div class="menu-items" id="menuItems">
                    <c:forEach var="cat" items="${categories}">
                        <c:set var="categoryProducts" value="${productsByCategory[cat.id]}" />
                        <c:if test="${not empty categoryProducts}">
                            <c:forEach var="p" items="${categoryProducts}">
                                <div class="menu-card menu-category-item cat-${p.categoryId} reveal">
                                    <img src="${p.imageUrl}" alt="${p.name}">
                                    <h4>${p.name}</h4>
                                    <p class="price"><fmt:formatNumber value="${p.price}" type="currency" currencyCode="VND" minFractionDigits="0"/></p>
                                    <c:if test="${menuSettings['showDetailButton'] != 'false'}">
                                        <div class="buttons">
                                            <a href="product-detail?id=${p.id}" class="btn">Xem chi tiết</a>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="includes/footer.jsp" />

    
    <div id="toast-container">
        <c:if test="${not empty flashSuccess}">
            <div id="toastNotification" class="toast-notification">
                <i class="fa-solid fa-circle-check"></i>
                <span>${flashSuccess}</span>
            </div>
        </c:if>
    </div>
    
    <script>
        let currentCategory = 'all';
        
        // 1. Hàm chuyển tab (Giữ lại)
        function showCategory(id, link, ev) {
            if (ev) ev.preventDefault();
            currentCategory = id;
            document.querySelectorAll(".menu-sidebar li").forEach(li => li.classList.remove("active"));
            link.parentElement.classList.add("active");
            filterProducts();
        }
        
        // 2. Hàm tìm kiếm và lọc sản phẩm
        function filterProducts() {
            const searchKeyword = document.getElementById('searchInput').value.toLowerCase().trim();
            const allItems = document.querySelectorAll('.menu-category-item');
            let visibleCount = 0;
            
            allItems.forEach(item => {
                const productName = item.querySelector('h4').textContent.toLowerCase();
                const categoryClass = currentCategory === 'all' ? true : item.classList.contains(currentCategory);
                const matchesSearch = searchKeyword === '' || productName.includes(searchKeyword);
                
                if (categoryClass && matchesSearch) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });
            
            // Hiển thị thông báo nếu không tìm thấy
            const menuItems = document.getElementById('menuItems');
            let noResultsMsg = document.getElementById('noResultsMessage');
            
            if (visibleCount === 0) {
                if (!noResultsMsg) {
                    noResultsMsg = document.createElement('div');
                    noResultsMsg.id = 'noResultsMessage';
                    noResultsMsg.style.cssText = 'width: 100%; text-align: center; padding: 40px; color: #666;';
                    noResultsMsg.innerHTML = '<i class="fa fa-search" style="font-size: 48px; margin-bottom: 15px; color: #ccc;"></i><h3>Không tìm thấy món ăn</h3><p>Vui lòng thử lại với từ khóa khác</p>';
                    menuItems.appendChild(noResultsMsg);
                }
            } else {
                if (noResultsMsg) {
                    noResultsMsg.remove();
                }
            }
        }
        
        // 3. Logic Kích hoạt
        document.addEventListener("DOMContentLoaded", () => {
             // Kích hoạt tab
             const firstCategoryLink = document.querySelector(".menu-sidebar li.active a");
            if (firstCategoryLink) {
                 showCategory('all', firstCategoryLink, null);
            }
            
            // Thêm event listener cho thanh tìm kiếm
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.addEventListener('input', filterProducts);
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        filterProducts();
                    }
                });
            }
            
            // === LOGIC HIỂN THỊ THÔNG BÁO (NẾU CÓ) ===
            const toast = document.getElementById("toastNotification");
            if (toast) {
                // 1. Hiển thị thông báo
                setTimeout(() => {
                    toast.classList.add("show");
                }, 100); 

                // 2. Tự động ẩn thông báo sau 3 giây
                setTimeout(() => {
                    toast.classList.remove("show");
                    // Tùy chọn: Xóa hẳn khỏi DOM
                    setTimeout(() => { toast.remove(); }, 400); 
                }, 3000); // 3 giây
            }
            // === KẾT THÚC LOGIC MỚI ===
        });
        
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
    </script>
</body>
</html>