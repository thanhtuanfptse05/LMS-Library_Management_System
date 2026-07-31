-- ============================================================
-- MIGRATION: Gộp role MANAGER vào ADMIN
-- Chạy script này trên DB production TRƯỚC KHI deploy code mới
-- ============================================================

-- 1. Chuyển dữ liệu LibraryManager sang Admin (cho user chưa có trong Admin)
INSERT INTO Admin (userId, staffCode)
SELECT lm.userId, lm.staffCode FROM LibraryManager lm
WHERE NOT EXISTS (SELECT 1 FROM Admin a WHERE a.userId = lm.userId);

-- 2. Cập nhật role từ MANAGER → ADMIN
UPDATE "User" SET role = 'ADMIN' WHERE role = 'MANAGER';

-- 3. Sửa FK DocumentTemp: đổi từ LibraryManager sang "User"
ALTER TABLE DocumentTemp DROP CONSTRAINT IF EXISTS FK_DocumentTemp_Manager;
ALTER TABLE DocumentTemp ADD CONSTRAINT FK_DocumentTemp_User
    FOREIGN KEY (managerId) REFERENCES "User"(userId);

-- 4. DROP bảng LibraryManager (không còn sử dụng)
DROP TABLE IF EXISTS LibraryManager CASCADE;

-- Kiểm tra: không còn user nào với role MANAGER
-- SELECT * FROM "User" WHERE role = 'MANAGER';
-- Kỳ vọng: 0 rows
