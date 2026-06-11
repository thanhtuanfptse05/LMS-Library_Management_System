USE LMS_Library_Management_System;
GO

IF OBJECT_ID('BookImportBatch', 'U') IS NULL
BEGIN
    CREATE TABLE BookImportBatch (
        importBatchId INT IDENTITY(1,1) PRIMARY KEY,
        importedBy INT NOT NULL,
        fileName NVARCHAR(255) NOT NULL,
        totalRows INT NOT NULL DEFAULT 0 CHECK (totalRows >= 0),
        successRows INT NOT NULL DEFAULT 0 CHECK (successRows >= 0),
        failedRows INT NOT NULL DEFAULT 0 CHECK (failedRows >= 0),
        [status] NVARCHAR(50) NOT NULL DEFAULT 'failed',
        createdAt DATETIME NOT NULL DEFAULT GETDATE(),
        expiresAt DATETIME NOT NULL DEFAULT (DATEADD(YEAR, 1, GETDATE())),
        CONSTRAINT FK_BookImportBatch_ImportedBy FOREIGN KEY (importedBy) REFERENCES [User](userId),
        CONSTRAINT CK_BookImportBatch_RowCounts CHECK (successRows + failedRows <= totalRows),
        CONSTRAINT CK_BookImportBatch_Status CHECK ([status] IN ('success', 'failed'))
    );
END;
GO

IF OBJECT_ID('BookImportError', 'U') IS NULL
BEGIN
    CREATE TABLE BookImportError (
        importErrorId INT IDENTITY(1,1) PRIMARY KEY,
        importBatchId INT NOT NULL,
        sheetName NVARCHAR(50) NOT NULL,
        rowNumber INT NOT NULL CHECK (rowNumber >= 1),
        columnName NVARCHAR(100) NULL,
        errorMessage NVARCHAR(1000) NOT NULL,
        createdAt DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_BookImportError_Batch FOREIGN KEY (importBatchId)
            REFERENCES BookImportBatch(importBatchId) ON DELETE CASCADE,
        CONSTRAINT CK_BookImportError_SheetName CHECK (sheetName IN ('Books', 'BookCopies'))
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BookImportBatch_CreatedAt'
        AND object_id = OBJECT_ID('BookImportBatch'))
    CREATE INDEX IX_BookImportBatch_CreatedAt ON BookImportBatch(createdAt);
GO
