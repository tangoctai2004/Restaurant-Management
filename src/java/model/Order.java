package model;

import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private Account account;
    private Booking booking;
    private Promotion promotion;
    private double subtotal;
    private double discountAmount;
    private double totalAmount;
    private String paymentMethod;
    private String paymentStatus; // Unpaid, Paid, Failed, Refunded
    private String orderStatus; // Pending, Confirmed, Cooking, Ready, Completed, Canceled
    private String transactionRef;
    private String note;
    private Date createdAt;
    private List<OrderDetail> orderDetails;
    private Account cashier; // Nhân viên thu ngân
    private Date paidAt; // Thời điểm thanh toán

    public Order() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public Promotion getPromotion() {
        return promotion;
    }

    public void setPromotion(Promotion promotion) {
        this.promotion = promotion;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getTransactionRef() {
        return transactionRef;
    }

    public void setTransactionRef(String transactionRef) {
        this.transactionRef = transactionRef;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }
    
    public Account getCashier() {
        return cashier;
    }
    
    public void setCashier(Account cashier) {
        this.cashier = cashier;
    }
    
    public Date getPaidAt() {
        return paidAt;
    }
    
    public void setPaidAt(Date paidAt) {
        this.paidAt = paidAt;
    }
}



