# .sdd/shared_context.md
# File này là NGUỒN SỰ THẬT CHUNG cho mọi agents trong dự án LMS
# Read bởi: Tất cả agents trước khi bắt đầu code JSP hoặc Servlet
# Version: 2.0.0 | Updated: 29/5/2026
# Updated by: Lead Architect Agent — khởi tạo đầy đủ từ 32 FR + 23 UC

---

## 1. ACTOR ↔ USE CASE MAPPING

### Guest
| UC | Tên | Servlet dự kiến |
|---|---|---|
| UC01 | Đăng nhập hệ thống | `LoginServlet` |

### Student, Lecturer (Shared)
| UC | Tên | Servlet dự kiến |
|---|---|---|
| UC01 | Đăng nhập hệ thống | `LoginServlet` |
| UC02 | Đăng xuất tài khoản | `LogoutServlet` |
| UC03 | Xem hồ sơ cá nhân | `ProfileServlet` (GET) |
| UC04 | Cập nhật hồ sơ | `ProfileServlet` (POST) |
| UC05 | Tìm kiếm Đầu sách | `BookSearchServlet` |
| UC06 | Xem trạng thái Kho sách | `BookDetailServlet` |
| UC07 | Nhận gợi ý sách (AI) | `AIRecommendServlet` |
| UC08 | Yêu cầu Gia hạn | `ExtendBookServlet` |
| UC09 | Ghi danh Đặt trước | `ReservationServlet` (POST) |
| UC10 | Hủy Đặt trước chủ động | `CancelReservationServlet` |
| UC11 | Tra cứu nợ phạt | `FineListServlet` |
| UC12 | Thanh toán VNPAY | `PaymentServlet` + `PaymentCallbackServlet` |

### Librarian
| UC | Tên | Servlet dự kiến |
|---|---|---|
| UC13 | Quét mã Mượn sách | `BorrowBookServlet` |
| UC14 | Quét mã Trả sách | `ReturnBookServlet` |
| UC15 | Quản lý thông tin Đầu sách | `BookManagementServlet` |
| UC16 | Quản lý Phân loại sách | `CategoryTagServlet` |
| UC17 | Khai báo Bản sao vật lý | `BookCopyServlet` |
| UC18 | Cập nhật Hao mòn tài sản | `BookConditionServlet` |

### Library Manager
| UC | Tên | Servlet dự kiến |
|---|---|---|
| UC19 | Đăng Thông báo chung | `NotificationServlet` |
| UC20 | Cấu hình Quy tắc Thư viện | `SystemConfigServlet` |

### SysAdmin
| UC | Tên | Servlet dự kiến |
|---|---|---|
| UC21 | Quản trị Danh sách User | `UserListServlet` |
| UC22 | Xử lý Vi phạm thủ công | `UserLockServlet` |
| UC23 | Tra cứu Nhật ký (Audit) | `AuditLogServlet` |

---

## 2. SERVLET ↔ JSP CONTRACTS (Source of Truth)

### Authentication Module

**POST /login** (`LoginServlet`)
  Form Parameters:
    - email: String
    - password: String
  View Attributes (trả về login.jsp hoặc redirect dashboard):
    - errorMessage: String (nếu sai thông tin)
    - user: User (set vào HttpSession nếu thành công)
  Business Rules: BR-LMS-001 (lockout), BR-LMS-022 (password policy)
  Status: 📋 PLANNED

**GET /logout** (`LogoutServlet`)
  Action: Invalidate HttpSession → redirect login.jsp
  FR tham chiếu: FR03
  Status: 📋 PLANNED

### Profile Module

**GET /profile** (`ProfileServlet`)
  View Attributes (trả về profile.jsp):
    - userProfile: MemberProfile
    - studentInfo: Student (nếu role = student)
    - lecturerInfo: Lecturer (nếu role = lecturer)
  FR tham chiếu: FR04
  Status: 📋 PLANNED

**POST /profile** (`ProfileServlet`)
  Form Parameters:
    - fullName: String
    - phoneNumber: String (10 digits)
    - gender: String (Male/Female/Other)
    - dateOfBirth: String (dd/MM/yyyy)
  View Attributes:
    - successMessage: String
    - errorMessage: String (nếu vi phạm BR-LMS-023 duplicate)
  FR tham chiếu: FR05
  Status: 📋 PLANNED

### Search & AI Module

