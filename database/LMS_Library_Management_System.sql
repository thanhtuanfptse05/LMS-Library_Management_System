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
    password_hash NVARCHAR(255) NOT NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'active', --active,locked
    [role] NVARCHAR(50) NOT NULL,
	lock_reason NVARCHAR(50) NULL, --unpaid, adminban, securitybreach
    failed_login_attempts INT NOT NULL DEFAULT 0,
    locked_until DATETIME NULL
);

-- ============================================================

CREATE TABLE MemberProfile (
    userId INT PRIMARY KEY,
    full_name NVARCHAR(255) NOT NULL,
    phone_number NVARCHAR(20) NULL,
    gender NVARCHAR(10) NULL,
    date_of_birth DATE NULL,
    [start_date] DATE NULL,
    end_date DATE NULL,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Student (
    userId INT PRIMARY KEY,
    student_code NVARCHAR(50) NOT NULL UNIQUE,
    major NVARCHAR(255) NULL,
    enrollment_year INT NULL,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Lecturer (
    userId INT PRIMARY KEY,
    lecturer_code NVARCHAR(50) NOT NULL UNIQUE,
    department NVARCHAR(255) NULL,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Librarian (
    userId INT PRIMARY KEY,
    staff_code NVARCHAR(50) NOT NULL UNIQUE,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE LibraryManager (
    userId INT PRIMARY KEY,
    staff_code NVARCHAR(50) NOT NULL UNIQUE,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Admin (
    userId INT PRIMARY KEY,
    staff_code NVARCHAR(50) NOT NULL UNIQUE,

    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE SystemConfigurations (
    config_key NVARCHAR(255) PRIMARY KEY,
    config_value NVARCHAR(MAX) NULL,
    [description] NVARCHAR(MAX) NULL,
    updated_by INT NULL,
    updated_at DATETIME NULL DEFAULT GETDATE(),

    FOREIGN KEY (updated_by) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE AuditLogs (
    auditLogId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NULL,
    action_type NVARCHAR(100) NOT NULL,
    [entity_name] NVARCHAR(255) NULL,
    [entity_id] INT NULL,
    old_values NVARCHAR(MAX) NULL,
    new_values NVARCHAR(MAX) NULL,
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

CREATE TABLE Books (
    bookId INT IDENTITY(1,1) PRIMARY KEY,
    isbn NVARCHAR(20) NOT NULL UNIQUE,
    title NVARCHAR(500) NOT NULL,
    author NVARCHAR(500) NULL,
    publisher NVARCHAR(255) NULL,
    publication_year INT NULL,
    price DECIMAL(18,2) NULL,
    total_quantity INT NOT NULL DEFAULT 0,
    available_quantity INT NOT NULL DEFAULT 0,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'available',  --unvailable, available
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME  NULL 
);

-- ============================================================

CREATE TABLE BookCategory (
    bookId INT NOT NULL,
    categoryId INT NOT NULL,

    PRIMARY KEY (bookId, categoryId),

    FOREIGN KEY (bookId) REFERENCES Books(bookId),
    FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
);

-- ============================================================

CREATE TABLE BookTag (
    bookId INT NOT NULL,
    tagId INT NOT NULL,

    PRIMARY KEY (bookId, tagId),

    FOREIGN KEY (bookId) REFERENCES Books(bookId),
    FOREIGN KEY (tagId) REFERENCES Tag(tagId)
);

-- ============================================================

CREATE TABLE BookCopy (
    bookCopyId INT IDENTITY(1,1) PRIMARY KEY,
    bookId INT NOT NULL,
    [location] NVARCHAR(255) NULL,
    condition NVARCHAR(100) NOT NULL DEFAULT 'good',  -- good, damaged, lost
    [status] NVARCHAR(50) NOT NULL DEFAULT 'available', -- available, unavailable, borrowed , reserved 
	barcode NVARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,

    FOREIGN KEY (bookId) REFERENCES Books(bookId)
);

-- ============================================================

CREATE TABLE Reservation (
    reservationId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    bookId INT NOT NULL,
    bookCopyId INT NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'pending', -- pending, readypickup, fulfilled, cancelled 
    queue_position INT NULL,
    [start_date] DATE NULL DEFAULT GETDATE(),
    end_date DATE NULL,
  

    FOREIGN KEY (userId) REFERENCES [User](userId),
    FOREIGN KEY (bookId) REFERENCES Books(bookId),
    FOREIGN KEY (bookCopyId) REFERENCES BookCopy(bookCopyId)
);

-- ============================================================

CREATE TABLE BorrowRecord (
    borrowRecordId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    bookCopyId INT NOT NULL,
    bookId INT NOT NULL,
    [start_date] DATE NOT NULL DEFAULT GETDATE(),
    end_date DATE NOT NULL,
    returned_at DATETIME NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'borrowed', --borrowed, returned, overdue, lost
    extension_count INT NOT NULL DEFAULT 0,
    created_by INT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (userId) REFERENCES [User](userId),
    FOREIGN KEY (bookCopyId) REFERENCES BookCopy(bookCopyId),
    FOREIGN KEY (bookId) REFERENCES Books(bookId),
    FOREIGN KEY (created_by) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Fine (
    fineId INT IDENTITY(1,1) PRIMARY KEY,
    borrowRecordId INT NOT NULL,
    userId INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    reason NVARCHAR(500) NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'unpaid', --unpaid, paid  
    created_at DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (borrowRecordId) REFERENCES BorrowRecord(borrowRecordId),
    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Payment (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    fineId INT NOT NULL,
    paid_amount DECIMAL(18,2) NOT NULL,
    payment_method NVARCHAR(100) NULL,
    transaction_reference NVARCHAR(255) NULL UNIQUE,
    process_by INT NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'pending', --completed, pending, canceled
    paid_at DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (fineId) REFERENCES Fine(fineId),
    FOREIGN KEY (process_by) REFERENCES [User](userId)
);

-- ============================================================

CREATE TABLE Notification (
    notificationId INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(500) NOT NULL,
    content NVARCHAR(MAX) NULL,
    created_by INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (created_by) REFERENCES [User](userId)

);