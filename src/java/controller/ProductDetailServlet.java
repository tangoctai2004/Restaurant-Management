package controller;

import dao.PostDAO;
import dao.ProductDAO;
import model.Post;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private PostDAO postDAO = new PostDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String productIdStr = request.getParameter("id");
            
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Không tìm thấy món ăn!");
                request.getRequestDispatcher("product-detail.jsp").forward(request, response);
                return;
            }
            
            int productId = Integer.parseInt(productIdStr.trim());
            
            // Lấy thông tin món ăn
            Product product = productDAO.getById(productId);
            if (product == null) {
                request.setAttribute("error", "Không tìm thấy món ăn!");
                request.getRequestDispatcher("product-detail.jsp").forward(request, response);
                return;
            }
            
            // Lấy bài viết của món ăn (chỉ lấy bài đã Published)
            Post post = postDAO.getByProductId(productId);
            
            // Tăng lượt xem nếu có bài viết
            if (post != null) {
                postDAO.incrementViewCount(post.getId());
            }
            
            request.setAttribute("product", product);
            request.setAttribute("post", post);
            
            request.getRequestDispatcher("product-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID món ăn không hợp lệ!");
            request.getRequestDispatcher("product-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("product-detail.jsp").forward(request, response);
        }
    }
}

