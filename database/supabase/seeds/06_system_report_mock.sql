-- ============================================================
-- SCRIPT TẠO DỮ LIỆU MOCK ĐỂ TEST TÍNH NĂNG BÁO CÁO THỐNG KÊ
-- Chạy trực tiếp trong Supabase SQL Editor
-- ============================================================

DO $$
DECLARE
    v_userId INT;
    v_bookId INT;
    v_bookCopyId INT;
    v_borrowId1 INT;
    v_borrowId2 INT;
    v_fineId INT;
    v_inventorySessionId INT;
BEGIN
    -- Lấy 1 userId bất kỳ có trong DB
    SELECT userId INTO v_userId FROM "User" LIMIT 1;
    
    -- Lấy 1 bookId và bookCopyId bất kỳ có trong DB
    SELECT bookCopyId, bookId INTO v_bookCopyId, v_bookId FROM BookCopy LIMIT 1;

    -- Kiểm tra nếu có dữ liệu mới chạy tiếp (Tránh lỗi FK)
    IF v_userId IS NOT NULL AND v_bookCopyId IS NOT NULL THEN

        -- ==========================================
        -- 1. DỮ LIỆU MƯỢN TRẢ SÁCH (BorrowRecord)
        -- ==========================================
        
        -- Mượn và trả đúng hạn (Gần đây)
        INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount)
        VALUES (v_userId, v_bookCopyId, v_bookId, NOW() - INTERVAL '5 days', NOW() + INTERVAL '2 days', NOW() - INTERVAL '1 day', 'returned_good', 0);

        -- Mượn và trả đúng hạn (Tháng trước)
        INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount)
        VALUES (v_userId, v_bookCopyId, v_bookId, NOW() - INTERVAL '35 days', NOW() - INTERVAL '25 days', NOW() - INTERVAL '26 days', 'returned_good', 0);

        -- Quá hạn (Tháng trước)
        INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount)
        VALUES (v_userId, v_bookCopyId, v_bookId, NOW() - INTERVAL '40 days', NOW() - INTERVAL '30 days', NULL, 'overdue', 0)
        RETURNING borrowRecordId INTO v_borrowId1;

        -- Quá hạn (Tháng hiện tại)
        INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount)
        VALUES (v_userId, v_bookCopyId, v_bookId, NOW() - INTERVAL '15 days', NOW() - INTERVAL '5 days', NULL, 'overdue', 0)
        RETURNING borrowRecordId INTO v_borrowId2;

        -- ==========================================
        -- 2. DỮ LIỆU TÀI CHÍNH (Fine & Payment)
        -- ==========================================

        -- Phạt và đã thanh toán (Tháng trước)
        INSERT INTO Fine (borrowRecordId, userId, amount, reason, status, createdAt)
        VALUES (v_borrowId1, v_userId, 50000.00, 'Quá hạn trả sách (Tháng trước)', 'paid', NOW() - INTERVAL '25 days')
        RETURNING fineId INTO v_fineId;

        INSERT INTO Payment (fineId, paidAmount, paymentMethod, transactionReference, status, paidAt)
        VALUES (v_fineId, 50000.00, 'vnpay', 'TXN_MOCK_' || floor(random() * 1000000)::text, 'paid', NOW() - INTERVAL '24 days');

        -- Phạt nhưng chưa thanh toán (Tháng hiện tại)
        INSERT INTO Fine (borrowRecordId, userId, amount, reason, status, createdAt)
        VALUES (v_borrowId2, v_userId, 20000.00, 'Quá hạn trả sách chưa thu', 'unpaid', NOW() - INTERVAL '2 days');

        -- ==========================================
        -- 3. DỮ LIỆU KIỂM KÊ (InventorySession & Item)
        -- ==========================================

        INSERT INTO InventorySession (location, status, startedBy, completedBy, startedAt, completedAt, note)
        VALUES ('Kho Tổng Hợp (Tạo tự động)', 'completed', v_userId, v_userId, NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day', 'Kiểm kê định kỳ sinh tự động')
        RETURNING inventorySessionId INTO v_inventorySessionId;

        INSERT INTO InventoryItem (inventorySessionId, bookCopyId, expectedLocation, result)
        VALUES (v_inventorySessionId, v_bookCopyId, 'Kệ sách A1', 'matched');

        INSERT INTO InventoryItem (inventorySessionId, bookCopyId, expectedLocation, result)
        VALUES (v_inventorySessionId, v_bookCopyId, 'Kệ sách A2', 'missing');

        INSERT INTO InventoryItem (inventorySessionId, bookCopyId, expectedLocation, result)
        VALUES (v_inventorySessionId, v_bookCopyId, 'Kệ sách A3', 'misplaced');
        
        INSERT INTO InventoryItem (inventorySessionId, bookCopyId, expectedLocation, result)
        VALUES (v_inventorySessionId, v_bookCopyId, 'Kệ sách A4', 'matched');

    END IF;
END $$;
