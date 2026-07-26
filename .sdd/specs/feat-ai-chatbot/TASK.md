# TASK.md — F14: AI Chatbot
# Generated: 2026-06-19 | Total: 7 tasks, ~10h

| ID | Task | Files | Est | Deps | Spec Refs | Done When |
|---|---|---|---|---|---|---|
| T001 | Tạo lớp Model ChatMessage | `src/java/model/ChatMessage.java` | 0.5h | | §5 Data Model | Biên dịch thành công lớp `ChatMessage` chứa các trường `role`, `content`, `timestamp`. |
| T002 | Phát triển lớp truy xuất dữ liệu SystemConfigurationsDAO | `src/java/dao/SystemConfigurationsDAO.java` | 1h | | §3 FR-69 / BR-37 | Lớp truy vấn được cấu hình từ bảng SystemConfigurations bằng PreparedStatement. |
| T003 | Triển khai lớp dịch vụ AiChatbotService kết nối API Gemini | `src/java/service/AiChatbotService.java` | 3h | T001, T002 | §3 FR-69 / BR-37 | Tích hợp thành công gọi Gemini, phân loại ý định, trích xuất context (nội quy/sách), kiểm duyệt hallucination và timeout. |
| T004 | Phát triển Controller AiChatbotServlet quản lý phiên chat | `src/java/controllers/AiChatbotServlet.java` | 2h | T003 | §3 FR-69, FR-70 / BR-37, BR-74 | Servlet nhận POST request dạng JSON, quản lý HttpSession (giới hạn 5 tin nhắn), và trả JSON chứa phản hồi. |
| T005 | Thiết kế UI Widget Chatbot JSP nổi trên màn hình | `web/components/chatbot-widget.jsp` | 1.5h | | §3 FR-69 / BR-37 | Giao diện hiển thị widget nổi, chatbox hiển thị tin nhắn chào mừng và các bong bóng tin nhắn. |
| T006 | Viết Javascript gửi tin và render Markdown động cho Chatbot | `web/assets/js/chatbot.js` | 1h | T004, T005 | §3 FR-69, FR-70 / BR-37, BR-74 | Xử lý sự kiện click gửi tin, fetch API bất đồng bộ tới servlet, render tin nhắn dạng Markdown mượt mà. |
| T007 | Viết Unit Test kiểm thử logic phân loại ý định và lấy ngữ cảnh | `test/service/AiChatbotServiceTest.java` | 1h | T003 | §7 Acceptance Criteria | JUnit Test chạy thành công kiểm tra happy path phân loại ý định và mock gọi API. |
