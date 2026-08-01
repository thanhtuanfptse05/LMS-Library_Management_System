-- ============================================================
-- MIGRATION: Fix UserLockReason.reason column length
-- Issue: VARCHAR(50) quá ngắn cho chuỗi lý do chế tài đặt trước quá hạn
-- Chạy lệnh này 1 lần trên Supabase SQL Editor
-- ============================================================

ALTER TABLE UserLockReason
    ALTER COLUMN reason TYPE VARCHAR(500);

-- Xác nhận sau khi chạy:
-- SELECT column_name, character_maximum_length
-- FROM information_schema.columns
-- WHERE table_name = 'UserLockReason' AND column_name = 'reason';
-- Kỳ vọng: 500
