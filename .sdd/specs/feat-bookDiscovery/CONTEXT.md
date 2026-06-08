# CONTEXT.md — F8: Book Discovery
# Người viết: @Antigravity | Ngày: 2026-06-08

## 1. PROBLEM STATEMENT
Người dùng thường gặp khó khăn trong việc tìm kiếm nhanh một tựa sách cụ thể, hoặc không biết nên đọc sách gì tiếp theo. Hệ thống cần tự động gợi ý sách phù hợp hoặc cho phép tìm kiếm/lọc chủ động để tăng tương tác và trải nghiệm khám phá sách của người dùng trong thư viện.

## 2. DOMAIN KNOWLEDGE
- **Top Trending**: Sách có lượt mượn (được lưu trong BorrowRecord) cao nhất.
- **Candidate Pool**: Tập hợp các sách tiềm năng được trích xuất (tối đa 50 cuốn) dựa trên ngữ cảnh người dùng để gửi cho AI Re-ranking.
- **Hallucination (Ảo giác AI)**: Khái niệm AI sinh ra dữ liệu sách không có thật hoặc không có trong kho. Cần phải có lớp đối chiếu `book_id` trả về với Candidate Pool.
- **Available Quantity**: Số lượng sách thực tế có thể mượn = Tổng số `BookCopy` trừ đi các bản sao đang mượn, đã hỏng, đã mất, hoặc đã được đặt trước.

## 3. STAKEHOLDERS
- **Student/User**: Người trực tiếp sử dụng tính năng tìm kiếm, xem chi tiết và nhận gợi ý sách để ra quyết định mượn.
- **Guest**: Người dùng vãng lai (chưa đăng nhập), chỉ được xem danh sách, chi tiết sách nhưng không được mượn.
- **Librarian/Admin**: Quản lý sách và theo dõi xu hướng mượn sách.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Tech**: BẮT BUỘC dùng Java Servlet/JSP, JDBC thuần, không Spring/Hibernate. Request gọi AI Service phải chạy bất đồng bộ (Async/AJAX) để không block giao diện.
- **Business**: Gợi ý AI chỉ áp dụng cho User có `>= 3` lượt mượn (để tối ưu chi phí token và tăng độ chính xác). Giao diện hiển thị thẻ sách (Unified Component) phải đồng nhất bất kể nguồn dữ liệu là SQL hay AI (BR-27).
- **Security**: Ngăn chặn SQL Injection khi tìm kiếm (dùng `PreparedStatement`). Không cho phép Guest bypass qua nút Đặt mượn.

## 5. ASSUMPTIONS (Giả định)
- Endpoint AI của OpenAI/Gemini đã được cấu hình và hoạt động ổn định trên môi trường triển khai.
- Cơ sở dữ liệu SQL Server hỗ trợ tính năng TOP/OFFSET-FETCH cho việc phân trang dữ liệu sách.
- Frontend có sẵn bộ khung HTML/CSS thuần hỗ trợ Flexbox/Grid phục vụ việc tái sử dụng UI component.

## 6. OPEN QUESTIONS
- (Không có - Đặc tả đã được chốt và truy vết hoàn toàn từ Activity Diagram và Rule List của dự án)
