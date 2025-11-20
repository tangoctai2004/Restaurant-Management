package controller;

import dao.PostDAO;
import dao.ProductDAO;
import model.Post;
import model.Product;
import model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminPostsServlet", urlPatterns = {"/admin/posts"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminPostsServlet extends HttpServlet {
    
    private PostDAO postDAO = new PostDAO();
    private ProductDAO productDAO = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        // Kiểm tra permission POSTS
        if (account.getRole() != 1 && !util.PermissionHelper.hasPermission(session, "POSTS")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Bài viết!");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String search = request.getParameter("search");
        
        // Xử lý xem chi tiết
        if ("view".equals(action) && idStr != null) {
            try {
                int postId = Integer.parseInt(idStr);
                Post post = postDAO.getById(postId);
                if (post != null) {
                    request.setAttribute("post", post);
                    request.getRequestDispatcher("/admin/post-detail.jsp").forward(request, response);
                    return;
                } else {
                    session.setAttribute("error", "Không tìm thấy bài viết!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID bài viết không hợp lệ!");
            }
        }
        
        // Xử lý sửa bài viết - load dữ liệu để hiển thị trong modal
        if ("edit".equals(action) && idStr != null) {
            try {
                int postId = Integer.parseInt(idStr);
                Post post = postDAO.getById(postId);
                if (post != null) {
                    request.setAttribute("editPost", post);
                    // Load lại danh sách posts và products
                    List<Post> posts = postDAO.getAll();
                    List<Product> products = productDAO.getAll();
                    request.setAttribute("posts", posts);
                    request.setAttribute("products", products);
                    
                    // Lấy flash messages từ session
                    String successMessage = (String) session.getAttribute("successMessage");
                    String errorMessage = (String) session.getAttribute("error");
                    if (successMessage != null) {
                        request.setAttribute("successMessage", successMessage);
                        session.removeAttribute("successMessage");
                    }
                    if (errorMessage != null) {
                        request.setAttribute("error", errorMessage);
                        session.removeAttribute("error");
                    }
                    
                    request.getRequestDispatcher("/admin/posts.jsp").forward(request, response);
                    return;
                } else {
                    session.setAttribute("error", "Không tìm thấy bài viết!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID bài viết không hợp lệ!");
            }
        }
        
        // Xử lý xóa
        if ("delete".equals(action) && idStr != null) {
            try {
                int postId = Integer.parseInt(idStr);
                boolean success = postDAO.delete(postId);
                if (success) {
                    session.setAttribute("successMessage", "Đã xóa bài viết thành công!");
                } else {
                    session.setAttribute("error", "Không thể xóa bài viết!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID bài viết không hợp lệ!");
            }
            response.sendRedirect("posts");
            return;
        }
        
        // Lấy danh sách posts
        List<Post> posts;
        if (search != null && !search.trim().isEmpty()) {
            posts = postDAO.search(search.trim());
            request.setAttribute("searchKeyword", search);
        } else {
            posts = postDAO.getAll();
        }
        
        // Lấy danh sách products để chọn khi tạo/sửa post
        List<Product> products = productDAO.getAll();
        request.setAttribute("products", products);
        
        request.setAttribute("posts", posts);
        
        // Lấy flash messages từ session
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("error");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            session.removeAttribute("error");
        }
        
        request.getRequestDispatcher("/admin/posts.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (account == null || (account.getRole() != 1 && account.getRole() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }
        
        // Kiểm tra permission POSTS
        if (account.getRole() != 1 && !util.PermissionHelper.hasPermission(session, "POSTS")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập Bài viết!");
            return;
        }
        
        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        String idStr = request.getParameter("id");
        
        // Validation
        if (productIdStr == null || productIdStr.trim().isEmpty() ||
            title == null || title.trim().isEmpty() ||
            content == null || content.trim().isEmpty()) {
            session.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect("posts");
            return;
        }
        
        // Xử lý upload ảnh đại diện
        String currentImageUrl = null;
        if ("update".equals(action) && idStr != null) {
            try {
                Post existingPost = postDAO.getById(Integer.parseInt(idStr));
                if (existingPost != null) {
                    currentImageUrl = existingPost.getFeaturedImage();
                }
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        String uploadedImageUrl = handleImageUpload(request, currentImageUrl);
        
        try {
            Post post = new Post();
            post.setProductId(Integer.parseInt(productIdStr.trim()));
            post.setTitle(title.trim());
            post.setContent(content); // HTML content từ CKEditor
            post.setFeaturedImage(uploadedImageUrl != null && !uploadedImageUrl.trim().isEmpty() ? uploadedImageUrl.trim() : null);
            post.setStatus(status != null ? status : "Draft");
            post.setAuthorId(account.getId());
            
            boolean success = false;
            if ("add".equals(action)) {
                success = postDAO.create(post);
                if (success) {
                    session.setAttribute("successMessage", "Thêm bài viết thành công!");
                } else {
                    session.setAttribute("error", "Không thể thêm bài viết!");
                }
            } else if ("update".equals(action)) {
                if (idStr != null) {
                    post.setId(Integer.parseInt(idStr));
                    success = postDAO.update(post);
                    if (success) {
                        session.setAttribute("successMessage", "Cập nhật bài viết thành công!");
                    } else {
                        session.setAttribute("error", "Không thể cập nhật bài viết!");
                    }
                }
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        
        response.sendRedirect("posts");
    }
    
    /**
     * Xử lý upload file ảnh
     * @param request HttpServletRequest
     * @param existingImageUrl URL ảnh hiện tại (nếu có, dùng khi không upload ảnh mới)
     * @return Đường dẫn ảnh (URL) để lưu vào database
     */
    private String handleImageUpload(HttpServletRequest request, String existingImageUrl) {
        try {
            Part filePart = request.getPart("featuredImageFile");
            
            // Nếu không có file upload, giữ nguyên ảnh cũ (khi sửa)
            if (filePart == null || filePart.getSize() == 0) {
                return existingImageUrl != null && !existingImageUrl.trim().isEmpty() 
                    ? existingImageUrl.trim() : null;
            }
            
            // Lấy tên file gốc
            String fileName = filePart.getSubmittedFileName();
            if (fileName == null || fileName.isEmpty()) {
                return existingImageUrl != null && !existingImageUrl.trim().isEmpty() 
                    ? existingImageUrl.trim() : null;
            }
            
            // Lấy extension của file
            String extension = "";
            int lastDotIndex = fileName.lastIndexOf('.');
            if (lastDotIndex > 0) {
                extension = fileName.substring(lastDotIndex);
            }
            
            // Tạo tên file mới (UUID để tránh trùng lặp)
            String newFileName = "post_" + UUID.randomUUID().toString() + extension;
            
            // Lấy đường dẫn thư mục images trong webapp
            String uploadPath = getServletContext().getRealPath("/images");
            File uploadDir = new File(uploadPath);
            
            // Tạo thư mục nếu chưa tồn tại
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Đường dẫn file đầy đủ
            File file = new File(uploadDir, newFileName);
            
            // Lưu file
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Trả về đường dẫn để lưu vào database (relative path)
            return "images/" + newFileName;
            
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            // Nếu có lỗi, trả về ảnh cũ hoặc null
            return existingImageUrl != null && !existingImageUrl.trim().isEmpty() 
                ? existingImageUrl.trim() : null;
        }
    }
}


