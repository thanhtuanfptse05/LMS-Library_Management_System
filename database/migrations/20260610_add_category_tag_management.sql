USE LMS_Library_Management_System;
GO

IF COL_LENGTH('Category', 'status') IS NULL
    ALTER TABLE Category ADD [status] NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Category_Status DEFAULT 'active';
GO
IF COL_LENGTH('Category', 'updatedAt') IS NULL
    ALTER TABLE Category ADD updatedAt DATETIME NOT NULL
        CONSTRAINT DF_Category_UpdatedAt DEFAULT GETDATE();
GO
IF COL_LENGTH('Category', 'updatedBy') IS NULL
    ALTER TABLE Category ADD updatedBy INT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Category_Status')
    ALTER TABLE Category ADD CONSTRAINT CK_Category_Status
        CHECK ([status] IN ('active', 'hidden'));
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Category_UpdatedBy')
    ALTER TABLE Category ADD CONSTRAINT FK_Category_UpdatedBy
        FOREIGN KEY (updatedBy) REFERENCES [User](userId);
GO

IF COL_LENGTH('Tag', 'status') IS NULL
    ALTER TABLE Tag ADD [status] NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Tag_Status DEFAULT 'active';
GO
IF COL_LENGTH('Tag', 'updatedAt') IS NULL
    ALTER TABLE Tag ADD updatedAt DATETIME NOT NULL
        CONSTRAINT DF_Tag_UpdatedAt DEFAULT GETDATE();
GO
IF COL_LENGTH('Tag', 'updatedBy') IS NULL
    ALTER TABLE Tag ADD updatedBy INT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Tag_Status')
    ALTER TABLE Tag ADD CONSTRAINT CK_Tag_Status
        CHECK ([status] IN ('active', 'hidden'));
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Tag_UpdatedBy')
    ALTER TABLE Tag ADD CONSTRAINT FK_Tag_UpdatedBy
        FOREIGN KEY (updatedBy) REFERENCES [User](userId);
GO
