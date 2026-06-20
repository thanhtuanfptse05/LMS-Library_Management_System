package dto;

import java.util.Date;

public class SystemConfigLogDTO {
    private String configKey;
    private String oldValue;
    private String newValue;
    private Date updatedAt;
    private String updaterName;
    private String updaterEmail;

    public SystemConfigLogDTO() {
    }

    public SystemConfigLogDTO(String configKey, String oldValue, String newValue, Date updatedAt, String updaterName, String updaterEmail) {
        this.configKey = configKey;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.updatedAt = updatedAt;
        this.updaterName = updaterName;
        this.updaterEmail = updaterEmail;
    }

    public String getConfigKey() {
        return configKey;
    }

    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUpdaterName() {
        return updaterName;
    }

    public void setUpdaterName(String updaterName) {
        this.updaterName = updaterName;
    }

    public String getUpdaterEmail() {
        return updaterEmail;
    }

    public void setUpdaterEmail(String updaterEmail) {
        this.updaterEmail = updaterEmail;
    }
}
