package model;

import java.sql.Timestamp;

public class BookImportError {

    private int importErrorId;
    private int importBatchId;
    private String sheetName;
    private int rowNumber;
    private String columnName;
    private String errorMessage;
    private Timestamp createdAt;

    public BookImportError() { }

    public BookImportError(String sheetName, int rowNumber, String columnName, String errorMessage) {
        this.sheetName = sheetName;
        this.rowNumber = rowNumber;
        this.columnName = columnName;
        this.errorMessage = errorMessage;
    }

    public int getImportErrorId() { return importErrorId; }
    public void setImportErrorId(int importErrorId) { this.importErrorId = importErrorId; }
    public int getImportBatchId() { return importBatchId; }
    public void setImportBatchId(int importBatchId) { this.importBatchId = importBatchId; }
    public String getSheetName() { return sheetName; }
    public void setSheetName(String sheetName) { this.sheetName = sheetName; }
    public int getRowNumber() { return rowNumber; }
    public void setRowNumber(int rowNumber) { this.rowNumber = rowNumber; }
    public String getColumnName() { return columnName; }
    public void setColumnName(String columnName) { this.columnName = columnName; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
