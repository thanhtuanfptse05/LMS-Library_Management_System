# Feature Specification: Trợ lý AI Chatbot (AI Chatbot)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp một chatbot trực tuyến hỏi đáp 24/7 về các nội quy thư viện, chính sách mượn trả sách, và hỗ trợ tra cứu tựa sách sử dụng tích hợp mô hình ngôn ngữ lớn (Gemini API) kết hợp với kỹ thuật RAG.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách & Độc giả (Guest/User):** Gửi câu hỏi cho chatbot, xem lịch sử chat trong phiên.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-37 (AI Chatbot Access Control):** Tính năng AI Chatbot SHALL được public cho cả Guest và User đã đăng nhập. Chatbot SHALL chỉ trả lời các câu hỏi liên quan đến nội quy thư viện, chính sách mượn trả, và tra cứu thông tin sách. Chatbot MUST NOT trả lời các yêu cầu thực hiện giao dịch (mượn, trả, thanh toán) thay người dùng.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-69 (Gửi câu hỏi Chatbot với RAG):** WHEN nhận câu hỏi, THE system SHALL tự động truy vấn ngữ cảnh liên quan trong DB (thông báo, nội quy, sách hot) để nhúng vào prompt, gọi Gemini API lấy câu trả lời và lưu lịch sử chat vào session.\n* **FR-70 (Lấy lịch sử chat từ session):** WHEN người dùng tải lại trang chat, THE system SHALL tải lại lịch sử chat tối đa 50 tin nhắn gần nhất trong phiên làm việc hiện tại.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Hiệu năng: Thời gian phản hồi của chatbot AI phải dưới 15 giây (Timeout cấu hình).\n* Bảo mật: Không lộ API Key của Gemini ra phía Client.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng SystemConfigurations\n* `configKey` (VARCHAR(100), PK)\n* `configValue` (TEXT)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE kết nối API Gemini bị lỗi hoặc timeout 15 giây, THE system SHALL tự động phản hồi bằng câu trả lời mặc định offline dựa trên bộ câu hỏi thường gặp (FAQ) định nghĩa sẵn.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Hỏi về nội quy: Gửi câu hỏi 'Quy định phạt quá hạn?' -> Chatbot trả lời chính xác mức phạt 5,000đ/ngày dựa trên config.\n- [ ] Yêu cầu thực hiện mượn sách: Gửi 'Mượn hộ tôi quyển sách này' -> Chatbot từ chối thực hiện giao dịch theo quy tắc BR-37.

## 9. Out of Scope (Phạm vi không thực hiện)
* Lưu trữ lịch sử chat vĩnh viễn vào cơ sở dữ liệu (chỉ lưu tạm thời trong session của trình duyệt).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
