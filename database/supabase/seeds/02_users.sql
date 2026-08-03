-- ==========================================================================
-- LMS SEED DATA SEGMENT: Team Demo Accounts (4 Accounts Per Member: B, C, T, V, Q)
-- ==========================================================================
-- Tự động XÓA SẠCH dữ liệu User cũ và tạo lại 4 tài khoản cho mỗi thành viên (Tổng 20 tài khoản):
-- - Nhóm Bảo (B): adminB1@lms.com, librarianB1@lms.com, lecturerB1@lms.com, studentB1@lms.com
-- - Nhóm Chương (C): adminC1@lms.com, librarianC1@lms.com, lecturerC1@lms.com, studentC1@lms.com
-- - Nhóm Tuấn (T): adminT1@lms.com, librarianT1@lms.com, lecturerT1@lms.com, studentT1@lms.com
-- - Nhóm Thái (V): adminV1@lms.com, librarianV1@lms.com, lecturerV1@lms.com, studentV1@lms.com
-- - Nhóm Quyết (Q): adminQ1@lms.com, librarianQ1@lms.com, lecturerQ1@lms.com, studentQ1@lms.com
-- Mật khẩu mặc định của mỗi tài khoản là chính địa chỉ email của tài khoản đó.
-- Mỗi tài khoản sở hữu Họ và tên (fullName) khác nhau để giao diện hiển thị trực quan.
-- ==========================================================================

-- 1. Unlink FKs & Truncate các bảng User để reset ID về 1
UPDATE Category SET updatedBy = NULL WHERE updatedBy IS NOT NULL;
UPDATE Tag SET updatedBy = NULL WHERE updatedBy IS NOT NULL;
UPDATE SystemConfigurations SET updatedBy = NULL WHERE updatedBy IS NOT NULL;
UPDATE EmailTemplate SET updatedBy = NULL WHERE updatedBy IS NOT NULL;

TRUNCATE TABLE 
    Admin,
    Librarian,
    Lecturer,
    Student,
    MemberProfile,
    UserLockReason,
    "User"
RESTART IDENTITY CASCADE;

DO $$
DECLARE
    v_uid INT;
