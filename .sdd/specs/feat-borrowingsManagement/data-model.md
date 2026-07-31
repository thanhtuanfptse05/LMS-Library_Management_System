# Data Model & Schema Design: Librarian Borrowings Management & Recall Request

**Feature**: `.sdd/specs/feat-borrowingsManagement`
**Date**: 2026-07-31

---

## 1. DTO Specification: `BorrowingManagementDTO`

Lớp DTO chứa thông tin tổng hợp cho hiển thị danh sách mượn sách:

```java
package dto;

import java.sql.Timestamp;

public class BorrowingManagementDTO {
    private int borrowRecordId;
    private int userId;
    private String userFullName;
    private String userCode;        // studentCode hoặc lecturerCode
    private String userEmail;
    private String userRole;        // 'student' hoặc 'lecturer'
    private int bookId;
    private String bookTitle;
    private String isbn;
    private int bookCopyId;
    private String barcode;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp returnedAt;
    private String status;          // 'borrowed', 'overdue', 'returned', 'recalled'

    // Getters and Setters ...
}
```

---

## 2. Database Entities Involved

### `BorrowRecord` Table
* `borrowRecordId` (INT, PK)
* `userId` (INT, FK -> "User")
* `bookCopyId` (INT, FK -> BookCopy)
* `bookId` (INT, FK -> Book)
* `startDate` (TIMESTAMP)
* `endDate` (TIMESTAMP)
* `returnedAt` (TIMESTAMP NULL)
* `status` (VARCHAR - 'borrowed', 'overdue', 'returned', 'recalled')

### `EmailTemplate` Table
* `tempName` (VARCHAR(50), PK) = `'RECALL_NOTICE'`
* `subject` (VARCHAR(255)) = `'Thông báo: Yêu cầu thu hồi sách mượn — Thư viện LMS'`
* `bodyContent` (TEXT HTML với `{{userName}}`, `{{bookTitle}}`, `{{barcode}}`, `{{recallReason}}`)

### `AuditLogs` Table
* `auditLogId` (INT, PK)
* `userId` (INT, FK -> "User" - ID của Thủ thư thực hiện)
* `actionType` (VARCHAR(50)) = `'SEND_RECALL_EMAIL'`
* `entityName` (VARCHAR(50)) = `'BorrowRecord'`
* `entityId` (INT) = `borrowRecordId`
* `oldValues` (TEXT)
* `newValues` (TEXT) = `'reason=...'`
* `timestamp` (TIMESTAMP DEFAULT NOW())

---

## 3. Query Design & SQL Specifications

### Paginated Search Query

```sql
SELECT 
    br.borrowRecordId, br.userId, mp.fullName AS userFullName,
    COALESCE(st.studentCode, lec.lecturerCode, u.email) AS userCode,
    u.email AS userEmail, u.role AS userRole,
    b.bookId, b.title AS bookTitle, b.isbn,
    bc.bookCopyId, bc.barcode,
    br.startDate, br.endDate, br.returnedAt, br.status
FROM BorrowRecord br
JOIN "User" u ON br.userId = u.userId
JOIN MemberProfile mp ON u.userId = mp.userId
JOIN Book b ON br.bookId = b.bookId
JOIN BookCopy bc ON br.bookCopyId = bc.bookCopyId
LEFT JOIN Student st ON u.userId = st.userId
LEFT JOIN Lecturer lec ON u.userId = lec.userId
WHERE (? IS NULL OR mp.fullName ILIKE ? OR st.studentCode ILIKE ? OR lec.lecturerCode ILIKE ?)
  AND (? IS NULL OR bc.barcode ILIKE ?)
  AND (? IS NULL OR br.status = ?)
  AND (?::timestamp IS NULL OR br.startDate >= ?)
  AND (?::timestamp IS NULL OR br.startDate <= ?)
ORDER BY br.startDate DESC
LIMIT ? OFFSET ?;
```
