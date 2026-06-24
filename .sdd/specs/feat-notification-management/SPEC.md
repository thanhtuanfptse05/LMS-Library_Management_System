# SPEC.md — Đặc tả Chức năng (Detailed Level)
# Mức độ: Detailed Spec (Level 2) | Risk: Medium
# Mapping: UC-24, UC-25, UC-26 | BR: (none) | FR-44, FR-52

## 1. Context & Goal
Số hóa việc truyền thông nội bộ và cấu hình thông báo tự động để tăng tính linh hoạt trong vận hành thư viện.

## 2. Actors & Roles
* **Primary Actor:** Library Manager (Quản lý thư viện)
* **Receiver:** Toàn bộ người dùng (Student, Lecturer, Librarian)

## 3. Functional Requirements (EARS Notation)
* **FR-44 (UC-24, UC-25): Tạo thông báo:** WHEN Quản lý thư viện gửi form thông báo chung hợp lệ, THE system SHALL lưu vào bảng Notification và đẩy hiển thị lên Dashboard của mọi người dùng (UC-24).
* **FR-52 (UC-26): Cập nhật Template:** WHEN Quản lý thư viện lưu thay đổi mẫu tài liệu, THE system SHALL thực hiện UPDATE trường bodyContent và subject trong bảng DocumentTemp.
* **FR-N03 (Tự động hóa):** WHERE sự kiện nghiệp vụ (ví dụ: OVERDUE_NOTICE) xảy ra, THE system SHALL trích xuất nội dung từ DocumentTemp tương ứng để thực hiện gửi (không có số FR toàn cục — logic nội bộ của F7).

## 4. Data Model (Reference)
* **Notification:** {notificationId, title, content, createdBy, createdAt}
* **DocumentTemp:** {tempId, tempName, subject, bodyContent, managerId, updatedAt}

## 5. Error Handling (Unwanted Patterns)
* WHERE nội dung thông báo rỗng, THE system SHALL từ chối lưu và hiển thị lỗi: "Nội dung không được để trống".
* WHERE template chứa placeholder sai cú pháp (không nằm trong danh sách hỗ trợ), THE system SHALL cảnh báo người dùng trước khi lưu.

## 6. Acceptance Criteria (DoD)
- [ ] Manager tạo thông báo thành công, nội dung xuất hiện ngay lập tức ở Widget thông báo của Sinh viên.
- [ ] Chỉnh sửa mẫu Email quá hạn, Email gửi đi sau đó phải áp dụng nội dung mới.
- [ ] Hệ thống ghi nhận đúng managerId thực hiện thay đổi vào audit trail.

## 7. Out of Scope
* Hệ thống SHALL NOT hỗ trợ gửi SMS thủ công.
* Hệ thống SHALL NOT hỗ trợ thu hồi thông báo đã gửi sau 24h.
