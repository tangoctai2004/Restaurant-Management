package model;

public class Ingredient {
    private int id;
    private String name;
    private String unit;
    private double price; // Giá mua nguyên liệu (VND/unit)

    public Ingredient() {
    }

    public Ingredient(int id, String name, String unit, double price) {
        this.id = id;
        this.name = name;
        this.unit = unit;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
}

