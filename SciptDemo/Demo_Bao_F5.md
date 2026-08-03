# 🎬 Kịch bản Demo F5 — Đặt trước & Gia hạn Sách Trực tuyến (Lê Thế Bảo)

## 📌 Hướng Dẫn Chuẩn Bị CSDL Trước Khi Demo

> **Quy trình reset & khởi tạo CSDL:**
> 1. Chạy toàn bộ các file seed mặc định từ `01_truncate_all.sql` đến `06_email_templates.sql`.
> 2. Mở file SQL riêng **[Script_Demo_Bao.sql](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/SciptDemo/Script_Demo_Bao.sql)**, dán toàn bộ vào Supabase SQL Editor và bấm **RUN**.

---

## 📋 Danh Sách Tài Khoản & Phân Vai Thuyết Trình

> [!TIP]
> **Kịch bản tương tác kịch tính:**
> 1. `studentB1` đặt trước sách hết (Clean Code -> pending #1) và đặt sách có sẵn (Corporate Finance -> readypickup #0).
> 2. `studentB2` đặt ngay đằng sau Corporate Finance (pending #1).
> 3. `studentB1` bấm Hủy Corporate Finance -> `studentB2` đăng nhập kiểm tra **THẤY TỰ ĐỘNG ĐÔN LÊN READYPICKUP #0 LIVE**!

| # | Tài Khoản | Mật Khẩu | Role | Vai Trò & Chuỗi Thao Tác Demo |
|---|-----------|----------|------|-------------------------------|
| 1️⃣ | `studentB1@lms.com` | `studentB1@lms.com` | Sinh viên | **Tài khoản chính (Live 100%):** Đặt Clean Code (Pending #1) → Đặt Corporate Finance (ReadyPickup #0) → Gia hạn Algorithms OK → Hủy Corporate Finance (đôn B2 lên #0) |
| 2️⃣ | `studentB2@lms.com` | `studentB2@lms.com` | Sinh viên | **Tài khoản xếp hàng & Nhận đôn hàng:** Đặt Corporate Finance đằng sau B1 (Pending #1) → Thấy tự đôn lên #0 sau khi B1 hủy → Hủy đơn #0 (trả kho) |
| 3️⃣ | `lecturerB1@lms.com` | `lecturerB1@lms.com` | Giảng viên | **Test các case Gia Hạn FAIL:** Thử gia hạn chưa 50% → Thử gia hạn hết 2 lượt → Thử gia hạn sách có người chờ |
| 4️⃣ | `studentB3@lms.com` | `studentB3@lms.com` | Sinh viên | **Test Chạm Trần Quota:** Đã có 3/3 đơn → Thử đặt thêm cuốn thứ 4 (Bị chặn) |
| 5️⃣ | `studentB4@lms.com` & `studentB5@lms.com` | *(như email)* | Sinh viên | **Test Ràng Buộc Khóa & Phạt:** B4 bị khóa TK → B5 bị nợ phạt 15k (Đều bị chặn khi đặt trước) |

---

## ⚙️ Các Tham Số Cấu Hình Chứng Minh Trong Demo

| Config Key | Giá trị | Ý nghĩa nghiệp vụ | Chứng minh ở Tài khoản nào? |
|------------|---------|--------------------|----------------------------|
| `STUDENT_MAX_BORROW_LIMIT` | **3** | SV mượn+đặt trước tối đa 3 cuốn | `studentB1` & `studentB3` |
| `LECTURER_MAX_BORROW_LIMIT` | **5** | GV mượn+đặt trước tối đa 5 cuốn | *(cấu hình hệ thống)* |
| `STUDENT_MAX_BORROW_DAYS` | **5** | SV mượn tối đa 5 ngày | `studentB1` (TC-Renew-01) |
| `LECTURER_MAX_BORROW_DAYS` | **10** | GV mượn tối đa 10 ngày | `lecturerB1` (TC-Renew-02) |
| `MAX_EXTENSION_COUNT` | **2** | Tối đa 2 lần gia hạn | `lecturerB1` (TC-Renew-03) |
| `RENEW_DURATION_DAYS` | **5** | Mỗi lần gia hạn thêm 5 ngày | `studentB1` (TC-Renew-01) |
| `RENEW_THRESHOLD_PERCENT` | **50** | Phải mượn qua 50% thời hạn mới được gia hạn | `studentB1` & `lecturerB1` |
| `RESERVATION_HOLD_DAYS` | **1** | Giữ sách 1 ngày, quá hạn tự hủy | `studentB1` (TC-Res-01) |
| `FINE_RATE_PER_DAY` | **5,000₫** | Mức phạt 5,000đ/ngày trễ hạn | `studentB5` (TC-Res-05) |

---

## 🎯 TIẾN TRÌNH THUYẾT TRÌNH LIVE TƯƠNG TÁC KỊCH TÍNH (~12 PHÚT)

### 1️⃣ BƯỚC 1: Đăng nhập `studentB1@lms.com` lần 1 ~ 2 phút

- **Thao tác 1 (TC-Res-02 — Đặt trước sách hết → vào hàng chờ):**
  - Tìm sách **"Clean Code"** (available = 0) → Bấm **"Đặt trước"**.
  - **Kết quả:** Đặt thành công vào hàng chờ (`pending`) ở **Position 1**! *(Quota B1: 1/3 -> 2/3)*.

- **Thao tác 2 (TC-Res-01 — Đặt trước sách có sẵn → Lấy cuốn cuối):**
  - Tìm sách **"Corporate Finance"** (available = 1) → Bấm **"Đặt trước"**.
  - **Kết quả:** Đặt thành công đơn `readypickup` Position 0! `availableQuantity` của *Corporate Finance* giảm từ 1 xuống 0! *(Quota B1: 2/3 -> 3/3 FULL)*.

- **Thao tác 3 (TC-Renew-01 — Gia hạn sách đang mượn):**
  - Vào **Sách của tôi** → Chọn cuốn **"Algorithms"** (đã mượn 4/5 ngày = 80% > 50%) → Bấm **"Gia hạn"**.
  - **Kết quả:** Gia hạn thành công! Hạn trả dời thêm +5 ngày (`RENEW_DURATION_DAYS = 5`), `extensionCount` tăng từ 0 lên 1. Quota giữ 3/3.

👉 **ĐĂNG XUẤT `studentB1`**.

---

### 2️⃣ BƯỚC 2: Đăng nhập `studentB2@lms.com` lần 1 ~ 1 phút

- **Thao tác 1 (Xếp hàng đằng sau B1 cuốn Corporate Finance):**
  - Tìm sách **"Corporate Finance"** (vừa bị B1 lấy mất cuốn cuối ở Bước 1 → available = 0!) → Bấm **"Đặt trước"**.
  - **Kết quả:** Đặt thành công vào hàng chờ (`pending`) ở **Position 1** đằng sau B1!

👉 **ĐĂNG XUẤT `studentB2`**.

---

### 3️⃣ BƯỚC 3: Đăng nhập lại `studentB1@lms.com` lần 2 ~ 1 phút

- **Thao tác 1 (TC-Cancel-02 — Hủy đơn Corporate Finance để đôn B2 ⭐ HIGHLIGHT):**
  - Vào **Sách của tôi**, bấm **"Hủy đặt trước"** cuốn **"Corporate Finance"** (đơn vừa nhận #0 ở Bước 1).
  - **Kết quả:** Đơn `studentB1` chuyển `cancelled`! Quota `studentB1` giảm về 2/3.
  - ⭐ **HIGHLIGHT CỰC MẠNH VỚI GIẢNG VIÊN:** Suất này ngay lập tức được hệ thống tự động chuyển sang cho `studentB2` đằng sau!

👉 **ĐĂNG XUẤT `studentB1`**.

---

### 4️⃣ BƯỚC 4: Đăng nhập lại `studentB2@lms.com` lần 2 ~ 2 phút

- **Thao tác 1 (Kiểm tra đôn hàng tự động từ B1 live):**
  - Vào ngay màn **Sách của tôi**.
  - **Kết quả:** Đơn cuốn **"Corporate Finance"** (vốn ở pending position 1 đằng sau B1) **ĐÃ TỰ ĐỘNG CHUYỂN THÀNH `readypickup` POSITION 0**!

- **Thao tác 2 (TC-Cancel-03 — Hủy đơn readypickup vừa được đôn):**
  - Bấm **"Hủy đặt trước"** cuốn **"Corporate Finance"** vừa nhảy lên #0.
  - **Kết quả:** Hủy thành công. Suất sách được trả về kho: `availableQuantity` tăng từ 0 lên 1!

- **Thao tác 3 (TC-Cancel-01 — Hủy đơn pending trong hàng chờ):**
  - Bấm **"Hủy đặt trước"** đơn `pending` cuốn **"AI Modern Approach"** (position 1).
  - **Kết quả:** Hủy đơn hàng chờ thành công, vị trí hàng chờ được cập nhật.

👉 **ĐĂNG XUẤT `studentB2`**.

---

### 5️⃣ BƯỚC 5: Giảng viên & Các Tài khoản Khóa/Phạt (`lecturerB1`, `studentB3`, `B4`, `B5`) ~ 4 phút

- **`lecturerB1@lms.com`:**
  - Gia hạn *Macroeconomics* (mượn 1/10 ngày = 10% < 50%) → ❌ Bị chặn.
  - Gia hạn *Introduction to Politics* (`extensionCount = 2`) → ❌ Bị chặn.
  - Gia hạn *Designing Data-Intensive Applications* (có `studentB2` đang chờ) → ❌ Bị chặn.
- **`studentB3@lms.com`:** Đã có 3/3 đơn → Thử đặt thêm cuốn 4 → ❌ Bị chặn Quota 3/3.
- **`studentB4@lms.com`:** Trạng thái khóa → Thử đặt trước → ❌ Bị chặn TK locked.
- **`studentB5@lms.com`:** Nợ phạt 15,000đ → Thử đặt trước → ❌ Bị chặn nợ phạt (BR-22).

---

## 📊 Kịch Bản Trình Bày Timeline Tóm Tắt

```mermaid
timeline
    title Tiến trình Demo F5 Phân Theo Tương Tác Live (~12 Phút)
    00:00 - 02:00 : studentB1 Lần 1 : Đặt Clean Code (pending #1) -> Đặt Corporate Finance (readypickup #0) -> Gia hạn Algorithms OK
    02:00 - 03:00 : studentB2 Lần 1 : Đặt Corporate Finance đằng sau B1 (pending #1)
    03:00 - 04:00 : studentB1 Lần 2 : Hủy Corporate Finance -> Giải phóng suất đôn B2
    04:00 - 06:00 : studentB2 Lần 2 : Thấy Corporate Finance tự đôn lên #0 LIVE -> Hủy đơn #0 trả kho -> Hủy pending #1 AI
    06:00 - 12:00 : lecturerB1 & B3-B5 : Test 3 case gia hạn FAIL (GV) -> Test trần Quota 3/3 (B3) -> Test TK Khóa (B4) & Nợ phạt 15k (B5)
```
