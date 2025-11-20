package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CharacterEncodingFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI();
        
        // BỎ QUA HOÀN TOÀN static resources - không can thiệp gì cả
        if (isStaticResource(requestURI)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Chỉ xử lý cho HTML/JSP requests
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        chain.doFilter(request, response);
    }
    
    /**
     * Kiểm tra xem request có phải là static resource không
     */
    private boolean isStaticResource(String requestURI) {
        // Loại bỏ context path nếu có
        String path = requestURI;
        if (path.contains("/css/") || path.contains("/js/") || path.contains("/images/")) {
            return true;
        }
        
        // Kiểm tra extension
        return path.endsWith(".css") ||
               path.endsWith(".js") ||
               path.endsWith(".png") ||
               path.endsWith(".jpg") ||
               path.endsWith(".jpeg") ||
               path.endsWith(".gif") ||
               path.endsWith(".svg") ||
               path.endsWith(".ico") ||
               path.endsWith(".woff") ||
               path.endsWith(".woff2") ||
               path.endsWith(".ttf") ||
               path.endsWith(".eot");
    }
    
    @Override
    public void destroy() {
    }
}



