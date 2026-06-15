USE LMS_Library_Management_System;
GO

IF OBJECT_ID('InventorySession', 'U') IS NULL
BEGIN
    CREATE TABLE InventorySession (
        inventorySessionId INT IDENTITY(1,1) PRIMARY KEY,
        [location] NVARCHAR(255) NOT NULL,
        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_InventorySession_Status DEFAULT 'draft',
        startedBy INT NOT NULL,
        startedAt DATETIME NOT NULL CONSTRAINT DF_InventorySession_StartedAt DEFAULT GETDATE(),
        completedBy INT NULL,
        completedAt DATETIME NULL,
        note NVARCHAR(1000) NULL,
        CONSTRAINT FK_InventorySession_StartedBy FOREIGN KEY (startedBy) REFERENCES [User](userId),
        CONSTRAINT FK_InventorySession_CompletedBy FOREIGN KEY (completedBy) REFERENCES [User](userId),
        CONSTRAINT CK_InventorySession_Status CHECK ([status] IN ('draft', 'counting', 'reviewing', 'completed', 'cancelled'))
    );
END;
GO

IF OBJECT_ID('InventoryItem', 'U') IS NULL
BEGIN
    CREATE TABLE InventoryItem (
        inventoryItemId INT IDENTITY(1,1) PRIMARY KEY,
        inventorySessionId INT NOT NULL,
        bookCopyId INT NOT NULL,
        expectedLocation NVARCHAR(255) NOT NULL,
        scannedLocation NVARCHAR(255) NULL,
        result NVARCHAR(20) NOT NULL CONSTRAINT DF_InventoryItem_Result DEFAULT 'pending',
        scannedBy INT NULL,
        scannedAt DATETIME NULL,
        resolution NVARCHAR(1000) NULL,
        resolvedBy INT NULL,
        resolvedAt DATETIME NULL,
        CONSTRAINT FK_InventoryItem_Session FOREIGN KEY (inventorySessionId)
            REFERENCES InventorySession(inventorySessionId) ON DELETE CASCADE,
        CONSTRAINT FK_InventoryItem_BookCopy FOREIGN KEY (bookCopyId) REFERENCES BookCopy(bookCopyId),
        CONSTRAINT FK_InventoryItem_ScannedBy FOREIGN KEY (scannedBy) REFERENCES [User](userId),
        CONSTRAINT FK_InventoryItem_ResolvedBy FOREIGN KEY (resolvedBy) REFERENCES [User](userId),
        CONSTRAINT CK_InventoryItem_Result CHECK (result IN ('pending', 'matched', 'missing', 'misplaced'))
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_InventoryItem_Session_Copy'
        AND object_id = OBJECT_ID('InventoryItem'))
    CREATE UNIQUE INDEX UX_InventoryItem_Session_Copy ON InventoryItem(inventorySessionId, bookCopyId);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_InventorySession_StartedAt'
        AND object_id = OBJECT_ID('InventorySession'))
    CREATE INDEX IX_InventorySession_StartedAt ON InventorySession(startedAt DESC);
GO
