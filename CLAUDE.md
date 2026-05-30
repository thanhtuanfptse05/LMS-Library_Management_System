# CLAUDE.md — LMS Project DNA & Architecture
# Phiên bản: 1.1.0 | Đọc file AGENTS.md trước để hiểu các quy tắc kỹ thuật bắt buộc

## 1. TL;DR (Đọc nhanh trong 60 giây)
> Đây là hệ thống Quản lý Thư viện Đại học (LMS) - SWP391 Milestone 2.
> **Kiến trúc:** Monolith Java Web. Servlet điều khiển, JDBC thuần tương tác CSDL, JSP hiển thị giao diện.
> **CSDL:** Microsoft SQL Server. Đặt tên bảng dạng PascalCase, tên cột dạng camelCase.
> **Bảo mật:** Chặn truy cập trái phép bằng `@WebFilter` và `HttpSession`. Chống SQL Injection bằng `PreparedStatement`.

## 2. KIẾN TRÚC HỆ THỐNG & DATA FLOW

### Sơ đồ luồng MVC Monolith
```
User (Browser) ──[HTTP Request]──> WebFilter (Auth Check) ──> Servlet (Controller)
                                                                 │
   JSP View <──[Forward (JSTL)]── Servlet <──[Result DTO]─── Service (Business Logic)
                                                                 │
                                                             DAO (JDBC PreparedStatement)
                                                                 │
                                                             SQL Server
```

### Các phân hệ người dùng (Actors & Roles)
1. **Student (Sinh viên):** Đăng nhập, tra cứu sách, nhận gợi ý AI, yêu cầu đặt trước/gia hạn sách, thanh toán phạt qua VNPAY.
2. **Lecturer (Giảng viên):** Vai trò tương tự sinh viên nhưng có hạn mức mượn và hạn trả sách cao hơn theo cấu hình.
3. **Librarian (Thủ thư):** Thêm/sửa thông tin sách, khai báo bản sao sách và mã vạch (barcode), cập nhật tình trạng hao mòn, quét mã mượn/trả sách tại quầy.
4. **Library Manager (Quản lý thư viện):** Cấu hình các quy tắc, chính sách thư viện (mức phạt, hạn mức mượn, số lần gia hạn tối đa), đăng thông báo hệ thống.
5. **SysAdmin (Quản trị viên):** Quản trị tài khoản (khóa/mở khóa tài khoản), xem Audit Logs để truy vết sự cố hệ thống.

---

## 3. CƠ SỞ DỮ LIỆU (CSDL) - TÓM TẮT SCHEMA 20 BẢNG CỐT LÕI
Tất cả các cột khóa chính (`PK`) và khóa ngoại (`FK`) được đồng bộ chuẩn đặt tên dạng **camelCase** thống nhất:

* **Tài khoản & Hồ sơ:**
  * `[User]` (`userId` PK, `email`, `passwordHash`, `status`, `role`, `lockReason`, `failedLoginAttempts`, `lockedUntil`)
  * `MemberProfile` (`userId` PK/FK, `fullName`, `phoneNumber`, `gender`, `dateOfBirth`, `startDate`, `endDate`)
  * `Student` (`userId` PK/FK, `studentCode` UNIQUE, `major`, `enrollmentYear`)
  * `Lecturer` (`userId` PK/FK, `lecturerCode` UNIQUE, `department`)
  * `Librarian` (`userId` PK/FK, `staffCode` UNIQUE)
  * `LibraryManager` (`userId` PK/FK, `staffCode` UNIQUE)
  * `Admin` (`userId` PK/FK, `staffCode` UNIQUE)
