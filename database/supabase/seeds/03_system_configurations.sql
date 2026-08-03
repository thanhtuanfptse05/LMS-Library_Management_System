-- ==========================================================================
-- LMS SEED DATA SEGMENT: System Configurations
-- ==========================================================================
-- Lưu ý: Không hardcode updatedBy = 1. Tìm userId của Admin động từ email.
-- ==========================================================================

DO $$
DECLARE
    v_admin_id INT;
BEGIN
    -- Lấy userId của Admin mặc định (adminB1@lms.com) để gán làm người cập nhật cấu hình
    SELECT userId INTO v_admin_id FROM "User" WHERE email = 'adminB1@lms.com';

    INSERT INTO SystemConfigurations (configKey, configValue, description, configGroup, updatedBy, updatedAt) VALUES
    ('DAMAGED_FINE_MULTIPLIER', '2.0', 'Hệ số nhân giá sách để tính phạt đền bù khi sách bị hỏng', 'library', v_admin_id, '2026-06-21 13:25:48.79781'),
    ('DEFAULT_BOOK_PRICE', '500000', 'Giá mặc định của sách khi không có giá gốc (VND)', 'library', v_admin_id, '2026-06-21 09:50:33.217688'),
    ('EMAIL_FROM_NAME', 'Thư viện LMS', 'Tên hiển thị người gửi email', 'system', v_admin_id, '2026-07-31 17:20:44.897'),
    ('EMAIL_MAX_RETRIES', '3', 'Số lần thử lại tối đa khi gửi email lỗi', 'system', v_admin_id, '2026-07-31 17:20:44.897'),
    ('EMAIL_OTP_EXPIRE_MINUTES', '10', 'Thời gian hết hạn OTP qua email (phút)', 'system', v_admin_id, '2026-06-21 09:50:33.381931'),
    ('EMAIL_OVERDUE_NOTICE_DAYS', '1', 'Số ngày trước khi quá hạn để gửi email nhắc', 'system', v_admin_id, '2026-06-21 09:50:33.381931'),
    ('EMAIL_QUEUE_CAPACITY', '500', 'Sức chứa tối đa của hàng đợi EmailJob', 'system', v_admin_id, '2026-07-31 17:20:44.897'),
    ('EMAIL_RETRY_DELAY_SECONDS', '30', 'Độ trễ chờ thử lại gửi thư (giây)', 'system', v_admin_id, '2026-07-31 17:20:44.897'),
    ('FINE_RATE_PER_DAY', '5000', 'Mức phạt mỗi ngày trả sách trễ hạn (VND)', 'library', v_admin_id, '2026-06-24 07:41:44.113446'),
    ('GEMINI_CHATBOT_API_KEY', 'YOUR_GEMINI_API_KEY', 'Google Gemini chatbot API Key', 'API', v_admin_id, '2026-06-24 06:29:55.093164'),
    ('GEMINI_RECOMMEN_API_KEY', 'YOUR_GEMINI_API_KEY', 'Google Gemini gợi ý sách API Key', 'API', NULL, '2026-06-21 10:27:29.340852'),
    ('IMPORT_EXPIRE_DAYS', '365', 'Số ngày lưu lịch sử import', 'system', v_admin_id, '2026-06-21 09:50:33.381931'),
    ('LECTURER_MAX_BORROW_DAYS', '10', 'Số ngày mượn tối đa cho giảng viên', 'library', v_admin_id, '2026-08-01 16:23:24.809'),
    ('LECTURER_MAX_BORROW_LIMIT', '5', 'Giới hạn tổng số sách được mượn và đặt trước cùng lúc của Giảng viên', 'library', v_admin_id, '2026-08-01 16:22:02.711'),
    ('LOST_FINE_MULTIPLIER', '2.0', 'Hệ số nhân giá sách để tính phạt đền bù khi mất sách', 'library', v_admin_id, '2026-06-21 09:50:33.217688'),
    ('MAX_EXTENSION_COUNT', '2', 'Số lần gia hạn tối đa cho một lượt mượn sách', 'library', v_admin_id, '2026-06-21 09:50:33.158691'),
    ('MAX_IMPORT_ROWS', '5000', 'Số BookCopy tối đa trong một file import', 'system', v_admin_id, '2026-06-21 09:50:33.381931'),
    ('MAX_SUGGESTION_PER_LECTURER', '5', 'Giới hạn số đề xuất đang ở trạng thái pending tối đa cho mỗi giảng viên', 'library', v_admin_id, '2026-08-01 16:22:19.004'),
    ('RENEW_DURATION_DAYS', '5', 'Số ngày được gia hạn thêm cho một lượt mượn', 'library', v_admin_id, '2026-08-01 16:22:33.307'),
    ('RENEW_THRESHOLD_PERCENT', '50', 'Phần trăm thời gian mượn tối thiểu đã qua để được phép gia hạn (ví dụ: 50%)', 'library', v_admin_id, '2026-06-21 09:50:33.158691'),
    ('RESERVATION_HOLD_DAYS', '1', 'Số ngày giữ sách đặt trước trước khi hủy tự động', 'library', v_admin_id, '2026-06-21 09:50:33.381931'),
    ('SEPAY_ACCOUNT_NAME', 'CAO THANH TUAN', 'Tên chủ tài khoản ngân hàng nhận tiền', 'system', v_admin_id, '2026-06-21 11:13:27.32442'),
    ('SEPAY_ACCOUNT_NUMBER', '96247LMS06', 'Số tài khoản ngân hàng nhận tiền phạt', 'system', v_admin_id, '2026-06-22 02:14:45.701125'),
    ('SEPAY_API_KEY', 'spsk_live_DXEB1eDLNX5VM7inLYKRDLzAL3KQQL2f', 'API Key xác thực Webhook từ SePay', 'system', v_admin_id, '2026-06-21 09:50:33.273388'),
    ('SEPAY_BANK_CODE', 'BIDV', 'Mã ngân hàng nhận tiền phạt (dùng cho VietQR)', 'system', v_admin_id, '2026-06-21 09:58:04.645602'),
    ('STUDENT_MAX_BORROW_DAYS', '5', 'Số ngày mượn tối đa cho sinh viên', 'library', v_admin_id, '2026-08-01 16:23:57.697'),
    ('STUDENT_MAX_BORROW_LIMIT', '3', 'Giới hạn tổng số sách được mượn và đặt trước cùng lúc của Sinh viên', 'library', v_admin_id, '2026-08-01 16:23:41.245')
    ON CONFLICT (configKey) DO UPDATE SET
        configValue = EXCLUDED.configValue,
        description = EXCLUDED.description,
        configGroup = EXCLUDED.configGroup,
        updatedBy = EXCLUDED.updatedBy,
        updatedAt = EXCLUDED.updatedAt;

END $$;
