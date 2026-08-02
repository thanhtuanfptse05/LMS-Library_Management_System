BEGIN;

-- Chặn hai thể loại chỉ khác khoảng trắng đầu/cuối hoặc chữ hoa/thường.
-- Migration cố ý dừng nếu dữ liệu cũ đang trùng để tránh tự ý gộp/xóa thể loại.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Category
        GROUP BY LOWER(BTRIM(name))
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION
            'Không thể tạo UX_Category_Name_Normalized: Category đang có tên trùng sau chuẩn hóa.';
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS UX_Category_Name_Normalized
    ON Category (LOWER(BTRIM(name)));

COMMIT;