BEGIN

    -- =========================================================================
    -- 1. NHÓM BẢO (Mã định danh email: B)
    -- =========================================================================

    -- adminB1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('adminB1@lms.com', '$2a$10$/PIn3U.heyp0OZAbqXZbMORwXCaw7aMAc8B6VyLYYOjb2gE5WocNO', 'active', 'ADMIN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Phạm Thế Bảo', '0962969970', 'Nam', '1985-04-12');
    INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'ADB01');

    -- librarianB1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('librarianB1@lms.com', '$2a$10$F3uZM1g/TlZ1odwqxibQNu5neay83DX363SmWaq3W.p5EYogdIJbK', 'active', 'LIBRARIAN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Lê Thu Hà', '0962969971', 'Nữ', '1992-08-20');
    INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LBB01');

    -- lecturerB1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('lecturerB1@lms.com', '$2a$10$oXN11LhG1Uhv0LiRWzk96ecnWfmVNdy5rU8psYAgD.k1NZtCcWGJ2', 'active', 'LECTURER')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Nguyễn Bảo Long', '0962969972', 'Nam', '1980-11-15');
    INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LECB01', 'Computer Science');

    -- studentB1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('studentB1@lms.com', '$2a$10$T7l/SwIG3IWUci8D96gkjueXz5KZ9H2FUM0MnYT0d4Tf03.//6Jgi', 'active', 'STUDENT')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Lê Thế Bảo', '0962969973', 'Nam', '2003-05-18');
    INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180001', 'Software Engineering', 2022);


    -- =========================================================================
    -- 2. NHÓM CHƯƠNG (Mã định danh email: C)
    -- =========================================================================

    -- adminC1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('adminC1@lms.com', '$2a$10$fzrkweZRyBpP1K9PutQS0uVDoxHuKl6TpoCKbxHcZm7J9iJ8Xl2RO', 'active', 'ADMIN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Nguyễn Văn Chương', '0987654321', 'Nam', '1983-09-10');
    INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'ADC01');

    -- librarianC1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('librarianC1@lms.com', '$2a$10$lsL9v2gcOR7WoZN9AVXS9uTpTnO1tUSChSjCL//Pa.1xRFp.GoXjC', 'active', 'LIBRARIAN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Trần Thị Khánh Chương', '0987654322', 'Nữ', '1990-03-25');
    INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LBC01');

    -- lecturerC1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('lecturerC1@lms.com', '$2a$10$FSk9IRZN8c.3HPYiQHjMhOzXc7MxdChTYGGFPWBD321JmeoyL55rG', 'active', 'LECTURER')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Hoàng Minh Chương', '0987654323', 'Nam', '1978-12-05');
    INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LECC01', 'Social Sciences');

    -- studentC1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('studentC1@lms.com', '$2a$10$tVS18JAragCvrnhNKvi1ZOZGbSFNp/xJTIQlHTspc.8GVlUDPsrii', 'active', 'STUDENT')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Đỗ Thành Chương', '0987654324', 'Nam', '2003-07-22');
    INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180002', 'Business Administration', 2022);


    -- =========================================================================
    -- 3. NHÓM TUẤN (Mã định danh email: T)
    -- =========================================================================

    -- adminT1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('adminT1@lms.com', '$2a$10$WhdP1aj8TKBSHDy3QTwQi.98kUUl0CJ3Ydzgw.mc7.M67wOOFei0.', 'active', 'ADMIN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Cao Thanh Tuấn', '0912345671', 'Nam', '1986-01-15');
    INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'ADT01');

    -- librarianT1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('librarianT1@lms.com', '$2a$10$jHQQouYnRymO.jTUbwfYKuDGlv8J8ZhNHc/U7kSDFgsr3NieEWV4m', 'active', 'LIBRARIAN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Vũ Minh Tuấn', '0912345672', 'Nam', '1994-06-30');
    INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LBT01');

    -- lecturerT1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('lecturerT1@lms.com', '$2a$10$L3dCj86a0hDKMbLTx9vjuuNsKdH8tIaBTH/kTUEcm1uwz4.fD7EN6', 'active', 'LECTURER')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Đặng Anh Tuấn', '0912345673', 'Nam', '1975-10-18');
    INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LECT01', 'Foreign Languages');

    -- studentT1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('studentT1@lms.com', '$2a$10$VC03Uwa2CiJAvzJ77tSPLeYndA521oXVOcRxx0qiLW84YVdh1Hu5y', 'active', 'STUDENT')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Bùi Quốc Tuấn', '0912345674', 'Nam', '2003-11-09');
    INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180003', 'Artificial Intelligence', 2022);


    -- =========================================================================
    -- 4. NHÓM THÁI (Mã định danh email: V)
    -- =========================================================================

    -- adminV1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('adminV1@lms.com', '$2a$10$lEznB1TI8HW7Bbkjrwp4Wus8Uua606uh6NgIldSD9pJlx.5dpfbWq', 'active', 'ADMIN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Nguyễn Việt Thái', '0923456781', 'Nam', '1984-05-20');
    INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'ADV01');

    -- librarianV1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('librarianV1@lms.com', '$2a$10$yS.rXBruhDDPb6v.1XRfmeZxOZE1iJ30opXEa.G.qq2decBaAsoaa', 'active', 'LIBRARIAN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Phan Hồng Thái', '0923456782', 'Nam', '1991-09-14');
    INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LBV01');

    -- lecturerV1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('lecturerV1@lms.com', '$2a$10$aezYT1WtV0T3fXK0Z3nU2Oq0z5neAOLe3J67.J373gtcCeQVogTd6', 'active', 'LECTURER')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Dương Quang Thái', '0923456783', 'Nam', '1979-02-28');
    INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LECV01', 'Economic Sciences');

    -- studentV1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('studentV1@lms.com', '$2a$10$szKz/bgh4U9w0wpWxHn.CePwjJyFiveSs9.Me9rATfSeSHEOxRW7W', 'active', 'STUDENT')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Ngô Xuân Thái', '0923456784', 'Nam', '2003-08-11');
    INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180004', 'Information Assurance', 2022);


    -- =========================================================================
    -- 5. NHÓM QUYẾT (Mã định danh email: Q)
    -- =========================================================================

    -- adminQ1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('adminQ1@lms.com', '$2a$10$wN0D1F7GwAjzDMDmlY2LT.Co8UeaFMFY5z9B7kBXx9Z5w.CMLeiX.', 'active', 'ADMIN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Vũ Đức Quyết', '0934567891', 'Nam', '1987-03-08');
    INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'ADQ01');

    -- librarianQ1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('librarianQ1@lms.com', '$2a$10$VpeJj1AHA5DCr0rRAJHGyOeZMthgbbgQoOzS.ANpEWWBTS9n5kdRW', 'active', 'LIBRARIAN')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Trịnh Văn Quyết', '0934567892', 'Nam', '1993-07-19');
    INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LBQ01');

    -- lecturerQ1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('lecturerQ1@lms.com', '$2a$10$TSgqO6sXYSJt56GFoOI.m.SUhV3rY2Q4zqiTq9XfbhiRarNhDTY8u', 'active', 'LECTURER')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Tạ Minh Quyết', '0934567893', 'Nam', '1981-04-03');
    INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LECQ01', 'Information Technology');

    -- studentQ1@lms.com
    INSERT INTO "User" (email, passwordHash, status, role)
    VALUES ('studentQ1@lms.com', '$2a$10$ZOZedAuDIx.0XsWe/QMAk.Pyi5zp2IGLvLd4Ua1ditM6RKSaTD3yi', 'active', 'STUDENT')
    RETURNING userId INTO v_uid;
    INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
    VALUES (v_uid, 'Hà Tiến Quyết', '0934567894', 'Nam', '2003-12-25');
    INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180005', 'Graphic Design', 2022);

END $$;
