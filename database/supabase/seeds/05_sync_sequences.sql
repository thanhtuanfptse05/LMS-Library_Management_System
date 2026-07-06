-- ==========================================================================
-- LMS SEED DATA SEGMENT: Syncing DB Sequences
-- ==========================================================================
-- Lưu ý: Bảng "User" không cần sync sequence vì seed data
--        đã dùng RETURNING thay vì hardcode userId.
-- ==========================================================================

SELECT setval(pg_get_serial_sequence('Category', 'categoryid'), COALESCE(MAX(categoryId), 1)) FROM Category;
SELECT setval(pg_get_serial_sequence('Tag', 'tagid'), COALESCE(MAX(tagId), 1)) FROM Tag;
SELECT setval(pg_get_serial_sequence('EmailTemplate', 'templateid'), COALESCE(MAX(templateId), 1)) FROM EmailTemplate;
