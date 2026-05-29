# Library Management System (LMS) — Spec
# Version: 0.1 (DRAFT) | Owner: @your-name | Date: 2025-01-20

---

## 1. Context & Goal

**Bài toán:** Thư viện đại học đang vận hành thủ công (giấy tờ, excel), dẫn đến việc tra cứu sách chậm, dễ sai sót trong giao dịch mượn/trả, khó kiểm soát phạt quá hạn, và không có cơ chế đặt trước tự động.

**Mục tiêu:** Xây dựng hệ thống LMS số hóa toàn bộ luồng: tra cứu → mượn → gia hạn → trả → phạt → thanh toán. Hệ thống phục vụ 5 nhóm người dùng (Student, Lecturer, Librarian, Library Manager, System Administrator) với phân quyền độc lập.

**Giá trị cốt lõi:**
- Giảm thời gian giao dịch tại quầy bằng quét mã vạch.
- Tự động hóa: tính phạt hằng ngày, thông báo email, xử lý hàng chờ đặt trước.
- Đảm bảo truy vết toàn bộ thao tác qua Audit Log bất biến.

---

## 2. Actors & Roles

| Actor | Quyền chính |
|---|---|
| **Student** | Tìm kiếm, mượn (qua thủ thư), trả, gia hạn online, đặt trước, thanh toán phạt, xem lịch sử cá nhân |
| **Lecturer** | Như Student (chia sẻ các quyền mượn/trả/đặt trước/thanh toán) |
| **Librarian** | Quản lý danh mục sách & kho vật lý, quét mã vạch mượn/trả, xử lý hàng chờ đặt trước |
| **Library Manager** | Cấu hình chính sách (giới hạn mượn, mức phạt, số ngày gia hạn), báo cáo thống kê, quản lý tài khoản Librarian, đăng thông báo hệ thống |
| **System Administrator (SysAdmin)** | Quản lý toàn bộ tài khoản & phân quyền, xem Audit Log, cấu hình kỹ thuật (VNPAY, AI, Email), quản lý Business Configuration |
| **Guest** | Tìm kiếm sách (chỉ đọc), không thể xem lịch sử hoặc thực hiện giao dịch |

---

## 3. Functional Requirements

### UC-01 — Xác thực (Authentication)

- **FR01:** WHEN a user submits valid email + password, THE system SHALL authenticate and return a session token with role-based permissions.
- **FR01a:** WHEN a user enters an incorrect password, THE system SHALL increment `failed_login_attempts`. WHEN `failed_login_attempts` reaches 5, THE system SHALL set `status = 'locked'` and populate `locked_until` per security policy (BR-LMS-001).
- **FR02:** WHEN a user requests logout, THE system SHALL invalidate the current session token on all devices.
- **FR-OTP:** WHEN a user requests a password reset, THE system SHALL send a 6-digit OTP valid for 15 minutes. WHEN the user enters the OTP incorrectly 5 times, THE system SHALL lock the account for 30 minutes (BR-LMS-001).

### UC-02 — Quản lý Hồ sơ (Profile Management)

- **FR03:** WHEN a Student or Lecturer accesses their profile, THE system SHALL display role-specific fields: `student_code + major + enrollment_year` cho Student; `lecturer_code + department` cho Lecturer.
- **FR03a:** WHEN a user submits a profile update, THE system SHALL validate: full_name (chữ cái, không rỗng), phone_number (10 chữ số), email (đúng định dạng), gender (Male/Female/Other), date_of_birth (≥18 tuổi, không sau ngày hiện tại), student/lecturer code (10–15 ký tự chữ & số) (BR-LMS-023).
- **FR03b:** WHEN the system detects a profile update with duplicate phone_number or student/lecturer code, THE system SHALL block creation and prompt the user to update the existing profile or cancel (BR-LMS-023).

### UC-03 — Tìm kiếm & Gợi ý Sách

- **FR04:** WHEN a user searches by keyword, author, category, or tag, THE system SHALL return matching books with `available_quantity` visible for each result.
- **FR05:** WHEN a logged-in user views their profile or search results, THE system SHALL invoke the AI recommendation engine to display a personalized suggestion list based on borrow history and preferences (BR-LMS-018 — AI gợi ý chỉ mang tính tham khảo).

