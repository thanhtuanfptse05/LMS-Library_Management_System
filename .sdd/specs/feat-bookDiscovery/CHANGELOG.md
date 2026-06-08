# CHANGELOG.md — F8: Book Discovery

## [1.0.0] - 2026-06-08
### Added
- Đặc tả yêu cầu (FR-42 đến FR-48) cho luồng Khám phá sách, bao gồm tính năng Tra cứu chủ động và Gợi ý tự động (Top Trending & AI) dựa trên ngữ cảnh người dùng.
- Thêm Business Rules (BR-26, BR-27) quản lý điều kiện gọi API thông minh nhằm tối ưu chi phí AI (Threshold >= 3 lượt mượn).
- Cấu trúc Spec-Driven Development mới với 5 file cốt lõi (CONTEXT, SPEC, PLAN, TASK, CHANGELOG).

### Changed
- (Initial Version - Phiên bản khởi tạo, chưa có nội dung thay đổi)

### Fixed
- Giải quyết vấn đề mâu thuẫn (Contradiction) trong việc xử lý rủi ro từ AI bằng cơ chế Fallback an toàn (chuyển về SQL Top Trending khi AI Timeout hoặc lỗi HTTP).

### Security
- Bắt buộc sử dụng `PreparedStatement` (SEC-03) cho mọi logic search để chống SQL Injection.
- Bắt buộc vòng lặp xác thực (Anti-Hallucination) đối với các `book_id` AI trả về. ID phải tồn tại trong Candidate Pool mới được cấp quyền render lên UI.
- Thắt chặt phân quyền Guest: Chặn hành vi truy cập luồng mượn sách bằng cách điều hướng tự động sang trang `/login`.