**GET /book-search** (`BookSearchServlet`)
  Request Parameters:
    - keyword: String (optional)
    - categoryId: int (optional)
    - tagId: int (optional)
    - page: int (default 1)
  View Attributes (trả về book-list.jsp):
    - books: List<Book> (mỗi Book kèm available_quantity)
    - totalPages: int
    - currentPage: int
  FR tham chiếu: FR06
  Status: 📋 PLANNED

**GET /book-detail** (`BookDetailServlet`)
  Request Parameters:
    - bookId: int
  View Attributes (trả về book-detail.jsp):
    - book: Book
    - availableCopies: int
    - categories: List<Category>
    - tags: List<Tag>
  FR tham chiếu: FR07
  Status: 📋 PLANNED

**GET /ai-recommend** (`AIRecommendServlet`)
  View Attributes (trả về recommendation.jsp hoặc JSON fragment):
    - recommendations: List<Book>
  Notes: Gọi AI bất đồng bộ qua ExecutorService (ARCH-04)
  FR tham chiếu: FR08
  Status: 📋 PLANNED

### Transaction Module (Librarian)

**POST /borrow-book** (`BorrowBookServlet`)
  Form Parameters:
    - barcode: String (mã vạch BookCopy)
    - memberId: String (mã sinh viên/giảng viên)
  View Attributes (trả về borrow-result.jsp):
    - successMessage: String
    - errorMessage: String
    - borrowRecord: BorrowRecord (nếu thành công)
  Business Rules: BR-LMS-004 (fine-first), BR-LMS-005 (borrow limit), BR-LMS-006 (loan duration)
  FR tham chiếu: FR09, FR10
  Status: 📋 PLANNED

**POST /return-book** (`ReturnBookServlet`)
  Form Parameters:
    - barcode: String (mã vạch BookCopy)
    - condition: String (good/damaged/lost) — BẮT BUỘC (BR-LMS-013)
  View Attributes (trả về return-result.jsp):
    - successMessage: String
    - errorMessage: String
    - fineGenerated: Fine (nếu có phạt đền bù — BR-LMS-016)
  Trigger: FR23 (phân bổ hàng chờ), FR29 (kiểm tra phạt trễ hạn)
  FR tham chiếu: FR22
  Status: 📋 PLANNED

### Extension & Reservation Module

**POST /extend-book** (`ExtendBookServlet`)
  Form Parameters:
    - borrowRecordId: int
  View Attributes:
    - successMessage: String
    - errorMessage: String (nếu bị chặn — BR-LMS-007, BR-LMS-008)
    - newEndDate: java.sql.Date
  FR tham chiếu: FR11, FR12
  Status: 📋 PLANNED

**POST /reservation** (`ReservationServlet`)
  Form Parameters:
    - bookId: int
  View Attributes:
    - successMessage: String (kèm queuePosition)
    - errorMessage: String (nếu vi phạm BR-LMS-005 hoặc BR-LMS-009)
  FR tham chiếu: FR13
  Status: 📋 PLANNED

**POST /cancel-reservation** (`CancelReservationServlet`)
  Form Parameters:
    - reservationId: int
  View Attributes:
    - successMessage: String
    - errorMessage: String
  FR tham chiếu: FR14
  Status: 📋 PLANNED

### Finance Module

**GET /fine-list** (`FineListServlet`)
  View Attributes (trả về fine-list.jsp):
    - fines: List<Fine>
    - totalUnpaid: BigDecimal
    - alerts: List<String> (cảnh báo sắp/quá hạn — FR15, tính realtime không lưu DB)
  FR tham chiếu: FR15
  Status: 📋 PLANNED

**POST /payment** (`PaymentServlet`)
  Form Parameters:
    - fineId: int
  Action: Đóng gói thông tin → redirect VNPAY gateway
  FR tham chiếu: FR16
  Status: 📋 PLANNED

**GET /payment-callback** (`PaymentCallbackServlet`)
  Request Parameters: (từ VNPAY IPN)
    - vnp_ResponseCode: String
    - vnp_TransactionNo: String
    - vnp_SecureHash: String
    - ... (VNPAY standard params)
  Action: Đối soát SecureHash → cập nhật Fine.status + tạo Payment record
  FR tham chiếu: FR17
  Status: 📋 PLANNED

### Admin & Config Module