### UC-04 — Ghi nhận Mượn Sách

- **FR06:** WHEN a Librarian scans a book copy barcode and selects a valid member, THE system SHALL execute the borrowing transaction by checking for a `'readypickup'` reservation for this user and book. If found, the system fulfills it; if not, it creates a new reservation with status `'readypickup'` and immediately fulfills it. Fulfilling the reservation SHALL:
  1. Verify `available_quantity > 0` cho tựa sách.
  2. Verify thành viên không vượt giới hạn số sách mượn (configurable: `max_borrow_limit`).
  3. Verify thành viên không có khoản phạt chưa thanh toán (BR-LMS-004).
  4. Verify thành viên đã điền đầy đủ thông tin bắt buộc (BR-LMS-029).
  5. Create `BorrowRecord` với `start_date = GETDATE()`, `end_date = start_date + max_loan_days` (configurable).
  6. Set `BookCopy.status = 'borrowed'`. If the reservation was newly created, decrement `Books.available_quantity` by 1 (if it was an existing `'readypickup'` reservation, quantity is already decremented).
  7. Update `Reservation.status = 'fulfilled'`.
  8. Log vào `AuditLogs`.

### UC-05 — Gia hạn Sách

- **FR07:** WHEN a Student/Lecturer requests an extension online, THE system SHALL:
  1. Check `extension_count < max_extensions` (configurable).
  2. Check không có `Reservation` ở trạng thái `pending` hoặc `readypickup` cho cùng `bookId`.
  3. Check thành viên không có phạt chưa thanh toán (BR-LMS-004).
  4. WHEN điều kiện đạt, THE system SHALL extend `end_date` thêm `extension_duration_days` (configurable) và increment `extension_count` (BR-LMS-008).

### UC-06 — Đặt trước Sách (Reservation)

- **FR08:** EVERY borrow or reservation request SHALL start by creating a `Reservation` record. The system checks if `available_quantity > 0`. If so, it creates the `Reservation` with `status = 'readypickup'`. If `available_quantity = 0`, it creates the `Reservation` with `status = 'pending'` and assigns `queue_position` (FIFO queue). Creating a reservation only requires that `User.status != 'locked'` and total borrowed + reserved < `max_borrow_limit` (BR-LMS-005).
- **FR08a:** [Deprecated / Merged into FR08] All transactions route through Reservation first. Direct borrowing at the counter automatically creates a `'readypickup'` reservation and immediately fulfills it.
- **FR14:** WHEN a `BorrowRecord` is marked as `returned` (with `condition = 'good'`), THE system SHALL automatically:
  1. Query `Reservation` for earliest `queue_position` với `status = 'pending'` for this book.
  2. IF found: set `Reservation.status = 'readypickup'`, assign `bookCopyId` (Copy status set to `'reserved'`), set `end_date = GETDATE() + reservation_validity_days` (configurable).
  3. Decrement `Books.available_quantity` by 1 to lock the copy for the reserved user.
  4. Send email notification to reserved user (FR20, BR-LMS-027).
  5. IF `readypickup` không được collect trong `reservation_validity_days` (default 3 days), THE system SHALL auto-cancel (set `Reservation.status = 'cancelled'`), set `BookCopy.status = 'available'`, increment `Books.available_quantity` by 1, and advance queue (which will trigger assignment to the next pending user if any).

### UC-07 — Thanh toán Phạt

- **FR09:** WHEN a logged-in user accesses their dashboard, THE system SHALL display visual alerts for books due within 3 days or already overdue.
- **FR10:** WHEN a user initiates fine payment, THE system SHALL redirect to VNPAY gateway. WHEN VNPAY returns a successful `transaction_reference`, THE system SHALL set `Fine.status = 'paid'`, create `Payment` record, and restore borrowing rights.
- **FR19 (Background Job):** WHILE the system runs daily batch, THE system SHALL scan all `BorrowRecord` where `status = 'borrowed'` AND `end_date < GETDATE()`. FOR EACH overdue record, THE system SHALL update the existing unpaid `Fine` record for that borrowing transaction, or create a new `Fine` record if none exists: `amount = fine_per_day × days_overdue`, capped at `min(fine_per_day × days, book_price × max_fine_multiplier)` (BR-LMS-015, using `default_book_price` and `max_fine_multiplier` configurations if book price is NULL).

