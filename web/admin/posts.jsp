<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý bài viết | HAH Restaurant</title>

        <%-- Đảm bảo các đường dẫn CSS này chính xác --%>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">

        <%-- Font Awesome CDN --%>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <script src="https://cdn.ckeditor.com/ckeditor5/41.0.0/classic/ckeditor.js"></script>

         <style>
             body, .admin-content, .dashboard-card, .data-table td, .data-table th {
                 color: #333 !important;
             }
             .data-table td strong {
                 color: #222 !important;
             }
             .action-buttons {
                 margin-bottom: 20px;
             }
            .search-bar {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }
            .search-bar input {
                flex: 1;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
            .search-bar button {
                padding: 10px 20px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            .search-bar button:hover {
                background: #0056b3;
            }
            .status-badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: 600;
            }
            .status-published {
                background: #d4edda;
                color: #155724;
            }
            .status-draft {
                background: #fff3cd;
                color: #856404;
            }

            /* --- Tối Ưu Hóa CSS Modal (Header/Body/Footer cố định) --- */
            .modal {
                display: none;
                position: fixed;
                z-index: 10000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(4px);
                animation: fadeIn 0.3s ease;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }
            .modal-content {
                background: linear-gradient(to bottom, #ffffff, #f8f9fa);
                margin: 3% auto;
                padding: 0;
                border: none;
                border-radius: 16px;
                width: 90%;
                max-width: 1100px;
                max-height: 95vh; /* Tăng chiều cao tối đa */
                display: flex;
                flex-direction: column;
                overflow: hidden; /* Quan trọng: Ngăn modal-content cuộn */
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.2), 0 0 60px rgba(0, 0, 0, 0.1);
                animation: slideDown 0.3s ease;
            }
            #postForm {
                /* Quan trọng: Cho form chiếm hết không gian và kiểm soát cuộn */
                display: flex;
                flex-direction: column;
                flex: 1 1 auto;
                min-height: 0;
            }
            .modal-scrollable {
                flex: 1 1 auto;
                overflow-y: auto; /* Quan trọng: Cho phép cuộn phần body */
                overflow-x: hidden;
                display: flex;
                flex-direction: column;
                min-height: 0;
                -webkit-overflow-scrolling: touch;
            }
            @keyframes slideDown {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            .modal-header {
                background: linear-gradient(135deg, #104c23 0%, #28a745 100%);
                color: white;
                padding: 20px 30px;
                border-radius: 16px 16px 0 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-shrink: 0; /* Giữ header cố định */
            }
            .modal-header h2 {
                margin: 0;
                font-size: 24px;
                font-weight: 600;
            }
            .close {
                color: white;
                font-size: 32px;
                font-weight: bold;
                cursor: pointer;
                background: rgba(255, 255, 255, 0.2);
                width: 36px;
                height: 36px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s;
                line-height: 1;
            }
            .close:hover {
                background: rgba(255, 255, 255, 0.3);
                transform: rotate(90deg);
            }
            .modal-body {
                padding: 30px;
                flex: 1 0 auto; /* Đảm bảo nó không bị co quá mức */
                min-height: fit-content;
                overflow: hidden;
            }
            .form-group {
                margin-bottom: 24px;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #333;
                font-size: 14px;
            }
            .form-group label .required {
                color: #dc3545;
                font-weight: bold;
            }
            .form-group input[type="text"],
            .form-group input[type="file"],
            .form-group select {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s;
                background: white;
            }
            .form-group input[type="file"] {
                cursor: pointer;
            }
            .form-group input:focus,
            .form-group select:focus {
                outline: none;
                border-color: #28a745;
                box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
            }
            .form-group textarea {
                width: 100%;
                min-height: 100px;
                padding: 12px 16px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 14px;
                font-family: inherit;
                resize: vertical;
            }
            /* CKEditor Custom Styles */
            .ck-editor {
                border-radius: 8px;
                overflow: hidden;
                border: 2px solid #e0e0e0;
            }
            .ck-editor {
                width: 100% !important;
            }
            .ck-editor__editable {
                min-height: 250px;
                max-height: 300px; /* Có thể tăng/giảm nếu cần */
                padding: 20px !important;
                font-size: 14px;
                overflow-y: auto !important;
            }
            .ck-toolbar {
                border: none !important;
                border-bottom: 2px solid #e0e0e0 !important;
                background: #f8f9fa !important;
                padding: 10px !important;
            }
            .modal-footer {
                padding: 20px 30px;
                background: #f8f9fa;
                border-top: 1px solid #e0e0e0;
                border-radius: 0 0 16px 16px;
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                flex-shrink: 0; /* Giữ footer cố định */
                margin-top: 0; /* Bỏ auto margin */
            }

            .btn-info {
                background-color: #0066cc !important;
                color: #ffffff !important;
                border: none !important;
            }

            .btn-info:hover {
                background-color: #0052a3 !important;
                color: #ffffff !important;
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
                    <h1><i class="fa fa-newspaper"></i> Quản lý bài viết</h1>
                </div>

                <%-- Toast notifications sẽ tự động hiển thị từ toast-notification.jsp --%>

                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="openModal('addPostModal')">
                        <i class="fa fa-plus"></i> Thêm bài viết mới
                    </button>
                </div>

                <div class="search-bar">
                    <input type="text" id="searchInput" placeholder="Tìm kiếm bài viết..." value="${searchKeyword}">
                    <button onclick="searchPosts()">
                        <i class="fa fa-search"></i> Tìm kiếm
                    </button>
                </div>

                <div class="dashboard-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tiêu đề</th>
                            <th>Món ăn</th>
                            <th>Tác giả</th>
                            <th>Trạng thái</th>
                            <th>Lượt xem</th>
                            <th>Ngày thêm/sửa đổi</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty posts}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 20px;">
                                        <i class="fa fa-info-circle"></i> Chưa có bài viết nào
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="post" items="${posts}">
                                    <tr>
                                        <td>${post.id}</td>
                                        <td><strong>${post.title}</strong></td>
                                        <td>${post.productName}</td>
                                        <td>${post.authorName}</td>
                                        <td>
                                            <span class="status-badge ${post.status == 'Published' ? 'status-published' : 'status-draft'}">
                                                ${post.status == 'Published' ? 'Đã xuất bản' : 'Bản nháp'}
                                            </span>
                                        </td>
                                        <td>${post.viewCount}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty post.updatedAt}">
                                                    <fmt:formatDate value="${post.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="posts?action=view&id=${post.id}" class="btn btn-sm btn-info">
                                                <i class="fa fa-eye"></i> Chi tiết
                                            </a>
                                            <button class="btn btn-sm btn-primary" onclick="editPost(${post.id})">
                                                <i class="fa fa-edit"></i> Sửa
                                            </button>
                                            <a href="posts?action=delete&id=${post.id}" class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này?')">
                                                <i class="fa fa-trash"></i> Xóa
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                </div>
            </div>
        </div>

        <div id="addPostModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle" style="color: white;">Thêm bài viết mới</h2>
                    <span class="close" onclick="closeModal('addPostModal')">&times;</span>
                </div>
                <form id="postForm" method="POST" action="posts" enctype="multipart/form-data">
                    <div class="modal-scrollable">
                        <div class="modal-body">
                            <input type="hidden" name="action" id="formAction" value="add">
                            <input type="hidden" name="id" id="postId">

                            <div class="form-group">
                                <label for="productId">Món ăn <span class="required">(*)</span>:</label>
                                <select id="productId" name="productId" required>
                                    <option value="">-- Chọn món ăn --</option>
                                    <c:forEach var="product" items="${products}">
                                        <option value="${product.id}">${product.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="postTitle">Tiêu đề <span class="required">(*)</span>:</label>
                                <input type="text" id="postTitle" name="title" placeholder="Nhập tiêu đề bài viết" required>
                            </div>

                            <div class="form-group">
                                <label for="featuredImageFile">Ảnh đại diện:</label>
                                <input type="file" id="featuredImageFile" name="featuredImageFile" accept="image/*" onchange="previewImage(this)">
                                <input type="hidden" id="featuredImage" name="featuredImage">
                                <div id="imagePreview" style="margin-top: 10px; display: none;">
                                    <img id="previewImg" src="" alt="Preview" style="max-width: 100%; max-height: 250px; width: auto; height: auto; border-radius: 8px; border: 2px solid #e0e0e0; object-fit: contain;">
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="postContent">Nội dung <span class="required">(*)</span>:</label>
                                <textarea id="postContent" name="content" required></textarea>
                            </div>

                            <div class="form-group">
                                <label for="postStatus">Trạng thái:</label>
                                <select id="postStatus" name="status">
                                    <option value="Draft">Bản nháp</option>
                                    <option value="Published">Đã xuất bản</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-save"></i> Lưu
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="closeModal('addPostModal')">
                            <i class="fa fa-times"></i> Hủy
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            let editor;
            let editorReady = false;

            // Function to initialize CKEditor 5
            async function initCKEditor(initialContent = '') {
                const textarea = document.querySelector('#postContent');
                if (!textarea) {
                    console.error('Textarea #postContent not found');
                    return false;
                }

                // 1. Nếu editor đang tồn tại, hủy bỏ nó trước
                if (editor) {
                    try {
                        await editor.destroy();
                        editor = null;
                        editorReady = false;
                    } catch (e) {
                        // console.log('Editor already destroyed or not initialized');
                    }
                }

                // 2. Kiểm tra CKEditor đã load chưa
                if (typeof ClassicEditor === 'undefined') {
                    // console.error('CKEditor 5 is not loaded, retrying...');
                    setTimeout(() => initCKEditor(initialContent), 500);
                    return false;
                }

                try {
                    // 3. Đặt nội dung ban đầu vào textarea trước khi khởi tạo
                    textarea.value = initialContent;

                    // 4. Khởi tạo Classic Editor
                    ClassicEditor
                            .create(textarea, {
                                toolbar: {
                                    items: [
                                        'heading', '|',
                                        'bold', 'italic', 'underline', 'strikethrough', '|',
                                        'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor', '|',
                                        'alignment', '|',
                                        'numberedList', 'bulletedList', '|',
                                        'outdent', 'indent', '|',
                                        'link', 'blockQuote', 'insertTable', '|',
                                        'imageUpload', 'mediaEmbed', '|', // Dùng imageUpload cho việc tải ảnh lên
                                        'undo', 'redo', '|',
                                        'sourceEditing'
                                    ],
                                    shouldNotGroupWhenFull: true
                                },
                                language: 'vi',
                                heading: {
                                    options: [
                                        {model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph'},
                                        {model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1'},
                                        {model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2'},
                                        {model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3'}
                                    ]
                                },
                                // Thêm cấu hình upload ảnh nếu bạn tự xử lý phía Server
                                image: {
                                    toolbar: [
                                        'imageTextAlternative',
                                        'imageStyle:inline',
                                        'imageStyle:block',
                                        'imageStyle:side'
                                    ]
                                },
                                table: {
                                    contentToolbar: [
                                        'tableColumn',
                                        'tableRow',
                                        'mergeTableCells'
                                    ]
                                },
                                // NOTE: Bạn cần cài đặt Image Upload Adapter cho CKEditor để xử lý việc tải ảnh lên server
                                // Ví dụ: SimpleUploadAdapter hoặc bạn tự xây dựng adapter
                                simpleUpload: {
                                    // Ví dụ về cấu hình upload ảnh đơn giản (cần backend xử lý)
                                    // uploadUrl: '${pageContext.request.contextPath}/api/upload-image', 
                                    // headers: { ... }
                                }
                            })
                            .then(newEditor => {
                                editor = newEditor;
                                editorReady = true;
                                // console.log('CKEditor 5 initialized successfully');
                                // Thiết lập nội dung ban đầu (đã được đặt vào textarea ở bước 3)
                                editor.setData(initialContent);
                            })
                            .catch(error => {
                                console.error('Error initializing CKEditor 5:', error);
                                editorReady = false;
                            });

                    return true;
                } catch (e) {
                    console.error('Error initializing CKEditor:', e);
                    editorReady = false;
                    return false;
            }
            }

            function openModal(modalId) {
                document.getElementById(modalId).style.display = 'block';

                if (modalId === 'addPostModal') {
                    // Đảm bảo editor được khởi tạo sau khi modal visible
                    setTimeout(function () {
                        const postContent = document.getElementById('postContent').value || '';
                        initCKEditor(postContent);
                    }, 300);
                }
            }

            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
                // Tùy chọn: Hủy editor để tránh rò rỉ bộ nhớ (khuyến nghị)
                if (editor) {
                    editor.destroy().catch(e => console.log('Editor destroy failed:', e));
                    editor = null;
                    editorReady = false;
                }
                // Reset form sau khi đóng modal
                document.getElementById('postForm').reset();
                document.getElementById('imagePreview').style.display = 'none';
            }

            // Preview ảnh khi chọn file
            function previewImage(input) {
                const previewDiv = document.getElementById('imagePreview');
                const previewImg = document.getElementById('previewImg');
                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        previewImg.src = e.target.result;
                        previewDiv.style.display = 'block';
                    };
                    reader.readAsDataURL(input.files[0]);
                } else {
                    previewImg.src = '';
                    previewDiv.style.display = 'none';
                }
            }

            function editPost(id) {
                // Chuyển hướng sang trang edit để load dữ liệu (bao gồm nội dung) từ server
                window.location.href = 'posts?action=edit&id=' + id;
            }

            function searchPosts() {
                const keyword = document.getElementById('searchInput').value;
                if (keyword.trim()) {
                    window.location.href = 'posts?search=' + encodeURIComponent(keyword);
                } else {
                    window.location.href = 'posts';
                }
            }

            // Search on Enter key
            document.getElementById('searchInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    searchPosts();
                }
            });

            // Close modal when clicking outside
            window.onclick = function (event) {
                const modals = document.getElementsByClassName('modal');
                for (let modal of modals) {
                    if (event.target === modal) {
                        closeModal(modal.id);
                    }
                }
            }
            
            // Close modal when pressing ESC key
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape' || event.keyCode === 27) {
                    const modals = document.getElementsByClassName('modal');
                    for (let modal of modals) {
                        if (modal.style.display === 'block') {
                            closeModal(modal.id);
                            break;
                        }
                    }
                }
            });

            // Update form before submit to include CKEditor content
            document.getElementById('postForm').addEventListener('submit', function (e) {
                // Lấy nội dung từ CKEditor 5 và cập nhật vào textarea
                const content = (editor && editorReady) ? editor.getData() : document.getElementById('postContent').value;

                // Validate các trường trước
                const title = document.getElementById('postTitle').value.trim();
                const productId = document.getElementById('productId').value;

                if (!title) {
                    e.preventDefault();
                    alert('Vui lòng nhập tiêu đề bài viết!');
                    return false;
                }

                if (!productId) {
                    e.preventDefault();
                    alert('Vui lòng chọn món ăn!');
                    return false;
                }

                if (!content || content.trim() === '' || content.trim() === '<p></p>') {
                    e.preventDefault();
                    alert('Vui lòng nhập nội dung bài viết!');
                    return false;
                }

                // Cập nhật textarea với nội dung từ CKEditor
                document.getElementById('postContent').value = content;

                // console.log('Form submitting with content length:', content.length);
            });
        </script>

        <c:if test="${not empty editPost}">
            <div id="editPostContent" style="display: none;">
                <c:out value="${editPost.content}" escapeXml="false" />
            </div>
            <script>
                window.addEventListener('DOMContentLoaded', function () {
                    // Đặt dữ liệu vào form
                    const postContentDiv = document.getElementById('editPostContent');
                    const postContent = postContentDiv ? postContentDiv.innerHTML : '';

                    document.getElementById('postId').value = ${editPost.id};
                    document.getElementById('formAction').value = 'update';
                    document.getElementById('postTitle').value = '<c:out value="${editPost.title}" escapeXml="true" />';
                    document.getElementById('productId').value = ${editPost.productId};
                    document.getElementById('postStatus').value = '${editPost.status}';
                    document.getElementById('featuredImage').value = '<c:out value="${editPost.featuredImage != null ? editPost.featuredImage : ''}" escapeXml="true" />';

                    // Hiển thị ảnh cũ nếu có
                    const oldImg = document.getElementById('featuredImage').value;
                    if (oldImg) {
                        document.getElementById('previewImg').src = oldImg; // Giả định oldImg là URL truy cập được
                        document.getElementById('imagePreview').style.display = 'block';
                    }

                    // Đặt nội dung vào textarea trước khi mở modal
                    document.getElementById('postContent').value = postContent;

                    // Mở modal và khởi tạo CKEditor với nội dung đã tải
                    openModal('addPostModal');

                    // Cập nhật tiêu đề modal
                    document.getElementById('modalTitle').textContent = 'Sửa bài viết';
                });
            </script>
        </c:if>
    <jsp:include page="../includes/toast-notification.jsp" />
    </body>
</html>