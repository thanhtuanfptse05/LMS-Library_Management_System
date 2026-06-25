-- ==========================================================================
-- LMS SEED DATA SEGMENT: Core System Accounts (1 Admin, 1 Library Manager)
-- ==========================================================================

-- 1. Users
-- Passwords are BCrypt hashes of their respective emails
-- Admin (userId = 1)
INSERT INTO "User" (userId, email, passwordHash, status, role, failedLoginAttempts, lockedUntil) 
VALUES (1, 'lethebaoonepiece@gmail.com', '$2a$10$lTPfLnp/F.whSXsLMHaEJ.u.1t5S5zuZsQiZJj8u2Vo7pewVmcLYC', 'active', 'ADMIN', 0, NULL);

-- Library Manager (userId = 2)
INSERT INTO "User" (userId, email, passwordHash, status, role, failedLoginAttempts, lockedUntil) 
VALUES (2, 'caotuan01122005@gmail.com', '$2a$10$C1T/jl2S/N69KiAxLCInLuOz/8x41wu3vwAzVBHCfxtBhCIwTihNO', 'active', 'MANAGER', 0, NULL);


-- 2. Member Profiles
INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) 
VALUES (1, 'Lê Thế Bảo', '0962969970', 'Nam', '2000-01-01', NULL, NULL);

INSERT INTO MemberProfile (userId, fullName, phoneNumber, gender, dateOfBirth, startDate, endDate) 
VALUES (2, 'Cao Tuấn', '0123456789', 'Nam', '2005-12-01', NULL, NULL);


-- 3. Role Specific Tables
INSERT INTO Admin (userId, staffCode) VALUES (1, 'ALL1');
INSERT INTO LibraryManager (userId, staffCode) VALUES (2, 'ALL2');
