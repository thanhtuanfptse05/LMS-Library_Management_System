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

### UC-08 — Quản lý Danh mục Sách
- **FR-CAT-01:** Thủ thư thêm mới hoặc chỉnh sửa thông tin sách: `ISBN`, `title`, `author`, `publisher`, `publication_year`, `price`, `total_quantity`.
  - Validate: `ISBN` là duy nhất, `title` không rỗng, `publication_year` không được lớn hơn năm hiện tại, `price` ≥ 0, `total_quantity` ≥ 0.
- **FR-CAT-02:** Phát hiện trùng lặp ISBN khi thêm sách: Hệ thống đưa ra lựa chọn ghi đè (overwrite), bỏ qua (skip) hoặc gộp số lượng (merge).

### UC-09 — Quản lý Kho Vật lý (BookCopy)
- **FR-INV-01:** Mỗi tựa sách (Books) liên kết với nhiều bản sao vật lý (`BookCopy`). Mỗi bản sao có mã `barcode` độc nhất để quét và `location` cụ thể trong thư viện.
- **FR-INV-02:** Cập nhật tình trạng bản sao (`condition` ∈ {good, damaged, lost}). Khi `condition = 'lost'`, trạng thái copy chuyển thành `'unavailable'`, đồng thời `available_quantity` của tựa sách đó bị trừ đi 1.

### UC-03 — Tìm kiếm & Gợi ý Sách
- **FR-SRCH-01:** Người dùng tìm kiếm sách theo từ khóa (khớp tiêu đề, tác giả), danh mục hoặc tag. Kết quả tìm kiếm hiển thị trạng thái và `available_quantity` thời gian thực.
- **FR-SRCH-02 (AI Recommendation):** Khi người dùng đã đăng nhập xem profile hoặc chi tiết sách, hệ thống gọi API OpenAI/Gemini bất đồng bộ để đưa ra gợi ý sách dựa trên lịch sử mượn và chuyên ngành (major) của người dùng đó.

---

## 4. Non-functional Requirements

- **Performance:** Tìm kiếm sách phải trả kết quả trong ≤ 2 giây đối với kho dữ liệu lên tới 500,000 bản ghi.
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
- `BookCopy`

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| ISBN bị trùng khi thêm thủ công | Hiển thị thông báo lỗi trùng lặp và hỏi ý kiến thủ thư muốn ghi đè hoặc cộng dồn số lượng. |
| Bản ghi sách bị thiếu trường bắt buộc | Gán trạng thái tựa sách là `unavailable` để tránh hiển thị lỗi trên UI tìm kiếm của người dùng. |
| Gọi API AI thất bại / Timeout | Tự động chuyển sang danh sách gợi ý mặc định (sách mượn nhiều nhất) và không làm sập trang profile. |

---

## 7. Acceptance Criteria

- [ ] Tìm kiếm sách theo từ khóa hiển thị kết quả chính xác kèm số lượng sách khả dụng thời gian thực.
- [ ] Thủ thư cập nhật trạng thái bản sao là 'lost' -> khả dụng giảm 1 và không thể quét để mượn bản sao đó nữa.
- [ ] Giao diện gợi ý AI hiển thị đúng danh sách gợi ý cá nhân hóa cho học sinh đã đăng nhập.
- [ ] Validation ISBN kiểm tra tính độc nhất trước khi cho phép lưu sách mới vào DB.

---

## 8. Out of Scope

- Tích hợp cổng thông tin Z39.50 nhập sách tự động từ thư viện quốc gia.
- Quét barcode của nhà xuất bản ngoài để tự động điền metadata (chỉ dùng barcode nội bộ thư viện).
