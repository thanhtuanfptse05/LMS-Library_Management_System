create database LMS_Library_Management_System;
go
use LMS_Library_Management_System;
go
-- ============================================================
-- LIBRARY MANAGEMENT SYSTEM
-- ============================================================

CREATE TABLE [User] (
    userId INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    passwordHash NVARCHAR(255) NOT NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'active', -- active, locked
    [role] NVARCHAR(50) NOT NULL,
    failedLoginAttempts INT NOT NULL DEFAULT 0,
    lockedUntil DATETIME NULL
);

-- ============================================================

CREATE TABLE UserLockReason (
    lockReasonId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    reason NVARCHAR(50) NOT NULL, -- unpaid, adminban, securitybreach
    createdAt DATETIME NOT NULL DEFAULT GETDATE(), -- Lưu lại thời điểm bị đánh dấu lỗi này
    
    -- Khóa ngoại liên kết với bảng User
    CONSTRAINT FK_UserLockReason_User FOREIGN KEY (userId) 
        REFERENCES [User](userId) 
        ON DELETE CASCADE -- Tùy chọn: xóa user thì xóa luôn các lý do khóa
);

-- ============================================================

CREATE TABLE MemberProfile (
    userId INT PRIMARY KEY,
    fullName NVARCHAR(255) NOT NULL,
    phoneNumber NVARCHAR(20) NOT NULL,
    gender NVARCHAR(10) NOT NULL,
    dateOfBirth DATE NOT NULL,
    startDate DATE  NULL,
    endDate DATE  NULL,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Student (
    userId INT PRIMARY KEY,
    studentCode NVARCHAR(50) NOT NULL UNIQUE,
    major NVARCHAR(255) NULL,
    enrollmentYear INT NULL,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Lecturer (
    userId INT PRIMARY KEY,
    lecturerCode NVARCHAR(50) NOT NULL UNIQUE,
    department NVARCHAR(255) NULL,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Librarian (
    userId INT PRIMARY KEY,
    staffCode NVARCHAR(50) NOT NULL UNIQUE,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE LibraryManager (
    userId INT PRIMARY KEY,
    staffCode NVARCHAR(50) NOT NULL UNIQUE,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Admin (
    userId INT PRIMARY KEY,
    staffCode NVARCHAR(50) NOT NULL UNIQUE,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE SystemConfigurations (
    configKey NVARCHAR(255) PRIMARY KEY,
    configValue NVARCHAR(MAX) NULL,
    [description] NVARCHAR(MAX) NULL,
    configGroup NVARCHAR(50) NOT NULL DEFAULT 'library', -- system, library
    updatedBy INT NULL,
    updatedAt DATETIME NULL DEFAULT GETDATE(),

    FOREIGN KEY (updatedBy) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE AuditLogs (
    auditLogId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NULL,
    actionType NVARCHAR(100) NOT NULL,
    [entityName] NVARCHAR(255) NULL,
    [entityId] INT NULL,
    oldValues NVARCHAR(MAX) NULL,
    newValues NVARCHAR(MAX) NULL,
    [timestamp] DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Category (
    categoryId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL UNIQUE,
    description NVARCHAR(MAX) NULL,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'active',
    updatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedBy INT NULL,

    CONSTRAINT CK_Category_Status CHECK ([status] IN ('active', 'hidden')),
    FOREIGN KEY (updatedBy) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Tag (
    tagId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'active',
    updatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedBy INT NULL,

    CONSTRAINT CK_Tag_Status CHECK ([status] IN ('active', 'hidden')),
    FOREIGN KEY (updatedBy) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Book (
    bookId INT IDENTITY(1,1) PRIMARY KEY,
    isbn NVARCHAR(20) NOT NULL UNIQUE,
    title NVARCHAR(500) NOT NULL,
    author NVARCHAR(500) NULL,
    publisher NVARCHAR(255) NULL,
    publicationYear INT NULL,
    price DECIMAL(18,2) NULL CHECK (price IS NULL OR price >= 0),
    imagePath NVARCHAR(255) NULL,
    totalQuantity INT NOT NULL DEFAULT 0 CHECK (totalQuantity >= 0),
    availableQuantity INT NOT NULL DEFAULT 0 CHECK (availableQuantity >= 0),
    [status] NVARCHAR(50) NOT NULL DEFAULT 'available',  -- unavailable, available
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedAt DATETIME NULL,

    CONSTRAINT CK_Book_AvailableQuantity_Lte_TotalQuantity
        CHECK (availableQuantity <= totalQuantity),
    CONSTRAINT CK_Book_Status
        CHECK ([status] IN ('available', 'unavailable'))
);

-- ============================================================

CREATE TABLE BookCategory (
    bookId INT NOT NULL,
    categoryId INT NOT NULL,

    PRIMARY KEY (bookId, categoryId),

    FOREIGN KEY (bookId) REFERENCES Book(bookId),
    FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
);

-- ============================================================

CREATE TABLE BookTag (
    bookId INT NOT NULL,
    tagId INT NOT NULL,

    PRIMARY KEY (bookId, tagId),

    FOREIGN KEY (bookId) REFERENCES Book(bookId),
    FOREIGN KEY (tagId) REFERENCES Tag(tagId)
);

-- ============================================================

CREATE TABLE BookCopy (
    bookCopyId INT IDENTITY(1,1) PRIMARY KEY,
    bookId INT NOT NULL,
    [location] NVARCHAR(255) NULL,
    condition NVARCHAR(100) NOT NULL DEFAULT 'good',  -- good, damaged, lost
    [status] NVARCHAR(50) NOT NULL DEFAULT 'available', -- available, unavailable, borrowed, reserved 
    barcode NVARCHAR(50) NOT NULL UNIQUE,
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedAt DATETIME NULL,

    FOREIGN KEY (bookId) REFERENCES Book(bookId),
    CONSTRAINT CK_BookCopy_Condition
        CHECK (condition IN ('good', 'damaged', 'lost')),
    CONSTRAINT CK_BookCopy_Status
        CHECK ([status] IN ('available', 'unavailable', 'borrowed', 'reserved'))
);

-- ============================================================

CREATE TABLE BookCopyIncident (
    incidentId INT IDENTITY(1,1) PRIMARY KEY,
    bookCopyId INT NOT NULL,
    incidentType NVARCHAR(20) NOT NULL, -- damaged, lost
    description NVARCHAR(1000) NOT NULL,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, investigating, resolved, rejected
    resolution NVARCHAR(1000) NULL,
    reportedBy INT NOT NULL,
    reportedAt DATETIME NOT NULL DEFAULT GETDATE(),
    resolvedBy INT NULL,
    resolvedAt DATETIME NULL,

    CONSTRAINT FK_BookCopyIncident_BookCopy FOREIGN KEY (bookCopyId) REFERENCES BookCopy(bookCopyId),
    CONSTRAINT FK_BookCopyIncident_ReportedBy FOREIGN KEY (reportedBy) REFERENCES [User](userId),
    CONSTRAINT FK_BookCopyIncident_ResolvedBy FOREIGN KEY (resolvedBy) REFERENCES [User](userId),
    CONSTRAINT CK_BookCopyIncident_Type CHECK (incidentType IN ('damaged', 'lost')),
    CONSTRAINT CK_BookCopyIncident_Status CHECK ([status] IN ('pending', 'investigating', 'resolved', 'rejected'))
);

CREATE UNIQUE INDEX UX_BookCopyIncident_Open
    ON BookCopyIncident(bookCopyId)
    WHERE [status] <> 'resolved' AND [status] <> 'rejected';

CREATE INDEX IX_BookCopyIncident_Status_ReportedAt
    ON BookCopyIncident([status], reportedAt DESC);

-- ============================================================

CREATE TABLE BookImportBatch (
    importBatchId INT IDENTITY(1,1) PRIMARY KEY,
    importedBy INT NOT NULL,
    fileName NVARCHAR(255) NOT NULL,
    totalRows INT NOT NULL DEFAULT 0 CHECK (totalRows >= 0),
    successRows INT NOT NULL DEFAULT 0 CHECK (successRows >= 0),
    failedRows INT NOT NULL DEFAULT 0 CHECK (failedRows >= 0),
    [status] NVARCHAR(50) NOT NULL DEFAULT 'failed', -- success, failed
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    expiresAt DATETIME NOT NULL DEFAULT (DATEADD(YEAR, 1, GETDATE())),

    FOREIGN KEY (importedBy) REFERENCES [User](userId),
    CONSTRAINT CK_BookImportBatch_RowCounts
        CHECK (successRows + failedRows <= totalRows),
    CONSTRAINT CK_BookImportBatch_Status
        CHECK ([status] IN ('success', 'failed'))
);

-- ============================================================

CREATE TABLE BookImportError (
    importErrorId INT IDENTITY(1,1) PRIMARY KEY,
    importBatchId INT NOT NULL,
    sheetName NVARCHAR(50) NOT NULL,
    rowNumber INT NOT NULL CHECK (rowNumber >= 1),
    columnName NVARCHAR(100) NULL,
    errorMessage NVARCHAR(1000) NOT NULL,
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (importBatchId) REFERENCES BookImportBatch(importBatchId)
        ON DELETE CASCADE,
    CONSTRAINT CK_BookImportError_SheetName
        CHECK (sheetName IN ('Books', 'BookCopies'))
);

-- ============================================================

CREATE INDEX IX_Book_Title ON Book(title);
CREATE INDEX IX_Book_Status ON Book([status]);
CREATE INDEX IX_BookCopy_BookId ON BookCopy(bookId);
CREATE INDEX IX_BookCopy_BookId_Status ON BookCopy(bookId, [status]);
CREATE INDEX IX_BookCopy_BookId_Condition ON BookCopy(bookId, condition);
CREATE INDEX IX_BookImportBatch_CreatedAt ON BookImportBatch(createdAt);

-- ============================================================

CREATE TABLE Reservation (
    reservationId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    bookId INT NOT NULL,
    bookCopyId INT NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'pending', -- pending, readypickup, fulfilled, cancelled 
    queuePosition INT NULL,
    startDate DATETIME NULL DEFAULT GETDATE(),
    endDate DATETIME NULL,
  
    FOREIGN KEY (userId) REFERENCES [User](userId),
    FOREIGN KEY (bookId) REFERENCES Book(bookId),
    FOREIGN KEY (bookCopyId) REFERENCES BookCopy(bookCopyId)
);

-- ============================================================

CREATE TABLE BorrowRecord (
    borrowRecordId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    bookCopyId INT NOT NULL,
    bookId INT NOT NULL,
    startDate DATETIME NOT NULL DEFAULT GETDATE(),
    endDate DATETIME NOT NULL,
    returnedAt DATETIME NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'borrowed', -- borrowed, returned, overdue, lost
    extensionCount INT NOT NULL DEFAULT 0,
    createdBy INT NULL,
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (userId) REFERENCES [User](userId),
    FOREIGN KEY (bookCopyId) REFERENCES BookCopy(bookCopyId),
    FOREIGN KEY (bookId) REFERENCES Book(bookId),
    FOREIGN KEY (createdBy) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Fine (
    fineId INT IDENTITY(1,1) PRIMARY KEY,
    borrowRecordId INT NOT NULL,
    userId INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    reason NVARCHAR(500) NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'unpaid', -- unpaid, paid  
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (borrowRecordId) REFERENCES BorrowRecord(borrowRecordId),
    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Payment (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    fineId INT NOT NULL,
    paidAmount DECIMAL(18,2) NOT NULL,
    paymentMethod NVARCHAR(100) NULL,
    transactionReference NVARCHAR(255) NULL UNIQUE,
    processedBy INT NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'pending', -- completed, pending, canceled
    paidAt DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (fineId) REFERENCES Fine(fineId),
    FOREIGN KEY (processedBy) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Notification (
    notificationId INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(500) NOT NULL,
    content NVARCHAR(MAX) NULL,
    createdBy INT NOT NULL,
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (createdBy) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE DocumentTemp (
    tempId INT IDENTITY(1,1) PRIMARY KEY,
    tempName NVARCHAR(100) NOT NULL UNIQUE, -- Ví dụ: 'PICKUP_REMINDER', 'OVERDUE_FINE_NOTICE'
    [subject] NVARCHAR(255) NOT NULL,      -- Tiêu đề email mẫu
    bodyContent NVARCHAR(MAX) NOT NULL,    -- Nội dung có chứa tham số {{...}}
    managerId INT NOT NULL,                -- FK kết nối với LibraryManager
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedAt DATETIME NULL,
    FOREIGN KEY (managerId) REFERENCES LibraryManager(userId)
);