### UC-08 — Quản lý Danh mục Sách

- **FR11:** WHEN a Librarian adds/edits a book, THE system SHALL validate: ISBN (unique), title, author, publisher, publication_year, category (required), quantity > 0, price ≥ 0 (BR-LMS-024).
- **FR11a:** WHEN a duplicate ISBN is detected during import, THE system SHALL prompt the Librarian to overwrite, skip, or merge (BR-LMS-024).

### UC-09 — Quản lý Kho Vật lý

- **FR12:** WHEN a Librarian updates a `BookCopy`, THE system SHALL allow setting `condition` ∈ {good, damaged, lost} và `location`. WHEN condition = 'lost', THE system SHALL set `BookCopy.status = 'unavailable'` và decrement `Books.available_quantity`.

### UC-10 — Xử lý Trả Sách

- **FR13:** WHEN a Librarian scans a return barcode, THE system SHALL set `BorrowRecord.returned_at = GETDATE()`, `status = 'returned'`, `BookCopy.status = 'available'`, increment `Books.available_quantity`. THE system SHALL then trigger FR14 (luồng đặt trước) và FR19 check.

### UC-11 — Cấu hình & Thông báo

- **FR15:** WHEN a Library Manager creates a system announcement, THE system SHALL store it in `Notification` và display it as a banner to all logged-in users.
- **FR16:** WHEN a Library Manager updates a policy value (e.g., `max_loan_days`, `fine_per_day`), THE system SHALL write the new value to `SystemConfigurations` với `updated_by` và `updated_at`, và log vào `AuditLogs`.

### UC-12 — Quản trị Tài khoản

- **FR17:** WHEN a SysAdmin locks/unlocks a user account, THE system SHALL update `User.status` và log action vào `AuditLogs` với `userId` của admin và timestamp (BR-LMS-002, BR-LMS-019). Accounts cannot be deleted — only locked.

### UC-13 — Giám sát Hệ thống

- **FR18:** WHEN a SysAdmin queries audit logs, THE system SHALL return immutable records filtered by `entity_name`, `action_type`, `userId`, và time range (BR-LMS-019).
- **FR20 (Background):** THE system SHALL automatically send emails for: sắp đến hạn trả (3 ngày trước), phạt quá hạn mới, sách đặt trước sẵn sàng (BR-LMS-027).

---

## 4. Non-functional Requirements

| Category | Requirement |
|---|---|
| **Performance** | Tìm kiếm sách trả kết quả trong ≤2 giây với dataset ≤500,000 bản ghi |
| **Performance** | Quét mã vạch mượn/trả hoàn thành giao dịch trong ≤3 giây |
| **Availability** | Uptime ≥99.5% cho các module cốt lõi (search, borrow, reserve, payment). Bảo trì thông báo trước ≥48 giờ qua email + system banner |
| **Security** | Mã hóa toàn bộ data in-transit (TLS 1.2+) và at-rest (BR-LMS-028) |
| **Security** | RBAC: mỗi role chỉ truy cập đúng module được cấp quyền. Unauthorized access phải được log (BR-LMS-003) |
| **Security** | Password: ≥8 ký tự, có chữ hoa/thường/số/ký tự đặc biệt (BR-LMS-022) |
| **Auditability** | Mọi thao tác critical (mượn, trả, phạt, payment, config change) đều ghi vào `AuditLogs` với userId + timestamp + old/new values. Audit log bất biến (BR-LMS-019) |
| **Scalability** | Hệ thống hỗ trợ tối thiểu 500 concurrent users |
| **Data Integrity** | Bản ghi sách bị thiếu/hỏng phải được đánh dấu `unavailable` — không hiển thị dữ liệu không đầy đủ (BR-LMS-024) |
| **Integration** | VNPAY payment gateway; AI recommendation engine; SMTP email service |

---

## 5. Data

### Bảng chính và quan hệ

