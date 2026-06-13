# Manual Acceptance Tests (MAT) - F8 Book Discovery (View Layer)

Do tính chất của dự án SWP391 (Java Web Monolith) và quy định không sử dụng thư viện tự động hóa UI bên ngoài (như Selenium, HtmlUnit) trong thư mục `allowedlib`, việc kiểm thử tầng View (JSP/HTML/JS) được thực hiện dưới dạng **Kiểm thử chấp nhận thủ công (Manual Acceptance Test - MAT)** dựa trên Acceptance Criteria từ SPEC.md.

## Bảng kịch bản kiểm thử (Test Scenarios)

| Test ID | Tính năng / Giao diện | Kịch bản kiểm thử (Scenario) | Kết quả mong đợi (Expected Result) | Trạng thái | Người test |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **MAT-F8-01** | `index.jsp` | Truy cập trang chủ với tư cách **Guest** (Chưa đăng nhập). | Hiển thị thành công layout cơ bản. Không báo lỗi. Tại phần AI Gợi ý, sau 1-2s (do gọi fallback), giao diện hiển thị danh sách sách **Top Trending** thay vì gợi ý cá nhân hóa. | [ ] | |
| **MAT-F8-02** | `index.jsp` | Truy cập trang chủ với tư cách **Sinh viên** (Đã đăng nhập) và có lịch sử mượn $\ge$ 3 sách. | Giao diện tự động bắn AJAX call hiển thị Spinner Loading. Sau đó, render thành công block danh sách **AI Recommendation** đúng định dạng thẻ sách (Unified Card UI). | [ ] | |
| **MAT-F8-03** | `book-search.jsp` | Vào trang Khám phá, không nhập từ khóa, bấm "Lọc kết quả". | Hiển thị toàn bộ sách trong hệ thống. Badge Trạng thái hiện Xanh (Sẵn sàng) hoặc Đỏ (Đang mượn). | [ ] | |
| **MAT-F8-04** | `book-search.jsp` | Nhập từ khóa "Lập trình Java" vào thanh tìm kiếm và bấm Enter. | URL chuyển thành `?keyword=Lập+trình+Java`. Danh sách hiển thị đúng các cuốn sách có chứa từ khóa. Layout không bị vỡ. | [ ] | |
| **MAT-F8-05** | `book-search.jsp` | Bấm chuyển trang (Pagination) ở dưới cùng. | Nội dung sách thay đổi theo trang, URL thêm tham số `&page=2`. Thanh tìm kiếm và bộ lọc vẫn giữ nguyên trạng thái vừa chọn. | [ ] | |
| **MAT-F8-06** | `book-detail.jsp` | Click vào một cuốn sách bất kỳ từ trang Tìm kiếm. | View hiển thị đúng ảnh bìa, Tên sách, Tác giả, và đặc biệt là số lượng sách có sẵn (`availableQuantity`). | [ ] | |
| **MAT-F8-07** | `book-detail.jsp` | (Guest) Bấm nút "Đăng nhập để đặt mượn". | Trình duyệt Redirect chính xác sang `/login?redirect=student/book-detail?id=...`. | [ ] | |
| **MAT-F8-08** | `book-detail.jsp` | (Sinh viên) Bấm nút "Đặt mượn ngay" khi sách khả dụng. | Bắn Form POST tới `/student/borrow`, hệ thống điều hướng sang giao diện giỏ hàng/thanh toán. | [ ] | |
| **MAT-F8-09** | `book-detail.jsp` | (Sinh viên) Nút bấm khi số lượng sách $\le$ 0. | Nút chuyển thành "Tạm thời hết sách", bị mờ đi (disabled) và không thể click. | [ ] | |
| **MAT-F8-10** | AJAX Error | Tắt mạng hoặc Backend lỗi khi đang fetch `/recommendation`. | Javascript bắt lỗi, không làm trắng trang mà thay vào đó hiển thị khối fallback UI báo lỗi "Hệ thống gợi ý đang bảo trì". | [ ] | |
