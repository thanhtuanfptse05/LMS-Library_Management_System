# CLAUDE.md — LMS Project DNA & Architecture
# Phiên bản: 1.2.0 | Đọc file AGENTS.md trước để hiểu các quy tắc kỹ thuật bắt buộc

## 1. TL;DR (Đọc nhanh trong 60 giây)
> Đây là hệ thống Quản lý Thư viện Đại học (LMS) - SWP391 Milestone 2.
> **Kiến trúc:** Monolith Java Web. Servlet điều khiển, JDBC thuần tương tác CSDL, JSP hiển thị giao diện.
> **CSDL:** PostgreSQL (Supabase / Supavisor). Đặt tên bảng dạng PascalCase (riêng bảng User là từ khóa dự trữ nên bắt buộc bọc nháy kép `"User"` trong SQL), tên cột dạng camelCase.
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
                                                             PostgreSQL (Supabase)
```

### Các phân hệ người dùng (Actors & Roles)
1. **Student (Sinh viên):** Đăng nhập, tra cứu sách, nhận gợi ý AI, yêu cầu đặt trước/gia hạn sách, thanh toán phạt qua SePay.
2. **Lecturer (Giảng viên):** Vai trò tương tự sinh viên nhưng có hạn mức mượn và hạn trả sách cao hơn theo cấu hình.
3. **Librarian (Thủ thư):** Thêm/sửa thông tin sách, khai báo bản sao sách và mã vạch (barcode), cập nhật tình trạng hao mòn, quét mã mượn/trả sách tại quầy.
4. **Library Manager (Quản lý thư viện):** Cấu hình các quy tắc, chính sách thư viện (mức phạt, hạn mức mượn, số lần gia hạn tối đa), đăng thông báo hệ thống.
5. **SysAdmin (Quản trị viên):** Quản trị tài khoản (khóa/mở khóa tài khoản), xem Audit Logs để truy vết sự cố hệ thống.

---

## 3. CƠ SỞ DỮ LIỆU (CSDL) - TÓM TẮT SCHEMA 28 BẢNG CỐT LÕI
Tất cả các cột khóa chính (`PK`) và khóa ngoại (`FK`) được đồng bộ chuẩn đặt tên dạng **camelCase** thống nhất:

* **Tài khoản & Hồ sơ (8 bảng):**
  * `"User"` (`userId` PK, `email`, `passwordHash`, `status`, `role`, `failedLoginAttempts`, `lockedUntil`) -> *Lưu ý: Bắt buộc viết `"User"` có nháy kép.*
  * `UserLockReason` (`lockReasonId` PK, `userId` FK, `reason`, `createdAt`)
  * `MemberProfile` (`userId` PK/FK, `fullName`, `phoneNumber`, `gender`, `dateOfBirth`, `startDate`, `endDate`)
  * `Student` (`userId` PK/FK, `studentCode` UNIQUE, `major`, `enrollmentYear`)
  * `Lecturer` (`userId` PK/FK, `lecturerCode` UNIQUE, `department`)
  * `Librarian` (`userId` PK/FK, `staffCode` UNIQUE)
  * `LibraryManager` (`userId` PK/FK, `staffCode` UNIQUE)
  * `Admin` (`userId` PK/FK, `staffCode` UNIQUE)
* **Quản lý Sách & Danh mục (6 bảng):**
  * `Category` (`categoryId` PK, `name`, `description`, `status`, `updatedAt`, `updatedBy` FK)
  * `Tag` (`tagId` PK, `name` UNIQUE, `status`, `updatedAt`, `updatedBy` FK)
  * `Book` (`bookId` PK, `isbn` UNIQUE, `title`, `author`, `publisher`, `publicationYear`, `price`, `imagePath`, `totalQuantity`, `availableQuantity`, `status`, `createdAt`, `updatedAt`)
  * `BookCategory` (`bookId` PK/FK, `categoryId` PK/FK)
  * `BookTag` (`bookId` PK/FK, `tagId` PK/FK)
  * `BookCopy` (`bookCopyId` PK, `bookId` FK, `location`, `condition`, `status`, `barcode` UNIQUE, `createdAt`, `updatedAt`)
* **Giao dịch Thư viện (2 bảng):**
  * `Reservation` (`reservationId` PK, `userId` FK, `bookId` FK, `bookCopyId` FK, `status`, `queuePosition`, `startDate`, `endDate`)
  * `BorrowRecord` (`borrowRecordId` PK, `userId` FK, `bookCopyId` FK, `bookId` FK, `startDate`, `endDate`, `returnedAt`, `status`, `extensionCount`, `createdBy` FK, `createdAt`)
* **Phạt & Thanh toán (2 bảng):**
  * `Fine` (`fineId` PK, `borrowRecordId` FK, `userId` FK, `amount`, `reason`, `status`, `createdAt`)
  * `Payment` (`paymentId` PK, `fineId` FK, `paidAmount`, `paymentMethod`, `transactionReference` UNIQUE, `processedBy` FK, `status`, `paidAt`)
* **Cấu hình & Nhật ký (5 bảng):**
  * `SystemConfigurations` (`configKey` PK, `configValue`, `description`, `configGroup`, `updatedBy` FK, `updatedAt`)
  * `AuditLogs` (`auditLogId` PK, `userId` FK, `actionType`, `entityName`, `entityId`, `oldValues`, `newValues`, `timestamp`)
  * `Notification` (`notificationId` PK, `title`, `content`, `type`, `isPinned`, `createdBy` FK, `createdAt`, `updatedAt`)
  * `UserNotificationStatus` (`userId` PK/FK, `notificationId` PK/FK, `readAt`)
  * `DocumentTemp` (`tempId` PK, `tempName` UNIQUE, `subject`, `bodyContent`, `managerId` FK, `createdAt`, `updatedAt`)
* **Sự cố & Nhập liệu & Kiểm kê (5 bảng):**
  * `BookCopyIncident` (`incidentId` PK, `bookCopyId` FK, `incidentType`, `description`, `status`, `resolution`, `reportedBy` FK, `reportedAt`, `resolvedBy` FK, `resolvedAt`)
  * `BookImportBatch` (`importBatchId` PK, `importedBy` FK, `fileName`, `totalRows`, `successRows`, `failedRows`, `status`, `createdAt`, `expiresAt`)
  * `BookImportError` (`importErrorId` PK, `importBatchId` FK, `sheetName`, `rowNumber`, `columnName`, `errorMessage`, `createdAt`)
  * `InventorySession` (`inventorySessionId` PK, `location`, `status`, `startedBy` FK, `startedAt`, `completedBy` FK, `completedAt`, `note`)
  * `InventoryItem` (`inventoryItemId` PK, `inventorySessionId` FK, `bookCopyId` FK, `expectedLocation`, `scannedLocation`, `result`, `scannedBy` FK, `scannedAt`, `resolution`, `resolvedBy` FK, `resolvedAt`)

> [!WARNING]
> **RÀNG BUỘC KHI LÀM VIỆC VỚI POSTGRESQL (SUPABASE/SUPAVISOR):**
> 1. **Bảng "User" bắt buộc bọc nháy kép:** Vì `User` là từ khóa hệ thống của PostgreSQL, các truy vấn SQL tác động lên bảng này phải viết rõ dạng `"User"` (có dấu ngoặc kép bọc quanh). Các bảng khác tuyệt đối không bọc để tránh lỗi phân biệt hoa/thường (`relation does not exist`).
> 2. **Cấu hình Pooler cổng 6543:** Để tránh lỗi không phân giải được IPv6 (`UnknownHostException`), JDBC kết nối qua cổng **6543** (Transaction/Session Pooler) của Supabase để được hỗ trợ định tuyến IPv4 mặc định.
> 3. **Cột processedBy trong Payment:** Cột được lưu thực tế là `processedBy INT NULL`. Mã nguồn Java (DAO, DTO, Model) cần map chính xác với tên này.
> 4. **Hàm thời gian:** Sử dụng hàm `NOW()` hoặc `CURRENT_TIMESTAMP` của PostgreSQL thay cho `GETDATE()` của SQL Server.

---

## 4. CẤU TRÚC THƯ MỤC DỰ ÁN QUAN TRỌNG
```
├── .agents
│   ├── skills
│   │   ├── speckit-agent-context-update
│   │   │   └── SKILL.md
│   │   ├── speckit-analyze
│   │   │   └── SKILL.md
│   │   ├── speckit-checklist
│   │   │   └── SKILL.md
│   │   ├── speckit-clarify
│   │   │   └── SKILL.md
│   │   ├── speckit-constitution
│   │   │   └── SKILL.md
│   │   ├── speckit-git-commit
│   │   │   └── SKILL.md
│   │   ├── speckit-git-feature
│   │   │   └── SKILL.md
│   │   ├── speckit-git-initialize
│   │   │   └── SKILL.md
│   │   ├── speckit-git-remote
│   │   │   └── SKILL.md
│   │   ├── speckit-git-validate
│   │   │   └── SKILL.md
│   │   ├── speckit-implement
│   │   │   └── SKILL.md
│   │   ├── speckit-plan
│   │   │   └── SKILL.md
│   │   ├── speckit-specify
│   │   │   └── SKILL.md
│   │   ├── speckit-tasks
│   │   │   └── SKILL.md
│   │   └── speckit-taskstoissues
│   │       └── SKILL.md
│   ├── .agentignore
│   ├── AGENTS.md
│   └── CLAUDE.md
├── .github
│   └── workflows
│       └── constitution-check.yml
├── .sdd
│   ├── constraints
│   │   ├── business.md
│   │   ├── global.md
│   │   ├── safety.md
│   │   └── verify.md
│   ├── specs
│   │   ├── feat-Reservation&Renewal
│   │   │   ├── CHANGELOG.md
│   │   │   ├── CONTEXT.md
│   │   │   ├── PLAN.md
│   │   │   ├── SPEC.md
│   │   │   └── TASK.md
│   │   ├── feat-authentication
│   │   │   ├── CHANGELOG.md
│   │   │   ├── CONTEXT.md
│   │   │   ├── PLAN.md
│   │   │   ├── SPEC.md
│   │   │   └── TASKS.md
│   │   ├── feat-bookDiscovery
│   │   │   ├── CHANGELOG.md
│   │   │   ├── CONTEXT.md
│   │   │   ├── PLAN.md
│   │   │   ├── SPEC.md
│   │   │   └── TASK.md
│   │   ├── feat-bookManagement
│   │   │   ├── CHANGELOG.md
│   │   │   ├── CONTEXT.md
│   │   │   ├── PLAN.md
│   │   │   ├── SPEC.md
│   │   │   └── TASK.md
│   │   ├── feat-deskCirculationOperations
│   │   │   ├── CHANGELOG.md
│   │   │   ├── CONTEXT.md
│   │   │   ├── PLAN.md
│   │   │   ├── SPEC.md
│   │   │   └── TASK.md
│   │   ├── feat-notification-management
│   │   │   ├── CHANGELOG.md
│   │   │   ├── CONTEXT.md
│   │   │   ├── PLAN.md
│   │   │   ├── SPEC.md
│   │   │   └── TASK.md
│   │   ├── feat-profileManagement
│   │   │   ├── CHANGELOG.md
│   │   │   ├── CONTEXT.md
│   │   │   ├── PLAN.md
│   │   │   ├── SPEC.md
│   │   │   └── TASKS.md
│   │   ├── feat-userAccountManagement
│   │   │   ├── CHANGELOG.md
│   │   │   ├── CONTEXT.md
│   │   │   ├── PLAN.md
│   │   │   ├── SPEC.md
│   │   │   └── TASKS.md
│   │   └── _template.md
│   ├── constitution.md
│   └── shared_context.md
├── .specify
│   ├── extensions
│   │   ├── agent-context
│   │   │   ├── commands
│   │   │   │   └── speckit.agent-context.update.md
│   │   │   ├── scripts
│   │   │   │   ├── bash
│   │   │   │   │   └── update-agent-context.sh
│   │   │   │   └── powershell
│   │   │   │       └── update-agent-context.ps1
│   │   │   ├── README.md
│   │   │   ├── agent-context-config.yml
│   │   │   └── extension.yml
│   │   ├── git
│   │   │   ├── commands
│   │   │   │   ├── speckit.git.commit.md
│   │   │   │   ├── speckit.git.feature.md
│   │   │   │   ├── speckit.git.initialize.md
│   │   │   │   ├── speckit.git.remote.md
│   │   │   │   └── speckit.git.validate.md
│   │   │   ├── scripts
│   │   │   │   ├── bash
│   │   │   │   │   ├── auto-commit.sh
│   │   │   │   │   ├── create-new-feature.sh
│   │   │   │   │   ├── git-common.sh
│   │   │   │   │   └── initialize-repo.sh
│   │   │   │   └── powershell
│   │   │   │       ├── auto-commit.ps1
│   │   │   │       ├── create-new-feature.ps1
│   │   │   │       ├── git-common.ps1
│   │   │   │       └── initialize-repo.ps1
│   │   │   ├── README.md
│   │   │   ├── config-template.yml
│   │   │   ├── extension.yml
│   │   │   └── git-config.yml
│   │   └── .registry
│   ├── integrations
│   │   ├── agy.manifest.json
│   │   └── speckit.manifest.json
│   ├── memory
│   │   └── constitution.md
│   ├── scripts
│   │   └── powershell
│   │       ├── check-prerequisites.ps1
│   │       ├── common.ps1
│   │       ├── create-new-feature.ps1
│   │       ├── setup-plan.ps1
│   │       └── setup-tasks.ps1
│   ├── templates
│   │   ├── checklist-template.md
│   │   ├── constitution-template.md
│   │   ├── plan-template.md
│   │   ├── spec-template.md
│   │   └── tasks-template.md
│   ├── workflows
│   │   ├── speckit
│   │   │   └── workflow.yml
│   │   └── workflow-registry.json
│   ├── extensions.yml
│   ├── init-options.json
│   └── integration.json
├── allowedlib
│   ├── SparseBitSet-1.3.jar
│   ├── commons-codec-1.16.0.jar
│   ├── commons-collections4-4.4.jar
│   ├── commons-compress-1.25.0.jar
│   ├── commons-io-2.15.0.jar
│   ├── commons-math3-3.6.1.jar
│   ├── curvesapi-1.08.jar
│   ├── jakarta.mail-2.0.1.jar
│   ├── jakarta.servlet.jsp.jstl-2.0.0.jar
│   ├── jakarta.servlet.jsp.jstl-api-2.0.0.jar
│   ├── javax.mail-1.6.2.jar
│   ├── jaxb-api-2.1.jar
│   ├── jbcrypt-0.4.jar
│   ├── log4j-api-2.21.1.jar
│   ├── log4j-core-2.21.1.jar
│   ├── poi-5.2.5.jar
│   ├── poi-ooxml-5.2.5.jar
│   ├── poi-ooxml-lite-5.2.5.jar
│   ├── postgresql-42.7.3.jar
│   ├── sqljdbc42.jar
│   └── xmlbeans-5.2.0.jar
├── database
│   └── supabase
│       ├── LMS_Schema_PostgreSQL.sql
│       └── LMS_Seed_Data_PostgreSQL.sql
├── diagram
│   ├── feat-Reservation&Renewal
│   │   └── ActivityDiagramF5.txt
│   ├── feat-authentication
│   │   ├── ActivityDiagramF1.txt
│   │   ├── Swimlane-UC-login.txt
│   │   ├── Swimlane-UC-resetPassword.txt
│   │   └── Swimlane-authentication.txt
│   ├── feat-bookDiscovery
│   │   └── ActivityDiagramF8.txt
│   ├── feat-bookManagement
│   │   ├── ActivityDiagramF4.txt
│   │   ├── Swimlane-UC-login.txt (Nếu có hoặc các flow diagram tương tự)
│   ├── feat-deskCirculationOperations
│   │   └── ActivityDiagramF6.txt
│   ├── feat-profileManagement
│   │   ├── ActivityDiagramF2.txt
│   │   ├── Swimlane-UC-updateUserProfile.txt
│   │   ├── Swimlane-UC-viewUserDetail.txt
│   │   └── Swimlane-profileManagement.txt
│   ├── feat-userAccountManagement
│   │   ├── ActivityDiagramF3.txt
│   │   ├── Swimlane-UC-createUserAccount.txt
│   │   ├── Swimlane-UC-importUserAccount.txt
│   │   ├── Swimlane-UC-updateUserAccount.txt
│   │   ├── Swimlane-UC-viewUserList.txt
│   │   └── Swimlane-userAccountManagement.txt
│   └── spec-UC-BR-FR.txt
├── nbproject
│   ├── private
│   │   ├── private.properties
│   │   └── private.xml
│   ├── ant-deploy.xml
│   ├── build-impl.xml
│   ├── genfiles.properties
│   ├── project.properties
│   └── project.xml
├── src
│   ├── conf
│   │   └── MANIFEST.MF
│   └── java
│       ├── config
│       │   ├── AiConfig.java
│       │   ├── AppConfig.java
│       │   └── AppContextListener.java
│       ├── controllers
│       │   ├── AdminDashboardServlet.java
│       │   ├── AdminProfileServlet.java
│       │   ├── BookCopyIncidentServlet.java
│       │   ├── BookCopyServlet.java
│       │   ├── BookDetailServlet.java
│       │   ├── BookImageServlet.java
│       │   ├── BookImportHistoryServlet.java
│       │   ├── BookImportServlet.java
│       │   ├── BookSearchServlet.java
│       │   ├── BookServlet.java
│       │   ├── CashPaymentServlet.java
│       │   ├── CategoryServlet.java
│       │   ├── CheckInServlet.java
│       │   ├── CheckOutServlet.java
│       │   ├── CreateUserServlet.java
│       │   ├── DeskDashboardServlet.java
│       │   ├── DocumentTempManagerServlet.java
│       │   ├── ExportUserServlet.java
│       │   ├── ForgotPasswordServlet.java
│       │   ├── GoogleLoginServlet.java
│       │   ├── ImportUserServlet.java
│       │   ├── InventoryReconciliationServlet.java
│       │   ├── LecturerDashboardServlet.java
│       │   ├── LecturerProfileServlet.java
│       │   ├── LibrarianDashboardServlet.java
│       │   ├── LibrarianProfileServlet.java
│       │   ├── LoginServlet.java
│       │   ├── LogoutServlet.java
│       │   ├── ManagerDashboardServlet.java
│       │   ├── ManagerProfileServlet.java
│       │   ├── NewsServlet.java
│       │   ├── NotificationManagerServlet.java
│       │   ├── NotificationStatusServlet.java
│       │   ├── RecommendationServlet.java
│       │   ├── StudentDashboardServlet.java
│       │   ├── StudentProfileServlet.java
│       │   ├── TagServlet.java
│       │   ├── UpdateUserServlet.java
│       │   └── UserListServlet.java
│       ├── dao
│       │   ├── AdminDAO.java
│       │   ├── AuditLogDAO.java
│       │   ├── BookCopyDAO.java
│       │   ├── BookCopyIncidentDAO.java
│       │   ├── BookDAO.java
│       │   ├── BookImportDAO.java
│       │   ├── BorrowRecordDAO.java
│       │   ├── CategoryDAO.java
│       │   ├── DocumentTempDAO.java
│       │   ├── FineDAO.java
│       │   ├── InventoryDAO.java
│       │   ├── LecturerDAO.java
│       │   ├── LibrarianDAO.java
│       │   ├── LibraryManagerDAO.java
│       │   ├── MemberProfileDAO.java
│       │   ├── NotificationDAO.java
│       │   ├── PaymentDAO.java
│       │   ├── ReservationDAO.java
│       │   ├── StudentDAO.java
│       │   ├── TagDAO.java
│       │   ├── UserDAO.java
│       │   ├── UserLockReasonDAO.java
│       │   └── UserLookupDAO.java
│       ├── dto
│       │   ├── BookCatalogSummaryDTO.java
│       │   ├── BookCopyIncidentSummaryDTO.java
│       │   ├── BookCopySummaryDTO.java
│       │   ├── BookImportPreviewDTO.java
│       │   ├── BookImportRowDTO.java
│       │   ├── InventorySummaryDTO.java
│       │   └── ManagementSummaryDTO.java
│       ├── exception
│       │   ├── DatabaseException.java
│       │   └── ValidationException.java
│       ├── filter
│       │   └── AuthFilter.java
│       ├── model
│       │   ├── Admin.java
│       │   ├── Book.java
│       │   ├── BookCopy.java
│       │   ├── BookCopyIncident.java
│       │   ├── BookImportBatch.java
│       │   ├── BookImportError.java
│       │   ├── BookSummaryDTO.java
│       │   ├── BorrowRecord.java
│       │   ├── Category.java
│       │   ├── DocumentTemp.java
│       │   ├── Fine.java
│       │   ├── InventoryItem.java
│       │   ├── InventorySession.java
│       │   ├── Lecturer.java
│       │   ├── Librarian.java
│       │   ├── LibraryManager.java
│       │   ├── MemberProfile.java
│       │   ├── Notification.java
│       │   ├── Payment.java
│       │   ├── Reservation.java
│       │   ├── Student.java
│       │   ├── Tag.java
│       │   ├── User.java
│       │   ├── UserContactDTO.java
│       │   └── UserDTO.java
│       ├── service
│       │   ├── AiRecommendationService.java
│       │   ├── AuthService.java
│       │   ├── BookCopyIncidentService.java
│       │   ├── BookCopyService.java
│       │   ├── BookImportService.java
│       │   ├── BookImportValidator.java
│       │   ├── BookService.java
│       │   ├── CategoryService.java
│       │   ├── DeskCirculationService.java
│       │   ├── EmailService.java
│       │   ├── InventoryReconciliationService.java
│       │   ├── MarkdownUtil.java
│       │   ├── ProfileService.java
│       │   ├── TagService.java
│       │   └── UserService.java
│       └── util
│           ├── BookImageStorage.java
│           ├── BookImportWorkbookReader.java
│           ├── CSVHelper.java
│           ├── DAOMigrationTest.java
│           ├── DatabaseConnection.java
│           └── GoogleSSOUtil.java
├── template
│   ├── temp-.agents-AGENTS.md
│   ├── temp-.agents-CLAUDE.md
│   ├── temp-.agents-agentignore.md
│   ├── temp-agents-root.md
│   ├── temp-claude-root.md
│   ├── temp-constitution.md
│   ├── temp-constraints-business.md
│   ├── temp-constraints-global.md
│   ├── temp-constraints-safety.md
│   ├── temp-plan.md
│   ├── temp-shared_context.md
│   └── temp-spec.md
├── test
│   ├── dao
│   │   ├── BookCopyDAOTest.java
│   │   ├── BookCopyIncidentDAOTest.java
│   │   ├── BookDAOTest.java
│   │   ├── BookImportDAOTest.java
│   │   ├── CategoryTagDAOTest.java
│   │   └── InventoryDAOTest.java
│   ├── f6
│   │   ├── DAOTests.java
│   │   ├── DeskCirculationServiceIntegrationTest.java
│   │   ├── DeskCirculationServiceParameterTest.java
│   │   ├── DeskCirculationServiceUnitTest.java
│   │   └── ServletTests.java
│   ├── f8
│   │   ├── step1_dao
│   │   │   ├── BookDAOTest.java
│   │   │   └── BorrowRecordDAOTest.java
│   │   ├── step2_service
│   │   │   ├── AiConfigTest.java
│   │   │   └── AiRecommendationServiceTest.java
│   │   ├── step3_controller
│   │   │   ├── BookDetailServletTest.java
│   │   │   ├── RecommendationApiServletTest.java
│   │   │   └── RecommendationServletTest.java
│   │   └── step4_view
│   │       ├── ManualAcceptanceTest.md
│   │       └── ViewControllerLinkageTest.java
│   ├── lib
│   │   ├── jacocoagent.jar
│   │   └── jacocoant.jar
│   ├── service
│   │   ├── AuthServiceTest.java
│   │   ├── BookCopyIncidentServiceTest.java
│   │   ├── BookCopyServiceTest.java
│   │   ├── BookServiceTest.java
│   │   ├── CategoryServiceTest.java
│   │   ├── DeskCirculationServiceAccessor.java
│   │   ├── InventoryReconciliationServiceTest.java
│   │   ├── TagServiceTest.java
│   │   └── UserServiceTest.java
│   └── util
│       ├── BookImageStorageTest.java
│       └── BookImportWorkbookReaderTest.java
├── web
│   ├── META-INF
│   │   └── context.xml
│   ├── WEB-INF
│   │   ├── lib
│   │   │   ├── gson-2.10.1.jar
│   │   │   ├── jakarta.activation-2.0.1.jar
│   │   │   ├── jakarta.activation-api-2.1.3.jar
│   │   │   ├── jakarta.mail-2.0.1.jar
│   │   │   ├── jakarta.servlet.jsp.jstl-2.0.0.jar
│   │   │   ├── jakarta.servlet.jsp.jstl-api-2.0.0.jar
│   │   │   ├── jaxb-api-2.1.jar
│   │   │   ├── jbcrypt-0.4.jar
│   │   │   └── postgresql-42.7.3.jar
│   │   └── web.xml
│   ├── admin
│   │   ├── fragments
│   │   │   ├── _footer.jsp
│   │   │   ├── _head.jsp
│   │   │   ├── _header.jsp
│   │   │   ├── _sidebar.jsp
│   │   │   ├── _user_create_modal.jsp
│   │   │   ├── _user_edit_modal.jsp
│   │   │   ├── _user_import_modal.jsp
│   │   │   └── _user_lock_modal.jsp
│   │   ├── .gitkeep
│   │   ├── dashboard.jsp
│   │   ├── profile.jsp
│   │   └── user-list.jsp
│   ├── assets
│   │   ├── css
│   │   │   ├── .gitkeep
│   │   │   └── book-management.css
│   │   ├── images
│   │   │   ├── .gitkeep
│   │   │   └── avt.jpg
│   │   └── js
│   │       ├── .gitkeep
│   │       ├── book-categories.js
│   │       ├── book-copies.js
│   │       ├── book-tags.js
│   │       ├── book-titles.js
│   │       └── recommendation.js
│   ├── auth
│   │   ├── .gitkeep
│   │   ├── forgot-password.jsp
│   │   ├── login.jsp
│   │   └── reset-password.jsp
│   ├── common
│   │   ├── .gitkeep
│   │   ├── _footer.jsp
│   │   ├── _head.jsp
│   │   ├── _header.jsp
│   │   ├── _recommendation.jsp
│   │   ├── _section-cta.jsp
│   │   ├── _section-hero.jsp
│   │   ├── _section-news-full.jsp
│   │   ├── _section-news.jsp
│   │   ├── _section-policies.jsp
│   │   ├── _section-quicklinks.jsp
│   │   └── _section-services.jsp
│   ├── errors
│   │   ├── .gitkeep
│   │   ├── 403.jsp
│   │   ├── 404.jsp
│   │   └── 500.jsp
│   ├── lecturer
│   │   ├── fragments
│   │   │   ├── _footer.jsp
│   │   │   ├── _head.jsp
│   │   │   ├── _header.jsp
│   │   │   └── _sidebar.jsp
│   │   ├── .gitkeep
│   │   ├── dashboard.jsp
│   │   ├── notifications.jsp
│   │   └── profile.jsp
│   ├── librarian
│   │   ├── fragments
│   │   │   ├── _book-form-fields.jsp
│   │   │   ├── _book-import-history-modal.jsp
│   │   │   ├── _book-incident-detail-modal.jsp
│   │   │   ├── _book-incident-report-modal.jsp
│   │   │   ├── _footer.jsp
│   │   │   ├── _head.jsp
│   │   │   ├── _header.jsp
│   │   │   └── _sidebar.jsp
│   │   ├── .gitkeep
│   │   ├── book-categories.jsp
│   │   ├── book-copies.jsp
│   │   ├── book-damaged-lost.jsp
│   │   ├── book-import-history.jsp
│   │   ├── book-import.jsp
│   │   ├── book-inventory-reconciliation.jsp
│   │   ├── book-overview.jsp
│   │   ├── book-tags.jsp
│   │   ├── book-titles.jsp
│   │   ├── dashboard.jsp
│   │   ├── desk-checkin.jsp
│   │   ├── desk-checkout.jsp
│   │   ├── desk-dashboard.jsp
│   │   ├── desk-payment.jsp
│   │   └── profile.jsp
│   ├── manager
│   │   ├── fragments
│   │   │   ├── _footer.jsp
│   │   │   ├── _head.jsp
│   │   │   ├── _header.jsp
│   │   │   └── _sidebar.jsp
│   │   ├── .gitkeep
│   │   ├── dashboard.jsp
│   │   ├── manage-email-templates.jsp
│   │   ├── manage-notifications.jsp
│   │   └── profile.jsp
│   ├── student
│   │   ├── fragments
│   │   │   ├── _footer.jsp
│   │   │   ├── _head.jsp
│   │   │   ├── _header.jsp
│   │   │   ├── _section-activity.jsp
│   │   │   ├── _section-alert.jsp
│   │   │   ├── _section-reading.jsp
│   │   │   ├── _section-stats.jsp
│   │   │   ├── _section-welcome.jsp
│   │   │   └── _sidebar.jsp
│   │   ├── .gitkeep
│   │   ├── dashboard.jsp
│   │   ├── notifications.jsp
│   │   └── profile.jsp
│   ├── book-detail.jsp
│   ├── book-search.jsp
│   ├── index.jsp
│   ├── news.jsp
│   ├── policies.jsp
│   └── services.jsp
├── .gitignore
├── AGENTS.md
├── DESIGN.md
├── GEMINI.md
├── build.xml
├── plan.md
└── ui_rule.md
```
