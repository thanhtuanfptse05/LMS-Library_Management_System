# Comprehensive Author Review Checklist: Book Suggestions (F20)

**Purpose**: Bộ Unit Test dành cho tài liệu Đặc tả (Requirements) nhằm giúp Tác giả (Author) tự rà soát độ chi tiết, rõ ràng và tính toàn vẹn của mọi khía cạnh trong tính năng F20 (Book Suggestions) ở mức độ chuyên sâu (bao gồm DB constraints, state transitions, và edge cases).
**Created**: 2026-07-05
**Feature**: [SPEC.md](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/.sdd/specs/feat-bookSuggestion/SPEC.md)

**Note**: Checklist này tập trung vào việc đánh giá chất lượng CÁCH VIẾT YÊU CẦU (không phải là file QA test ứng dụng). Mỗi mục đánh giá xem một ràng buộc, luồng xử lý hoặc ngoại lệ đã được mô tả đủ rõ ràng để lập trình viên có thể code mà không cần phỏng đoán hay chưa.

---

## 1. Requirement Completeness & Measurability

- [ ] CHK001 - Các trường dữ liệu đầu vào (tiêu đề, tác giả, lý do) đã có quy định rõ ràng về giới hạn ký tự tối đa/tối thiểu (max/min length) chưa? [Gap]
- [ ] CHK002 - Thuật toán hoặc tiêu chí để xác định "tiêu đề tương tự" đã được mô tả bằng các bước logic cụ thể (measurable) chưa, hay vẫn đang ở mức chung chung? [Measurability, Spec §FR-012]
- [x] CHK003 - Đặc tả đã chỉ rõ định dạng hiển thị ngày giờ (VD: `dd/MM/yyyy HH:mm`) cho danh sách đề xuất chưa? [Gap]
- [x] CHK004 - Các thông báo lỗi (Error messages) cho toàn bộ form tạo/sửa đã được liệt kê cụ thể string text chưa? [Completeness]

## 2. State Transitions & Logic Constraints

- [x] CHK005 - Logic khóa tài khoản (status ≠ 'active') đã được quy định rõ tác động tới UI (ẩn form/nút bấm) thay vì chỉ chặn ở tầng Backend chưa? [Clarity, Spec §EdgeCases]
- [x] CHK006 - Quy trình chuyển trạng thái ngược (từ `acknowledged` về `pending`) đã mô tả rõ hệ quả đối với các lượt vote (có bị reset hay giữ nguyên) chưa? [Consistency, Spec §FR-006]
- [x] CHK007 - Ràng buộc về "Hard Delete" đã giải thích rõ liệu việc xóa có gây ảnh hưởng tới việc tái sử dụng ISBN cho một đề xuất mới trong tương lai hay không? [Edge Case, Spec §FR-013b]
- [x] CHK008 - Yêu cầu về `voteCount` tối thiểu = 0 đã được định nghĩa thành ràng buộc Database (CHECK constraint) trong spec chưa? [Completeness]

## 3. Database & Transaction Traceability

- [x] CHK009 - Phạm vi rollback của DB Transaction khi xảy ra lỗi trong thao tác Vote/Unvote đã được xác định cụ thể trong yêu cầu chưa? [Coverage, Spec §FR-005]
- [x] CHK010 - Hành vi mặc định của hệ thống khi không tìm thấy key `MAX_SUGGESTION_PER_LECTURER` trong bảng cấu hình đã được định nghĩa chưa? (VD: fallback = 10, hay báo lỗi) [Edge Case, Spec §FR-015]
- [x] CHK011 - Yêu cầu Audit Log đã liệt kê chính xác cấu trúc dữ liệu `oldValues` và `newValues` cho hành động đổi trạng thái chưa? [Clarity, Spec §FR-010]
- [x] CHK012 - Cơ chế đánh index DB để hỗ trợ tìm kiếm phân trang dưới 2s (SC-004) đã được mô tả ở dạng yêu cầu phi chức năng cần thiết kế chưa? [Completeness, Spec §SC-004]

## 4. UI/UX & Edge Case Coverage

- [x] CHK013 - Đặc tả có xác định rõ UI sẽ hiển thị thế nào (Zero-state) khi danh sách đề xuất hoàn toàn trống không? [Coverage, Gap]
- [x] CHK014 - Trạng thái loading/disable của nút "Gửi đề xuất" hoặc nút "+1" trong thời gian chờ phản hồi từ server đã được yêu cầu rõ ràng để tránh double-submit chưa? [Coverage, Gap]
- [x] CHK015 - Yêu cầu hiển thị lỗi phân trang (khi truy cập page không tồn tại) đã được định nghĩa trong danh sách các tình huống ngoại lệ chưa? [Edge Case]
- [x] CHK016 - Đã có yêu cầu cụ thể về việc bảo tồn các lựa chọn lọc (Filter) và tìm kiếm (Search) khi Giảng viên nhấn "+1" rồi trang tự tải lại chưa? [UX Consistency]

## 5. Security & RBAC Integrity

- [x] CHK017 - Yêu cầu phân quyền đã xác định rõ hành vi khi Sinh viên cố tình gọi trực tiếp POST endpoint tạo đề xuất chưa (Trả về 403 Forbidden hay redirect)? [Clarity, Spec §FR-011]
- [x] CHK018 - Yêu cầu bảo vệ chống Spam Vote đã quy định giới hạn tốc độ (Rate Limit) cho thao tác nhấn "+1" liên tục từ một IP/Session chưa? [Security Gap]

---

## Notes

- Đánh dấu `[x]` sau khi rà soát và xác nhận nội dung trong `SPEC.md` đã đáp ứng câu hỏi.
- Nếu phát hiện có mục đánh dấu `[Gap]`, Tác giả nên bổ sung trực tiếp thông tin vào `SPEC.md`.
- Checklist này phục vụ quá trình tự hoàn thiện (Self-review) trước/trong khi phát triển để triệt tiêu các điểm mơ hồ về logic.
