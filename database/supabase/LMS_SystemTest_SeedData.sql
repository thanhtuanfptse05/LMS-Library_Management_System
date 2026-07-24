-- ============================================================================
-- LIBRARY MANAGEMENT SYSTEM — SELF-CLEANING SEED DATA FOR ALL TEST SUITES (TS1 - TS4)
-- Hướng dẫn: Dán trực tiếp vào Supabase SQL Editor và bấm Run.
-- Tự động DỌN SẠCH TRIỆT ĐỂ dữ liệu do Katalon sinh ra (TS2, TS3, TS4) để test/demo lại từ đầu 100%.
-- ============================================================================

BEGIN;

-- ----------------------------------------------------------------------------
-- BƯỚC 1: XÓA SẠCH MỌI DỮ LIỆU CŨ THUỘC TS2, TS3, TS4 (Full Cleanup)
-- ----------------------------------------------------------------------------

-- 1. Unlink các bảng có khóa ngoại trỏ tới Test User (tránh lỗi Foreign Key Constraint violation)
UPDATE Category SET updatedBy = NULL WHERE updatedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
UPDATE Tag SET updatedBy = NULL WHERE updatedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
UPDATE SystemConfigurations SET updatedBy = NULL WHERE updatedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
UPDATE EmailTemplate SET updatedBy = NULL WHERE updatedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
UPDATE BookCopy SET removedFromInventoryBy = NULL WHERE removedFromInventoryBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
UPDATE Payment SET processedBy = NULL WHERE processedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
UPDATE BorrowRecord SET createdBy = NULL WHERE createdBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));

-- 2. Xóa các dữ liệu con phụ thuộc vào Test User
DELETE FROM SuggestionVote WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
DELETE FROM BookSuggestion WHERE createdBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900)) OR reviewedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
DELETE FROM InventoryItem WHERE scannedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900)) OR resolvedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
DELETE FROM InventorySession WHERE startedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900)) OR completedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
DELETE FROM BookImportError WHERE importBatchId IN (SELECT importBatchId FROM BookImportBatch WHERE importedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900)));
DELETE FROM BookImportBatch WHERE importedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
DELETE FROM BookCopyIncident WHERE reportedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900)) OR resolvedBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
DELETE FROM UserNotificationStatus WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
DELETE FROM Notification WHERE createdBy IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));
DELETE FROM AuditLogs WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9901, 9902, 9903, 9900));

-- 3. Xóa Payments & Fines liên quan đến Test Data
DELETE FROM Payment WHERE fineId IN (SELECT fineId FROM Fine WHERE userId IN (9900, 9901, 9902, 9903) OR reason LIKE '%[SystemTest]%') OR paymentId = 9901;
DELETE FROM Fine WHERE userId IN (9900, 9901, 9902, 9903) OR reason LIKE '%[SystemTest]%' OR fineId = 9901;

-- 4. Xóa BorrowRecords & Reservations của Test Data
DELETE FROM BorrowRecord 
WHERE userId IN (9900, 9901, 9902, 9903) 
   OR borrowRecordId IN (9901, 9902, 9903, 9904, 9905, 9906)
   OR userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com')
   OR bookId IN (SELECT bookId FROM Book WHERE isbn LIKE '978-604-0-99999-%' OR isbn IN ('978-0134685991', '978-0134685992') OR bookId IN (991, 992));

DELETE FROM Reservation 
WHERE userId IN (9900, 9901, 9902, 9903) 
   OR reservationId = 9901
   OR userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com')
   OR bookId IN (SELECT bookId FROM Book WHERE isbn LIKE '978-604-0-99999-%' OR isbn IN ('978-0134685991', '978-0134685992') OR bookId IN (991, 992));

