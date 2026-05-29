# Feature Specification: feat-catalog-search (Danh mục, Kho sách & Tìm kiếm, Gợi ý AI)
# Version: 1.0.0 | Owner: Member 2 | Date: 2026-05-29

---

## 1. Context & Goal

**Mục tiêu:** Quản lý kho thông tin sách bao gồm thông tin thư tịch (Books), danh mục phân loại (Category, Tag), trạng thái của từng cuốn sách vật lý (BookCopy), đồng thời hỗ trợ tìm kiếm hiệu năng cao cho người dùng và hiển thị gợi ý sách cá nhân hóa thông qua API OpenAI/Gemini.

---

## 2. Actors & Roles

- **Guest / Student / Lecturer:** Tìm kiếm sách trực tuyến, xem vị trí và trạng thái khả dụng của từng cuốn. Nhận gợi ý sách cá nhân hóa khi xem thông tin profile.
- **Librarian:** Quản lý việc thêm/sửa sách, nhập danh mục, gắn thẻ (tag) và cập nhật tình trạng vật lý của từng bản copy (Good, Damaged, Lost).
- **Library Manager / Admin:** Cập nhật hoặc cấu hình API giới hạn liên quan đến catalog.

---

## 3. Functional Requirements

### UC-03 — Tìm kiếm & Gợi ý Sách
- **FR06 (Tìm kiếm Đầu sách):** Hệ thống trả về danh sách các tựa sách dựa trên từ khóa tìm kiếm (tiêu đề, tác giả, danh mục, thẻ).
- **FR07 (Xem trạng thái Kho):** Hệ thống hiển thị số lượng bản sao sách vật lý hiện đang có sẵn để mượn đối với một tựa sách cụ thể (`available_quantity` thời gian thực).
- **FR08 (Gợi ý Sách (AI)):** Hệ thống sử dụng AI phân tích lịch sử để đưa ra danh sách các tựa sách đề xuất cá nhân hóa. Kết quả gợi ý chỉ mang tính tham khảo (Tuân thủ BR18).

### UC-08 — Quản lý Danh mục Sách
- **FR18 (Quản lý Đầu sách):** Thủ thư thực hiện thêm, sửa, xóa (soft-delete status) thông tin trừu tượng của các tựa sách (ISBN, Tên, Tác giả, Nhà XB, năm XB, giá tiền, số lượng). Validate: `ISBN` độc nhất, giá và số lượng $\ge$ 0. Nếu trùng ISBN đưa ra lựa chọn ghi đè, bỏ qua hoặc gộp số lượng.
- **FR19 (Quản lý Phân loại):** Thủ thư thực hiện thêm, sửa, xóa các Danh mục (Category) và Thẻ (Tag).

### UC-09 — Quản lý Kho Vật lý
- **FR20 (Quản lý Mã vạch):** Thủ thư thêm mới và sinh mã vạch (`barcode` độc nhất) cho từng cuốn sách vật lý nhập kho và gán vị trí (`location`).
- **FR21 (Cập nhật Hao mòn):** Thủ thư ghi nhận lại tình trạng vật lý thực tế của sách (`condition` ∈ {good, damaged, lost}). Bản sao sách vật lý nếu bị Thủ thư ghi nhận là "Hư hỏng nặng" (damaged) hoặc "Đã mất" (lost) sẽ tự động bị loại khỏi danh sách có thể mượn hoặc phân bổ cho hàng chờ (`status = 'unavailable'`, trừ `available_quantity` đi 1, tuân thủ BR13).

---

## 4. Non-functional Requirements

- **Performance:** Tìm kiếm sách phải trả kết quả trong ≤ 2 giây đối với kho dữ liệu lên tới 500,000 bản ghi (FR06).
- **Integrations:** Tích hợp API OpenAI hoặc Gemini thông qua biến môi trường cấu hình trong hệ thống để tránh hardcode API key.
- **Data Integrity:** Các trường bắt buộc như ISBN, barcode không được phép null hoặc rỗng.

---

## 5. Data (Các bảng liên quan)

Tham chiếu các bảng từ database:
- `Category`
- `Tag`
- `Books`
- `BookCategory`
- `BookTag`
- `BookCopy` (Tuân thủ BR13 cho thuộc tính condition/status)

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| ISBN bị trùng khi thêm thủ công | Hiển thị thông báo lỗi trùng lặp và hỏi ý kiến thủ thư muốn ghi đè hoặc cộng dồn số lượng. |
| Bản ghi sách bị thiếu trường bắt buộc | Gán trạng thái tựa sách là `unavailable` để tránh hiển thị lỗi trên UI tìm kiếm của người dùng. |
| Gọi API AI thất bại / Timeout (BR18) | Tự động chuyển sang danh sách gợi ý mặc định (sách mượn nhiều nhất) và không làm sập trang profile. |
| Giá sách bị NULL khi tính phạt (đền bù/trễ hạn) | Hệ thống tự động sử dụng giá trị giá sách mặc định (`default_book_price`) cấu hình trong `SystemConfigurations` để làm cơ sở tính toán nhằm tránh lỗi `NullPointerException` (Tuân thủ BR20). |

---

## 7. Acceptance Criteria

- [ ] Tìm kiếm sách theo từ khóa hiển thị kết quả chính xác kèm số lượng sách khả dụng thời gian thực (FR06, FR07).
- [ ] Thủ thư cập nhật trạng thái bản sao là 'lost' -> tự động loại khỏi danh sách mượn/hàng chờ, khả dụng giảm 1 (BR13, FR21).
- [ ] Giao diện gợi ý AI hiển thị đúng danh sách gợi ý cá nhân hóa cho học sinh đã đăng nhập (FR08). Quyết định cuối cùng do con người (BR18).
- [ ] Validation ISBN kiểm tra tính độc nhất trước khi cho phép lưu sách mới vào DB.
- [ ] Khi trường giá sách bị NULL, hệ thống tự động fallback sử dụng `default_book_price` khi tính toán phạt đền bù/quá hạn.

---

## 8. Out of Scope

- Tích hợp cổng thông tin Z39.50 nhập sách tự động từ thư viện quốc gia.
- Quét barcode của nhà xuất bản ngoài để tự động điền metadata (chỉ dùng barcode nội bộ thư viện).