```
[User] 1──────< [MemberProfile]
[User] 1──────< [Student]           (userId FK)
[User] 1──────< [Lecturer]          (userId FK)
[User] 1──────< [Librarian]         (userId FK)
[User] 1──────< [LibraryManager]    (userId FK)
[User] 1──────< [Admin]             (userId FK)

[Books] 1──────< [BookCopy]         (bookId FK)
[Books] >──────< [Category]         via [BookCategory]
[Books] >──────< [Tag]              via [BookTag]

[User] 1──────< [BorrowRecord]      (userId, bookId, bookCopyId)
[User] 1──────< [Reservation]       (userId, bookId, bookCopyId nullable)
[BorrowRecord] 1──────< [Fine]
[Fine] 1──────< [Payment]

[SystemConfigurations]              (config_key PK, config_value, updated_by FK)
[AuditLogs]                         (userId FK, action_type, entity_name, entity_id, old_values, new_values, timestamp)
[Notification]                      (created_by FK)
```

### Script tạo bảng trong SQL Server (DDL)

```sql
CREATE DATABASE LMS_Library_Management_System;
GO
USE LMS_Library_Management_System;
GO

-- ============================================================
-- 1. Bảng User
-- ============================================================
CREATE TABLE [User] (
    userId INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'active', -- active, locked
    [role] NVARCHAR(50) NOT NULL,
    lock_reason NVARCHAR(50) NULL, -- unpaid, adminban, securitybreach
    failed_login_attempts INT NOT NULL DEFAULT 0,
    locked_until DATETIME NULL
);

-- ============================================================
-- 2. Bảng MemberProfile
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
-- 3. Bảng Student
-- ============================================================
CREATE TABLE Student (
    userId INT PRIMARY KEY,
    student_code NVARCHAR(50) NOT NULL UNIQUE,
    major NVARCHAR(255) NULL,
    enrollment_year INT NULL,
    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================
-- 4. Bảng Lecturer
-- ============================================================
CREATE TABLE Lecturer (
    userId INT PRIMARY KEY,
    lecturer_code NVARCHAR(50) NOT NULL UNIQUE,
    department NVARCHAR(255) NULL,
    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================
-- 5. Bảng Librarian
-- ============================================================
CREATE TABLE Librarian (
    userId INT PRIMARY KEY,
    staff_code NVARCHAR(50) NOT NULL UNIQUE,
    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================
-- 6. Bảng LibraryManager
-- ============================================================
CREATE TABLE LibraryManager (
    userId INT PRIMARY KEY,
    staff_code NVARCHAR(50) NOT NULL UNIQUE,
    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================
-- 7. Bảng Admin
-- ============================================================
CREATE TABLE Admin (
    userId INT PRIMARY KEY,
    staff_code NVARCHAR(50) NOT NULL UNIQUE,
    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================
-- 8. Bảng SystemConfigurations
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
-- 9. Bảng AuditLogs
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
-- 10. Bảng Category
-- ============================================================
CREATE TABLE Category (
    categoryId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL
);

-- ============================================================
-- 11. Bảng Tag
-- ============================================================
CREATE TABLE Tag (
    tagId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE
);

-- ============================================================
-- 12. Bảng Books
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
    [status] NVARCHAR(50) NOT NULL DEFAULT 'available',  -- unavailable, available
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL 
);

-- ============================================================
-- 13. Bảng BookCategory (Liên kết Book - Category)
-- ============================================================
CREATE TABLE BookCategory (
    bookId INT NOT NULL,
    categoryId INT NOT NULL,
    PRIMARY KEY (bookId, categoryId),
    FOREIGN KEY (bookId) REFERENCES Books(bookId),
    FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
);

-- ============================================================
-- 14. Bảng BookTag (Liên kết Book - Tag)
-- ============================================================
CREATE TABLE BookTag (
    bookId INT NOT NULL,
    tagId INT NOT NULL,
    PRIMARY KEY (bookId, tagId),
    FOREIGN KEY (bookId) REFERENCES Books(bookId),
    FOREIGN KEY (tagId) REFERENCES Tag(tagId)
);

-- ============================================================
-- 15. Bảng BookCopy
-- ============================================================
CREATE TABLE BookCopy (
    bookCopyId INT IDENTITY(1,1) PRIMARY KEY,
    bookId INT NOT NULL,
    [location] NVARCHAR(255) NULL,
    condition NVARCHAR(100) NOT NULL DEFAULT 'good',  -- good, damaged, lost
    [status] NVARCHAR(50) NOT NULL DEFAULT 'available', -- available, unavailable, borrowed, reserved 
    barcode NVARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    FOREIGN KEY (bookId) REFERENCES Books(bookId)
);

-- ============================================================
-- 16. Bảng Reservation (Đặt trước sách)
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
-- 17. Bảng BorrowRecord (Nhật ký mượn)
-- ============================================================
CREATE TABLE BorrowRecord (
    borrowRecordId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    bookCopyId INT NOT NULL,
    bookId INT NOT NULL,
    [start_date] DATE NOT NULL DEFAULT GETDATE(),
    end_date DATE NOT NULL,
    returned_at DATETIME NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'borrowed', -- borrowed, returned, overdue, lost
    extension_count INT NOT NULL DEFAULT 0,
    created_by INT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES [User](userId),
    FOREIGN KEY (bookCopyId) REFERENCES BookCopy(bookCopyId),
    FOREIGN KEY (bookId) REFERENCES Books(bookId),
    FOREIGN KEY (created_by) REFERENCES [User](userId)
);

-- ============================================================
-- 18. Bảng Fine (Phạt vi phạm)
-- ============================================================
CREATE TABLE Fine (
    fineId INT IDENTITY(1,1) PRIMARY KEY,
    borrowRecordId INT NOT NULL,
    userId INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    reason NVARCHAR(500) NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'unpaid', -- unpaid, paid  
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (borrowRecordId) REFERENCES BorrowRecord(borrowRecordId),
    FOREIGN KEY (userId) REFERENCES [User](userId)
);

-- ============================================================
-- 19. Bảng Payment (Thanh toán phạt)
-- ============================================================
CREATE TABLE Payment (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    fineId INT NOT NULL,
    paid_amount DECIMAL(18,2) NOT NULL,
    payment_method NVARCHAR(100) NULL,
    transaction_reference NVARCHAR(255) NULL UNIQUE,
    process_by INT NULL,
    [status] NVARCHAR(50) NOT NULL DEFAULT 'pending', -- completed, pending, canceled
    paid_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (fineId) REFERENCES Fine(fineId),
    FOREIGN KEY (process_by) REFERENCES [User](userId)
);

-- ============================================================
-- 20. Bảng Notification (Thông báo hệ thống)
-- ============================================================
CREATE TABLE Notification (
    notificationId INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(500) NOT NULL,
    content NVARCHAR(MAX) NULL,
    created_by INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (created_by) REFERENCES [User](userId)
);
```