**GET /user-list** (`UserListServlet`)
  Request Parameters:
    - keyword: String (optional)
    - role: String (optional)
    - page: int
  View Attributes (trả về user-list.jsp):
    - users: List<User>
    - totalPages: int
  FR tham chiếu: FR26
  Status: 📋 PLANNED

**POST /user-lock** (`UserLockServlet`)
  Form Parameters:
    - userId: int
    - action: String (lock/unlock)
    - reason: String (optional)
  Trigger: AuditLogDAO.insert() — bắt buộc (ARCH-02)
  FR tham chiếu: FR27
  Status: 📋 PLANNED

**GET /audit-log** (`AuditLogServlet`)
  Request Parameters:
    - entityName: String (optional)
    - actionType: String (optional)
    - userId: int (optional)
    - fromDate: String (optional, dd/MM/yyyy)
    - toDate: String (optional, dd/MM/yyyy)
  View Attributes (trả về audit-log.jsp):
    - logs: List<AuditLog>
    - totalPages: int
  FR tham chiếu: FR28
  Status: 📋 PLANNED

**POST /system-config** (`SystemConfigServlet`)
  Form Parameters:
    - configKey: String
    - configValue: String
  Trigger: AuditLogDAO.insert() — bắt buộc (ARCH-02)
  FR tham chiếu: FR25
  Status: 📋 PLANNED

**POST /notification** (`NotificationServlet`)
  Form Parameters:
    - title: String
    - content: String
  View Attributes:
    - successMessage: String
  FR tham chiếu: FR24
  Status: 📋 PLANNED

### Book & Inventory Management (Librarian)

**POST /book-management** (`BookManagementServlet`)
  Form Parameters:
    - action: String (add/edit/delete)
    - isbn: String, title: String, author: String, publisher: String
    - publicationYear: int, price: BigDecimal, categoryIds: int[]
  Business Rules: BR-LMS-024 (validation), BR-LMS-026 (classification)
  FR tham chiếu: FR18
  Status: 📋 PLANNED

**POST /category-tag** (`CategoryTagServlet`)
  Form Parameters:
    - action: String (addCategory/editCategory/deleteCategory/addTag/editTag/deleteTag)
    - name: String, description: String (optional)
  FR tham chiếu: FR19
  Status: 📋 PLANNED

**POST /book-copy** (`BookCopyServlet`)
  Form Parameters:
    - bookId: int
    - location: String
  Action: Tạo BookCopy mới + sinh barcode tự động
  FR tham chiếu: FR20
  Status: 📋 PLANNED

**POST /book-condition** (`BookConditionServlet`)
  Form Parameters:
    - bookCopyId: int
    - condition: String (good/damaged/lost)
  Business Rules: BR-LMS-013 (condition management)
  FR tham chiếu: FR21
  Status: 📋 PLANNED

---

## 3. BACKGROUND JOBS (System-triggered — không có UI)

| Job | Trigger | Mô tả | FR tham chiếu |
|---|---|---|---|
| `DailyFineJob` | Mỗi đêm (00:00) | Rà soát BorrowRecord quá hạn → tạo Fine records | FR29 |
| `ReservationCleanupJob` | Mỗi đêm (01:00) | Hủy Reservation `readypickup` quá hạn, luân chuyển cho người tiếp theo | FR30 |
| `EmailNotificationJob` | Mỗi đêm (06:00) | Gửi email: sắp đến hạn (3 ngày), có sách chờ, bị phạt | FR31 |
| `PaymentTimeoutJob` | Mỗi 15 phút | Hủy Payment `pending` quá 15 phút chưa nhận phản hồi VNPAY | FR32 |

---

## 4. DATA TYPES (Java Model ↔ SQL Database)
# Ánh xạ chính xác giữa Java CamelCase và DB columns
# Tham chiếu: database/LMS_Library_Management_System.sql

### User
  userId: int (DB: userId INT IDENTITY PK)
  email: String (DB: email NVARCHAR(255) UNIQUE NOT NULL)
  passwordHash: String (DB: password_hash NVARCHAR(255) NOT NULL)
  status: String (DB: status NVARCHAR(50) — values: 'active', 'locked')
  role: String (DB: role NVARCHAR(50))
  lockReason: String (DB: lock_reason NVARCHAR(50) — values: 'unpaid', 'adminban', 'securitybreach', NULL)
  failedLoginAttempts: int (DB: failed_login_attempts INT DEFAULT 0)
  lockedUntil: java.sql.Timestamp (DB: locked_until DATETIME, nullable)

