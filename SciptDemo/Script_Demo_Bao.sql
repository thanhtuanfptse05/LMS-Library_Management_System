-- ============================================================================
-- SCRIPT DEMO BẢO (F5: Online Reservation & Renewal)
-- Hướng dẫn: 
-- 1. Chạy các file seeds mặc định (01_truncate_all.sql -> 06_email_templates.sql) để reset CSDL.
-- 2. Dán toàn bộ file này vào Supabase SQL Editor và bấm RUN.
-- ============================================================================

DO $$
DECLARE
    v_uid INT;
BEGIN

-- =====================================================================
-- BƯỚC 1: Cấu hình hệ thống & Tạo 4 tài khoản Student bổ sung (B2–B5)
-- =====================================================================

-- Cấu hình GV mượn+đặt trước tối đa = 5 cuốn
UPDATE SystemConfigurations SET configValue = '5' WHERE configKey = 'LECTURER_MAX_BORROW_LIMIT';

-- ===== studentB2@lms.com (dùng cho Xếp hàng chờ & Hủy đặt trước) =====
INSERT INTO "User" (email, passwordHash, status, role)
VALUES ('studentB2@lms.com', '$2a$10$xQMQN77wcRcemqufl4mxweSL.KQiAJZwvKmbJ6eexT03D6tiS8xYu', 'active', 'STUDENT')
RETURNING userId INTO v_uid;
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
VALUES (v_uid, 'Demo Student B2', '0900000002', 'Nam', '2002-02-02');
INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (v_uid, 'HE180B02', 'Computer Science', 2022);

-- ===== studentB3@lms.com (dùng cho Test case Quota Limit 3/3) =====
INSERT INTO "User" (email, passwordHash, status, role)
VALUES ('studentB3@lms.com', '$2a$10$PenWn55PFNKRM3Vu1YVfguzaMy91iNZbis.jdRkZDvAUnwAnwGqwO', 'active', 'STUDENT')
RETURNING userId INTO v_uid;
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
VALUES (v_uid, 'Demo Student B3', '0900000003', 'Nữ', '2002-03-03');
INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (v_uid, 'HE180B03', 'Business Administration', 2022);

-- ===== studentB4@lms.com (dùng cho Test case Tài khoản bị khóa) =====
INSERT INTO "User" (email, passwordHash, status, role)
VALUES ('studentB4@lms.com', '$2a$10$/rsKFolY1AgCOI4m6SYPNOcuU/wB1SEUtBEalMBN1cPyIWyPjW6Be', 'active', 'STUDENT')
RETURNING userId INTO v_uid;
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
VALUES (v_uid, 'Demo Student B4', '0900000004', 'Nữ', '2002-04-04');
INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (v_uid, 'HE180B04', 'Graphic Design', 2023);

-- ===== studentB5@lms.com (dùng cho Test case Nợ phạt chưa thanh toán) =====
INSERT INTO "User" (email, passwordHash, status, role)
VALUES ('studentB5@lms.com', '$2a$10$iIK30uavFlj2U0QfroVAUug0iunTmPV9Eb07O8yp78q/j20a9SLru', 'active', 'STUDENT')
RETURNING userId INTO v_uid;
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
VALUES (v_uid, 'Demo Student B5', '0900000005', 'Nam', '2002-05-05');
INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (v_uid, 'HE180B05', 'Hospitality Management', 2023);


-- =====================================================================
-- BƯỚC 2: Thiết lập dữ liệu trạng thái cho 12 Test Cases F5
-- =====================================================================

-- ===== TC-Res-03: studentB3 đã đặt trước ĐỦ 3 cuốn (chạm trần quota 3/3) =====
INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES
  ((SELECT userId FROM "User" WHERE email = 'studentB3@lms.com'),
   (SELECT bookId FROM Book WHERE isbn = '9780134685991'), NULL, 'readypickup', 0, NOW(), NOW() + INTERVAL '1 day'),
  ((SELECT userId FROM "User" WHERE email = 'studentB3@lms.com'),
   (SELECT bookId FROM Book WHERE isbn = '9780132350884'), NULL, 'readypickup', 0, NOW(), NOW() + INTERVAL '1 day'),
  ((SELECT userId FROM "User" WHERE email = 'studentB3@lms.com'),
   (SELECT bookId FROM Book WHERE isbn = '9780201633610'), NULL, 'readypickup', 0, NOW(), NOW() + INTERVAL '1 day');

