package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(filterName = "StaticResourceFilter", urlPatterns = {"/css/*", "/js/*", "/images/*"})
public class StaticResourceFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        
        // Set content type và cache control headers cho static resources
        if (requestURI.endsWith(".css")) {
            // CSS không cần charset trong content type
            httpResponse.setContentType("text/css");
            // Cache trong 1 giờ, sau đó phải revalidate
            httpResponse.setHeader("Cache-Control", "public, max-age=3600, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
        } else if (requestURI.endsWith(".js")) {
            httpResponse.setContentType("application/javascript; charset=UTF-8");
            httpResponse.setHeader("Cache-Control", "public, max-age=3600, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
        } else if (requestURI.matches(".*\\.(png|jpg|jpeg|gif|svg|ico)$")) {
            httpResponse.setHeader("Cache-Control", "public, max-age=86400"); // 1 ngày cho images
        }
        
        // KHÔNG set character encoding cho static resources
        // Để server tự xử lý theo MIME type
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Không cần cleanup
    }
}

