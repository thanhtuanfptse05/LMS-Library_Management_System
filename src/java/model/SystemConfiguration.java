package model;

import java.sql.Timestamp;

public class SystemConfiguration {

    private String configKey;
    private String configValue;
    private String description;
    private String configGroup;
    private Integer updatedBy;
    private String updaterName;
    private Timestamp updatedAt;

    public SystemConfiguration() {
    }

    public SystemConfiguration(String configKey, String configValue, String description, String configGroup, Integer updatedBy, String updaterName, Timestamp updatedAt) {
        this.configKey = configKey;
        this.configValue = configValue;
        this.description = description;
        this.configGroup = configGroup;
        this.updatedBy = updatedBy;
        this.updaterName = updaterName;
        this.updatedAt = updatedAt;
    }

    public String getConfigKey() {
        return configKey;
    }

    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }

    public String getConfigValue() {
        return configValue;
    }

    public void setConfigValue(String configValue) {
        this.configValue = configValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getConfigGroup() {
        return configGroup;
    }

    public void setConfigGroup(String configGroup) {
        this.configGroup = configGroup;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public String getUpdaterName() {
        return updaterName;
    }

    public void setUpdaterName(String updaterName) {
        this.updaterName = updaterName;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

}