UPDATE Book SET availableQuantity = availableQuantity - 1 WHERE isbn IN ('9780134685991', '9780132350884', '9780201633610');


-- ===== TC-Res-04: studentB4 tài khoản bị khóa =====
UPDATE "User" SET status = 'locked' WHERE email = 'studentB4@lms.com';
INSERT INTO UserLockReason (userId, reason, createdAt)
VALUES ((SELECT userId FROM "User" WHERE email = 'studentB4@lms.com'), 'Khóa bởi Quản trị viên hệ thống', NOW());


-- ===== TC-Res-05: studentB5 nợ phạt chưa thanh toán (15,000đ) =====
INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'studentB5@lms.com'),
  (SELECT bookId FROM Book WHERE isbn = '9780321356680'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9780321356680-01'),
  'fulfilled', NULL, NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days'
);

INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount, createdBy, createdAt)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'studentB5@lms.com'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9780321356680-01'),
  (SELECT bookId FROM Book WHERE isbn = '9780321356680'),
  NOW() - INTERVAL '15 days', NOW() - INTERVAL '10 days',
  NOW() - INTERVAL '7 days', 'returned', 0,
  (SELECT userId FROM "User" WHERE email = 'librarianB1@lms.com'),
  NOW() - INTERVAL '15 days'
);

INSERT INTO Fine (borrowRecordId, userId, amount, reason, status, createdAt)
VALUES (
  (SELECT borrowRecordId FROM BorrowRecord WHERE userId = (SELECT userId FROM "User" WHERE email = 'studentB5@lms.com') ORDER BY borrowRecordId DESC LIMIT 1),
  (SELECT userId FROM "User" WHERE email = 'studentB5@lms.com'),
  15000, 'Quá hạn trả sách 3 ngày × 5,000₫/ngày', 'unpaid', NOW() - INTERVAL '7 days'
);

UPDATE "User" SET status = 'locked' WHERE email = 'studentB5@lms.com';
INSERT INTO UserLockReason (userId, reason, createdAt)
VALUES ((SELECT userId FROM "User" WHERE email = 'studentB5@lms.com'), 'unpaid', NOW() - INTERVAL '7 days');


-- ===== TC-Renew-01 PASS: studentB1 mượn "Algorithms" (4/5 ngày = 80% > 50%) =====
INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'studentB1@lms.com'),
  (SELECT bookId FROM Book WHERE isbn = '9780321356680'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9780321356680-02'),
  'fulfilled', NULL, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'
);

INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount, createdBy, createdAt)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'studentB1@lms.com'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9780321356680-02'),
  (SELECT bookId FROM Book WHERE isbn = '9780321356680'),
  NOW() - INTERVAL '4 days', NOW() + INTERVAL '1 day',
  NULL, 'borrowed', 0,
  (SELECT userId FROM "User" WHERE email = 'librarianB1@lms.com'),
  NOW() - INTERVAL '4 days'
);
UPDATE BookCopy SET status = 'borrowed' WHERE barcode = 'BC9780321356680-02';
UPDATE Book SET availableQuantity = availableQuantity - 1 WHERE isbn = '9780321356680';


-- ===== TC-Renew-02 FAIL: lecturerB1 mượn "Macroeconomics" (1/10 ngày = 10% < 50%) =====
INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'lecturerB1@lms.com'),
  (SELECT bookId FROM Book WHERE isbn = '9780073523323'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9780073523323-01'),
  'fulfilled', NULL, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'
);

INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount, createdBy, createdAt)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'lecturerB1@lms.com'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9780073523323-01'),
  (SELECT bookId FROM Book WHERE isbn = '9780073523323'),
  NOW() - INTERVAL '1 day', NOW() + INTERVAL '9 days',
  NULL, 'borrowed', 0,
  (SELECT userId FROM "User" WHERE email = 'librarianB1@lms.com'),
  NOW() - INTERVAL '1 day'
);
UPDATE BookCopy SET status = 'borrowed' WHERE barcode = 'BC9780073523323-01';
UPDATE Book SET availableQuantity = availableQuantity - 1 WHERE isbn = '9780073523323';


