# AI Chatbot Spec (F14)
# Version: 1.0 | Owner: @Antigravity | Date: 2026-06-19

## 1. Context & Goal
Tính năng F14 cung cấp giao diện hội thoại (Chatbot) thông minh giúp người dùng (bao gồm cả khách vãng lai và người dùng đã đăng nhập) có thể hỏi các câu hỏi bằng ngôn ngữ tự nhiên về nội quy thư viện hoặc tra cứu/tìm kiếm sách nhanh chóng. Trợ lý ảo sử dụng mô hình RAG (Retrieval-Augmented Generation) kết hợp dữ liệu thực tế từ CSDL thư viện và API AI (Gemini/OpenAI) để trả lời chính xác, tránh hiện tượng ảo giác (hallucination), đồng thời bảo đảm an toàn hệ thống (read-only) và tối ưu chi phí thông qua bộ phân loại ý định (Intent Classifier) và cơ chế Fallback.

## 2. Actors & Roles
- **Guest (Khách vãng lai)**: Có thể truy cập Chatbot widget nổi trên màn hình, gửi câu hỏi về nội quy hoặc tìm sách công khai.
- **Authenticated User (Student, Lecturer, Librarian, Manager, Admin)**: Có quyền hỏi chatbot tương tự Guest, nhưng có thể nhận đề xuất mang tính cá nhân hóa hơn nếu tích hợp thông tin tài khoản (nếu cần thiết ở các pha sau). Ở pha hiện tại, quyền lợi chính là hỗ trợ đàm thoại read-only.

## 3. Functional Requirements
- **FR-33.1 (Giao diện widget)**: WHEN người dùng truy cập hệ thống, THE system SHALL hiển thị một widget Chatbot nổi (float button) ở góc dưới màn hình. Khi click, widget mở ra khung giao diện đàm thoại (chat window) với tin nhắn chào mừng mặc định: *"Xin chào! Tôi là trợ lý ảo của thư viện. Tôi có thể giúp bạn tìm kiếm sách hoặc giải đáp các quy định, nội quy thư viện."*
- **FR-33.2 (Khởi tạo phiên chat)**: WHEN bắt đầu một phiên truy cập, THE system SHALL khởi tạo một danh sách lịch sử hội thoại rỗng (`List<ChatMessage>`) trong `HttpSession` của người dùng để lưu trữ hội thoại ngắn hạn.
- **FR-33.3 (Giới hạn lịch sử đàm thoại)**: WHEN gửi câu hỏi mới lên server, THE system SHALL trích xuất lịch sử từ `HttpSession` và chỉ giữ lại tối đa **5 lượt hội thoại gần nhất** (5 cặp Prompt - Response) gửi kèm trong Payload gửi tới AI nhằm kiểm soát token và chi phí.
- **FR-33.4 (Bộ phân loại ý định - Intent Classifier)**: WHEN nhận tin nhắn từ người dùng, THE system SHALL phân loại ý định câu hỏi thành 1 trong 3 nhóm:
  - **Library Rules Intent**: Các câu hỏi liên quan đến nội quy, giờ mở cửa, quy tắc phạt mượn trả.
  - **Book Search Intent**: Các câu hỏi tra cứu, tìm kiếm sách theo tên, tác giả, thể loại.
  - **Other / Irrelevant Intent**: Các câu hỏi không liên quan đến thư viện hoặc sách.
- **FR-33.5 (Tự động từ chối câu hỏi ngoài phạm vi)**: WHERE ý định được phân loại là *Other / Irrelevant Intent*, THE system SHALL trực tiếp trả về thông điệp từ chối tĩnh: *"Tôi chỉ có thể hỗ trợ các vấn đề liên quan đến nội quy thư viện và tìm kiếm sách."* ĐỒNG THỜI, hệ thống **KHÔNG** thực hiện gọi tới AI Service để tiết kiệm chi phí API.
- **FR-33.6 (Truy xuất ngữ cảnh Nội quy - Rules RAG)**: WHERE ý định được phân loại là *Library Rules Intent*, THE system SHALL truy vấn CSDL (bảng `SystemConfigurations` hoặc các bảng nội quy khác) để trích xuất các quy tắc hoạt động hiện hành và nhúng vào phần Context Payload làm nguồn dữ liệu cho AI.
- **FR-33.7 (Truy xuất ngữ cảnh Sách - Book RAG)**: WHERE ý định được phân loại là *Book Search Intent*, THE system SHALL thực hiện truy vấn cơ sở dữ liệu để lấy danh sách sách phù hợp (tên sách, tác giả, thể loại, tình trạng có sẵn) để làm Candidate Pool và nhúng vào Context Payload gửi cho AI.
- **FR-33.8 (Gọi AI Service bất đồng bộ)**: WHEN đã đóng gói Context Payload (gồm System Prompt, Lịch sử chat, và Context dữ liệu thực tế), THE system SHALL thực hiện cuộc gọi HTTP API bất đồng bộ tới AI Service (Gemini/OpenAI) với thời gian chờ phản hồi tối đa (Timeout) là **15 giây**.
- **FR-33.9 (Xác thực chống ảo giác - Anti-Hallucination Gate)**: WHEN nhận được câu trả lời từ AI Service về tìm sách, THE system SHALL xác thực rằng nếu AI liệt kê các ID sách hoặc thông tin sách, thì các sách đó BẮT BUỘC phải nằm trong Candidate Pool đã cung cấp. Nếu phát hiện AI bịa đặt thông tin ngoài danh sách, hệ thống sẽ kích hoạt luồng Fallback.
- **FR-33.10 (Hiển thị Markdown)**: WHEN nhận phản hồi thành công từ AI Service (HTTP 200), THE system SHALL render nội dung văn bản dưới định dạng Markdown trực quan trên khung chat của người dùng.
- **FR-33.11 (Cập nhật phiên chat)**: WHEN kết thúc mỗi lượt xử lý (thành công hoặc lỗi), THE system SHALL cập nhật cặp tin nhắn vừa gửi và nhận vào mảng lịch sử trong `HttpSession`.

