# Feature Specification: Trợ lý AI Chatbot (AI Chatbot)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp một chatbot trực tuyến hỏi đáp 24/7 về các nội quy thư viện, chính sách mượn trả sách, và hỗ trợ tra cứu tựa sách sử dụng tích hợp mô hình ngôn ngữ lớn (Gemini API) kết hợp với kỹ thuật RAG.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách & Độc giả (Guest/User):** Gửi câu hỏi cho chatbot, xem lịch sử chat trong phiên.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-36 (Ask Chatbot):** Actor: Guest, User | (Hỏi chatbot): Người dùng gửi câu hỏi bằng ngôn ngữ tự nhiên về nội quy thư viện hoặc tìm kiếm sách thông qua giao diện chatbot.
* **UC-37 (View Chat History):** Actor: User | (Xem lịch sử chat): Người dùng xem lại các câu hỏi và câu trả lời trong phiên làm việc hiện tại.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-36 (Ask Chatbot):** Actor: Guest, User | (Hỏi chatbot): Người dùng gửi câu hỏi bằng ngôn ngữ tự nhiên về nội quy thư viện hoặc tìm kiếm sách thông qua giao diện chatbot.
* **UC-37 (View Chat History):** Actor: User | (Xem lịch sử chat): Người dùng xem lại các câu hỏi và câu trả lời trong phiên làm việc hiện tại.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-36 (Ask Chatbot):** Actor: Guest, User | (Hỏi chatbot): Người dùng gửi câu hỏi bằng ngôn ngữ tự nhiên về nội quy thư viện hoặc tìm kiếm sách thông qua giao diện chatbot.
* **UC-37 (View Chat History):** Actor: User | (Xem lịch sử chat): Người dùng xem lại các câu hỏi và câu trả lời trong phiên làm việc hiện tại.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-37 (AI Chatbot Access Control):** Tính năng AI Chatbot SHALL được public cho cả Guest và User đã đăng nhập. Chatbot SHALL chỉ trả lời các câu hỏi liên quan đến nội quy thư viện, chính sách mượn trả, và tra cứu thông tin sách. Chatbot MUST NOT trả lời các yêu cầu thực hiện giao dịch (mượn, trả, thanh toán) thay người dùng.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-69 (Gửi câu hỏi Chatbot với RAG):** WHEN AiChatbotServlet.doPost() nhận JSON {message:"..."}, THE system SHALL: (1) Validate message không rỗng và ≤ 500 ký tự, (2) Lấy chatHistory từ HttpSession (nếu chưa có: khởi tạo empty list), (3) Gọi AiChatbotService.processMessage(message, chatHistory): Service thực hiện RAG (Retrieval-Augmented Generation): (a) Query relevant context từ DB: NotificationDAO.findPinned() (nội quy), SystemConfigDAO.getAllPublic() (chính sách mượn/phạt), BookDAO.findPopular() (sách hot), (b) Build prompt với context + chatHistory (latest 5 messages) + new message, (c) Gọi Gemini API với prompt, (d) Parse response từ Gemini, (4) Append {role:"user", content:message} và {role:"assistant", content:reply} vào chatHistory, (5) Lưu chatHistory vào session, (6) Trả JSON {status:"success", reply, history}.
  * *Mapping:* UC-36 / BR-37
* **FR-70 (Lấy lịch sử Chat từ session):** WHEN AiChatbotServlet.doGet() được gọi, THE system SHALL: (1) Lấy chatHistory từ HttpSession (attribute name: "chatHistory"), (2) WHERE session không tồn tại hoặc chatHistory = NULL: trả JSON {status:"success", history:[]}, (3) WHERE chatHistory tồn tại: trả JSON {status:"success", history:[{role, content, timestamp}...]} với tối đa 50 messages gần nhất, (4) Không ghi AuditLog (read-only operation).
  * *Mapping:* UC-37

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Hiệu năng: Thời gian phản hồi của chatbot AI phải dưới 15 giây (Timeout cấu hình).
* Bảo mật: Không lộ API Key của Gemini ra phía Client.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng SystemConfigurations
* `configKey` (VARCHAR(100), PK)
* `configValue` (TEXT)



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE kết nối API Gemini bị lỗi hoặc timeout 15 giây, THE system SHALL tự động phản hồi bằng câu trả lời mặc định offline dựa trên bộ câu hỏi thường gặp (FAQ) định nghĩa sẵn.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Hỏi về nội quy: Gửi câu hỏi 'Quy định phạt quá hạn?' -> Chatbot trả lời chính xác mức phạt 5,000đ/ngày dựa trên config.
- [ ] Yêu cầu thực hiện mượn sách: Gửi 'Mượn hộ tôi quyển sách này' -> Chatbot từ chối thực hiện giao dịch theo quy tắc BR-37.

## 9. Out of Scope (Phạm vi không thực hiện)
* Lưu trữ lịch sử chat vĩnh viễn vào cơ sở dữ liệu (chỉ lưu tạm thời trong session của trình duyệt).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.