-- ==========================================================================
-- LMS SEED DATA SEGMENT: Syncing DB Sequences
-- ==========================================================================

-- ============================================================
-- UPDATE SEQUENCE GENERATORS AFTER EXPLICIT ID INSERTION
-- ============================================================
SELECT setval(pg_get_serial_sequence('"User"', 'userid'), COALESCE(MAX(userId), 1)) FROM "User";
SELECT setval(pg_get_serial_sequence('Category', 'categoryid'), COALESCE(MAX(categoryId), 1)) FROM Category;
SELECT setval(pg_get_serial_sequence('Tag', 'tagid'), COALESCE(MAX(tagId), 1)) FROM Tag;
SELECT setval(pg_get_serial_sequence('DocumentTemp', 'tempid'), COALESCE(MAX(tempId), 1)) FROM DocumentTemp;