### Configurable parameters (stored in SystemConfigurations)

| config_key | Ý nghĩa | Default |
|---|---|---|
| `max_borrow_limit` | Số sách tối đa được mượn đồng thời / thành viên | 5 |
| `max_loan_days` | Số ngày mượn tối đa | 14 |
| `max_extensions` | Số lần gia hạn tối đa / lượt mượn | 2 |
| `extension_duration_days` | Số ngày mỗi lần gia hạn | 7 |
| `fine_per_day` | Tiền phạt cơ sở / ngày quá hạn (VND) | 2,000 |
| `reservation_validity_days` | Số ngày giữ sách cho người đặt trước | 3 |
| `account_lock_duration_minutes` | Thời gian khóa tài khoản sau 5 lần sai | 30 |
| `default_book_price` | Giá trị mặc định của sách khi cột price bị NULL (VND) | 100,000 |
| `max_fine_multiplier` | Hệ số trần tiền phạt trễ hạn hoặc đền bù | 1.5 |
| `max_no_show_limit` | Giới hạn số lần đặt sách quá hạn không đến lấy | 3 |
| `no_show_lock_duration_days` | Thời gian khóa tài khoản khi quá giới hạn không lấy sách | 7 |

### Key constraints

- `Books.isbn` UNIQUE, NOT NULL
- `User.email` UNIQUE, NOT NULL
- `Student.student_code`, `Lecturer.lecturer_code` UNIQUE
- `BookCopy.barcode` NOT NULL
- `Payment.transaction_reference` UNIQUE
- `BorrowRecord.status` ∈ {borrowed, returned, overdue, lost}
- `Reservation.status` ∈ {pending, readypickup, fulfilled, cancelled}
- `Fine.status` ∈ {unpaid, paid}
- `User.status` ∈ {active, locked}

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| WHERE login fails 5 consecutive times | THE system SHALL set `User.status = 'locked'`, set `locked_until`, return HTTP 403 với message "Tài khoản đã bị khóa. Liên hệ Admin." |
| WHERE user attempts borrow with unpaid fine | THE system SHALL block transaction và display "Bạn có khoản phạt chưa thanh toán. Vui lòng thanh toán trước." |
| WHERE user attempts borrow exceeding `max_borrow_limit` | THE system SHALL block và display "Bạn đã đạt giới hạn mượn sách. Vui lòng trả sách trước." |
| WHERE `available_quantity = 0` and user tries to borrow | THE system SHALL suggest "Đặt trước" thay vì block silently |
| WHERE extension is blocked by existing reservation | THE system SHALL return "Không thể gia hạn — đã có người đặt trước tựa sách này." |
| WHERE VNPAY callback fails / timeout | THE system SHALL retain `Fine.status = 'unpaid'`, `Payment.status = 'pending'`, notify user "Thanh toán chưa xác nhận. Vui lòng thử lại." |
| WHERE duplicate ISBN detected during book import | THE system SHALL halt import, display conflicting record, và prompt Librarian: Overwrite / Skip / Merge |
| WHERE book record has missing mandatory fields | THE system SHALL mark `Books.status = 'unavailable'` và display error to Librarian |
| WHERE a book is reported `lost` | THE system SHALL set `BookCopy.condition = 'lost'`, `status = 'unavailable'`, generate Fine at book_price × 1.5 (capped per BR-LMS-028) |
| WHERE reservation `readypickup` expires (past `reservation_validity_days`) | THE system SHALL auto-cancel reservation, set `status = 'cancelled'`, advance queue to next person |
| WHERE user profile has duplicate phone/student ID | THE system SHALL block profile creation và suggest matching existing record |