## 4. Non-functional Requirements
- **Performance**:
  - Đối với các câu hỏi ngoài phạm vi (Irrelevant), thời gian phản hồi trực tiếp từ server phải `< 100ms`.
  - Đối với các câu hỏi gọi AI Service, thời gian phản hồi tối đa là 15 giây (Timeout). Cần xử lý gọi API bất đồng bộ để tránh tắc nghẽn main thread của Web Server.
- **Security**:
  - Tuyệt đối chỉ cho phép thao tác đọc (Read-only). Chatbot không được có khả năng thay đổi trạng thái cơ sở dữ liệu (tạo mượn sách, hủy phạt, khóa tài khoản...).
  - Phòng chống SQL Injection (SEC-03) bằng cách sử dụng `PreparedStatement` khi truy vấn CSDL lấy Context cho RAG.
- **Usability (Ngôn ngữ giao diện)**: 100% giao diện, thông báo lỗi, câu chào, nội dung phản hồi của Chatbot phải hiển thị bằng **tiếng Việt (100% Vietnamese)** theo quy định UI-01.

## 5. Data Model
Do Chatbot hoạt động hoàn toàn dựa trên `HttpSession` (Stateless đối với DB), không có bảng lưu trữ lịch sử chat dài hạn nào trong CSDL (theo quy định thiết kế hiện tại). Dữ liệu được quản lý như sau:
- **`HttpSession`**: Lưu trữ `List<ChatMessage>` đại diện cho phiên chat hiện tại.
- **`ChatMessage`**: Lớp Java Bean chứa:
  - `role` (`user` hoặc `model`/`assistant`)
  - `content` (nội dung văn bản tin nhắn)
  - `timestamp` (thời điểm gửi)
- **`SystemConfigurations`**: Dùng để lấy các tham số quy định thư viện (ví dụ: `fine_rate_per_day`, `max_borrow_limit_student`, `max_borrow_limit_lecturer`, `max_extension_limit`).
- **`Book`**, **`Category`**, **`Tag`**: Dùng để truy vấn lấy context thông tin sách.

## 6. Error Handling (Unwanted)
- **Timeout hoặc Lỗi HTTP 5xx từ AI Service**: WHERE AI Service bị timeout hoặc trả về lỗi, THE system SHALL ghi log lỗi và trả về thông báo lỗi thân thiện trên khung chat: *"Hệ thống AI hiện đang quá tải. Vui lòng thử lại sau ít phút"*.
- **Mất kết nối Internet hoặc lỗi cấu hình API Key**: Tương tự như trên, hệ thống ghi log lỗi hệ thống và trả về tin nhắn thông báo lỗi thân thiện cho người dùng, không làm treo ứng dụng hoặc hiện lỗi kỹ thuật thô.

## 7. Acceptance Criteria
- [ ] Widget chatbot hiển thị đúng vị trí (floating button) trên giao diện khách và thành viên, hoạt động mượt mà.
- [ ] Khi người dùng gửi câu hỏi vô hại/không liên quan (ví dụ: "thời tiết hôm nay thế nào?", "dịch cho tôi bài thơ"), hệ thống trả về thông báo từ chối tĩnh ngay lập tức và không tiêu tốn API AI.
- [ ] Khi hỏi về nội quy thư viện, hệ thống lấy được quy tắc từ CSDL, gửi AI và hiển thị câu trả lời Markdown chính xác về nội quy.
- [ ] Khi hỏi tìm sách, hệ thống truy vấn sách từ DB, đưa context sách đó cho AI và hiển thị danh sách sách đề xuất dưới dạng Markdown dễ đọc.
- [ ] Lịch sử chat được lưu trữ và hiển thị tối đa 5 lượt trong phiên làm việc. Tải lại trang (F5) không làm mất phiên nếu session còn hiệu lực.
- [ ] Thời gian timeout 15 giây hoạt động đúng: Nếu ngắt mạng hoặc ép trễ API AI > 15s, hệ thống hiển thị thông báo lỗi quá tải thân thiện bằng tiếng Việt.

## 8. Out of Scope
- KHÔNG xây dựng tính năng lưu trữ lịch sử chat vĩnh viễn vào CSDL.
- KHÔNG cho phép chatbot thực hiện các tác vụ ghi (Write) như đặt sách, gia hạn sách, thanh toán phạt.
- KHÔNG tích hợp giọng nói (Voice to Text / Text to Voice) ở pha này.

## 9. Notes / Open Questions
- Phục vụ AI Service: Project sẽ tích hợp trực tiếp API của Google Gemini thông qua REST API (sử dụng API Key cấu hình trong `AiConfig` hoặc file cấu hình hệ thống).
