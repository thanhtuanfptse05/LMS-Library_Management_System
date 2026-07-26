# Feature Specification: Trợ lý ảo AI & Chatbot (AI Assistant & Chatbot)
# Version: 1.3 | Chủ sở hữu: Thai | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp Trợ lý ảo AI (hỗ trợ bởi OpenAI / Gemini API) cho độc giả (Sinh viên, Giảng viên, Khách), giải đáp các câu hỏi tự nhiên về quy định thư viện, hướng dẫn thủ tục mượn trả, tìm kiếm sách theo chủ đề tư vấn và tóm tắt nội dung sách.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Tất cả Người dùng (All Roles) & Khách (Guest):** Tương tác với Widget Trợ lý AI để hỏi đáp thông tin thư viện.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-36 (Ask Chatbot):** Actor: Guest, User | (Hỏi chatbot): Người dùng gửi câu hỏi bằng ngôn ngữ tự nhiên về nội quy thư viện hoặc tìm kiếm sách thông qua giao diện chatbot.
* **UC-37 (View Chat History):** Actor: User | (Xem lịch sử chat): Người dùng xem lại các câu hỏi và câu trả lời trong phiên làm việc hiện tại.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F14 AI Chatbot. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-37 (AI Chatbot Access Control):** Tính năng AI Chatbot SHALL được public cho cả Guest và User đã đăng nhập. Chatbot SHALL chỉ trả lời các câu hỏi liên quan đến nội quy thư viện, chính sách mượn trả, và tra cứu thông tin sách. Chatbot MUST NOT trả lời các yêu cầu thực hiện giao dịch (mượn, trả, thanh toán) thay người dùng.
* **BR-74 (Chat History Ephemerality):** The system SHALL NOT persist AI chat history beyond the active user session.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-69 (Gửi câu hỏi Chatbot với RAG):** WHEN AiChatbotServlet.doPost() nhận JSON {message:"..."}, THE system SHALL: (1) Validate message không rỗng và ≤ 500 ký tự, (2) Lấy chatHistory từ HttpSession (nếu chưa có: khởi tạo empty list), (3) Gọi AiChatbotService.processMessage(message, chatHistory): Service thực hiện RAG (Retrieval-Augmented Generation): (a) Query relevant context từ DB: NotificationDAO.findPinned() (nội quy), SystemConfigDAO.getAllPublic() (chính sách mượn/phạt), BookDAO.findPopular() (sách hot), (b) Build prompt với context + chatHistory (latest 5 messages) + new message, (c) Gọi Gemini API với prompt, (d) Parse response từ Gemini, (4) Append {role:"user", content:message} và {role:"assistant", content:reply} vào chatHistory, (5) Lưu chatHistory vào session, (6) Trả JSON {status:"success", reply, history}.
  * *Mapping:* UC-36 / BR-37
* **FR-70 (Lấy lịch sử Chat từ session):** WHEN AiChatbotServlet.doGet() được gọi, THE system SHALL: (1) Lấy chatHistory từ HttpSession (attribute name: "chatHistory"), (2) WHERE session không tồn tại hoặc chatHistory = NULL: trả JSON {status:"success", history:[]}, (3) WHERE chatHistory tồn tại: trả JSON {status:"success", history:[{role, content, timestamp}...]} với tối đa 50 messages gần nhất, (4) Không ghi AuditLog (read-only operation).
  * *Mapping:* UC-37 / BR-74


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Khóa API (API Key) được lưu trữ bảo mật trong cấu hình môi trường, KHÔNG hardcode trong source code Java hay JSP.
* **Hiệu năng:** Timeout gọi API AI = 3 giây. Phản hồi mượt mà qua AJAX / Stream.
* **Giao diện:** Widget Chatbox ở góc dưới màn hình, giao diện 100% tiếng Việt.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
* Đọc thông tin sách từ `Book`, `Category` để nạp làm context cho AI khi tra cứu.

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** hết quota API hoặc không có mạng, **THE system SHALL** trả về câu trả lời fallback mặc định mà không làm gián đoạn ứng dụng.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-AI-01] Đặt câu hỏi về giờ mở cửa hoặc nội quy thư viện Trợ lý AI trả lời chính xác.
- [ ] [TC-AI-02] Nhập yêu cầu gợi ý sách theo chủ đề Trợ lý AI tư vấn các sách phù hợp.
- [ ] [TC-AI-03] Giả lập ngắt kết nối API AI hệ thống phản hồi câu thông báo fallback thân thiện trong 3 giây.

## 8. Out of Scope (Phạm vi không thực hiện)
* Xử lý giọng nói tiếng Việt (Voice-to-Text).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện cấu hình AiConfig và dịch vụ AiRecommendationService.