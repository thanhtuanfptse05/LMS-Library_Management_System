# Feature Specification: [Tên Tính Năng]
# Version: 0.1 (DRAFT) | Chủ sở hữu: @tên-agent | Ngày khởi tạo: YYYY-MM-DD

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
<!-- Tại sao tính năng này tồn tại? Nó giải quyết vấn đề gì cho thư viện? -->

## 2. Actors & Roles (Tác nhân & Quyền hạn)
<!-- Ai tương tác với tính năng này? Họ có quyền gì? -->
* **[Tên Actor 1]:** [Quyền hạn chi tiết]
* **[Tên Actor 2]:** [Quyền hạn chi tiết]

## 3. Business Rules (Quy tắc nghiệp vụ)
<!-- Các quy tắc ràng buộc, chính sách bắt buộc (Ví dụ: Không được xóa mềm, Không được tự động tạo tài khoản SSO) -->
* **[BR-XX-01]:** ...

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
<!-- Biểu diễn dưới dạng EARS Notation: 
     - WHEN <trigger>, THE system SHALL <response>
     - WHILE <state>, THE system SHALL <response> 
     - WHERE <condition>, THE system SHALL <response> -->
* **[FR-XX-01]:** WHEN... THE system SHALL...
* **[FR-XX-02]:** WHILE... THE system SHALL...

## 4. Non-functional Requirements (Yêu cầu phi chức năng)
<!-- Các tiêu chí về bảo mật (Security), hiệu năng (Performance), tính khả dụng (Usability) có số đo cụ thể -->
* **Bảo mật:** Chống SQL Injection bằng PreparedStatement, mã hóa tham số nhạy cảm.
* **Thời gian đáp ứng:** Thời gian xử lý truy vấn phải dưới 500ms.
* **Độ tương thích:** Responsive tốt trên các trình duyệt Chrome, Edge, Safari.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
<!-- Danh sách các bảng CSDL tương tác (PascalCase cho bảng, camelCase cho cột) -->
### Bảng [Tên Bảng] (Ví dụ: BorrowRecord)
* `cột1` (Kiểu dữ liệu, Primary Key/Foreign Key, Ràng buộc)
* `cột2` (Kiểu dữ liệu, Ràng buộc)

## 6. Error Handling (Xử lý lỗi ngoại lệ)
<!-- Khi có sự cố xảy ra, hệ thống phản hồi thế nào để đảm bảo an toàn? -->
* **WHERE** [Điều kiện lỗi, ví dụ: Input rỗng hoặc sai định dạng], **THE system SHALL** [Hành vi xử lý lỗi, ví dụ: hiển thị thông báo thân thiện và redirect về trang trước].
* **WHERE** [Lỗi kết nối CSDL DatabaseException], **THE system SHALL** [Hành vi xử lý lỗi, ví dụ: ghi log hệ thống và hiển thị trang báo lỗi chung, không in stack trace].

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
<!-- Danh sách các ca kiểm thử (test cases) cụ thể để pass DoD -->
- [ ] [TC-01] Kiểm thử trường hợp dữ liệu hợp lệ (Happy Path).
- [ ] [TC-02] Kiểm thử trường hợp nhập sai định dạng đầu vào.
- [ ] [TC-03] Kiểm thử phân quyền truy cập (nỗ lực bypass role).
- [ ] [TC-04] Kiểm thử ghi nhật ký Audit Log sau khi thực hiện thành công.

## 8. Out of Scope (Phạm vi không thực hiện)
<!-- Viết TƯỜNG MINH những gì KHÔNG làm trong sprint này để tránh phình to tính năng -->
* Không làm...
* Không tích hợp...

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
<!-- Các điểm chưa rõ cần hỏi ý kiến Human trước khi triển khai code -->