-- 5. Xóa BookCopies & Books do TS3 (Quản lý Sách) & TS4 tạo ra
DELETE FROM BookCopyIncident WHERE bookCopyId IN (SELECT bookCopyId FROM BookCopy WHERE barcode LIKE 'BC-2026-%' OR barcode LIKE 'BC_TEST_%' OR barcode LIKE 'BC_QUOTA_%' OR barcode LIKE 'BC_NOT_%' OR bookCopyId IN (9901, 9902, 9903, 9904, 9905, 9906, 9907, 9908));
DELETE FROM BookCopy WHERE barcode LIKE 'BC-2026-%' OR barcode LIKE 'BC_TEST_%' OR barcode LIKE 'BC_QUOTA_%' OR barcode LIKE 'BC_NOT_%' OR bookCopyId IN (9901, 9902, 9903, 9904, 9905, 9906, 9907, 9908) OR bookId IN (SELECT bookId FROM Book WHERE isbn LIKE '978-604-0-99999-%' OR title LIKE '%Kiểm Thử%');
DELETE FROM BookCategory WHERE bookId IN (SELECT bookId FROM Book WHERE isbn LIKE '978-604-0-99999-%' OR title LIKE '%Kiểm Thử%' OR bookId IN (991, 992));
DELETE FROM BookTag WHERE bookId IN (SELECT bookId FROM Book WHERE isbn LIKE '978-604-0-99999-%' OR title LIKE '%Kiểm Thử%' OR bookId IN (991, 992));
DELETE FROM Book WHERE isbn LIKE '978-604-0-99999-%' OR isbn IN ('978-0134685991', '978-0134685992') OR title LIKE '%Kiểm Thử%' OR bookId IN (991, 992);

-- 6. Xóa các vai trò & Hồ sơ người dùng Test (TS2 & TS4)
DELETE FROM UserLockReason WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9900, 9901, 9902, 9903));
DELETE FROM Student WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9900, 9901, 9902, 9903)) OR studentCode LIKE 'ST2026%' OR studentCode IN ('ST20230001', 'SE_TEST_QUOTA', 'SE_TEST_FINE');
DELETE FROM Lecturer WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com') OR lecturerCode LIKE 'LC2026%';
DELETE FROM Librarian WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com') OR staffCode LIKE 'LB2026%';
DELETE FROM LibraryManager WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com');
DELETE FROM Admin WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com');
DELETE FROM MemberProfile WHERE userId IN (SELECT userId FROM "User" WHERE email LIKE 'user_%@lms.com' OR email LIKE '%@test.com' OR userId IN (9900, 9901, 9902, 9903));

-- 7. Xóa triệt để bảng "User" cho các tài khoản Test
DELETE FROM "User" 
WHERE email LIKE 'user_%@lms.com' 
   OR email LIKE '%@test.com' 
   OR userId IN (9900, 9901, 9902, 9903) 
   OR email IN ('student_reservation@test.com', 'student_max_quota@test.com', 'student_fine@test.com');

-- 8. Khôi phục mật khẩu chuẩn cho tất cả các tài khoản hệ thống chính (chống bị đổi mất mật khẩu)
UPDATE "User" SET passwordHash = '$2a$10$hiOu2EHfO1RAe2h8m9XqDO1W/kR/XgyWVQ90DGeu8Sfl/RagqgBMO', status = 'active', failedLoginAttempts = 0, lockedUntil = NULL WHERE email = 'admin1@lms.com';
UPDATE "User" SET passwordHash = '$2a$10$uRUTHUvqNKlx8YJC52Li8uHl4ucxQGX7lAiAubXgyY1S4yFMTGTkK', status = 'active', failedLoginAttempts = 0, lockedUntil = NULL WHERE email = 'librarian1@lms.com';
UPDATE "User" SET passwordHash = '$2a$10$ZQNNOZIfmfOOmY80jqVyDe7OJBlIpTtQi2nEUtZ3uejMLU9Y9P1q.', status = 'active', failedLoginAttempts = 0, lockedUntil = NULL WHERE email = 'student1@lms.com';
UPDATE "User" SET passwordHash = '$2a$10$AVfGAutJO858xISgD54usee4yHwv/CGMNBimW/OwmDheMaekMGKOe', status = 'active', failedLoginAttempts = 0, lockedUntil = NULL WHERE email = 'lecturer1@lms.com';
UPDATE "User" SET passwordHash = '$2a$10$UCnIKt3ToXAZgxUBqFbh..fASkyaahmBXbjnrFOo4cY93WNkGfrs6', status = 'active', failedLoginAttempts = 0, lockedUntil = NULL WHERE email = 'manager1@lms.com';


