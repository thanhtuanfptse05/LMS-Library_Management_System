USE LMS_Library_Management_System;
GO

IF OBJECT_ID('BookCopyIncident', 'U') IS NULL
BEGIN
    CREATE TABLE BookCopyIncident (
        incidentId INT IDENTITY(1,1) PRIMARY KEY,
        bookCopyId INT NOT NULL,
        incidentType NVARCHAR(20) NOT NULL,
        description NVARCHAR(1000) NOT NULL,
        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_BookCopyIncident_Status DEFAULT 'pending',
        resolution NVARCHAR(1000) NULL,
        reportedBy INT NOT NULL,
        reportedAt DATETIME NOT NULL CONSTRAINT DF_BookCopyIncident_ReportedAt DEFAULT GETDATE(),
        resolvedBy INT NULL,
        resolvedAt DATETIME NULL,
        CONSTRAINT FK_BookCopyIncident_BookCopy FOREIGN KEY (bookCopyId) REFERENCES BookCopy(bookCopyId),
        CONSTRAINT FK_BookCopyIncident_ReportedBy FOREIGN KEY (reportedBy) REFERENCES [User](userId),
        CONSTRAINT FK_BookCopyIncident_ResolvedBy FOREIGN KEY (resolvedBy) REFERENCES [User](userId),
        CONSTRAINT CK_BookCopyIncident_Type CHECK (incidentType IN ('damaged', 'lost')),
        CONSTRAINT CK_BookCopyIncident_Status CHECK ([status] IN ('pending', 'investigating', 'resolved', 'rejected'))
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_BookCopyIncident_Open'
        AND object_id = OBJECT_ID('BookCopyIncident'))
    CREATE UNIQUE INDEX UX_BookCopyIncident_Open ON BookCopyIncident(bookCopyId)
        WHERE [status] <> 'resolved' AND [status] <> 'rejected';
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BookCopyIncident_Status_ReportedAt'
        AND object_id = OBJECT_ID('BookCopyIncident'))
    CREATE INDEX IX_BookCopyIncident_Status_ReportedAt ON BookCopyIncident([status], reportedAt DESC);
GO