### MemberProfile
  userId: int (DB: userId INT PK FK → User)
  fullName: String (DB: full_name NVARCHAR(255) NOT NULL)
  phoneNumber: String (DB: phone_number NVARCHAR(20), nullable)
  gender: String (DB: gender NVARCHAR(10), nullable)
  dateOfBirth: java.sql.Date (DB: date_of_birth DATE, nullable)
  startDate: java.sql.Date (DB: start_date DATE, nullable)
  endDate: java.sql.Date (DB: end_date DATE, nullable)

### Student
  userId: int (DB: userId INT PK FK → User)
  studentCode: String (DB: student_code NVARCHAR(50) UNIQUE NOT NULL)
  major: String (DB: major NVARCHAR(255), nullable)
  enrollmentYear: int (DB: enrollment_year INT, nullable)

### Lecturer
  userId: int (DB: userId INT PK FK → User)
  lecturerCode: String (DB: lecturer_code NVARCHAR(50) UNIQUE NOT NULL)
  department: String (DB: department NVARCHAR(255), nullable)

### BorrowRecord
  borrowRecordId: int (DB: borrowRecordId INT IDENTITY PK)
  userId: int (DB: userId INT FK → User)
  bookCopyId: int (DB: bookCopyId INT FK → BookCopy)
  bookId: int (DB: bookId INT FK → Books)
  startDate: java.sql.Date (DB: start_date DATE)
  endDate: java.sql.Date (DB: end_date DATE)
  returnedAt: java.sql.Timestamp (DB: returned_at DATETIME, nullable)
  status: String (DB: status NVARCHAR(50) — values: 'borrowed', 'returned', 'overdue', 'lost')
  extensionCount: int (DB: extension_count INT DEFAULT 0)
  createdBy: int (DB: created_by INT FK → User, nullable)
  createdAt: java.sql.Timestamp (DB: created_at DATETIME DEFAULT GETDATE())

### Reservation
  reservationId: int (DB: reservationId INT IDENTITY PK)
  userId: int (DB: userId INT FK → User)
  bookId: int (DB: bookId INT FK → Books)
  bookCopyId: int (DB: bookCopyId INT FK → BookCopy, nullable)
  status: String (DB: status NVARCHAR(50) — values: 'pending', 'readypickup', 'fulfilled', 'cancelled')
  queuePosition: int (DB: queue_position INT, nullable)
  startDate: java.sql.Date (DB: start_date DATE DEFAULT GETDATE())
  endDate: java.sql.Date (DB: end_date DATE, nullable)

### Fine
  fineId: int (DB: fineId INT IDENTITY PK)
  borrowRecordId: int (DB: borrowRecordId INT FK → BorrowRecord)
  userId: int (DB: userId INT FK → User)
  amount: BigDecimal (DB: amount DECIMAL(18,2))
  reason: String (DB: reason NVARCHAR(500), nullable)
  status: String (DB: status NVARCHAR(50) — values: 'unpaid', 'paid')
  createdAt: java.sql.Timestamp (DB: created_at DATETIME DEFAULT GETDATE())

### Payment
  paymentId: int (DB: paymentId INT IDENTITY PK)
  fineId: int (DB: fineId INT FK → Fine)
  paidAmount: BigDecimal (DB: paid_amount DECIMAL(18,2))
  paymentMethod: String (DB: payment_method NVARCHAR(100), nullable)
  transactionReference: String (DB: transaction_reference NVARCHAR(255) UNIQUE, nullable)
  processBy: int (DB: process_by INT FK → User, nullable)
  status: String (DB: status NVARCHAR(50) — values: 'completed', 'pending', 'canceled')
  paidAt: java.sql.Timestamp (DB: paid_at DATETIME DEFAULT GETDATE())

