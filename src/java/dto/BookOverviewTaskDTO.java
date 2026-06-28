package dto;

public class BookOverviewTaskDTO {
    private String icon;
    private String title;
    private String description;
    private String url;
    private String actionLabel;
    private String severity;

    public BookOverviewTaskDTO(String icon, String title, String description, String url,
            String actionLabel, String severity) {
        this.icon = icon;
        this.title = title;
        this.description = description;
        this.url = url;
        this.actionLabel = actionLabel;
        this.severity = severity;
    }

    public String getIcon() {
        return icon;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getUrl() {
        return url;
    }

    public String getActionLabel() {
        return actionLabel;
    }

    public String getSeverity() {
        return severity;
    }
}