-- ===== TC-Renew-03 FAIL: lecturerB1 mượn "Intro Politics" (extensionCount = 2/2) =====
INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'lecturerB1@lms.com'),
  (SELECT bookId FROM Book WHERE isbn = '9780199232741'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9780199232741-01'),
  'fulfilled', NULL, NOW() - INTERVAL '18 days', NOW() - INTERVAL '18 days'
);

INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount, createdBy, createdAt)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'lecturerB1@lms.com'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9780199232741-01'),
  (SELECT bookId FROM Book WHERE isbn = '9780199232741'),
  NOW() - INTERVAL '18 days', NOW() + INTERVAL '2 days',
  NULL, 'borrowed', 2,
  (SELECT userId FROM "User" WHERE email = 'librarianB1@lms.com'),
  NOW() - INTERVAL '18 days'
);
UPDATE BookCopy SET status = 'borrowed' WHERE barcode = 'BC9780199232741-01';
UPDATE Book SET availableQuantity = availableQuantity - 1 WHERE isbn = '9780199232741';


-- ===== TC-Renew-04 FAIL: lecturerB1 mượn "Data-Intensive Apps" + studentB2 pending queue pos 1 =====
INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'lecturerB1@lms.com'),
  (SELECT bookId FROM Book WHERE isbn = '9781449331818'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9781449331818-01'),
  'fulfilled', NULL, NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days'
);

INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount, createdBy, createdAt)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'lecturerB1@lms.com'),
  (SELECT bookCopyId FROM BookCopy WHERE barcode = 'BC9781449331818-01'),
  (SELECT bookId FROM Book WHERE isbn = '9781449331818'),
  NOW() - INTERVAL '9 days', NOW() + INTERVAL '1 day',
  NULL, 'borrowed', 0,
  (SELECT userId FROM "User" WHERE email = 'librarianB1@lms.com'),
  NOW() - INTERVAL '9 days'
);

UPDATE BookCopy SET status = 'borrowed' WHERE barcode IN ('BC9781449331818-01', 'BC9781449331818-02');
UPDATE Book SET availableQuantity = 0 WHERE isbn = '9781449331818';

-- studentB2 đặt trước cuốn này → pending queue pos 1
INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'studentB2@lms.com'),
  (SELECT bookId FROM Book WHERE isbn = '9781449331818'),
  NULL, 'pending', 1, NOW(), NULL
);


-- ===== TC-Cancel-01: studentB2 pending (pos 1) + studentB1 pending (pos 2) cho "AI Modern Approach" =====
UPDATE BookCopy SET status = 'borrowed' WHERE barcode IN ('BC9780132145374-01', 'BC9780132145374-02');
UPDATE Book SET availableQuantity = 0 WHERE isbn = '9780132145374';

INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES
  ((SELECT userId FROM "User" WHERE email = 'studentB2@lms.com'),
   (SELECT bookId FROM Book WHERE isbn = '9780132145374'), NULL, 'pending', 1, NOW(), NULL),
  ((SELECT userId FROM "User" WHERE email = 'studentB1@lms.com'),
   (SELECT bookId FROM Book WHERE isbn = '9780132145374'), NULL, 'pending', 2, NOW(), NULL);


-- ===== TC-Cancel-02/03: studentB1 readypickup "Corporate Finance" + studentB2 pending pos 1 =====
UPDATE Book SET availableQuantity = availableQuantity - 1 WHERE isbn = '9781119560821';

INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES
  ((SELECT userId FROM "User" WHERE email = 'studentB1@lms.com'),
   (SELECT bookId FROM Book WHERE isbn = '9781119560821'), NULL, 'readypickup', 0, NOW(), NOW() + INTERVAL '1 day'),
  ((SELECT userId FROM "User" WHERE email = 'studentB2@lms.com'),
   (SELECT bookId FROM Book WHERE isbn = '9781119560821'), NULL, 'pending', 1, NOW(), NULL);

END $$;
