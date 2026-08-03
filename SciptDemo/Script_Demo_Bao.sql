-- ============================================================================
-- SCRIPT DEMO BẢO (F5: Online Reservation & Renewal)
-- Hướng dẫn: 
-- 1. Chạy các file seeds mặc định (01_truncate_all.sql -> 06_email_templates.sql) để reset CSDL.
-- 2. Dán toàn bộ file này vào Supabase SQL Editor và bấm RUN (Có thể RUN nhiều lần không bị lặp dữ liệu).
-- ============================================================================

DO $$
DECLARE
    v_uid INT;
BEGIN

-- =====================================================================
-- BƯỚC 1: DỌN SẠCH DỮ LIỆU CŨ THUỘC SCRIPT DEMO (Tự làm sạch - Idempotent)
-- =====================================================================

-- 1.1. Xóa các dữ liệu giao dịch cũ của các tài khoản Nhóm B
DELETE FROM Fine WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'studentB%@lms.com' OR email = 'lecturerB1@lms.com');
DELETE FROM BorrowRecord WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'studentB%@lms.com' OR email = 'lecturerB1@lms.com');
DELETE FROM Reservation WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'studentB%@lms.com' OR email = 'lecturerB1@lms.com');
DELETE FROM UserLockReason WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'studentB%@lms.com' OR email = 'lecturerB1@lms.com');

-- 1.2. Reset trạng thái tài khoản studentB1 & lecturerB1 về active
UPDATE "User" SET status = 'active' WHERE email IN ('studentB1@lms.com', 'lecturerB1@lms.com');

-- 1.3. Xóa các tài khoản studentB2..B5 nếu đã tạo trước đó để tạo mới sạch sẽ
DELETE FROM Student WHERE userId IN (SELECT userId FROM "User" WHERE email IN ('studentB2@lms.com', 'studentB3@lms.com', 'studentB4@lms.com', 'studentB5@lms.com'));
DELETE FROM MemberProfile WHERE userId IN (SELECT userId FROM "User" WHERE email IN ('studentB2@lms.com', 'studentB3@lms.com', 'studentB4@lms.com', 'studentB5@lms.com'));
DELETE FROM "User" WHERE email IN ('studentB2@lms.com', 'studentB3@lms.com', 'studentB4@lms.com', 'studentB5@lms.com');

-- 1.4. Reset số lượng & trạng thái sách về ban đầu
UPDATE Book SET availableQuantity = 2, status = 'available' 
WHERE isbn IN ('9780134685991', '9780132350884', '9780201633610', '9781119560821', '9780321356680', '9780073523323', '9780199232741', '9781449331818', '9780132145374');
UPDATE BookCopy SET status = 'available' WHERE barcode LIKE 'BC978%';


-- =====================================================================
-- BƯỚC 2: Cấu hình hệ thống & Tạo 4 tài khoản Student bổ sung (B2–B5)
-- =====================================================================

-- Cấu hình GV mượn+đặt trước tối đa = 5 cuốn
UPDATE SystemConfigurations SET configValue = '5' WHERE configKey = 'LECTURER_MAX_BORROW_LIMIT';

-- ===== studentB2@lms.com =====
INSERT INTO "User" (email, passwordHash, status, role)
VALUES ('studentB2@lms.com', '$2a$10$xQMQN77wcRcemqufl4mxweSL.KQiAJZwvKmbJ6eexT03D6tiS8xYu', 'active', 'STUDENT')
RETURNING userId INTO v_uid;
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
VALUES (v_uid, 'Lê Văn B2', '0900000002', 'Nam', '2002-02-02');
INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (v_uid, 'HE180B02', 'Computer Science', 2022);

-- ===== studentB3@lms.com =====
INSERT INTO "User" (email, passwordHash, status, role)
VALUES ('studentB3@lms.com', '$2a$10$PenWn55PFNKRM3Vu1YVfguzaMy91iNZbis.jdRkZDvAUnwAnwGqwO', 'active', 'STUDENT')
RETURNING userId INTO v_uid;
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
VALUES (v_uid, 'Trần Thị B3', '0900000003', 'Nữ', '2002-03-03');
INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (v_uid, 'HE180B03', 'Business Administration', 2022);

-- ===== studentB4@lms.com =====
INSERT INTO "User" (email, passwordHash, status, role)
VALUES ('studentB4@lms.com', '$2a$10$/rsKFolY1AgCOI4m6SYPNOcuU/wB1SEUtBEalMBN1cPyIWyPjW6Be', 'active', 'STUDENT')
RETURNING userId INTO v_uid;
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
VALUES (v_uid, 'Phạm Hoàng B4', '0900000004', 'Nam', '2002-04-04');
INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (v_uid, 'HE180B04', 'Graphic Design', 2023);

