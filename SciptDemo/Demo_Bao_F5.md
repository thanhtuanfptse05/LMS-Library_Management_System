# 🎬 Kịch bản Demo F5 — Đặt trước & Gia hạn Sách Trực tuyến (Lê Thế Bảo)

## 📌 Hướng Dẫn Chuẩn Bị CSDL Trước Khi Demo

> **Quy trình reset & khởi tạo CSDL:**
> 1. Chạy toàn bộ các file seed mặc định từ `01_truncate_all.sql` đến `06_email_templates.sql`.
> 2. Mở file [Script_Demo_Bao.sql](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/SciptDemo/Script_Demo_Bao.sql), dán vào Supabase SQL Editor và bấm **RUN**.

---

## 📋 Danh Sách Tài Khoản Demo

| Email | Mật khẩu | Role | Mã SV/GV | Vai trò trong Demo |
|-------|----------|------|----------|-------------------|
| `studentB1@lms.com` | `studentB1@lms.com` | Sinh viên | `HE180001` | 🟢 Happy Path + Gia hạn OK |
| `studentB2@lms.com` | `studentB2@lms.com` | Sinh viên | `HE180B02` | 🟡 Xếp hàng chờ + Hủy đặt trước |
| `studentB3@lms.com` | `studentB3@lms.com` | Sinh viên | `HE180B03` | 🔴 Bị chặn: Đạt trần quota (3/3) |
| `studentB4@lms.com` | `studentB4@lms.com` | Sinh viên | `HE180B04` | 🔴 Bị chặn: Tài khoản bị khóa |
| `studentB5@lms.com` | `studentB5@lms.com` | Sinh viên | `HE180B05` | 🔴 Bị chặn: Đang nợ phạt 15k |
| `lecturerB1@lms.com` | `lecturerB1@lms.com` | Giảng viên | `LECB01` | 🟢 Các case gia hạn FAIL |
| `adminB1@lms.com` | `adminB1@lms.com` | Admin | `ADB01` | Xem / chỉnh sửa Cấu hình |

---

## ⚙️ Các Tham Số Cấu Hình Chứng Minh Trong Demo

| Config Key | Giá trị | Ý nghĩa nghiệp vụ | Demo chứng minh |
|------------|---------|--------------------|------------------|
| `STUDENT_MAX_BORROW_LIMIT` | **3** | SV mượn+đặt trước tối đa 3 cuốn | TC-Res-03 |
| `LECTURER_MAX_BORROW_LIMIT` | **5** | GV mượn+đặt trước tối đa 5 cuốn | *(cấu hình hệ thống)* |
| `STUDENT_MAX_BORROW_DAYS` | **5** | SV mượn tối đa 5 ngày | TC-Renew-01 |
| `LECTURER_MAX_BORROW_DAYS` | **10** | GV mượn tối đa 10 ngày | TC-Renew-02 |
| `MAX_EXTENSION_COUNT` | **2** | Tối đa 2 lần gia hạn | TC-Renew-03 |
| `RENEW_DURATION_DAYS` | **5** | Mỗi lần gia hạn thêm 5 ngày | TC-Renew-01 |
| `RENEW_THRESHOLD_PERCENT` | **50** | Phải mượn qua 50% thời hạn mới được gia hạn | TC-Renew-01, TC-Renew-02 |
| `RESERVATION_HOLD_DAYS` | **1** | Giữ sách 1 ngày, quá hạn tự hủy | TC-Res-01 |
| `FINE_RATE_PER_DAY` | **5,000₫** | Mức phạt 5,000đ/ngày trễ hạn | TC-Res-05 |

---

## 🎯 Chi Tiết 12 Test Cases Demo

### 1️⃣ Nhóm Đặt Trước Sách (Reserve Book Online)

#### ✅ TC-Res-01: Đặt trước sách còn sẵn → readypickup (PASS)
- **Tài khoản:** `studentB1@lms.com`
- **Thao tác:** Tìm sách **"Clean Code"** (available = 1) → Bấm **"Đặt trước"**.
- **Kết quả:** Đặt trước thành công, tạo đơn `readypickup` kèm countdown timer 1 ngày (dựa trên `RESERVATION_HOLD_DAYS = 1`). `availableQuantity` của sách giảm còn 0.

