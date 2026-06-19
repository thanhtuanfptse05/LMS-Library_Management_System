### CONTEXT.md — Chatbot Hỗ trợ AI (Feature 9)
### Phiên bản: 1.0.0 | Trạng thái: DRAFT

#### 1. PROBLEM STATEMENT
Người dùng (Độc giả/Khách vãng lai) thường có những câu hỏi lặp đi lặp lại về nội quy thư viện, giờ mở cửa, mức phạt, hoặc cần hỗ trợ tìm sách nhanh. Việc tìm kiếm thủ công trong tài liệu hoặc chờ thủ thư giải đáp gây mất thời gian. Cần một trợ lý ảo 24/7 để tiếp nhận câu hỏi tự nhiên và trả lời tức thì dựa trên dữ liệu thật của thư viện.

#### 2. DOMAIN KNOWLEDGE
*   **RAG (Retrieval-Augmented Generation):** Mẫu kiến trúc AI kết hợp giữa tìm kiếm dữ liệu thực tế (CSDL Thư viện) và khả năng sinh văn bản của LLM (Gemini). AI không tự bịa ra câu trả lời mà phải dựa trên Context do hệ thống cung cấp.
*   **System Prompt:** Chỉ thị hệ thống ẩn được gửi kèm mỗi tin nhắn để đóng khung "nhân cách" và "giới hạn" của Chatbot (Ví dụ: "Bạn là trợ lý thư viện, chỉ trả lời các câu hỏi về sách...").

#### 3. STAKEHOLDERS
*   **Người dùng (Guest, Student, Lecturer):** Đặt câu hỏi đàm thoại tự nhiên.
*   **Thủ thư/Quản trị viên:** Giảm tải công việc hỗ trợ (hưởng lợi gián tiếp).

#### 4. CONSTRAINTS (Ràng buộc cứng)
*   **Security & Read-Only:** Chatbot KHÔNG ĐƯỢC phép thay đổi dữ liệu hệ thống.
*   **Anti-Hallucination:** Chatbot KHÔNG ĐƯỢC trả lời các câu hỏi ngoài phạm vi thư viện. Hệ thống BẮT BUỘC inject ngữ cảnh sách/nội quy vào prompt trước khi gọi AI API.