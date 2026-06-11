package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class BookImportBatch {

    private int importBatchId;
    private int importedBy;
    private String importedByName;
    private String fileName;
    private int totalRows;
    private int successRows;
    private int failedRows;
    private String status;
    private Timestamp createdAt;
    private Timestamp expiresAt;
    private List<BookImportError> errors = new ArrayList<>();

    public int getImportBatchId() { return importBatchId; }
    public void setImportBatchId(int importBatchId) { this.importBatchId = importBatchId; }
    public int getImportedBy() { return importedBy; }
    public void setImportedBy(int importedBy) { this.importedBy = importedBy; }
    public String getImportedByName() { return importedByName; }
    public void setImportedByName(String importedByName) { this.importedByName = importedByName; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public int getTotalRows() { return totalRows; }
    public void setTotalRows(int totalRows) { this.totalRows = totalRows; }
    public int getSuccessRows() { return successRows; }
    public void setSuccessRows(int successRows) { this.successRows = successRows; }
    public int getFailedRows() { return failedRows; }
    public void setFailedRows(int failedRows) { this.failedRows = failedRows; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }
    public List<BookImportError> getErrors() { return errors; }
    public void setErrors(List<BookImportError> errors) { this.errors = errors; }
}