-- ===== studentB5@lms.com =====
INSERT INTO "User" (email, passwordHash, status, role)
VALUES ('studentB5@lms.com', '$2a$10$iIK30uavFlj2U0QfroVAUug0iunTmPV9Eb07O8yp78q/j20a9SLru', 'active', 'STUDENT')
RETURNING userId INTO v_uid;
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
VALUES (v_uid, 'Đỗ Văn B5', '0900000005', 'Nam', '2002-05-05');
INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (v_uid, 'HE180B05', 'Hospitality Management', 2023);


-- =====================================================================
-- BƯỚC 3: Thiết lập dữ liệu chuẩn cho các Test Cases F5
-- =====================================================================

-- ===== 3.1. studentB1@lms.com (TÀI KHOẢN LIVE DEMO CHÍNH - QUOTA BAN ĐẦU: 1/3) =====
-- Chỉ tạo 1 BorrowRecord cho "Algorithms" (4/5 ngày = 80% > 50%) để B1 bấm Gia Hạn live ở TC-Renew-01!
-- KHÔNG TẠO ĐƠN ĐẶT TRƯỚC NÀO CHO B1 TRONG CSDL.
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


-- ===== 3.2. TRẠNG THÁI BÁN ĐẦU CÁC SÁCH DEMO KHI LIVE =====
-- Clean Code (9780132350884): HẾT SÁCH (availableQuantity = 0, Cả 2 bản sao đều borrowed)
-- Dùng để B1 đặt trước live -> Nhận đơn pending vị trí #1!
UPDATE BookCopy SET status = 'borrowed' WHERE barcode IN ('BC9780132350884-01', 'BC9780132350884-02');
UPDATE Book SET availableQuantity = 0 WHERE isbn = '9780132350884';

-- Corporate Finance (9781119560821): CÒN SẴN 1 CUỐN (availableQuantity = 1)
-- B1 bấm Đặt trước live -> Nhận đơn readypickup #0, làm availableQuantity thành 0!
-- B2 đăng nhập bấm Đặt trước live ngay sau đó -> Nhận đơn pending position 1 (xếp hàng đằng sau B1)!
-- B1 quay lại bấm Hủy đơn -> B2 tự động được đôn lên readypickup position 0!
UPDATE BookCopy SET status = 'borrowed' WHERE barcode = 'BC9781119560821-01';
UPDATE Book SET availableQuantity = 1 WHERE isbn = '9781119560821';


-- ===== 3.3. studentB2@lms.com (ĐƠN PENDING "AI Modern Approach" DÙNG CHO DEMO HỦY PENDING) =====
UPDATE BookCopy SET status = 'borrowed' WHERE barcode IN ('BC9780132145374-01', 'BC9780132145374-02');
UPDATE Book SET availableQuantity = 0 WHERE isbn = '9780132145374';

INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES (
  (SELECT userId FROM "User" WHERE email = 'studentB2@lms.com'),
  (SELECT bookId FROM Book WHERE isbn = '9780132145374'),
  NULL, 'pending', 1, NOW(), NULL
);


-- ===== 3.4. studentB3@lms.com (CHẠM TRẦN QUOTA 3/3) =====
INSERT INTO Reservation (userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES
  ((SELECT userId FROM "User" WHERE email = 'studentB3@lms.com'), (SELECT bookId FROM Book WHERE isbn = '9780134685991'), NULL, 'readypickup', 0, NOW(), NOW() + INTERVAL '1 day'),
  ((SELECT userId FROM "User" WHERE email = 'studentB3@lms.com'), (SELECT bookId FROM Book WHERE isbn = '9780201633610'), NULL, 'readypickup', 0, NOW(), NOW() + INTERVAL '1 day'),
  ((SELECT userId FROM "User" WHERE email = 'studentB3@lms.com'), (SELECT bookId FROM Book WHERE isbn = '9781449331818'), NULL, 'readypickup', 0, NOW(), NOW() + INTERVAL '1 day');
UPDATE Book SET availableQuantity = availableQuantity - 1 WHERE isbn IN ('9780134685991', '9780201633610', '9781449331818');


-- ===== 3.5. studentB4@lms.com (TÀI KHOẢN BỊ KHÓA) =====
UPDATE "User" SET status = 'locked' WHERE email = 'studentB4@lms.com';
INSERT INTO UserLockReason (userId, reason, createdAt)
VALUES ((SELECT userId FROM "User" WHERE email = 'studentB4@lms.com'), 'Khóa bởi Quản trị viên hệ thống', NOW());


-- ===== 3.6. studentB5@lms.com (NỢ PHẠT CHƯA THANH TOÁN 15,000đ) =====
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


-- ===== 3.7. lecturerB1@lms.com (GIẢNG VIÊN - TEST CASES GIA HẠN THẤT BẠI) =====

-- TC-Renew-02 FAIL: lecturerB1 mượn "Macroeconomics" (1/10 ngày = 10% < 50% ngưỡng)
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


-- TC-Renew-03 FAIL: lecturerB1 mượn "Intro Politics" (extensionCount = 2/2 lần tối đa)
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


-- TC-Renew-04 FAIL: lecturerB1 mượn "Data-Intensive Apps" + studentB2 đang xếp hàng chờ (pos 1)
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

END $$;
