# TASK.md — F8: Book Discovery
# Generated: 2026-06-08 | Total: 11 tasks, ~12h

| ID | Task | Files | Est | Deps | Spec Refs | Done When |
|---|---|---|---|---|---|---|
| T001 | Khởi tạo cấu trúc các lớp Model/Entities | `src/java/models/*.java` | 1h | | §5 Data Model | Các Beans (Book, BookCategory, BookTag, BookCopy, BorrowRecord) biên dịch thành công. |
| T002 | Phát triển các lệnh truy vấn BookDAO (LIKE, Filter, Pagination, Count Available) | `src/java/daos/BookDAO.java` | 2h | T001 | §3 FR-43 / BR-65, BR-66 | Các query có sử dụng PreparedStatement hoạt động và trả về dữ liệu đúng chuẩn. |
| T003 | Phát triển Controller BookSearchServlet | `src/java/controllers/BookSearchServlet.java` | 1h | T002 | §3 FR-43 | Trích xuất params, gọi DAO, forward dữ liệu danh sách sang JSP an toàn. |
| T004 | Xây dựng giao diện book-catalog.jsp | `web/book-catalog.jsp` | 1.5h | T003 | §3 FR-43 | Giao diện hiển thị thanh tìm kiếm, filter và grid các thẻ sách có phân trang. |
| T005 | Phát triển Controller BookDetailServlet | `src/java/controllers/BookDetailServlet.java` | 1h | T002 | §3 FR-43 | Xử lý logic load chi tiết sách và định hướng/redirect chặn Guest đặt mượn. |
| T006 | Xây dựng giao diện book-detail.jsp | `web/book-detail.jsp` | 1h | T005 | §3 FR-43 | Hiển thị thông tin sách, availableQuantity thực tế và nút Đặt mượn. |
| T007 | Xây dựng thuật toán Data Retrieval cho Top Trending và Candidate Pool | `src/java/daos/BookDAO.java` | 1h | T001 | §3 FR-43 / BR-66 | Query Top 10 và Query Context Pool 50 sách hoạt động chính xác dựa trên lịch sử mượn. |
| T008 | Tích hợp thư viện và thiết lập cấu hình AiRecommendationService | `src/java/services/AiRecommendationService.java` | 2h | T007 | §3 FR-43 / BR-66 | Gửi payload HTTP thành công tới AI, có xử lý try-catch chống Hallucination ID. |
| T009 | Xây dựng API Endpoint RecommendationApiServlet kết hợp Fallback | `src/java/controllers/RecommendationApiServlet.java` | 1h | T008 | §3 FR-43 / BR-66 | API định tuyến chính xác ngưỡng threshold và fallback về JSON Top Trending nếu lỗi. |
| T010 | Phát triển Unified Component thẻ sách (book-card.jsp) | `web/components/book-card.jsp` | 0.5h | | FR-43 / BR-65 | Template tái sử dụng để render độc lập từ HTML trực tiếp hoặc JS Fetch. |
| T011 | Viết Async Script tích hợp gọi API gợi ý sách trên Homepage | `web/index.jsp`, `web/assets/js/recommendation.js` | 1h | T009, T010 | §3 FR-43 / BR-66 | Homepage tự động load sách (bất đồng bộ) không gây block màn hình. |