-- ----------------------------------------------------------------------------
-- BƯỚC 2: NẠP DỮ LIỆU MỒI DÀNH RIÊNG CHO TS4 (TSCirculation E2E Flow)
-- ----------------------------------------------------------------------------

-- 0. Tài khoản Sinh viên Gốc (ST20230001): Dùng để test Giao Sách theo Đặt Trước
INSERT INTO "User" (userId, email, passwordHash, status, role, failedLoginAttempts, lockedUntil)
VALUES (9900, 'student_reservation@test.com', '$2a$10$hiOu2EHfO1RAe2h8m9XqDO1W/kR/XgyWVQ90DGeu8Sfl/RagqgBMO', 'active', 'STUDENT', 0, NULL);

INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate)
VALUES (9900, 'Nguyễn Văn Sinh Viên', '0911999000', 'Nam', '2003-01-01', '2023-01-01', '2027-01-01');

INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (9900, 'ST20230001', 'Software Engineering', 2023);


-- 1. Tài khoản Sinh viên A: Dùng để test Mượn Quá Hạn Mức (Max Quota = 3)
INSERT INTO "User" (userId, email, passwordHash, status, role, failedLoginAttempts, lockedUntil)
VALUES (9901, 'student_max_quota@test.com', '$2a$10$hiOu2EHfO1RAe2h8m9XqDO1W/kR/XgyWVQ90DGeu8Sfl/RagqgBMO', 'active', 'STUDENT', 0, NULL);

INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate)
VALUES (9901, 'Sinh Viên Chạm Trần Quota', '0911999001', 'Nam', '2003-01-01', '2023-01-01', '2027-01-01');

INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (9901, 'SE_TEST_QUOTA', 'Software Engineering', 2023);


-- 2. Tài khoản Sinh viên B: Dùng để test Trả Sách Quá Hạn & Thu Tiền Phạt
INSERT INTO "User" (userId, email, passwordHash, status, role, failedLoginAttempts, lockedUntil)
VALUES (9902, 'student_fine@test.com', '$2a$10$hiOu2EHfO1RAe2h8m9XqDO1W/kR/XgyWVQ90DGeu8Sfl/RagqgBMO', 'active', 'STUDENT', 0, NULL);

INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate)
VALUES (9902, 'Sinh Viên Nợ Phạt', '0911999002', 'Nữ', '2003-05-05', '2023-01-01', '2027-01-01');

INSERT INTO Student (userId, studentCode, major, enrollmentYear)
VALUES (9902, 'SE_TEST_FINE', 'Information Assurance', 2023);


-- 3. Tạo Các Đầu sách mồi cho TS4
INSERT INTO Book (bookId, isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status, createdAt, updatedAt)
VALUES 
(991, '978-0134685991', 'Giáo Trình Kiểm Thử LMS 2026', 'Joshua Bloch', 'NXB Đại Học FPT', 2024, 185000, 10, 6, 'available', NOW(), NOW()),
(992, '978-0134685992', 'Lập Trình Java Servlet Monolith', 'FPT Author', 'NXB Giáo Dục', 2024, 150000, 5, 5, 'available', NOW(), NOW());


-- 4. Tạo các Bản sao sách mồi cho TS4
INSERT INTO BookCopy (bookCopyId, bookId, location, condition, status, barcode, createdAt, updatedAt)
VALUES 
(9901, 991, 'Kệ CS-01', 'good', 'reserved', 'BC_TEST_CHECKOUT', NOW(), NOW()),
(9902, 991, 'Kệ CS-02', 'good', 'borrowed', 'BC_TEST_CHECKIN_OVERDUE', NOW(), NOW()),
(9903, 991, 'Kệ CS-03', 'good', 'borrowed', 'BC_QUOTA_01', NOW(), NOW()),
(9904, 991, 'Kệ CS-04', 'good', 'borrowed', 'BC_QUOTA_02', NOW(), NOW()),
(9905, 991, 'Kệ CS-05', 'good', 'borrowed', 'BC_QUOTA_03', NOW(), NOW()),
(9906, 991, 'Kệ CS-06', 'good', 'borrowed', 'BC_TEST_CHECKIN_DAMAGED', NOW(), NOW()),
(9907, 991, 'Kệ CS-07', 'good', 'borrowed', 'BC_TEST_CHECKIN_LOST', NOW(), NOW()),
(9908, 991, 'Kệ CS-08', 'good', 'available', 'BC_NOT_BORROWED', NOW(), NOW());


