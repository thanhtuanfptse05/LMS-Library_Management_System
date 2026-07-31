-- ==========================================================================
-- LMS SEED DATA SEGMENT: Truncate All Tables (Clean Slate Data Wipe)
-- ==========================================================================
-- Hướng dẫn sử dụng: Chỉ chạy script này khi muốn xóa sạch toàn bộ dữ liệu 
--                   trong tất cả các bảng để chuẩn bị chạy lại các file seed.
--                   Tất cả các sequence ID (IDENTITY) sẽ được reset về 1.
-- ==========================================================================

TRUNCATE TABLE 
    SuggestionVote,
    BookSuggestion,
    InventoryItem,
    InventorySession,
    BookImportError,
    BookImportBatch,
    BookCopyIncident,
    EmailTemplate,
    DocumentTemp,
    UserNotificationStatus,
    Notification,
    Payment,
    Fine,
    BorrowRecord,
    Reservation,
    BookCopy,
    BookTag,
    BookCategory,
    Book,
    Tag,
    Category,
    AuditLogs,
    SystemConfigurations,
    Admin,

    Librarian,
    Lecturer,
    Student,
    MemberProfile,
    UserLockReason,
    "User"
RESTART IDENTITY CASCADE;
