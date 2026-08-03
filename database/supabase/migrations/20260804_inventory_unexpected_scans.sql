BEGIN;

-- Cho phép ghi nhận mọi bản sao thực tế tìm thấy trên kệ mà không đưa chúng
-- vào danh sách dự kiến good + available của phiên kiểm kê.
ALTER TABLE InventoryItem ADD COLUMN IF NOT EXISTS anomalyType VARCHAR(40) NULL;
ALTER TABLE InventoryItem ADD COLUMN IF NOT EXISTS expectedInSession BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE InventoryItem ALTER COLUMN expectedLocation DROP NOT NULL;

-- Dữ liệu lịch sử chưa có cờ snapshot: các mục có vị trí dự kiến trùng vị trí
-- phiên là thành viên của snapshot, còn bản sao quét từ kệ khác thì không.
UPDATE InventoryItem i
SET expectedInSession = TRUE
FROM InventorySession s
WHERE s.inventorySessionId = i.inventorySessionId
  AND i.result <> 'unexpected'
  AND LOWER(BTRIM(i.expectedLocation)) = LOWER(BTRIM(s.location));

ALTER TABLE InventoryItem DROP CONSTRAINT IF EXISTS CK_InventoryItem_Result;
ALTER TABLE InventoryItem
    ADD CONSTRAINT CK_InventoryItem_Result
    CHECK (result IN ('pending', 'matched', 'missing', 'misplaced', 'unexpected', 'excluded'));

ALTER TABLE InventoryItem DROP CONSTRAINT IF EXISTS CK_InventoryItem_Anomaly;
ALTER TABLE InventoryItem
    ADD CONSTRAINT CK_InventoryItem_Anomaly
    CHECK (
        (result = 'unexpected' AND anomalyType IN (
            'damaged_on_shelf',
            'borrowed_on_shelf',
            'found_lost',
            'removed_copy_found',
            'unavailable_on_shelf'
        ))
        OR (result <> 'unexpected' AND anomalyType IS NULL)
    );

COMMIT;
