USE LMS_Library_Management_System;
GO

IF COL_LENGTH('Book', 'imagePath') IS NULL
BEGIN
    ALTER TABLE Book ADD imagePath NVARCHAR(255) NULL;
END;
GO
