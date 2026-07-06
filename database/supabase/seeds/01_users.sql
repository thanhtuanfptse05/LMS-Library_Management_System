-- ==========================================================================
-- LMS SEED DATA SEGMENT: Core & Demo Accounts (PostgreSQL Configurable Block)
-- ==========================================================================
-- Lưu ý: Không hardcode userId. Để Supabase tự tăng (IDENTITY).
--        Dùng kỹ thuật RETURNING userId INTO v_uid để lấy ID cho các bảng phụ.
-- ==========================================================================

DO $$
DECLARE
    -- =========================================================================
    -- CỜ CẤU HÌNH TẠO DỮ LIỆU SEED
    -- =========================================================================
    -- Đặt thành TRUE để tạo tài khoản Cao Tuấn (Manager)
    create_caotuan CONSTANT BOOLEAN := TRUE;

    -- Đặt thành TRUE để tạo 25 tài khoản mẫu từ Excel (5 tài khoản mỗi role)
    create_excel_users CONSTANT BOOLEAN := TRUE;
    -- =========================================================================

    v_uid INT; -- Biến tạm để nhận userId sau mỗi lần INSERT
BEGIN

    -- =========================================================================
    -- 1. TÀI KHOẢN CỐT LÕI (Mặc định luôn tạo)
    -- =========================================================================

    -- 1.1. Admin Lê Thế Bảo
    -- Mật khẩu mặc định: lethebaoonepiece@gmail.com
    IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lethebaoonepiece@gmail.com') THEN
        INSERT INTO "User" (email, passwordHash, status, role, failedLoginAttempts, lockedUntil)
        VALUES ('lethebaoonepiece@gmail.com', '$2a$10$lTPfLnp/F.whSXsLMHaEJ.u.1t5S5zuZsQiZJj8u2Vo7pewVmcLYC', 'active', 'ADMIN', 0, NULL)
        RETURNING userId INTO v_uid;

        INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate)
        VALUES (v_uid, 'Lê Thế Bảo', '0962969970', 'Nam', '2000-01-01', NULL, NULL);

        INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'ALL1');
    END IF;


    -- =========================================================================
    -- 2. TÀI KHOẢN CAO TUẤN (Tùy chọn)
    -- =========================================================================

    -- 2.1. Library Manager Cao Tuấn
    -- Mật khẩu mặc định: caotuan01122005@gmail.com
    IF create_caotuan THEN
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'caotuan01122005@gmail.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role, failedLoginAttempts, lockedUntil)
            VALUES ('caotuan01122005@gmail.com', '$2a$10$C1T/jl2S/N69KiAxLCInLuOz/8x41wu3vwAzVBHCfxtBhCIwTihNO', 'active', 'MANAGER', 0, NULL)
            RETURNING userId INTO v_uid;

            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate)
            VALUES (v_uid, 'Cao Tuấn', '0123456789', 'Nam', '2005-12-01', NULL, NULL);

            INSERT INTO LibraryManager (userId, staffCode) VALUES (v_uid, 'ALL2');
        END IF;
    END IF;


    -- =========================================================================
    -- 3. NHÓM 25 TÀI KHOẢN MẪU TỪ EXCEL (Tùy chọn)
    -- Mật khẩu mặc định của mỗi tài khoản là chính địa chỉ email của họ.
    -- =========================================================================

    IF create_excel_users THEN

        -- 3.1. ADMINS

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin1@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('admin1@lms.com', '$2a$10$hiOu2EHfO1RAe2h8m9XqDO1W/kR/XgyWVQ90DGeu8Sfl/RagqgBMO', 'active', 'ADMIN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Pham The Thanh', '0962969970', 'Nam', '1995-06-11');
            INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'AD001');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin2@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('admin2@lms.com', '$2a$10$9Cq/NiE4106iTR41Ol9NNuB5cqf2et.OI//kISvgloaV8vn0jsonS', 'active', 'ADMIN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Dang Van Anh', '0991955276', 'Nam', '1977-09-25');
            INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'AD002');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin3@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('admin3@lms.com', '$2a$10$KYTs9xu4cAaJNRBSPqio8e9eS5bH1/O2lf4TMiOBZG2gAd4B4p8eO', 'active', 'ADMIN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Nguyen My Huong', '0974241400', 'Nữ', '1978-03-10');
            INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'AD003');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin4@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('admin4@lms.com', '$2a$10$OKvo/EQDCQIsJqPpvVvX5eeifIqYsQYfaQgNIkXzGngRjBlGhUIDa', 'active', 'ADMIN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Vu Quang Phong', '0980917387', 'Nam', '1996-11-21');
            INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'AD004');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin5@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('admin5@lms.com', '$2a$10$Wte0aMunEABfnm6LAMdXKOXqPA7zfT3lN2WaHtbEPYSxdAjPy8Qpe', 'active', 'ADMIN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Phan Hong Nga', '0969835212', 'Nữ', '2003-02-21');
            INSERT INTO Admin (userId, staffCode) VALUES (v_uid, 'AD005');
        END IF;


        -- 3.2. MANAGERS

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager1@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('manager1@lms.com', '$2a$10$UCnIKt3ToXAZgxUBqFbh..fASkyaahmBXbjnrFOo4cY93WNkGfrs6', 'active', 'MANAGER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Do Viet Giang', '0945593975', 'Nam', '1984-08-24');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (v_uid, 'MN001');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager2@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('manager2@lms.com', '$2a$10$I2Ex6jTa8V9NXcNwHi/DSO5fqz3OHrWXzY4VuuM69E0gjm/wm3LFq', 'active', 'MANAGER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Duong Phuong Nga', '0956205558', 'Nữ', '1971-09-15');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (v_uid, 'MN002');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager3@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('manager3@lms.com', '$2a$10$JaLuq258cRukKV.24pcpMuE0/f.il.B2pm.4ftNmTD.27mmSifTYi', 'active', 'MANAGER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Hoang Xuan Long', '0932025897', 'Nam', '1989-09-10');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (v_uid, 'MN003');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager4@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('manager4@lms.com', '$2a$10$amDFog/Pf8TVYugE7jzcwefqwQ.QVCqvehGb/GGz4bdSxF3sY8YhG', 'active', 'MANAGER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Ly Quoc Hai', '0967183775', 'Nam', '1989-11-02');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (v_uid, 'MN004');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager5@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('manager5@lms.com', '$2a$10$/4.MaVvH3ZymcYa5P8JTkOJBa5qjXS0r/mcaIe8M8iWJJoMASMlva', 'active', 'MANAGER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Hoang Phuong Trinh', '0982080986', 'Nữ', '1970-06-22');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (v_uid, 'MN005');
        END IF;


        -- 3.3. LIBRARIANS

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian1@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('librarian1@lms.com', '$2a$10$uRUTHUvqNKlx8YJC52Li8uHl4ucxQGX7lAiAubXgyY1S4yFMTGTkK', 'active', 'LIBRARIAN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Pham Xuan Quan', '0921222652', 'Nam', '1997-11-08');
            INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LB001');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian2@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('librarian2@lms.com', '$2a$10$h5GpPf5aXY3K2kXJFXjtkekqZUVJnz69x0GG6e1WHd3JL7snwl6ZK', 'active', 'LIBRARIAN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Vo The Son', '0956226238', 'Nam', '1982-01-05');
            INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LB002');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian3@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('librarian3@lms.com', '$2a$10$M.mjDd8dHUxSvQm4nlQXDuetopFxZr6rieu59SHBgzQSz3rWht0Si', 'active', 'LIBRARIAN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Le Viet Hieu', '0968001373', 'Nam', '1987-02-28');
            INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LB003');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian4@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('librarian4@lms.com', '$2a$10$7iGZPGit3KEzMdzC..ujP.YzvrtjyZfWAON.AbGqlyp0t482wmhmm', 'active', 'LIBRARIAN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Dang Thanh Nhung', '0906716447', 'Nữ', '1986-11-24');
            INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LB004');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian5@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('librarian5@lms.com', '$2a$10$etrKnMUbuxbeVNBZF39QVuxm3KA5U8VflwR2LQHNIXR84XLJzR7x2', 'active', 'LIBRARIAN')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Nguyen Xuan Thai', '0987772600', 'Nam', '1996-03-18');
            INSERT INTO Librarian (userId, staffCode) VALUES (v_uid, 'LB005');
        END IF;


        -- 3.4. LECTURERS

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer1@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('lecturer1@lms.com', '$2a$10$AVfGAutJO858xISgD54usee4yHwv/CGMNBimW/OwmDheMaekMGKOe', 'active', 'LECTURER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Ly Viet Tung', '0967896410', 'Nam', '1976-08-01');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LEC001', 'Social Sciences');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer2@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('lecturer2@lms.com', '$2a$10$LsUQpT4w4dI5h8cMa.Rmde/UTL0I3EJTje5N4Ry66d.1HvfqiOQqi', 'active', 'LECTURER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Phan Duc Thanh', '0918758619', 'Nam', '1992-12-26');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LEC002', 'Social Sciences');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer3@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('lecturer3@lms.com', '$2a$10$BMzmtz1iJVG.wfGyW3iHXec3NtShIAT1aidEX3M658lc.tZC05SPO', 'active', 'LECTURER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Do Hong Vy', '0978955047', 'Nữ', '1984-07-11');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LEC003', 'Foreign Languages');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer4@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('lecturer4@lms.com', '$2a$10$eFL1oiqrVfkgloAWA7I7LOQ3qegqUccLDizeXX03fFUbHLUBW.9nK', 'active', 'LECTURER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Bui Dinh Anh', '0932741866', 'Nam', '1992-06-03');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LEC004', 'Social Sciences');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer5@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('lecturer5@lms.com', '$2a$10$t/ptEI00olP94m4anbd1gOyMXPtzecNzhCMj56fAV8Pk37IFCMFSy', 'active', 'LECTURER')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Ly Khanh Trinh', '0927653955', 'Nữ', '1993-10-01');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (v_uid, 'LEC005', 'Economic Sciences');
        END IF;


        -- 3.5. STUDENTS

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student1@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('student1@lms.com', '$2a$10$ZQNNOZIfmfOOmY80jqVyDe7OJBlIpTtQi2nEUtZ3uejMLU9Y9P1q.', 'active', 'STUDENT')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Tran Duy Hoang', '0970706186', 'Nam', '2004-05-22');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180001', 'Business Administration', 2021);
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student2@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('student2@lms.com', '$2a$10$OMrWkxLWzqAOhA9ynJD8i.hJSWGL1F5hQvqI23FCVNKDLWwA6AIMq', 'active', 'STUDENT')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Pham Kim Vy', '0904475712', 'Nữ', '2004-01-05');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180002', 'Hospitality Management', 2021);
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student3@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('student3@lms.com', '$2a$10$1ivPosHJ11lmmW6AC9q/zuIBBxKGjpdnUNaalQp6CzOTSO42qNi2S', 'active', 'STUDENT')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Pham Khanh Yen', '0994383732', 'Nữ', '2001-05-22');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180003', 'Computer Science', 2022);
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student4@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('student4@lms.com', '$2a$10$.tHr9MB6UrQelUjn5A2/fu3dw3SwXvvHYNwCwBpwrpchBlEWwuIWa', 'active', 'STUDENT')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Vu Thu Thao', '0925797218', 'Nữ', '2003-04-13');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180004', 'Hospitality Management', 2024);
        END IF;

        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student5@lms.com') THEN
            INSERT INTO "User" (email, passwordHash, status, role)
            VALUES ('student5@lms.com', '$2a$10$fhU/Xs0K332v1mNfJESoWuKR9vxH842/2jPE180WTlV8o/JS6PSvi', 'active', 'STUDENT')
            RETURNING userId INTO v_uid;
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (v_uid, 'Do Hong Trinh', '0909849795', 'Nữ', '2000-02-06');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (v_uid, 'HE180005', 'Graphic Design', 2022);
        END IF;

    END IF;

END $$;
