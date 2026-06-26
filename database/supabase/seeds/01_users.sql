-- ==========================================================================
-- LMS SEED DATA SEGMENT: Core & Demo Accounts (PostgreSQL Configurable Block)
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
BEGIN

    -- =========================================================================
    -- 1. TÀI KHOẢN CỐT LÕI (Mặc định luôn tạo)
    -- =========================================================================
    
    -- 1.1. Admin Lê Thế Bảo (userId = 1)
    -- Mật khẩu mặc định: lethebaoonepiece@gmail.com
    IF NOT EXISTS (SELECT 1 FROM "User" WHERE userId = 1) THEN
        INSERT INTO "User" (userId, email, passwordHash, status, role, failedLoginAttempts, lockedUntil) 
        VALUES (1, 'lethebaoonepiece@gmail.com', '$2a$10$lTPfLnp/F.whSXsLMHaEJ.u.1t5S5zuZsQiZJj8u2Vo7pewVmcLYC', 'active', 'ADMIN', 0, NULL);
        
        INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) 
        VALUES (1, 'Lê Thế Bảo', '0962969970', 'Nam', '2000-01-01', NULL, NULL);
        
        INSERT INTO Admin (userId, staffCode) VALUES (1, 'ALL1');
    END IF;


    -- =========================================================================
    -- 2. TÀI KHOẢN CAO TUẤN (Tùy chọn)
    -- =========================================================================
    
    -- 2.1. Library Manager Cao Tuấn (userId = 2)
    -- Mật khẩu mặc định: caotuan01122005@gmail.com
    IF create_caotuan THEN
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE userId = 2) THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role, failedLoginAttempts, lockedUntil) 
            VALUES (2, 'caotuan01122005@gmail.com', '$2a$10$C1T/jl2S/N69KiAxLCInLuOz/8x41wu3vwAzVBHCfxtBhCIwTihNO', 'active', 'MANAGER', 0, NULL);
            
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) 
            VALUES (2, 'Cao Tuấn', '0123456789', 'Nam', '2005-12-01', NULL, NULL);
            
            INSERT INTO LibraryManager (userId, staffCode) VALUES (2, 'ALL2');
        END IF;
    END IF;


    -- =========================================================================
    -- 3. NHÓM 25 TÀI KHOẢN MẪU TỪ EXCEL (Tùy chọn)
    -- Mật khẩu mặc định của mỗi tài khoản là chính địa chỉ email của họ.
    -- =========================================================================
    
    IF create_excel_users THEN
    
        -- 3.1. ADMINS (IDs: 11 - 15)
        
        -- Admin 1
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin1@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (11, 'admin1@lms.com', '$2a$10$hiOu2EHfO1RAe2h8m9XqDO1W/kR/XgyWVQ90DGeu8Sfl/RagqgBMO', 'active', 'ADMIN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (11, 'Pham The Thanh', '0962969970', 'Nam', '1995-06-11');
            INSERT INTO Admin (userId, staffCode) VALUES (11, 'AD001');
        END IF;

        -- Admin 2
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin2@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (12, 'admin2@lms.com', '$2a$10$9Cq/NiE4106iTR41Ol9NNuB5cqf2et.OI//kISvgloaV8vn0jsonS', 'active', 'ADMIN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (12, 'Dang Van Anh', '0991955276', 'Nam', '1977-09-25');
            INSERT INTO Admin (userId, staffCode) VALUES (12, 'AD002');
        END IF;

        -- Admin 3
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin3@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (13, 'admin3@lms.com', '$2a$10$KYTs9xu4cAaJNRBSPqio8e9eS5bH1/O2lf4TMiOBZG2gAd4B4p8eO', 'active', 'ADMIN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (13, 'Nguyen My Huong', '0974241400', 'Nữ', '1978-03-10');
            INSERT INTO Admin (userId, staffCode) VALUES (13, 'AD003');
        END IF;

        -- Admin 4
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin4@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (14, 'admin4@lms.com', '$2a$10$OKvo/EQDCQIsJqPpvVvX5eeifIqYsQYfaQgNIkXzGngRjBlGhUIDa', 'active', 'ADMIN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (14, 'Vu Quang Phong', '0980917387', 'Nam', '1996-11-21');
            INSERT INTO Admin (userId, staffCode) VALUES (14, 'AD004');
        END IF;

        -- Admin 5
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'admin5@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (15, 'admin5@lms.com', '$2a$10$Wte0aMunEABfnm6LAMdXKOXqPA7zfT3lN2WaHtbEPYSxdAjPy8Qpe', 'active', 'ADMIN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (15, 'Phan Hong Nga', '0969835212', 'Nữ', '2003-02-21');
            INSERT INTO Admin (userId, staffCode) VALUES (15, 'AD005');
        END IF;


        -- 3.2. MANAGERS (IDs: 21 - 25)
        
        -- Manager 1
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager1@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (21, 'manager1@lms.com', '$2a$10$UCnIKt3ToXAZgxUBqFbh..fASkyaahmBXbjnrFOo4cY93WNkGfrs6', 'active', 'MANAGER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (21, 'Do Viet Giang', '0945593975', 'Nam', '1984-08-24');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (21, 'MN001');
        END IF;

        -- Manager 2
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager2@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (22, 'manager2@lms.com', '$2a$10$I2Ex6jTa8V9NXcNwHi/DSO5fqz3OHrWXzY4VuuM69E0gjm/wm3LFq', 'active', 'MANAGER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (22, 'Duong Phuong Nga', '0956205558', 'Nữ', '1971-09-15');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (22, 'MN002');
        END IF;

        -- Manager 3
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager3@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (23, 'manager3@lms.com', '$2a$10$JaLuq258cRukKV.24pcpMuE0/f.il.B2pm.4ftNmTD.27mmSifTYi', 'active', 'MANAGER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (23, 'Hoang Xuan Long', '0932025897', 'Nam', '1989-09-10');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (23, 'MN003');
        END IF;

        -- Manager 4
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager4@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (24, 'manager4@lms.com', '$2a$10$amDFog/Pf8TVYugE7jzcwefqwQ.QVCqvehGb/GGz4bdSxF3sY8YhG', 'active', 'MANAGER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (24, 'Ly Quoc Hai', '0967183775', 'Nam', '1989-11-02');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (24, 'MN004');
        END IF;

        -- Manager 5
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'manager5@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (25, 'manager5@lms.com', '$2a$10$/4.MaVvH3ZymcYa5P8JTkOJBa5qjXS0r/mcaIe8M8iWJJoMASMlva', 'active', 'MANAGER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (25, 'Hoang Phuong Trinh', '0982080986', 'Nữ', '1970-06-22');
            INSERT INTO LibraryManager (userId, staffCode) VALUES (25, 'MN005');
        END IF;


        -- 3.3. LIBRARIANS (IDs: 31 - 35)
        
        -- Librarian 1
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian1@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (31, 'librarian1@lms.com', '$2a$10$uRUTHUvqNKlx8YJC52Li8uHl4ucxQGX7lAiAubXgyY1S4yFMTGTkK', 'active', 'LIBRARIAN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (31, 'Pham Xuan Quan', '0921222652', 'Nam', '1997-11-08');
            INSERT INTO Librarian (userId, staffCode) VALUES (31, 'LB001');
        END IF;

        -- Librarian 2
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian2@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (32, 'librarian2@lms.com', '$2a$10$h5GpPf5aXY3K2kXJFXjtkekqZUVJnz69x0GG6e1WHd3JL7snwl6ZK', 'active', 'LIBRARIAN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (32, 'Vo The Son', '0956226238', 'Nam', '1982-01-05');
            INSERT INTO Librarian (userId, staffCode) VALUES (32, 'LB002');
        END IF;

        -- Librarian 3
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian3@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (33, 'librarian3@lms.com', '$2a$10$M.mjDd8dHUxSvQm4nlQXDuetopFxZr6rieu59SHBgzQSz3rWht0Si', 'active', 'LIBRARIAN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (33, 'Le Viet Hieu', '0968001373', 'Nam', '1987-02-28');
            INSERT INTO Librarian (userId, staffCode) VALUES (33, 'LB003');
        END IF;

        -- Librarian 4
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian4@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (34, 'librarian4@lms.com', '$2a$10$7iGZPGit3KEzMdzC..ujP.YzvrtjyZfWAON.AbGqlyp0t482wmhmm', 'active', 'LIBRARIAN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (34, 'Dang Thanh Nhung', '0906716447', 'Nữ', '1986-11-24');
            INSERT INTO Librarian (userId, staffCode) VALUES (34, 'LB004');
        END IF;

        -- Librarian 5
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'librarian5@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (35, 'librarian5@lms.com', '$2a$10$etrKnMUbuxbeVNBZF39QVuxm3KA5U8VflwR2LQHNIXR84XLJzR7x2', 'active', 'LIBRARIAN');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (35, 'Nguyen Xuan Thai', '0987772600', 'Nam', '1996-03-18');
            INSERT INTO Librarian (userId, staffCode) VALUES (35, 'LB005');
        END IF;


        -- 3.4. LECTURERS (IDs: 41 - 45)
        
        -- Lecturer 1
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer1@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (41, 'lecturer1@lms.com', '$2a$10$AVfGAutJO858xISgD54usee4yHwv/CGMNBimW/OwmDheMaekMGKOe', 'active', 'LECTURER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (41, 'Ly Viet Tung', '0967896410', 'Nam', '1976-08-01');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (41, 'LEC001', 'Social Sciences');
        END IF;

        -- Lecturer 2
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer2@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (42, 'lecturer2@lms.com', '$2a$10$LsUQpT4w4dI5h8cMa.Rmde/UTL0I3EJTje5N4Ry66d.1HvfqiOQqi', 'active', 'LECTURER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (42, 'Phan Duc Thanh', '0918758619', 'Nam', '1992-12-26');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (42, 'LEC002', 'Social Sciences');
        END IF;

        -- Lecturer 3
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer3@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (43, 'lecturer3@lms.com', '$2a$10$BMzmtz1iJVG.wfGyW3iHXec3NtShIAT1aidEX3M658lc.tZC05SPO', 'active', 'LECTURER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (43, 'Do Hong Vy', '0978955047', 'Nữ', '1984-07-11');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (43, 'LEC003', 'Foreign Languages');
        END IF;

        -- Lecturer 4
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer4@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (44, 'lecturer4@lms.com', '$2a$10$eFL1oiqrVfkgloAWA7I7LOQ3qegqUccLDizeXX03fFUbHLUBW.9nK', 'active', 'LECTURER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (44, 'Bui Dinh Anh', '0932741866', 'Nam', '1992-06-03');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (44, 'LEC004', 'Social Sciences');
        END IF;

        -- Lecturer 5
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'lecturer5@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (45, 'lecturer5@lms.com', '$2a$10$t/ptEI00olP94m4anbd1gOyMXPtzecNzhCMj56fAV8Pk37IFCMFSy', 'active', 'LECTURER');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (45, 'Ly Khanh Trinh', '0927653955', 'Nữ', '1993-10-01');
            INSERT INTO Lecturer (userId, lecturerCode, department) VALUES (45, 'LEC005', 'Economic Sciences');
        END IF;


        -- 3.5. STUDENTS (IDs: 51 - 55)
        
        -- Student 1
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student1@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (51, 'student1@lms.com', '$2a$10$ZQNNOZIfmfOOmY80jqVyDe7OJBlIpTtQi2nEUtZ3uejMLU9Y9P1q.', 'active', 'STUDENT');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (51, 'Tran Duy Hoang', '0970706186', 'Nam', '2004-05-22');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (51, 'HE180001', 'Business Administration', 2021);
        END IF;

        -- Student 2
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student2@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (52, 'student2@lms.com', '$2a$10$OMrWkxLWzqAOhA9ynJD8i.hJSWGL1F5hQvqI23FCVNKDLWwA6AIMq', 'active', 'STUDENT');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (52, 'Pham Kim Vy', '0904475712', 'Nữ', '2004-01-05');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (52, 'HE180002', 'Hospitality Management', 2021);
        END IF;

        -- Student 3
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student3@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (53, 'student3@lms.com', '$2a$10$1ivPosHJ11lmmW6AC9q/zuIBBxKGjpdnUNaalQp6CzOTSO42qNi2S', 'active', 'STUDENT');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (53, 'Pham Khanh Yen', '0994383732', 'Nữ', '2001-05-22');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (53, 'HE180003', 'Computer Science', 2022);
        END IF;

        -- Student 4
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student4@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (54, 'student4@lms.com', '$2a$10$.tHr9MB6UrQelUjn5A2/fu3dw3SwXvvHYNwCwBpwrpchBlEWwuIWa', 'active', 'STUDENT');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (54, 'Vu Thu Thao', '0925797218', 'Nữ', '2003-04-13');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (54, 'HE180004', 'Hospitality Management', 2024);
        END IF;

        -- Student 5
        IF NOT EXISTS (SELECT 1 FROM "User" WHERE email = 'student5@lms.com') THEN
            INSERT INTO "User" (userId, email, passwordHash, status, role)
            VALUES (55, 'student5@lms.com', '$2a$10$fhU/Xs0K332v1mNfJESoWuKR9vxH842/2jPE180WTlV8o/JS6PSvi', 'active', 'STUDENT');
            INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth)
            VALUES (55, 'Do Hong Trinh', '0909849795', 'Nữ', '2000-02-06');
            INSERT INTO Student (userId, studentCode, major, enrollmentYear) VALUES (55, 'HE180005', 'Graphic Design', 2022);
        END IF;

    END IF;

END $$;