---

## 7. Acceptance Criteria

### Authentication
- [ ] Đăng nhập thành công với email + password hợp lệ → nhận session token, redirect đúng dashboard theo role.
- [ ] Đăng nhập sai 5 lần liên tiếp → tài khoản bị khóa, `locked_until` được set, không thể tiếp tục.
- [ ] Tài khoản bị khóa → không thể mượn sách hoặc truy cập tính năng cá nhân.
- [ ] Đăng xuất → session bị hủy, redirect về trang login.
- [ ] OTP reset password: gửi email trong ≤60s, hết hạn sau 15 phút, khóa 30 phút sau 5 lần nhập sai.

### Tìm kiếm & Gợi ý
- [ ] Tìm kiếm theo từ khóa, tác giả, category, tag → kết quả hiển thị `available_quantity` cho mỗi tựa sách.
- [ ] Người dùng đã đăng nhập xem profile → hiển thị ≥3 gợi ý AI.
- [ ] Guest không thấy lịch sử hoặc gợi ý cá nhân.

### Mượn & Trả
- [ ] Librarian quét barcode hợp lệ của thành viên active, không có fine, chưa đạt giới hạn → `BorrowRecord` được tạo, `BookCopy.status = 'borrowed'`, `available_quantity` giảm 1, AuditLog ghi nhận.
- [ ] Thành viên có fine chưa trả → giao dịch mượn bị block.
- [ ] Thành viên đã đạt `max_borrow_limit` → giao dịch mượn bị block.
- [ ] Librarian quét barcode trả sách → `BorrowRecord.returned_at` được set, `BookCopy.status = 'available'`, `available_quantity` tăng 1.
- [ ] Trả sách trễ hạn → `Fine` được tạo tự động với amount = fine_per_day × days_overdue (capped tại book_price × 1.5).

