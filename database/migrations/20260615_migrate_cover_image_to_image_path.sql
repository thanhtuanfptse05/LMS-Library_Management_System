USE LMS_Library_Management_System;
GO

IF COL_LENGTH('Book', 'imagePath') IS NULL
BEGIN
    ALTER TABLE Book ADD imagePath NVARCHAR(255) NULL;
END;
GO

IF COL_LENGTH('Book', 'coverImage') IS NOT NULL
BEGIN
    EXEC(N'UPDATE Book SET imagePath = coverImage WHERE imagePath IS NULL AND coverImage IS NOT NULL');
    ALTER TABLE Book DROP COLUMN coverImage;
END;
GO
