# RULE: CG-01 — CodeGraph Mandatory Usage Rules

## 1. MỤC TIÊU & QUY ĐỊNH BẮT BUỘC
* **BẮT BUỘC SỬ DỤNG CODEGRAPH ĐẦU TIÊN (FIRST-CHOICE):** Mỗi khi AI Agent (Antigravity, Claude, Gemini, v.v.) nhận yêu cầu từ Người dùng liên quan đến việc:
  - Phân tích luồng thực thi (execution flow) hoặc call stack giữa JSP, Servlet, Service và DAO.
  - Tra cứu thông tin, vị trí định nghĩa hoặc mối quan hệ gọi hàm (caller/callee) của một symbol, class, method.
  - Tìm kiếm toàn bộ các điểm liên quan trong vòng đời của một entity (ví dụ: `Book`, `BookCopy`, `BorrowRecord`, `Reservation`).
  - Đánh giá tác động (impact analysis) trước khi refactor hoặc sửa code.
* AI Agent **BẮT BUỘC PHẢI GỌI CODEGRAPH ĐẦU TIÊN** qua MCP tool `codegraph_explore` (hoặc lệnh shell `codegraph explore`) TRƯỚC KHI thực hiện grep, search_web, hay view_file thủ công.

## 2. NGUYÊN TẮC THỰC HIỆN
1. **Không đoán code hay tìm mù (No Blind Grep):** CodeGraph cung cấp đường đi chính xác của các biến, method và dispatch động. Sử dụng CodeGraph giúp loại bỏ giả định sai lệch.
2. **Khai thác triệt để Call Graph:** Khi truy vết một tính năng (ví dụ Check-out, Reservation, Renewal), dùng `codegraph_explore` với câu lệnh mô tả symbol hoặc nghiệp vụ để nhận toàn bộ bức tranh kiến trúc chỉ trong 1 lần gọi.
3. **Cập nhật & Tái sử dụng:** Sau khi CodeGraph trả về vị trí mã nguồn chính xác, mới tiến hành dùng `view_file` hoặc `replace_file_content` để chỉnh sửa code.
