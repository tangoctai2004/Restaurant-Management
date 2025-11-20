package model;

public class RestaurantSettings {
    private String settingKey;
    private String settingValue;
    private String pageName; // home, menu, reservation, about, contact, header, footer
    private String description;

    public RestaurantSettings() {
    }

    public RestaurantSettings(String settingKey, String settingValue, String pageName, String description) {
        this.settingKey = settingKey;
        this.settingValue = settingValue;
        this.pageName = pageName;
        this.description = description;
    }

    public String getSettingKey() {
        return settingKey;
    }

    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }

    public String getSettingValue() {
        return settingValue;
    }

    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }

    public String getPageName() {
        return pageName;
    }

    public void setPageName(String pageName) {
        this.pageName = pageName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

