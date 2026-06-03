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
    lockReason NVARCHAR(50) NULL, -- unpaid, adminban, securitybreach
    failedLoginAttempts INT NOT NULL DEFAULT 0,
    lockedUntil DATETIME NULL
);

-- ============================================================

CREATE TABLE MemberProfile (
    userId INT PRIMARY KEY,
    fullName NVARCHAR(255) NOT NULL,
    phoneNumber NVARCHAR(20) NOT NULL,
    gender NVARCHAR(10) NOT NULL,
    dateOfBirth DATE NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,

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
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL
);

-- ============================================================

CREATE TABLE Tag (
    tagId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE
);

-- ============================================================

CREATE TABLE Book (
    bookId INT IDENTITY(1,1) PRIMARY KEY,
    isbn NVARCHAR(20) NOT NULL UNIQUE,
    title NVARCHAR(500) NOT NULL,
    author NVARCHAR(500) NULL,
    publisher NVARCHAR(255) NULL,
    publicationYear INT NULL,
    price DECIMAL(18,2) NULL,
    totalQuantity INT NOT NULL DEFAULT 0,
    availableQuantity INT NOT NULL DEFAULT 0,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'available',  -- unavailable, available
    createdAt DATETIME NOT NULL DEFAULT GETDATE(),
    updatedAt DATETIME NULL 
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

    FOREIGN KEY (bookId) REFERENCES Book(bookId)
);

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

