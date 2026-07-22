-- ==========================================================================
-- LMS SEED DATA: Thêm khối lượng lớn dữ liệu Mượn trả, Phạt, Đặt trước
-- ==========================================================================

DO $$
DECLARE
    v_admin_id INT;
    v_book1_id INT; v_book2_id INT; v_book3_id INT; v_book4_id INT; v_book5_id INT; v_book6_id INT; v_book7_id INT;
    v_copy1_1_id INT; v_copy1_2_id INT; v_copy2_1_id INT; v_copy3_1_id INT; v_copy4_1_id INT; v_copy4_2_id INT; v_copy5_1_id INT; v_copy6_1_id INT; v_copy7_1_id INT; v_copy7_2_id INT;
    v_student1_id INT; v_student2_id INT; v_student3_id INT; v_student4_id INT; v_student5_id INT;
    v_borrow_id INT;
    v_notif_id INT;
BEGIN
    -- 0. Lấy ID Admin
    SELECT userId INTO v_admin_id FROM "User" WHERE role = 'ADMIN' LIMIT 1;
    IF v_admin_id IS NULL THEN RETURN; END IF;

    -- Lấy ID của 5 sinh viên mẫu
    SELECT userId INTO v_student1_id FROM "User" WHERE email = 'student1@lms.com';
    SELECT userId INTO v_student2_id FROM "User" WHERE email = 'student2@lms.com';
    SELECT userId INTO v_student3_id FROM "User" WHERE email = 'student3@lms.com';
    SELECT userId INTO v_student4_id FROM "User" WHERE email = 'student4@lms.com';
    SELECT userId INTO v_student5_id FROM "User" WHERE email = 'student5@lms.com';

    -- 1. TẠO SÁCH MỚI (Nhiều thể loại)
    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, imagePath, totalQuantity, availableQuantity, status) VALUES 
    ('978-0134685991', 'Effective Java (3rd Edition)', 'Joshua Bloch', 'Addison-Wesley', 2017, 450000, 'https://covers.openlibrary.org/b/isbn/9780134685991-M.jpg', 2, 0, 'available') RETURNING bookId INTO v_book1_id;

    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, imagePath, totalQuantity, availableQuantity, status) VALUES 
    ('978-0132350884', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, 350000, 'https://covers.openlibrary.org/b/isbn/9780132350884-M.jpg', 1, 0, 'available') RETURNING bookId INTO v_book2_id;

    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, imagePath, totalQuantity, availableQuantity, status) VALUES 
    ('978-0596009205', 'Head First Java', 'Kathy Sierra', 'O''Reilly', 2005, 300000, 'https://covers.openlibrary.org/b/isbn/9780596009205-M.jpg', 1, 0, 'available') RETURNING bookId INTO v_book3_id;

    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, imagePath, totalQuantity, availableQuantity, status) VALUES 
    ('978-0201835953', 'The Mythical Man-Month', 'Frederick P. Brooks Jr.', 'Addison-Wesley', 1995, 250000, 'https://covers.openlibrary.org/b/isbn/9780201835953-M.jpg', 2, 1, 'available') RETURNING bookId INTO v_book4_id;

    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, imagePath, totalQuantity, availableQuantity, status) VALUES 
    ('978-0321356680', 'Design Patterns', 'Erich Gamma', 'Addison-Wesley', 1994, 500000, 'https://covers.openlibrary.org/b/isbn/9780321356680-M.jpg', 1, 0, 'available') RETURNING bookId INTO v_book5_id;

    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, imagePath, totalQuantity, availableQuantity, status) VALUES 
    ('978-1449331818', 'Learning Python', 'Mark Lutz', 'O''Reilly', 2013, 600000, 'https://covers.openlibrary.org/b/isbn/9781449331818-M.jpg', 1, 0, 'available') RETURNING bookId INTO v_book6_id;

    INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, imagePath, totalQuantity, availableQuantity, status) VALUES 
    ('978-0134092669', 'Computer Networking', 'James Kurose', 'Pearson', 2016, 750000, 'https://covers.openlibrary.org/b/isbn/9780134092669-M.jpg', 2, 0, 'available') RETURNING bookId INTO v_book7_id;

    -- 2. TẠO BẢN SAO SÁCH (BOOK COPIES)
    -- Sửa lỗi: Cột condition chỉ chấp nhận 'good', 'damaged', 'lost'
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book1_id, 'A1-01', 'good', 'borrowed', 'BC-10001') RETURNING bookCopyId INTO v_copy1_1_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book1_id, 'A1-02', 'good', 'borrowed', 'BC-10002') RETURNING bookCopyId INTO v_copy1_2_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book2_id, 'B2-01', 'good', 'borrowed', 'BC-20001') RETURNING bookCopyId INTO v_copy2_1_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book3_id, 'C3-01', 'good', 'borrowed', 'BC-30001') RETURNING bookCopyId INTO v_copy3_1_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book4_id, 'D1-01', 'good', 'borrowed', 'BC-40001') RETURNING bookCopyId INTO v_copy4_1_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book4_id, 'D1-02', 'good', 'available', 'BC-40002') RETURNING bookCopyId INTO v_copy4_2_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book5_id, 'E2-01', 'good', 'borrowed', 'BC-50001') RETURNING bookCopyId INTO v_copy5_1_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book6_id, 'F3-01', 'good', 'borrowed', 'BC-60001') RETURNING bookCopyId INTO v_copy6_1_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book7_id, 'G1-01', 'good', 'borrowed', 'BC-70001') RETURNING bookCopyId INTO v_copy7_1_id;
    INSERT INTO BookCopy (bookId, location, condition, status, barcode) VALUES (v_book7_id, 'G1-02', 'good', 'borrowed', 'BC-70002') RETURNING bookCopyId INTO v_copy7_2_id;


    -- =========================================================================
    -- 3. BƠM DỮ LIỆU MƯỢN TRẢ CHO STUDENT 1 (TRẦN DUY HOÀNG)
    -- =========================================================================
    
    -- A. Sách Đang Mượn (7 cuốn, không bị phạt)
    INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, status, createdBy) VALUES 
    (v_student1_id, v_copy1_1_id, v_book1_id, NOW() - INTERVAL '5 days', NOW() + INTERVAL '9 days', 'borrowing', v_admin_id),
    (v_student1_id, v_copy4_1_id, v_book4_id, NOW() - INTERVAL '2 days', NOW() + INTERVAL '12 days', 'borrowing', v_admin_id),
    (v_student1_id, v_copy6_1_id, v_book6_id, NOW() - INTERVAL '1 days', NOW() + INTERVAL '13 days', 'borrowing', v_admin_id),
    (v_student1_id, v_copy5_1_id, v_book5_id, NOW() - INTERVAL '3 days', NOW() + INTERVAL '11 days', 'borrowing', v_admin_id),
    (v_student1_id, v_copy7_1_id, v_book7_id, NOW() - INTERVAL '4 days', NOW() + INTERVAL '10 days', 'borrowing', v_admin_id),
    (v_student1_id, v_copy3_1_id, v_book3_id, NOW() - INTERVAL '6 days', NOW() + INTERVAL '8 days', 'borrowing', v_admin_id);
    
    -- B. DUY NHẤT 1 Sách Quá Hạn & 1 Khoản Phạt (Overdue)
    -- Cuốn Clean Code (book 2): Quá hạn 5 ngày
    -- Khi hệ thống check vào ngày mai, nó sẽ thấy (NOW() - endDate) = 6 ngày và tự động update tiền phạt.
    INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, status, createdBy) 
    VALUES (v_student1_id, v_copy2_1_id, v_book2_id, NOW() - INTERVAL '19 days', NOW() - INTERVAL '5 days', 'overdue', v_admin_id) RETURNING borrowRecordId INTO v_borrow_id;
    
    INSERT INTO Fine (borrowRecordId, userId, amount, reason, status) 
    VALUES (v_borrow_id, v_student1_id, 25000, 'Quá hạn 5 ngày (5.000đ/ngày)', 'unpaid');

    -- C. Lịch sử mượn (10 cuốn đã trả)
    FOR i IN 1..10 LOOP
        INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, createdBy)
        VALUES (v_student1_id, v_copy4_2_id, v_book4_id, 
                NOW() - (INTERVAL '100 days' - (i * INTERVAL '5 days')), 
                NOW() - (INTERVAL '86 days' - (i * INTERVAL '5 days')), 
                NOW() - (INTERVAL '88 days' - (i * INTERVAL '5 days')), 
                'returned', v_admin_id);
    END LOOP;

    -- D. Sách đã đặt trước (4 cuốn)
    INSERT INTO Reservation (userId, bookId, status, queuePosition, startDate, endDate) VALUES 
    (v_student1_id, v_book1_id, 'active', 2, NOW(), NOW() + INTERVAL '3 days'),
    (v_student1_id, v_book2_id, 'active', 1, NOW(), NOW() + INTERVAL '3 days'),
    (v_student1_id, v_book5_id, 'active', 3, NOW(), NOW() + INTERVAL '3 days'),
    (v_student1_id, v_book6_id, 'active', 1, NOW(), NOW() + INTERVAL '3 days');

    -- E. Thông báo (1 nhắc nhở phạt + 4 chung)
    INSERT INTO Notification (title, content, type, targetRole, createdBy)
    VALUES ('Nhắc nhở trả sách quá hạn', 'Cuốn sách "Clean Code" của bạn đã quá hạn 5 ngày. Vui lòng hoàn trả và thanh toán 25.000đ.', 'reminder', 'STUDENT', v_admin_id)
    RETURNING notificationId INTO v_notif_id;

    FOR i IN 1..4 LOOP
        INSERT INTO Notification (title, content, type, targetRole, createdBy)
        VALUES ('Thông báo tự động số ' || i, 'Tài liệu hướng dẫn môn học kỳ Fall 2026 đã có sẵn trong danh mục.', 'general', 'STUDENT', v_admin_id)
        RETURNING notificationId INTO v_notif_id;
    END LOOP;


    -- =========================================================================
    -- 4. BƠM VÀI DỮ LIỆU CHO CÁC SINH VIÊN KHÁC
    -- =========================================================================
    
    -- Student 2
    INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, status, createdBy) VALUES 
    (v_student2_id, v_copy1_2_id, v_book1_id, NOW() - INTERVAL '2 days', NOW() + INTERVAL '12 days', 'borrowing', v_admin_id),
    (v_student2_id, v_copy7_2_id, v_book7_id, NOW() - INTERVAL '4 days', NOW() + INTERVAL '10 days', 'borrowing', v_admin_id);

    INSERT INTO Reservation (userId, bookId, status, queuePosition, startDate, endDate) VALUES 
    (v_student2_id, v_book3_id, 'active', 1, NOW(), NOW() + INTERVAL '3 days');

    -- Student 3
    INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, createdBy) VALUES 
    (v_student3_id, v_copy1_1_id, v_book1_id, NOW() - INTERVAL '50 days', NOW() - INTERVAL '36 days', NOW() - INTERVAL '35 days', 'returned', v_admin_id),
    (v_student3_id, v_copy2_1_id, v_book2_id, NOW() - INTERVAL '40 days', NOW() - INTERVAL '26 days', NOW() - INTERVAL '27 days', 'returned', v_admin_id);

END $$;