#### ✅ TC-Res-02: Đặt trước sách hết → xếp hàng chờ (PASS)
- **Tài khoản:** `studentB1@lms.com`
- **Thao tác:** Tìm sách **"Designing Data-Intensive Applications"** (available = 0) → Bấm **"Đặt trước"**.
- **Kết quả:** Đặt thành công vào hàng chờ (`pending`), hiển thị rõ vị trí **Position 2** (sau `studentB2` position 1).

#### ❌ TC-Res-03: Đạt giới hạn quota 3/3 → bị chặn (FAIL)
- **Tài khoản:** `studentB3@lms.com`
- **Thao tác:** Đăng nhập thấy đã có 3 đơn `readypickup` → Tìm sách bất kỳ → Bấm **"Đặt trước"**.
- **Kết quả:** Bị hệ thống chặn với thông báo: *"Bạn đã đạt giới hạn tối đa mượn và đặt trước sách (3 cuốn)."* (Chứng minh `STUDENT_MAX_BORROW_LIMIT = 3`).

#### ❌ TC-Res-04: Tài khoản bị khóa → bị chặn (FAIL)
- **Tài khoản:** `studentB4@lms.com`
- **Thao tác:** Tìm sách bất kỳ → Bấm **"Đặt trước"**.
- **Kết quả:** Bị chặn: *"Tài khoản của bạn hiện đang bị khóa hoặc ngưng hoạt động."*

#### ❌ TC-Res-05: Đang nợ phạt chưa trả → bị chặn (FAIL)
- **Tài khoản:** `studentB5@lms.com`
- **Thao tác:** Tìm sách bất kỳ → Bấm **"Đặt trước"**.
- **Kết quả:** Bị chặn do có khoản phạt `15,000₫` chưa thanh toán. (Chứng minh quy tắc BR-22).

---

### 2️⃣ Nhóm Gia Hạn Sách (Renew Book Online)

#### ✅ TC-Renew-01: Gia hạn thành công (PASS)
- **Tài khoản:** `studentB1@lms.com`
- **Thao tác:** Vào **Sách của tôi** → Chọn cuốn **"Algorithms"** (đã mượn 4/5 ngày = 80% > 50%) → Bấm **"Gia hạn"**.
- **Kết quả:** Gia hạn thành công! Hạn trả dời thêm +5 ngày (`RENEW_DURATION_DAYS = 5`), `extensionCount` tăng từ 0 lên 1.

#### ❌ TC-Renew-02: Chưa đủ 50% thời hạn mượn → từ chối (FAIL)
- **Tài khoản:** `lecturerB1@lms.com`
- **Thao tác:** Chọn cuốn **"Macroeconomics"** (mượn 1/10 ngày = 10% < 50%) → Bấm **"Gia hạn"**.
- **Kết quả:** Bị chặn: *"Bạn chỉ được gia hạn khi đã sử dụng ít nhất 50% thời hạn mượn sách."* (Chứng minh `RENEW_THRESHOLD_PERCENT = 50`).

#### ❌ TC-Renew-03: Hết 2 lần gia hạn cho phép → từ chối (FAIL)
- **Tài khoản:** `lecturerB1@lms.com`
- **Thao tác:** Chọn cuốn **"Introduction to Politics"** (`extensionCount = 2`) → Bấm **"Gia hạn"**.
- **Kết quả:** Bị chặn: *"Bạn đã vượt quá số lần gia hạn cho phép cho cuốn sách này (2 lần)."* (Chứng minh `MAX_EXTENSION_COUNT = 2`).

#### ❌ TC-Renew-04: Sách đang có người xếp hàng chờ → từ chối (FAIL)
- **Tài khoản:** `lecturerB1@lms.com`
- **Thao tác:** Chọn cuốn **"Designing Data-Intensive Applications"** (có `studentB2` đang chờ tại position 1) → Bấm **"Gia hạn"**.
- **Kết quả:** Bị chặn: *"Sách này đang có độc giả khác xếp hàng chờ đặt trước, không thể gia hạn."* (Chứng minh quy tắc BR-21 điều kiện 3).

---

### 3️⃣ Nhóm Hủy Đặt Trước (Cancel Reservation)