-- 5. Đơn Đặt Trước Chờ Lấy (Ready-pickup Reservation) cho sinh viên ST20230001 (userId = 9900)
INSERT INTO Reservation (reservationId, userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)
VALUES (9901, 9900, 991, 9901, 'readypickup', 0, NOW(), NOW() + INTERVAL '2 days');


-- 6. Tạo 3 Bản ghi mượn sách active cho SE_TEST_QUOTA (userId = 9901)
INSERT INTO BorrowRecord (borrowRecordId, userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount, createdBy, createdAt)
VALUES 
(9902, 9901, 9903, 991, NOW() - INTERVAL '5 days', NOW() + INTERVAL '9 days', NULL, 'borrowed', 0, (SELECT userId FROM "User" WHERE role IN ('LIBRARIAN', 'ADMIN') ORDER BY userId LIMIT 1), NOW() - INTERVAL '5 days'),
(9903, 9901, 9904, 991, NOW() - INTERVAL '4 days', NOW() + INTERVAL '10 days', NULL, 'borrowed', 0, (SELECT userId FROM "User" WHERE role IN ('LIBRARIAN', 'ADMIN') ORDER BY userId LIMIT 1), NOW() - INTERVAL '4 days'),
(9904, 9901, 9905, 991, NOW() - INTERVAL '3 days', NOW() + INTERVAL '11 days', NULL, 'borrowed', 0, (SELECT userId FROM "User" WHERE role IN ('LIBRARIAN', 'ADMIN') ORDER BY userId LIMIT 1), NOW() - INTERVAL '3 days');


-- 7. Tạo Các bản ghi mượn sách active cho SE_TEST_FINE (userId = 9902) để test Trả Tốt Quá Hạn, Trả Hỏng, Trả Mất
INSERT INTO BorrowRecord (borrowRecordId, userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount, createdBy, createdAt)
VALUES 
(9901, 9902, 9902, 991, NOW() - INTERVAL '24 days', NOW() - INTERVAL '10 days', NULL, 'borrowed', 0, (SELECT userId FROM "User" WHERE role IN ('LIBRARIAN', 'ADMIN') ORDER BY userId LIMIT 1), NOW() - INTERVAL '24 days'),
(9905, 9902, 9906, 991, NOW() - INTERVAL '10 days', NOW() + INTERVAL '4 days',  NULL, 'borrowed', 0, (SELECT userId FROM "User" WHERE role IN ('LIBRARIAN', 'ADMIN') ORDER BY userId LIMIT 1), NOW() - INTERVAL '10 days'),
(9906, 9902, 9907, 991, NOW() - INTERVAL '10 days', NOW() + INTERVAL '4 days',  NULL, 'borrowed', 0, (SELECT userId FROM "User" WHERE role IN ('LIBRARIAN', 'ADMIN') ORDER BY userId LIMIT 1), NOW() - INTERVAL '10 days');


-- 8. Tạo khoản Phạt chưa trả (Fine 50,000 VNĐ) & Hóa đơn Payment 'pending' cho SE_TEST_FINE (userId = 9902)
INSERT INTO Fine (fineId, borrowRecordId, userId, amount, reason, status, createdAt)
VALUES (9901, 9901, 9902, 50000, '[SystemTest] Phạt quá hạn trả sách 10 ngày', 'unpaid', NOW());

INSERT INTO Payment (paymentId, fineId, paidAmount, paymentMethod, transactionReference, processedBy, status, paidAt)
VALUES (9901, 9901, 50000, 'cash', 'REF_TEST_CASH_9901', NULL, 'pending', NOW());

COMMIT;
