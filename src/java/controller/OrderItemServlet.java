package controller;

import dao.ProductDAO;
import model.CartItem;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderItemServlet", urlPatterns = {"/orderitem"})
public class OrderItemServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    
    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        
        if ("add".equals(action)) {
            String productIdStr = request.getParameter("productId");
            if (productIdStr != null) {
                try {
                    int productId = Integer.parseInt(productIdStr);
                    Product product = productDAO.getById(productId);
                    
                    if (product != null) {
                        // Kiểm tra xem sản phẩm đã có trong giỏ chưa
                        boolean found = false;
                        for (CartItem item : cart) {
                            if (item.getProduct().getId() == productId) {
                                item.setQuantity(item.getQuantity() + 1);
                                found = true;
                                break;
                            }
                        }
                        
                        if (!found) {
                            CartItem newItem = new CartItem(product, 1, product.getPrice());
                            cart.add(newItem);
                        }
                        
                        session.setAttribute("flashSuccess", "Đã thêm món vào giỏ hàng!");
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("menu");
            
        } else if ("update".equals(action)) {
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");
            
            if (productIdStr != null && quantityStr != null) {
                try {
                    int productId = Integer.parseInt(productIdStr);
                    int quantity = Integer.parseInt(quantityStr);
                    
                    if (quantity > 0) {
                        for (CartItem item : cart) {
                            if (item.getProduct().getId() == productId) {
                                item.setQuantity(quantity);
                                break;
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("cart");
            
        } else if ("remove".equals(action)) {
            String productIdStr = request.getParameter("productId");
            if (productIdStr != null) {
                try {
                    int productId = Integer.parseInt(productIdStr);
                    cart.removeIf(item -> item.getProduct().getId() == productId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("cart");
        }
    }
}