### Gia hạn & Đặt trước
- [ ] Gia hạn hợp lệ (không có reservation, không quá max_extensions) → `end_date` tăng thêm `extension_duration_days`, `extension_count` tăng 1.
- [ ] Gia hạn khi có người đặt trước tựa sách → bị block, hiển thị message rõ ràng.
- [ ] Đặt trước khi `available_quantity = 0` → Reservation tạo với `queue_position` đúng thứ tự.
- [ ] Sách được trả khi có người đặt trước → người đầu hàng nhận email thông báo trong ≤5 phút, `Reservation.status = 'readypickup'`.
- [ ] Không lấy sách trong `reservation_validity_days` → Reservation tự động `cancelled`, người tiếp theo được thông báo.

### Thanh toán
- [ ] Người dùng có fine → nhìn thấy cảnh báo trên dashboard.
- [ ] Thanh toán VNPAY thành công → `Fine.status = 'paid'`, `Payment` record tạo, quyền mượn khôi phục.
- [ ] VNPAY timeout/fail → fine giữ `unpaid`, user thấy thông báo lỗi.

### Cấu hình & Audit
- [ ] Library Manager thay đổi `fine_per_day` → `SystemConfigurations` updated, AuditLog ghi nhận với `updated_by` + `updated_at`.
- [ ] Các giao dịch mượn, trả, fine, payment đều có bản ghi trong `AuditLogs` với đủ thông tin userId, action, timestamp.
- [ ] SysAdmin xem audit log → lọc được theo entity_name, action_type, user, time range.
- [ ] SysAdmin khóa/mở khóa tài khoản → ghi log action kèm admin ID.

### Background Jobs
- [ ] Daily job: sách quá hạn chưa có Fine → Fine được tạo tự động.
- [ ] Email reminder: gửi email cho sách sắp đến hạn (3 ngày trước).

---

## 8. Out of Scope

- **Xóa tài khoản người dùng** — Admin chỉ có thể lock/unlock, không delete (BR-LMS-002).
- **Mobile native app** — Sprint này chỉ build web application.
- **Digital/eBook borrowing** — Chỉ sách vật lý.
- **Inter-library loan** — Chỉ sách thuộc kho thư viện nội bộ.
- **Bulk book import từ external catalog** (MARC/Z39.50) — Nhập thủ công qua giao diện admin.
- **Reporting & analytics module** — Báo cáo thống kê (UC báo cáo của Library Manager) sẽ làm sprint sau.
- **AI recommendation model training** — Sprint này tích hợp API AI sẵn có, không train model riêng.
- **Multi-branch library support** — Chỉ 1 thư viện duy nhất.
- **Self-checkout kiosk integration** — Mượn sách vẫn qua quầy Librarian.
- **Fine waiver / appeal workflow** — Librarian tạo fine, không có UI kháng cáo.

---

## Notes / Open Questions

> *(Dành cho AI review ở Bước 2 — không xóa mục này)*

1. **Concurrent borrow:** Nếu 2 Librarian quét cùng 1 barcode trong cùng lúc (`available_quantity = 1`) → race condition xử lý thế nào? Cần pessimistic lock hay optimistic lock?
2. **Lost book fine:** BR-LMS-015 nói fine tối đa = book_price × 1.5, nhưng BR-LMS-013 / BR-LMS-009 nói sách lost không thể mượn/đặt. Liệu `BorrowRecord.status = 'lost'` có tự động generate fine không? Hay Librarian tạo thủ công?
3. **Reservation và available_quantity:** Nếu có 3 `Reservation` pending và 1 cuốn được trả, hệ thống gán ngay cho người #1 nhưng `available_quantity` vẫn = 0 (vì đang giữ cho reservation). Cần confirm logic update `available_quantity` trong trường hợp này.
4. **Payment partial:** `Payment.paid_amount` — liệu có trường hợp thanh toán một phần fine không? Hiện tại schema cho phép nhưng FR10 chưa mô tả.
5. **Email service:** FR20 cần SMTP config trong `SystemConfigurations` — ai setup? SysAdmin qua FR-technical config. Template email chuẩn hóa ở đâu?
6. **AI recommendation:** FR05 chưa định nghĩa: cold-start user (chưa có lịch sử mượn) nhận gợi ý gì? Gợi ý phổ biến nhất? Theo major của Student?
7. **Notification table:** `Notification` table hiện chỉ có title/content/created_by — thiếu `recipient` và `read_status`. Liệu đây là system-wide broadcast hay per-user notification?`