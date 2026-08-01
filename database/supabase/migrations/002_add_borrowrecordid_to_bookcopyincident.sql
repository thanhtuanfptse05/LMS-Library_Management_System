-- Migration: Bổ sung cột borrowRecordId cho bảng BookCopyIncident (Tách nghiệp vụ Check-in Hỏng/Mất)
ALTER TABLE BookCopyIncident
    ADD COLUMN IF NOT EXISTS borrowRecordId INT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_bookcopyincident_borrowrecord'
    ) THEN
        ALTER TABLE BookCopyIncident
            ADD CONSTRAINT FK_BookCopyIncident_BorrowRecord
            FOREIGN KEY (borrowRecordId) REFERENCES BorrowRecord(borrowRecordId);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS IX_BookCopyIncident_BorrowRecord
    ON BookCopyIncident(borrowRecordId) WHERE borrowRecordId IS NOT NULL;
