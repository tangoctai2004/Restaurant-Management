<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<!-- Toast Notification Component -->
<style>
    .toast-container {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 10000;
        display: flex;
        flex-direction: column;
        gap: 10px;
        pointer-events: none;
    }
    
    .toast {
        padding: 16px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        display: flex;
        align-items: center;
        gap: 12px;
        min-width: 300px;
        max-width: 500px;
        animation: slideInRight 0.3s ease-out, fadeOut 0.3s ease-in 2.7s forwards;
        pointer-events: auto;
        color: #fff;
    }
    
    .toast.success {
        background: #28a745;
    }
    
    .toast.error {
        background: #dc3545;
    }
    
    .toast i {
        font-size: 20px;
        flex-shrink: 0;
    }
    
    .toast-message {
        flex: 1;
        font-size: 15px;
        font-weight: 500;
        line-height: 1.4;
    }
    
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes fadeOut {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100%);
        }
    }
    
    @media (max-width: 768px) {
        .toast-container {
            bottom: 10px;
            right: 10px;
            left: 10px;
        }
        
        .toast {
            min-width: auto;
            max-width: 100%;
        }
    }
</style>

<div class="toast-container" id="toastContainer"></div>

<c:if test="${not empty successMessage}">
    <div id="toast-success-message" style="display: none;"><c:out value="${successMessage}" /></div>
    <c:remove var="successMessage" scope="session" />
</c:if>

<c:if test="${not empty error}">
    <div id="toast-error-message" style="display: none;"><c:out value="${error}" /></div>
    <c:remove var="error" scope="session" />
</c:if>

<c:if test="${not empty flashSuccess}">
    <div id="toast-flash-success-message" style="display: none;"><c:out value="${flashSuccess}" /></div>
    <c:remove var="flashSuccess" scope="session" />
</c:if>

<script>
    function showToast(message, isError) {
        if (!message || message.trim() === '') return;
        
        const container = document.getElementById('toastContainer');
        if (!container) return;
        
        const toast = document.createElement('div');
        toast.className = 'toast ' + (isError ? 'error' : 'success');
        
        // Tạo icon element
        const iconElement = document.createElement('i');
        iconElement.className = 'fa ' + (isError ? 'fa-exclamation-circle' : 'fa-check-circle');
        
        // Tạo message element
        const messageElement = document.createElement('span');
        messageElement.className = 'toast-message';
        messageElement.textContent = message; // textContent tự động escape HTML
        
        // Append elements
        toast.appendChild(iconElement);
        toast.appendChild(messageElement);
        
        container.appendChild(toast);
        
        // Tự động xóa sau 3 giây
        setTimeout(() => {
            toast.style.animation = 'fadeOut 0.3s ease-in forwards';
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 300);
        }, 3000);
    }
    
    // Tự động hiển thị thông báo từ session khi trang load
    document.addEventListener('DOMContentLoaded', function() {
        const successMsgEl = document.getElementById('toast-success-message');
        if (successMsgEl) {
            showToast(successMsgEl.textContent || successMsgEl.innerText, false);
            successMsgEl.remove();
        }
        
        const errorMsgEl = document.getElementById('toast-error-message');
        if (errorMsgEl) {
            showToast(errorMsgEl.textContent || errorMsgEl.innerText, true);
            errorMsgEl.remove();
        }
        
        const flashSuccessMsgEl = document.getElementById('toast-flash-success-message');
        if (flashSuccessMsgEl) {
            showToast(flashSuccessMsgEl.textContent || flashSuccessMsgEl.innerText, false);
            flashSuccessMsgEl.remove();
        }
    });
</script>

