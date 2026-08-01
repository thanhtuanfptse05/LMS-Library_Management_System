BEGIN;

-- Reservation chỉ giữ suất của đầu sách; trạng thái reserved cũ không còn được sử dụng.
UPDATE BookCopy
SET status = CASE
        WHEN condition = 'good' AND removedFromInventory = FALSE THEN 'available'
        ELSE 'unavailable'
    END,
    updatedAt = NOW()
WHERE status = 'reserved';

ALTER TABLE BookCopy DROP CONSTRAINT IF EXISTS CK_BookCopy_Status;
ALTER TABLE BookCopy
    ADD CONSTRAINT CK_BookCopy_Status
    CHECK (status IN ('available', 'unavailable', 'borrowed'));

UPDATE Reservation
SET bookCopyId = NULL
WHERE status IN ('pending', 'readypickup', 'cancelled');

UPDATE Reservation
SET queuePosition = NULL
WHERE status IN ('fulfilled', 'cancelled');

UPDATE Reservation
SET queuePosition = 0,
    endDate = COALESCE(endDate, NOW() + INTERVAL '3 days')
WHERE status = 'readypickup';

WITH ranked AS (
    SELECT reservationId,
           ROW_NUMBER() OVER (PARTITION BY bookId ORDER BY startDate, reservationId) AS position
    FROM Reservation
    WHERE status = 'pending'
)
UPDATE Reservation r
SET queuePosition = ranked.position,
    endDate = NULL
FROM ranked
WHERE r.reservationId = ranked.reservationId;

-- Đồng bộ số suất có thể cấp = bản vật lý khả dụng - suất readypickup đã giữ.
UPDATE Book b
SET availableQuantity = CASE
        WHEN b.status = 'unavailable' THEN 0
        ELSE GREATEST(
            0,
            (SELECT COUNT(*) FROM BookCopy bc
             WHERE bc.bookId = b.bookId
               AND bc.status = 'available'
               AND bc.condition = 'good'
               AND bc.removedFromInventory = FALSE)
            -
            (SELECT COUNT(*) FROM Reservation r
             WHERE r.bookId = b.bookId
               AND r.status = 'readypickup')
        )
    END,
    updatedAt = NOW();

ALTER TABLE Reservation DROP CONSTRAINT IF EXISTS CK_Reservation_Status;
ALTER TABLE Reservation DROP CONSTRAINT IF EXISTS CK_Reservation_Allocation;

ALTER TABLE Reservation
    ADD CONSTRAINT CK_Reservation_Status
    CHECK (status IN ('pending', 'readypickup', 'fulfilled', 'cancelled'));

ALTER TABLE Reservation
    ADD CONSTRAINT CK_Reservation_Allocation
    CHECK (
        (status = 'pending' AND queuePosition IS NOT NULL AND queuePosition >= 1 AND bookCopyId IS NULL AND endDate IS NULL)
        OR (status = 'readypickup' AND queuePosition IS NOT NULL AND queuePosition = 0 AND bookCopyId IS NULL AND endDate IS NOT NULL)
        OR (status = 'fulfilled' AND queuePosition IS NULL AND bookCopyId IS NOT NULL)
        OR (status = 'cancelled' AND queuePosition IS NULL AND bookCopyId IS NULL)
    );

COMMIT;
