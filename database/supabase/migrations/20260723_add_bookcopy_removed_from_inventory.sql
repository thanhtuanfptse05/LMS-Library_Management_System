ALTER TABLE BookCopy
    ADD COLUMN IF NOT EXISTS removedFromInventory BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS removedFromInventoryAt TIMESTAMP NULL,
    ADD COLUMN IF NOT EXISTS removedFromInventoryBy INT NULL;

ALTER TABLE BookCopy
    DROP CONSTRAINT IF EXISTS CK_BookCopy_RemovedInventory;

ALTER TABLE BookCopy
    ADD CONSTRAINT CK_BookCopy_RemovedInventory CHECK (
        removedFromInventory = FALSE
        OR (status = 'unavailable' AND condition IN ('damaged', 'lost') AND removedFromInventoryAt IS NOT NULL)
    );

ALTER TABLE BookCopy
    DROP CONSTRAINT IF EXISTS FK_BookCopy_RemovedBy;

ALTER TABLE BookCopy
    ADD CONSTRAINT FK_BookCopy_RemovedBy
    FOREIGN KEY (removedFromInventoryBy) REFERENCES "User"(userId);