#### ✅ TC-Cancel-01: Hủy đơn pending → hàng đợi tự dịch vị trí (PASS)
- **Tài khoản:** `studentB2@lms.com`
- **Thao tác:** Vào **Sách của tôi** → Hủy đơn `pending` cuốn **"AI Modern Approach"** (position 1).
- **Kết quả:** Hủy thành công. Đơn của `studentB1` (ở position 2) tự động được đôn lên **position 1**.

#### ✅ TC-Cancel-02: Hủy readypickup + có người chờ → cascade đôn hàng (PASS) ⭐ HIGHLIGHT
- **Tài khoản:** `studentB1@lms.com`
- **Thao tác:** Hủy đơn `readypickup` cuốn **"Corporate Finance"** (có `studentB2` đang pending position 1).
- **Kết quả:** Đơn `studentB1` chuyển `cancelled`. Đơn `studentB2` **tự động chuyển thành `readypickup`** (queuePosition = 0). `availableQuantity` của sách **giữ nguyên** vì suất được chuyển cho `studentB2`.

#### ✅ TC-Cancel-03: Hủy readypickup + không ai chờ → trả sách về kho (PASS)
- **Tài khoản:** `studentB2@lms.com`
- **Thao tác:** Hủy đơn `readypickup` cuốn **"Corporate Finance"** vừa nhận từ TC-Cancel-02 (lúc này không còn ai chờ nữa).
- **Kết quả:** Hủy thành công. Suất sách được trả về kho: `availableQuantity` tăng từ 0 lên 1.

---

## 📊 Kịch Bản Trình Bày 12 Phút Khuyến Nghị

```mermaid
timeline
    title Tiến trình Demo F5 (~12 Phút)
    00:00 - 04:00 : Đặt trước Sách : TC-Res-01 (Happy Path) -> TC-Res-03 (Chạm Quota) -> TC-Res-04 (TK Khóa) -> TC-Res-05 (Nợ Phạt)
    04:00 - 08:00 : Gia hạn Sách : TC-Renew-01 (Gia hạn OK) -> TC-Renew-02 (Chưa 50%) -> TC-Renew-03 (Max 2 Lần) -> TC-Renew-04 (Có Người Chờ)
    08:00 - 12:00 : Hủy đặt trước : TC-Cancel-02 (Cascade Đôn Hàng) -> TC-Cancel-01 (Dịch Queue) -> TC-Cancel-03 (Trả Số Lượng)
```

| Thời lượng | Nội dung demo | Tài khoản | Điểm nhấn giải thích với Giảng viên |
|------------|---------------|-----------|------------------------------------|
| **1.5 phút** | **TC-Res-01:** Đặt trước thành công | `studentB1` | Giới thiệu giao diện đặt trước & countdown timer hold hold 1 ngày |
| **1.0 phút** | **TC-Res-03:** Chặn vượt quota 3/3 | `studentB3` | Chứng minh cấu hình `STUDENT_MAX_BORROW_LIMIT = 3` |
| **1.0 phút** | **TC-Res-04 & 05:** Chặn khóa & Nợ phạt | `studentB4`, `studentB5` | Kiểm soát bảo mật role & quy tắc nợ phạt BR-22 |
| **1.5 phút** | **TC-Renew-01:** Gia hạn thành công | `studentB1` | Tính % thời gian mượn thực tế + dời hạn trả 5 ngày |
| **1.0 phút** | **TC-Renew-02:** Chặn chưa đủ 50% | `lecturerB1` | Chứng minh ngưỡng `RENEW_THRESHOLD_PERCENT = 50%` |
| **1.0 phút** | **TC-Renew-03:** Chặn hết 2 lần | `lecturerB1` | Chứng minh giới hạn `MAX_EXTENSION_COUNT = 2` |
| **1.0 phút** | **TC-Renew-04:** Chặn khi có người chờ | `lecturerB1` | Bảo vệ quyền ưu tiên cho độc giả đang xếp hàng |
| **1.5 phút** | **TC-Cancel-02:** Cascade đôn hàng | `studentB1` | **Feature nổi bật:** Đôn hàng tự động mà không đổi `availableQuantity` |
| **1.0 phút** | **TC-Cancel-01:** Dịch vị trí queue | `studentB2` | Tự động cập nhật `queuePosition` cho người đằng sau |
| **1.0 phút** | **TC-Cancel-03:** Hủy trả số lượng | `studentB2` | Tự động phục hồi `availableQuantity` cho kho sách |
