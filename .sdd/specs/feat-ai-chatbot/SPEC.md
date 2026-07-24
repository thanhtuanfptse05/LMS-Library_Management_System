# Feature Specification: Trợ lý ảo AI & Chatbot (AI Assistant & Chatbot)
# Version: 1.2 | Chủ sở hữu: @thai | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp Trợ lý ảo AI (hỗ trợ bởi OpenAI / Gemini API) cho độc giả (Sinh viên, Giảng viên, Khách), giải đáp các câu hỏi tự nhiên về quy định thư viện, hướng dẫn thủ tục mượn trả, tìm kiếm sách theo chủ đề tư vấn và tóm tắt nội dung sách.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Tất cả Người dùng (All Roles) & Khách (Guest):** Tương tác với Widget Trợ lý AI để hỏi đáp thông tin thư viện.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-43 (Interact with AI Chatbot):** Actor: Guest/All Users | Gửi câu hỏi bằng ngôn ngữ tự nhiên và nhận phản hồi tư vấn từ Trợ lý AI.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-48 (AI System Context Ingestion):** Trợ lý AI BẮT BUỘC được nạp bối cảnh quy định thư viện (Library Rules & Context) trong System Prompt để đảm bảo trả lời chính xác theo chính sách của thư viện LMS.
* **BR-49 (API Safety & Timeout Fallback):** Cuộc gọi tới API OpenAI/Gemini BẮT BUỘC có thời gian chờ (Timeout) tối đa 3.0 giây. Nếu vượt quá thời gian chờ hoặc API bị lỗi, hệ thống phải tự động trả về câu trả lời mặc định thân thiện mà không gây treo màn hình.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-54 (Trợ lý AI tư vấn ngôn ngữ tự nhiên):** WHEN độc giả gửi câu hỏi tại `AiChatbotServlet`, THE system SHALL gọi `AiRecommendationService` gửi câu hỏi kèm System Prompt cấu hình bối cảnh thư viện tới Gemini/OpenAI API. Trả về phản hồi dạng Chat Bubbles.
  * *Mapping:* UC-43 / BR-48
* **FR-55 (Xử lý Fallback an toàn khi API lỗi):** WHERE cuộc gọi API AI gặp sự cố ngắt kết nối hoặc Timeout 3s, THE system SHALL catch lỗi, trả về phản hồi mặc định: "Xin lỗi, hiện tại trợ lý AI đang bận. Bạn có thể tra cứu sách trực tiếp tại thanh tìm kiếm hoặc xem trang Quy định thư viện."
  * *Mapping:* UC-43 / BR-49

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