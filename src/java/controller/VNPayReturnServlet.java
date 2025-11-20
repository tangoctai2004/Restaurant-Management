package controller;

import dao.BookingDAO;
import model.Account;
import model.Booking;
import util.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/vnpay-return"})
public class VNPayReturnServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tất cả parameters từ VNPay
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }
        
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_Amount = request.getParameter("vnp_Amount");
        
        // Log để debug
        System.out.println("=== VNPay Return ===");
        System.out.println("ResponseCode: " + vnp_ResponseCode);
        System.out.println("TransactionStatus: " + vnp_TransactionStatus);
        System.out.println("TxnRef: " + vnp_TxnRef);
        System.out.println("Amount: " + vnp_Amount);
        
        // Tạo map để verify (loại bỏ SecureHash)
        Map<String, String> fieldsForVerify = new HashMap<>(fields);
        if (fieldsForVerify.containsKey("vnp_SecureHashType")) {
            fieldsForVerify.remove("vnp_SecureHashType");
        }
        if (fieldsForVerify.containsKey("vnp_SecureHash")) {
            fieldsForVerify.remove("vnp_SecureHash");
        }
        
        HttpSession session = request.getSession();
        Booking tempBooking = (Booking) session.getAttribute("tempBooking");
        
        // Kiểm tra xem có phải thanh toán hóa đơn không
        Integer tablePaymentBookingId = (Integer) session.getAttribute("tablePaymentBookingId");
        Integer tablePaymentTableId = (Integer) session.getAttribute("tablePaymentTableId");
        Integer tablePaymentOrderId = (Integer) session.getAttribute("tablePaymentOrderId");
        String tablePaymentOrderIdRef = (String) session.getAttribute("tablePaymentOrderIdRef");
        
        // Verify payment
        boolean isValid = VNPayUtil.verifyPayment(fieldsForVerify, vnp_SecureHash);
        System.out.println("Payment verification: " + isValid);
        System.out.println("TempBooking exists: " + (tempBooking != null));
        System.out.println("TablePayment exists: " + (tablePaymentBookingId != null));
        
        if (isValid && "00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
            // Thanh toán thành công
            
            // Xử lý thanh toán hóa đơn (ưu tiên)
            if (tablePaymentBookingId != null && tablePaymentOrderIdRef != null && tablePaymentOrderIdRef.equals(vnp_TxnRef)) {
                try {
                    dao.OrderDAO orderDAO = new dao.OrderDAO();
                    model.Order order = orderDAO.getByBookingId(tablePaymentBookingId);
                    
                    if (order != null) {
                        // Tính lại totalAmount (số tiền sau khi trừ cọc)
                        // Sử dụng subtotal (tổng tiền món ăn gốc) làm cơ sở tính toán
                        long DEPOSIT_AMOUNT = 100000;
                        double originalTotal = order.getSubtotal(); // Tổng tiền món ăn (chưa trừ cọc)
                        double amountAfterDeposit = Math.max(0, originalTotal - DEPOSIT_AMOUNT);
                        
                        // Cập nhật totalAmount = số tiền sau khi trừ cọc
                        order.setTotalAmount(amountAfterDeposit);
                        
                        // Lấy tên bàn trước khi release
                        String tableName = "N/A";
                        if (tablePaymentTableId != null && tablePaymentTableId > 0) {
                            dao.RestaurantTableDAO tableDAO = new dao.RestaurantTableDAO();
                            model.RestaurantTable table = tableDAO.getById(tablePaymentTableId);
                            if (table != null) {
                                tableName = table.getName();
                            }
                        }
                        
                        // Lấy thông tin nhân viên từ session (nếu có) hoặc từ account hiện tại
                        Account cashierAccount = (Account) session.getAttribute("account");
                        if (cashierAccount == null) {
                            // Nếu không có trong session, thử lấy từ order hiện tại (nếu đã có)
                            // Hoặc có thể để null nếu không xác định được
                        }
                        
                        // Cập nhật order
                        order.setPaymentMethod("VNPay");
                        order.setPaymentStatus("Paid");
                        order.setOrderStatus("Completed");
                        order.setTransactionRef(vnp_TransactionNo);
                        
                        // Lưu tên bàn vào note để dùng khi in hóa đơn (sau khi release sẽ không còn trong booking.tables)
                        if (order.getNote() == null || order.getNote().isEmpty()) {
                            order.setNote("TABLE:" + tableName);
                        } else {
                            order.setNote(order.getNote() + ";TABLE:" + tableName);
                        }
                        
                        // Lưu thông tin nhân viên thu ngân và thời gian thanh toán
                        if (cashierAccount != null) {
                            order.setCashier(cashierAccount);
                        }
                        order.setPaidAt(new java.util.Date());
                        
                        if (orderDAO.updateOrder(order)) {
                            // Cập nhật status bàn về Available
                            dao.BookingDAO bookingDAO = new dao.BookingDAO();
                            if (tablePaymentTableId != null && tablePaymentTableId > 0) {
                                bookingDAO.releaseTableFromBooking(tablePaymentTableId);
                            }
                            // Cập nhật booking status
                            bookingDAO.updateBookingStatus(tablePaymentBookingId, "Completed");
                            
                            // Xóa session
                            session.removeAttribute("tablePaymentBookingId");
                            session.removeAttribute("tablePaymentTableId");
                            session.removeAttribute("tablePaymentOrderId");
                            session.removeAttribute("tablePaymentOrderIdRef");
                            
                            // Lưu thông tin để hiển thị trang thành công
                            session.setAttribute("paymentSuccess", "true");
                            session.setAttribute("paymentBookingId", tablePaymentBookingId);
                            session.setAttribute("paymentTableId", tablePaymentTableId);
                            session.setAttribute("paymentAmount", vnp_Amount);
                            session.setAttribute("paymentTransactionNo", vnp_TransactionNo);
                            session.setAttribute("paymentMethod", "VNPay");
                            
                            response.sendRedirect("admin/payment-success");
                            return;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("flashError", "Có lỗi xảy ra khi xử lý thanh toán! Mã giao dịch: " + vnp_TransactionNo);
                    response.sendRedirect("orders?tab=current");
                    return;
                }
            }
            
            // Xử lý thanh toán đặt bàn (nếu không phải thanh toán hóa đơn)
            if (tempBooking != null) {
                try {
                    // Kiểm tra xem booking đã tồn tại chưa (tránh duplicate)
                    boolean alreadyExists = bookingDAO.bookingExists(
                        tempBooking.getCustomerName(),
                        tempBooking.getPhone(),
                        tempBooking.getBookingDate(),
                        tempBooking.getBookingTime()
                    );
                    
                    if (alreadyExists) {
                        System.out.println("⚠️ Booking already exists. Skipping creation.");
                        session.removeAttribute("tempBooking");
                        session.removeAttribute("bookingOrderId");
                        
                        session.setAttribute("flashSuccess", 
                            "✅ Đặt bàn thành công! Bạn đã thanh toán tiền cọc 100,000 VNĐ qua VNPay. " +
                            "Mã giao dịch: " + vnp_TransactionNo + ". Nhân viên sẽ liên hệ và sắp xếp bàn cho bạn.");
                        
                        response.sendRedirect("reservation");
                        return;
                    }
                    
                    // Kiểm tra bookingOrderId để đảm bảo đúng transaction
                    String bookingOrderId = (String) session.getAttribute("bookingOrderId");
                    if (bookingOrderId != null && bookingOrderId.equals(vnp_TxnRef)) {
                        // Tạo booking trong database (không cần tableIds - nhân viên sẽ sắp xếp)
                        boolean success = bookingDAO.createBooking(tempBooking);
                        System.out.println("Booking created: " + success);
                        
                        if (success) {
                            // Lấy bookingId vừa tạo bằng cách tìm booking theo thông tin
                            Booking createdBooking = null;
                            java.util.List<Booking> bookings = bookingDAO.getByPhone(tempBooking.getPhone());
                            for (Booking b : bookings) {
                                if (b.getCustomerName().equals(tempBooking.getCustomerName()) &&
                                    b.getBookingDate().equals(tempBooking.getBookingDate()) &&
                                    b.getBookingTime().equals(tempBooking.getBookingTime()) &&
                                    b.getStatus().equals("Pending")) {
                                    createdBooking = b;
                                    break;
                                }
                            }
                            
                            // Tạo Order cho tiền cọc nếu tìm thấy booking
                            if (createdBooking != null) {
                                dao.OrderDAO orderDAO = new dao.OrderDAO();
                                model.Order depositOrder = new model.Order();
                                
                                // Set booking
                                depositOrder.setBooking(createdBooking);
                                
                                // Set account nếu có
                                if (tempBooking.getAccount() != null) {
                                    depositOrder.setAccount(tempBooking.getAccount());
                                }
                                
                                // Thông tin hóa đơn cọc
                                long DEPOSIT_AMOUNT = 100000;
                                depositOrder.setSubtotal(DEPOSIT_AMOUNT);
                                depositOrder.setDiscountAmount(0);
                                depositOrder.setTotalAmount(DEPOSIT_AMOUNT);
                                depositOrder.setPaymentMethod("VNPay");
                                depositOrder.setPaymentStatus("Paid");
                                depositOrder.setOrderStatus("Completed");
                                depositOrder.setTransactionRef(vnp_TransactionNo);
                                depositOrder.setNote("DEPOSIT"); // Đánh dấu đây là hóa đơn cọc
                                depositOrder.setPaidAt(new java.util.Date());
                                
                                // Tạo order (không có orderDetails vì đây là hóa đơn cọc)
                                int orderId = orderDAO.createOrder(depositOrder, null);
                                if (orderId > 0) {
                                    System.out.println("✅ Deposit order created with ID: " + orderId);
                                } else {
                                    System.out.println("⚠️ Failed to create deposit order");
                                }
                            }
                            
                            // Xóa session
                            session.removeAttribute("tempBooking");
                            session.removeAttribute("bookingOrderId");
                            
                            // Lưu thông tin thanh toán thành công vào session để hiển thị
                            session.setAttribute("flashSuccess", 
                                "✅ Đặt bàn thành công! Bạn đã thanh toán tiền cọc 100,000 VNĐ qua VNPay. " +
                                "Mã giao dịch: " + vnp_TransactionNo + ". Nhân viên sẽ liên hệ và sắp xếp bàn phù hợp cho bạn sớm nhất.");
                            
                            response.sendRedirect("reservation");
                            return;
                        } else {
                            request.setAttribute("error", "Đặt bàn thất bại sau khi thanh toán! Vui lòng liên hệ hỗ trợ với mã giao dịch: " + vnp_TransactionNo);
                        }
                    } else {
                        // OrderId không khớp - có thể đã được xử lý
                        System.out.println("⚠️ OrderId mismatch. Expected: " + bookingOrderId + ", Got: " + vnp_TxnRef);
                        
                        // Kiểm tra lại xem booking đã tồn tại chưa
                        if (bookingDAO.bookingExists(
                            tempBooking.getCustomerName(),
                            tempBooking.getPhone(),
                            tempBooking.getBookingDate(),
                            tempBooking.getBookingTime()
                        )) {
                            session.removeAttribute("tempBooking");
                            session.removeAttribute("bookingOrderId");
                            
                            session.setAttribute("flashSuccess", 
                                "✅ Thanh toán thành công! Đặt bàn của bạn đã được xử lý. " +
                                "Mã giao dịch: " + vnp_TransactionNo + ". Nhân viên sẽ liên hệ sắp xếp bàn.");
                            response.sendRedirect("reservation");
                            return;
                        } else {
                            request.setAttribute("error", "Không tìm thấy thông tin đặt bàn tương ứng. Vui lòng liên hệ hỗ trợ với mã: " + vnp_TxnRef);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Có lỗi xảy ra khi tạo đặt bàn! Vui lòng liên hệ hỗ trợ với mã giao dịch: " + vnp_TransactionNo);
                }
            } else {
                // Session đã mất nhưng thanh toán thành công
                System.out.println("⚠️ Session expired but payment successful. OrderId: " + vnp_TxnRef);
                session.setAttribute("flashSuccess", 
                    "✅ Thanh toán thành công! Nếu bạn đã đặt bàn, vui lòng kiểm tra email hoặc liên hệ nhà hàng với mã: " + vnp_TxnRef);
                response.sendRedirect("reservation");
                return;
            }
        } else {
            // Thanh toán thất bại hoặc bị hủy
            String errorMsg = "Thanh toán thất bại hoặc bị hủy!";
            if (!isValid) {
                errorMsg += " (Xác thực không hợp lệ)";
            } else if (!"00".equals(vnp_ResponseCode)) {
                errorMsg += " (Mã lỗi: " + vnp_ResponseCode + ")";
            }
            
            // Xóa session
            session.removeAttribute("tempBooking");
            session.removeAttribute("bookingOrderId");
            
            request.setAttribute("error", errorMsg);
        }
        
        // Forward về trang reservation với thông báo
        request.getRequestDispatcher("reservation.jsp").forward(request, response);
    }
}

