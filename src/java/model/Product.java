package model;

public class Product {
    private int id;
    private int categoryId;
    private String categoryName;
    private String name;
    private String description;
    private double price; // Giá bán
    private double costPrice; // Giá vốn (tính từ nguyên liệu)
    private String imageUrl;
    private boolean isActive;

    public Product() {
    }

    public Product(int id, int categoryId, String name, String description, double price, String imageUrl, boolean isActive) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isActive() {
        return isActive;
    }
    
    // Thêm getter này để JSP EL có thể truy cập property "active"
    public boolean getActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
    
    public double getCostPrice() {
        return costPrice;
    }
    
    public void setCostPrice(double costPrice) {
        this.costPrice = costPrice;
    }
}