### Books
  bookId: int (DB: bookId INT IDENTITY PK)
  isbn: String (DB: isbn NVARCHAR(20) UNIQUE NOT NULL)
  title: String (DB: title NVARCHAR(500) NOT NULL)
  author: String (DB: author NVARCHAR(500), nullable)
  publisher: String (DB: publisher NVARCHAR(255), nullable)
  publicationYear: int (DB: publication_year INT, nullable)
  price: BigDecimal (DB: price DECIMAL(18,2), nullable)
  totalQuantity: int (DB: total_quantity INT DEFAULT 0)
  availableQuantity: int (DB: available_quantity INT DEFAULT 0)
  status: String (DB: status NVARCHAR(50) — values: 'available', 'unavailable')
  createdAt: java.sql.Timestamp (DB: created_at DATETIME DEFAULT GETDATE())
  updatedAt: java.sql.Timestamp (DB: updated_at DATETIME, nullable)

### BookCopy
  bookCopyId: int (DB: bookCopyId INT IDENTITY PK)
  bookId: int (DB: bookId INT FK → Books)
  location: String (DB: location NVARCHAR(255), nullable)
  condition: String (DB: condition NVARCHAR(100) — values: 'good', 'damaged', 'lost')
  status: String (DB: status NVARCHAR(50) — values: 'available', 'unavailable', 'borrowed', 'reserved')
  barcode: String (DB: barcode NVARCHAR(50) NOT NULL)
  createdAt: java.sql.Timestamp (DB: created_at DATETIME DEFAULT GETDATE())
  updatedAt: java.sql.Timestamp (DB: updated_at DATETIME, nullable)

### SystemConfigurations
  configKey: String (DB: config_key NVARCHAR(255) PK)
  configValue: String (DB: config_value NVARCHAR(MAX), nullable)
  description: String (DB: description NVARCHAR(MAX), nullable)
  updatedBy: int (DB: updated_by INT FK → User, nullable)
  updatedAt: java.sql.Timestamp (DB: updated_at DATETIME DEFAULT GETDATE())

### Notification
  notificationId: int (DB: notificationId INT IDENTITY PK)
  title: String (DB: title NVARCHAR(500) NOT NULL)
  content: String (DB: content NVARCHAR(MAX), nullable)
  createdBy: int (DB: created_by INT FK → User NOT NULL)
  createdAt: java.sql.Timestamp (DB: created_at DATETIME DEFAULT GETDATE())

### AuditLogs
  auditLogId: int (DB: auditLogId INT IDENTITY PK)
  userId: int (DB: userId INT FK → User, nullable)
  actionType: String (DB: action_type NVARCHAR(100) NOT NULL)
  entityName: String (DB: entity_name NVARCHAR(255), nullable)
  entityId: int (DB: entity_id INT, nullable)
  oldValues: String (DB: old_values NVARCHAR(MAX), nullable)
  newValues: String (DB: new_values NVARCHAR(MAX), nullable)
  timestamp: java.sql.Timestamp (DB: timestamp DATETIME DEFAULT GETDATE())

---

## 5. KNOWN BREAKING CHANGES
# Log mọi thay đổi ảnh hưởng đến logic giữa JSP và Servlet

2026-05-27 09:00: Cập nhật logic "Return Book"
  Impact: Khi trả sách, không dùng DELETE query nữa. Trạng thái trong DB chuyển thành status = 'returned'. Frontend cần cập nhật UI không hiển thị nút "Trả sách" với các record có status này.
  Status: ⚠️ Frontend CHƯA UPDATE — pending

2026-05-27 09:30: Đổi tên field list sách
  Impact: Field name đổi từ "bookList" thành "books" trong BookServlet.
  Status: ⚠️ Frontend CHƯA UPDATE — pending

---

## 6. SHARED DEPENDENCIES & FORMATS
# Đảm bảo nhất quán thư viện và định dạng hiển thị

Date Format:     'dd/MM/yyyy' trên toàn bộ JSP (Sử dụng JSTL <fmt:formatDate>). Backend trả java.sql.Date.
DateTime Format: 'dd/MM/yyyy HH:mm:ss' cho Audit Log timestamps.
Currency Format: 'VND' cho Tiền phạt. Ví dụ: 10,000 VND. Dùng DecimalFormat("#,##0").
Barcode Format:  Tự sinh, prefix "LMS-" + bookCopyId padded (VD: "LMS-000123").

---

## 7. ENVIRONMENT
Dev DB:     Sử dụng biến môi trường `$DB_URL` từ `.env`. Format: `jdbc:sqlserver://{host}:{port};databaseName={dbName}`
JSP Folder: `/WEB-INF/views/` (Tất cả JSP phải giấu trong WEB-INF để bảo mật)
Static:     `/assets/css/`, `/assets/js/`, `/assets/images/`