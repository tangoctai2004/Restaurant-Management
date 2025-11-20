package model;

public class RestaurantTable {
    private int id;
    private String name;
    private int capacity;
    private String locationArea;
    private String status; // Available, Occupied, Reserved, Maintenance

    public RestaurantTable() {
    }

    public RestaurantTable(int id, String name, int capacity, String locationArea, String status) {
        this.id = id;
        this.name = name;
        this.capacity = capacity;
        this.locationArea = locationArea;
        this.status = status;
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

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getLocationArea() {
        return locationArea;
    }

    public void setLocationArea(String locationArea) {
        this.locationArea = locationArea;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}



