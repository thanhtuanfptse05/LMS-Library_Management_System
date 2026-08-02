BEGIN;

-- Cho phép ghi nhận rõ bản sao đã rời phạm vi trong lúc kiểm kê thay vì gắn nhãn thiếu giả.
ALTER TABLE InventoryItem DROP CONSTRAINT IF EXISTS CK_InventoryItem_Result;
ALTER TABLE InventoryItem
    ADD CONSTRAINT CK_InventoryItem_Result
    CHECK (result IN ('pending', 'matched', 'missing', 'misplaced', 'excluded'));

-- Tách đúng thời điểm tạo, bắt đầu, hoàn thành và hủy phiên.
ALTER TABLE InventorySession ADD COLUMN IF NOT EXISTS createdBy INT;
ALTER TABLE InventorySession ADD COLUMN IF NOT EXISTS createdAt TIMESTAMP;
ALTER TABLE InventorySession ADD COLUMN IF NOT EXISTS cancelledBy INT;
ALTER TABLE InventorySession ADD COLUMN IF NOT EXISTS cancelledAt TIMESTAMP;

UPDATE InventorySession
SET createdBy = COALESCE(createdBy, startedBy),
    createdAt = COALESCE(createdAt, startedAt, NOW());

UPDATE InventorySession
SET cancelledBy = COALESCE(cancelledBy, completedBy),
    cancelledAt = COALESCE(cancelledAt, completedAt),
    completedBy = NULL,
    completedAt = NULL
WHERE status = 'cancelled';

ALTER TABLE InventorySession ALTER COLUMN createdBy SET NOT NULL;
ALTER TABLE InventorySession ALTER COLUMN createdAt SET NOT NULL;
ALTER TABLE InventorySession ALTER COLUMN createdAt SET DEFAULT NOW();
ALTER TABLE InventorySession ALTER COLUMN startedBy DROP NOT NULL;
ALTER TABLE InventorySession ALTER COLUMN startedAt DROP NOT NULL;
ALTER TABLE InventorySession ALTER COLUMN startedAt DROP DEFAULT;

-- Bản nháp của phiên bản cũ đã chứa snapshot tạo quá sớm. Soft-cancel để giữ lịch sử
-- và yêu cầu tạo draft mới theo logic snapshot-at-start, tránh xóa InventoryItem.
UPDATE InventorySession
SET status = 'cancelled',
    cancelledAt = COALESCE(cancelledAt, NOW()),
    startedBy = NULL,
    startedAt = NULL,
    note = LEFT(CONCAT_WS(E'\n', note,
        'Tự động hủy khi nâng cấp: snapshot cũ được tạo trước thời điểm bắt đầu.'), 1000)
WHERE status = 'draft'
  AND EXISTS (
      SELECT 1 FROM InventoryItem i
      WHERE i.inventorySessionId = InventorySession.inventorySessionId
  );

UPDATE InventorySession
SET startedBy = NULL, startedAt = NULL
WHERE status = 'draft';

ALTER TABLE InventorySession DROP CONSTRAINT IF EXISTS FK_InventorySession_CreatedBy;
ALTER TABLE InventorySession ADD CONSTRAINT FK_InventorySession_CreatedBy
    FOREIGN KEY (createdBy) REFERENCES "User"(userId);
ALTER TABLE InventorySession DROP CONSTRAINT IF EXISTS FK_InventorySession_CancelledBy;
ALTER TABLE InventorySession ADD CONSTRAINT FK_InventorySession_CancelledBy
    FOREIGN KEY (cancelledBy) REFERENCES "User"(userId);

-- Cho phép nhiều bản nháp, nhưng chỉ một phiên counting/reviewing trên toàn hệ thống.
DROP INDEX IF EXISTS UX_InventorySession_Active_Location;
CREATE UNIQUE INDEX IF NOT EXISTS UX_InventorySession_Running
    ON InventorySession ((1))
    WHERE status IN ('counting', 'reviewing');

COMMIT;