* **Quản lý Sách & Danh mục:**
  * `Category` (`categoryId` PK, `name`, `description`)
  * `Tag` (`tagId` PK, `name` UNIQUE)
  * `Books` (`bookId` PK, `isbn` UNIQUE, `title`, `author`, `publisher`, `publicationYear`, `price`, `totalQuantity`, `availableQuantity`, `status`, `createdAt`, `updatedAt`)
  * `BookCategory` (`bookId` PK/FK, `categoryId` PK/FK)
  * `BookTag` (`bookId` PK/FK, `tagId` PK/FK)
  * `BookCopy` (`bookCopyId` PK, `bookId` FK, `location`, `condition`, `status`, `barcode` UNIQUE, `createdAt`, `updatedAt`)
* **Giao dịch Thư viện:**
  * `Reservation` (`reservationId` PK, `userId` FK, `bookId` FK, `bookCopyId` FK, `status`, `queuePosition`, `startDate`, `endDate`)
  * `BorrowRecord` (`borrowRecordId` PK, `userId` FK, `bookCopyId` FK, `bookId` FK, `startDate`, `endDate`, `returnedAt`, `status`, `extensionCount`, `createdBy` FK, `createdAt`)
* **Phạt & Thanh toán:**
  * `Fine` (`fineId` PK, `borrowRecordId` FK, `userId` FK, `amount`, `reason`, `status`, `createdAt`)
  * `Payment` (`paymentId` PK, `fineId` FK, `paidAmount`, `paymentMethod`, `transactionReference` UNIQUE, `processBy` FK, `status`, `paidAt`)
* **Cấu hình & Nhật ký:**
  * `SystemConfigurations` (`configKey` PK, `configValue`, `description`, `configGroup`, `updatedBy` FK, `updatedAt`)
  * `AuditLogs` (`auditLogId` PK, `userId` FK, `actionType`, `entityName`, `entityId`, `oldValues`, `newValues`, `timestamp`)
  * `Notification` (`notificationId` PK, `title`, `content`, `createdBy` FK, `createdAt`)

---

## 4. CẤU TRÚC THƯ MỤC DỰ ÁN QUAN TRỌNG
```
/LMS-Library Management System
├── .sdd/                         # System Design Documents (Project Brain)
│   ├── constitution.md           # Hiến pháp dự án (Hard Rules Layer 1/2/3)
│   ├── shared_context.md         # API Contracts, FR & UC Mapping
│   ├── constraints/              # Các ràng buộc nghiệp vụ/kỹ thuật/an toàn
│   │   ├── global.md             # Tech Stack & Naming Conventions
│   │   ├── business.md           # 31 Business Rules (BR01-BR31)
│   │   └── safety.md             # Quy tắc bảo vệ code và dữ liệu
│   └── specs/                    # Đặc tả chi tiết từng tính năng
│       └── _template.md          # Template tạo spec mới
├── .agents/                      # Cấu hình riêng cho AI Agents
│   ├── AGENTS.md                 # Agent Persona (Bản ngã của Agent)
│   ├── CLAUDE.md                 # Bộ nhớ ngữ cảnh (Manual Memory)
│   └── .agentignore              # Danh sách file Agent không đọc
├── database/                     # Chứa các file SQL khởi tạo CSDL
│   └── LMS_Library_Management_System.sql
├── src/java/                     # Mã nguồn Backend (Java Monolith)
│   ├── controller/               # Java Servlets (MVC Controller)
│   ├── service/                  # Business Logic Services
│   ├── dao/                      # Data Access Objects (JDBC thuần)
│   └── model/                    # Entities & DTOs (Java Beans)
├── web/                          # Thư mục Web App (Views & Assets)
│   ├── WEB-INF/
│   │   ├── web.xml               # Cấu hình dự án (nếu có)
│   │   └── views/                # Chứa các file JSP (MVC View - kebab-case)
│   └── assets/                   # CSS, JS, Images tĩnh
├── plan.md                       # Theo dõi tiến độ task hiện tại
├── AGENTS.md                     # Root link tới Hiến pháp kỹ thuật
└── CLAUDE.md                     # Root link tới DNA & Kiến trúc dự án
```
