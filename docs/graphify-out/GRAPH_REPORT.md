# Graph Report - docs  (2026-07-24)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 2933 nodes · 8375 edges · 144 communities (110 shown, 34 thin omitted)
- Extraction: 75% EXTRACTED · 25% INFERRED · 0% AMBIGUOUS · INFERRED: 2125 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1ba065f1`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- BookDAO
- BookSuggestion
- SystemConfiguration
- Tag
- Category
- BookCopy
- AuditLogDTO
- .doGet
- BookCopyIncident
- DocumentTemp
- SQLException
- ManagerProfileServlet.java
- BookImportRowDTO
- HttpServlet
- BookCirculationHistoryDTO
- StaffPerformanceDTO
- BorrowRecord
- .doPost
- UserDTO
- Notification
- BookCopyDAO
- User
- Fine
- UserService
- .getConnection
- InventorySession
- .findById
- InventoryItem
- Reservation
- .getErrors
- BookCoverFetcher
- AuthFilter.java
- BookImportPreviewDTO
- Student
- BookImportBatch
- ReservationDAO
- ChatMessage
- .createMockConnection
- PaymentDAO
- BookCopyIncidentServiceTest
- BookSummaryDTO
- UserLockReasonDAO
- .insert
- BookImportError
- .findByUserId
- BookImportDAO
- OverdueProcessor
- BookCopyIncidentService
- SystemConfigDAO
- UserDAO
- LecturerDashboardServlet.java
- BookCopyIncidentDAO
- BorrowDetailDTO
- FinancialDetailDTO
- .isValid
- MemberProfileDAO
- DeskCirculationService
- LibrarianProfileServlet.java
- ReservationExpirationProcessor
- EmailTemplate
- InventoryResultDTO
- AuditLog
- BookImportServlet.java
- BorrowRecordDAO
- Payment
- SupabaseStorageClientTest
- .mapResultSetToUserDTO
- FineDAO
- BookCopyIncidentServlet
- BookImageStorage
- BookCoverFetcher.java
- SupabaseStorageClient
- BookCopyServlet
- DeskDashboardServlet.java
- .doPost
- BookOverviewServlet.java
- ReportDAO
- RecommendationServlet.java
- AppContextListener
- common.ps1
- NotificationManagerServlet
- InventoryDAO
- EmailJob
- ExcelExportService
- BookCopySummaryDTO
- BorrowTrendDTO
- .processCheckOut
- InventoryReconciliationServiceTest
- .doGet
- StudentDashboardServlet.java
- SuggestionVote
- .classifyIntent
- .changePassword
- ImportUserServlet.java
- AiConfig
- CashPaymentServlet.java
- CheckOutServlet
- PublicNewsServlet.java
- BookLocationSummaryDTO
- BookCatalogSummaryDTO
- EmailWorker
- AiChatbotService
- .processBook
- OnlineCirculationServiceTest
- LogoutServlet
- .doGet
- UserContactDTO
- NotificationWidgetServlet.java
- UserDTO.java
- InventorySummaryDTO
- FinancialTrendDTO
- .getQueueSize
- EmailService
- BorrowHistoryServlet.java
- LibrarianDashboardServlet.java
- AiRecommendationServiceTest
- ExportUserServlet.java
- MemberFinesServlet.java
- MyBorrowingsServlet.java
- SystemReportServlet.java
- BorrowRecord.java
- UserServiceTest
- BookCoverFetcherTest
- BookDetailServlet.java
- BookImageServlet.java
- .doGet
- HealthCheckServlet.java
- chatbot.js
- NotificationDAOTest.java
- ReportServiceTest.java
- generate_report.py
- create-new-feature.ps1
- .drainQueue
- MockJdbc

## God Nodes (most connected - your core abstractions)
1. `BookDAO` - 99 edges
2. `BookCopyDAO` - 84 edges
3. `UserDAO` - 83 edges
4. `Book` - 72 edges
5. `BookCopy` - 62 edges
6. `BorrowRecordDAO` - 56 edges
7. `UserDTO` - 53 edges
8. `BookCopyIncident` - 53 edges
9. `AuditLogDAO` - 50 edges
10. `BorrowRecord` - 50 edges

## Surprising Connections (you probably didn't know these)
- `BookCopyIncidentDAOTest` --references--> `BookCopyIncidentDAO`  [EXTRACTED]
  test/dao/BookCopyIncidentDAOTest.java → src/java/dao/BookCopyIncidentDAO.java
- `BorrowRecordDAOTest` --references--> `BorrowRecordDAO`  [EXTRACTED]
  test/dao/BorrowRecordDAOTest.java → src/java/dao/BorrowRecordDAO.java
- `NotificationDAOTest` --references--> `NotificationDAO`  [EXTRACTED]
  test/dao/NotificationDAOTest.java → src/java/dao/NotificationDAO.java
- `SystemConfigurationsDAOTest` --references--> `SystemConfigurationsDAO`  [EXTRACTED]
  test/dao/SystemConfigurationsDAOTest.java → src/java/dao/SystemConfigurationsDAO.java
- `UserDAOTest` --references--> `UserDAO`  [EXTRACTED]
  test/dao/UserDAOTest.java → src/java/dao/UserDAO.java

## Import Cycles
- None detected.

## Communities (144 total, 34 thin omitted)

### Community 0 - "BookDAO"
Cohesion: 0.05
Nodes (21): BookServlet, HttpServletRequest, HttpServletResponse, Logger, MultipartConfig, Override, WebServlet, BookDAO (+13 more)

### Community 1 - "BookSuggestion"
Cohesion: 0.06
Nodes (25): BookSuggestionServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, HttpServletRequest, HttpServletResponse (+17 more)

### Community 2 - "SystemConfiguration"
Cohesion: 0.05
Nodes (31): Logger, ServletContext, SuppressWarnings, SystemConfigCache, AdminSystemConfigServlet, HttpServletRequest, HttpServletResponse, Override (+23 more)

### Community 3 - "Tag"
Cohesion: 0.06
Nodes (18): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, TagServlet, Connection, PreparedStatement (+10 more)

### Community 4 - "Category"
Cohesion: 0.07
Nodes (16): CategoryServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, CategoryDAO, Connection (+8 more)

### Community 5 - "BookCopy"
Cohesion: 0.10
Nodes (8): ResultSet, BookCopy, Timestamp, BookCopyService, Pattern, BookCopyServiceTest, Before, Test

### Community 6 - "AuditLogDTO"
Cohesion: 0.07
Nodes (10): AuditLogServlet, HttpServletRequest, HttpServletResponse, Override, Timestamp, WebServlet, ResultSet, Timestamp (+2 more)

### Community 7 - ".doGet"
Cohesion: 0.08
Nodes (14): BookCopyExportServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet, BookExportServlet, HttpServletRequest, HttpServletResponse (+6 more)

### Community 8 - "BookCopyIncident"
Cohesion: 0.08
Nodes (5): BookCopyIncident, Timestamp, BookCopyIncidentDAOTest, Before, Test

### Community 9 - "DocumentTemp"
Cohesion: 0.13
Nodes (10): DocumentTempManagerServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet, DocumentTempDAO, Logger, ResultSet (+2 more)

### Community 10 - "SQLException"
Cohesion: 0.16
Nodes (8): DataSource, SQLException, AuditLogDAO, DatabaseException, ValidationException, DatabaseConnection, Connection, Logger

### Community 11 - "ManagerProfileServlet.java"
Cohesion: 0.16
Nodes (8): HttpServletRequest, HttpServletResponse, Override, WebServlet, ManagerProfileServlet, Logger, LibraryManagerDAO, LibraryManager

### Community 12 - "BookImportRowDTO"
Cohesion: 0.14
Nodes (6): DataFormatter, BookImportRowDTO, Connection, BookImportWorkbookReader, Row, Sheet

### Community 13 - "HttpServlet"
Cohesion: 0.11
Nodes (24): HttpServlet, CancelReservationServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet, DeskReservationServlet, HttpServletRequest (+16 more)

### Community 14 - "BookCirculationHistoryDTO"
Cohesion: 0.10
Nodes (9): BookCirculationHistoryServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet, BookCirculationHistoryDAO, ResultSet, BookCirculationHistoryDTO (+1 more)

### Community 15 - "StaffPerformanceDTO"
Cohesion: 0.09
Nodes (8): HttpServletRequest, HttpServletResponse, Override, WebServlet, StaffPerformanceServlet, Logger, StaffPerformanceDAO, StaffPerformanceDTO

### Community 17 - ".doPost"
Cohesion: 0.13
Nodes (13): ForgotPasswordServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, HttpServletRequest, HttpServletResponse (+5 more)

### Community 20 - "BookCopyDAO"
Cohesion: 0.14
Nodes (4): BookCopyDAO, Connection, Deprecated, PreparedStatement

### Community 21 - "User"
Cohesion: 0.14
Nodes (5): Timestamp, User, AuthServiceTest, Before, Test

### Community 23 - "UserService"
Cohesion: 0.11
Nodes (15): AdminDashboardServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet, CreateUserServlet, HttpServletRequest, HttpServletResponse (+7 more)

### Community 24 - ".getConnection"
Cohesion: 0.13
Nodes (11): HttpServletRequest, HttpServletResponse, Override, WebServlet, NewsServlet, HttpServletRequest, HttpServletResponse, Override (+3 more)

### Community 29 - ".getErrors"
Cohesion: 0.17
Nodes (6): BookImportValidatorTest, Before, Test, BookImportWorkbookReaderTest, Before, Test

### Community 30 - "BookCoverFetcher"
Cohesion: 0.20
Nodes (3): BodyHandler, BookCoverFetcher, CoverCandidate

### Community 31 - "AuthFilter.java"
Cohesion: 0.14
Nodes (12): Filter, FilterChain, FilterConfig, ServletRequest, ServletResponse, AuthFilter, HttpServletRequest, Override (+4 more)

### Community 32 - "BookImportPreviewDTO"
Cohesion: 0.16
Nodes (7): BookImportPreviewDTO, BookImportService, BookImportValidator, Pattern, BookImportServiceTest, Before, Test

### Community 33 - "Student"
Cohesion: 0.13
Nodes (8): HttpServletRequest, HttpServletResponse, Override, WebServlet, StudentProfileServlet, Logger, StudentDAO, Student

### Community 35 - "ReservationDAO"
Cohesion: 0.14
Nodes (6): Connection, Deprecated, Logger, ResultSet, ReservationDAO, Connection

### Community 36 - "ChatMessage"
Cohesion: 0.14
Nodes (9): Gson, AiChatbotServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, ChatMessage (+1 more)

### Community 37 - ".createMockConnection"
Cohesion: 0.21
Nodes (6): Before, Test, SystemConfigurationsDAOTest, Before, Test, UserDAOTest

### Community 38 - "PaymentDAO"
Cohesion: 0.14
Nodes (12): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, PaymentApiServlet, Connection, Logger (+4 more)

### Community 39 - "BookCopyIncidentServiceTest"
Cohesion: 0.18
Nodes (3): BookCopyIncidentServiceTest, Before, Test

### Community 40 - "BookSummaryDTO"
Cohesion: 0.13
Nodes (4): BookSummaryDTO, Override, AiRecommendationService, Logger

### Community 41 - "UserLockReasonDAO"
Cohesion: 0.16
Nodes (10): HttpServletRequest, HttpServletResponse, Logger, Override, Pattern, WebServlet, SePayWebhookServlet, Connection (+2 more)

### Community 42 - ".insert"
Cohesion: 0.21
Nodes (3): Connection, InventoryReconciliationService, Connection

### Community 43 - "BookImportError"
Cohesion: 0.13
Nodes (3): Connection, BookImportError, Timestamp

### Community 45 - "BookImportDAO"
Cohesion: 0.16
Nodes (8): BookImportHistoryServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet, BookImportDAO, PreparedStatement, ResultSet

### Community 46 - "OverdueProcessor"
Cohesion: 0.15
Nodes (13): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, TriggerOverdueServlet, Logger, Override (+5 more)

### Community 49 - "UserDAO"
Cohesion: 0.16
Nodes (10): GoogleLoginServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, Connection, Logger (+2 more)

### Community 50 - "LecturerDashboardServlet.java"
Cohesion: 0.14
Nodes (9): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, LecturerDashboardServlet, Logger, LecturerDAO (+1 more)

### Community 51 - "BookCopyIncidentDAO"
Cohesion: 0.20
Nodes (4): BookCopyIncidentDAO, Connection, PreparedStatement, ResultSet

### Community 54 - ".isValid"
Cohesion: 0.23
Nodes (3): IsbnValidator, IsbnValidatorTest, Test

### Community 55 - "MemberProfileDAO"
Cohesion: 0.10
Nodes (16): AdminProfileServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet, HttpServletRequest, HttpServletResponse, Override (+8 more)

### Community 56 - "DeskCirculationService"
Cohesion: 0.21
Nodes (9): CheckInServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, DeskCirculationService, Connection (+1 more)

### Community 57 - "LibrarianProfileServlet.java"
Cohesion: 0.16
Nodes (8): HttpServletRequest, HttpServletResponse, Override, WebServlet, LibrarianProfileServlet, Logger, LibrarianDAO, Librarian

### Community 58 - "ReservationExpirationProcessor"
Cohesion: 0.15
Nodes (13): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, TriggerReservationExpirationServlet, Logger, Override (+5 more)

### Community 60 - "InventoryResultDTO"
Cohesion: 0.21
Nodes (3): InventoryResultDTO, Timestamp, SuppressWarnings

### Community 62 - "BookImportServlet.java"
Cohesion: 0.23
Nodes (11): BookImportServlet, HttpServletRequest, HttpServletResponse, HttpSession, Logger, MultipartConfig, Override, Part (+3 more)

### Community 63 - "BorrowRecordDAO"
Cohesion: 0.20
Nodes (4): BorrowRecordDAO, Connection, Logger, Timestamp

### Community 65 - "SupabaseStorageClientTest"
Cohesion: 0.21
Nodes (3): Before, Test, SupabaseStorageClientTest

### Community 67 - "FineDAO"
Cohesion: 0.20
Nodes (6): FineDAO, Connection, Logger, FineDAOTest, Before, Test

### Community 68 - "BookCopyIncidentServlet"
Cohesion: 0.24
Nodes (6): BookCopyIncidentServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet

### Community 69 - "BookImageStorage"
Cohesion: 0.25
Nodes (4): BookImageStorage, BookImageStorageTest, Before, Test

### Community 70 - "BookCoverFetcher.java"
Cohesion: 0.17
Nodes (6): HttpResponse, HttpClient, Pattern, GoogleSSOUtil, GoogleSSOUtilTest, Test

### Community 71 - "SupabaseStorageClient"
Cohesion: 0.22
Nodes (5): AppConfig, Logger, Part, HttpClient, SupabaseStorageClient

### Community 72 - "BookCopyServlet"
Cohesion: 0.28
Nodes (6): BookCopyServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet

### Community 73 - "DeskDashboardServlet.java"
Cohesion: 0.26
Nodes (9): DeskDashboardServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, Connection, Logger (+1 more)

### Community 74 - ".doPost"
Cohesion: 0.26
Nodes (7): InventoryReconciliationServlet, HttpServletRequest, HttpServletResponse, HttpSession, Logger, Override, WebServlet

### Community 75 - "BookOverviewServlet.java"
Cohesion: 0.15
Nodes (5): BookOverviewServlet, HttpServletRequest, HttpServletResponse, WebServlet, BookOverviewTaskDTO

### Community 76 - "ReportDAO"
Cohesion: 0.27
Nodes (8): ExportReportServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet, InventoryReportDAO, ReportDAO, ReportService

### Community 77 - "RecommendationServlet.java"
Cohesion: 0.20
Nodes (6): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, RecommendationServlet

### Community 78 - "AppContextListener"
Cohesion: 0.22
Nodes (8): ServletContextEvent, ServletContextListener, AppContextListener, Logger, Override, EmailWorkerTest, Test, WebListener

### Community 79 - "common.ps1"
Cohesion: 0.22
Nodes (10): Find-SpecifyRoot(), Format-SpecKitCommand(), Get-CurrentBranch(), Get-FeaturePathsEnv(), Get-InvokeSeparator(), Get-Python3Command(), Get-RepoRoot(), Resolve-SpecifyInitDir() (+2 more)

### Community 80 - "NotificationManagerServlet"
Cohesion: 0.36
Nodes (6): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, NotificationManagerServlet

### Community 81 - "InventoryDAO"
Cohesion: 0.25
Nodes (3): InventoryDAO, Connection, ResultSet

### Community 83 - "ExcelExportService"
Cohesion: 0.24
Nodes (6): CellStyle, ExcelExportService, Row, ExcelExportServiceTest, Before, Test

### Community 86 - ".processCheckOut"
Cohesion: 0.28
Nodes (3): DeskCirculationServiceTest, Before, Test

### Community 87 - "InventoryReconciliationServiceTest"
Cohesion: 0.31
Nodes (3): InventoryReconciliationServiceTest, Before, Test

### Community 89 - "StudentDashboardServlet.java"
Cohesion: 0.33
Nodes (7): Connection, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, StudentDashboardServlet

### Community 91 - ".classifyIntent"
Cohesion: 0.35
Nodes (3): AiChatbotServiceTest, Before, Test

### Community 92 - ".changePassword"
Cohesion: 0.29
Nodes (3): Before, Test, ProfileServiceTest

### Community 93 - "ImportUserServlet.java"
Cohesion: 0.27
Nodes (7): Cell, ImportUserServlet, HttpServletRequest, HttpServletResponse, MultipartConfig, Override, WebServlet

### Community 95 - "CashPaymentServlet.java"
Cohesion: 0.40
Nodes (6): CashPaymentServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet

### Community 96 - "CheckOutServlet"
Cohesion: 0.40
Nodes (6): CheckOutServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet

### Community 97 - "PublicNewsServlet.java"
Cohesion: 0.38
Nodes (6): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, PublicNewsServlet

### Community 100 - "EmailWorker"
Cohesion: 0.29
Nodes (6): EmailTemplateDAO, Logger, ResultSet, EmailWorker, Logger, ServletContext

### Community 103 - "OnlineCirculationServiceTest"
Cohesion: 0.31
Nodes (3): Before, Test, OnlineCirculationServiceTest

### Community 104 - "LogoutServlet"
Cohesion: 0.44
Nodes (6): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, LogoutServlet

### Community 105 - ".doGet"
Cohesion: 0.33
Nodes (6): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, ManagerDashboardServlet

### Community 107 - "NotificationWidgetServlet.java"
Cohesion: 0.27
Nodes (7): HttpServletRequest, HttpServletResponse, Override, WebServlet, NotificationWidgetServlet, Logger, ResultSet

### Community 108 - "UserDTO.java"
Cohesion: 0.22
Nodes (5): HttpServletRequest, HttpServletResponse, WebServlet, UpdateUserServlet, Timestamp

### Community 112 - "EmailService"
Cohesion: 0.33
Nodes (4): LinkedBlockingQueue, Session, EmailService, Logger

### Community 113 - "BorrowHistoryServlet.java"
Cohesion: 0.39
Nodes (6): BorrowHistoryServlet, HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet

### Community 114 - "LibrarianDashboardServlet.java"
Cohesion: 0.42
Nodes (6): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, LibrarianDashboardServlet

### Community 115 - "AiRecommendationServiceTest"
Cohesion: 0.36
Nodes (3): AiRecommendationServiceTest, Before, Test

### Community 116 - "ExportUserServlet.java"
Cohesion: 0.36
Nodes (5): ExportUserServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet

### Community 117 - "MemberFinesServlet.java"
Cohesion: 0.39
Nodes (6): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, MemberFinesServlet

### Community 118 - "MyBorrowingsServlet.java"
Cohesion: 0.39
Nodes (6): HttpServletRequest, HttpServletResponse, Logger, Override, WebServlet, MyBorrowingsServlet

### Community 119 - "SystemReportServlet.java"
Cohesion: 0.39
Nodes (5): HttpServletRequest, HttpServletResponse, Override, WebServlet, SystemReportServlet

### Community 120 - "BorrowRecord.java"
Cohesion: 0.31
Nodes (3): BorrowRecordDAOTest, Before, Test

### Community 121 - "UserServiceTest"
Cohesion: 0.39
Nodes (3): Before, Test, UserServiceTest

### Community 122 - "BookCoverFetcherTest"
Cohesion: 0.39
Nodes (3): BookCoverFetcherTest, Before, Test

### Community 123 - "BookDetailServlet.java"
Cohesion: 0.43
Nodes (5): BookDetailServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet

### Community 124 - "BookImageServlet.java"
Cohesion: 0.43
Nodes (5): BookImageServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet

### Community 125 - ".doGet"
Cohesion: 0.43
Nodes (5): BookSearchServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet

### Community 126 - "HealthCheckServlet.java"
Cohesion: 0.43
Nodes (5): HealthCheckServlet, HttpServletRequest, HttpServletResponse, Override, WebServlet

### Community 127 - "chatbot.js"
Cohesion: 0.38
Nodes (4): appendMessage(), parseMarkdown(), scrollToBottom(), showLoadingIndicator()

### Community 128 - "NotificationDAOTest.java"
Cohesion: 0.47
Nodes (3): Before, Test, NotificationDAOTest

### Community 129 - "ReportServiceTest.java"
Cohesion: 0.47
Nodes (3): Before, Test, ReportServiceTest

### Community 130 - "generate_report.py"
Cohesion: 0.60
Nodes (4): build_expected_result(), build_template3_report(), parse_katalon_details_csv(), Builds a clear, professional Vietnamese Expected Result based on TC ID, Descript

### Community 143 - "MockJdbc"
Cohesion: 0.27
Nodes (5): ResultSetMetaData, Connection, PreparedStatement, ResultSet, MockJdbc

## Knowledge Gaps
- **34 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `BookDAO` connect `BookDAO` to `Tag`, `Category`, `BookCopy`, `.doGet`, `SQLException`, `HttpServlet`, `.findById`, `BookImportPreviewDTO`, `.insert`, `OverdueProcessor`, `BookCopyIncidentService`, `SystemConfigDAO`, `LecturerDashboardServlet.java`, `BookCopyIncidentDAO`, `DeskCirculationService`, `ReservationExpirationProcessor`, `BookCopyServlet`, `BookOverviewServlet.java`, `RecommendationServlet.java`, `StudentDashboardServlet.java`, `BookCatalogSummaryDTO`, `AiChatbotService`, `BorrowHistoryServlet.java`, `MyBorrowingsServlet.java`, `BookDetailServlet.java`, `.doGet`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **Why does `UserDAO` connect `UserDAO` to `SQLException`, `ManagerProfileServlet.java`, `HttpServlet`, `.doPost`, `UserDTO`, `User`, `UserService`, `.findById`, `AuthFilter.java`, `Student`, `.createMockConnection`, `UserLockReasonDAO`, `.findByUserId`, `OverdueProcessor`, `SystemConfigDAO`, `MemberProfileDAO`, `DeskCirculationService`, `LibrarianProfileServlet.java`, `ReservationExpirationProcessor`, `.mapResultSetToUserDTO`, `DeskDashboardServlet.java`, `NotificationManagerServlet`, `.doGet`, `UserContactDTO`?**
  _High betweenness centrality (0.034) - this node is a cross-community bridge._
- **Why does `BookCoverFetcher` connect `BookCoverFetcher` to `SupabaseStorageClientTest`, `.processBook`, `BookCoverFetcher.java`, `SupabaseStorageClient`, `BookCoverFetcherTest`?**
  _High betweenness centrality (0.033) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `UserDAO` (e.g. with `.doGet()` and `.validateUsers()`) actually correct?**
  _`UserDAO` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Should `BookDAO` be split into smaller, more focused modules?**
  _Cohesion score 0.05232383808095952 - nodes in this community are weakly interconnected._
- **Should `BookSuggestion` be split into smaller, more focused modules?**
  _Cohesion score 0.05595959595959596 - nodes in this community are weakly interconnected._
- **Should `SystemConfiguration` be split into smaller, more focused modules?**
  _Cohesion score 0.050102951269732326 - nodes in this community are weakly interconnected._