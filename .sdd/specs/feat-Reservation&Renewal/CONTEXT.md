# CONTEXT.md — Quản lý Đặt trước và Gia hạn trực tuyến (Feature 5)
# Phiên bản: 1.1.0 | Ngày: 2026-06-24

## 1. PROBLEM STATEMENT
Sinh viên và Giảng viên cần công cụ tự phục vụ (Self-service) để giữ chỗ tài liệu từ xa và kéo dài thời gian mượn mà không cần trực tiếp đến quầy. Hệ thống cần giải quyết bài toán cấp phát công bằng khi sách hết (xếp hàng đợi) và đảm bảo sách đang có người chờ sẽ không bị người đang cầm gia hạn (chiếm dụng tài nguyên).

## 2. DOMAIN KNOWLEDGE
- **Reservation (Đặt trước):** Chia làm 2 nhóm. 
  + `queuePosition = 0` và `status = 'readypickup'`: Sách đã có sẵn trong kho, đang được giữ cho người này.
  + `queuePosition > 0` và `status = 'pending'`: Sách đang được mượn hết, người này đang đứng chờ.
- **Hạn lấy sách đặt trước:** Khi đơn đặt trước chuyển sang `'readypickup'`, `endDate` được thiết lập làm hạn chót nhận sách (được lấy động từ cấu hình `RESERVATION_HOLD_DAYS` trong bảng `SystemConfigurations`, mặc định là 3 ngày). Nếu sau thời gian này độc giả không nhận sách, đơn đặt trước sẽ bị quá hạn.
- **Renewal (Gia hạn):** Hành động kéo dài `endDate` của một `BorrowRecord` đang active, bị giới hạn bởi số lần (`extensionCount`) và thời điểm.

## 3. STAKEHOLDERS
- **Student / Lecturer (Người dùng):** Khách hàng trực tiếp sử dụng tính năng từ xa.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Data Integrity:** Không cho phép gia hạn nếu đang có Reservation chờ (queuePosition > 0) cho đầu sách đó (BR-21).
- **Concurrency:** Tranh chấp đặt trước sách (queue 0 vs queue > 0) BẮT BUỘC sử dụng Transaction lock hoặc atomic update để tránh cấp phát vượt quá `availableQuantity`.

## 5. ASSUMPTIONS
- Các giới hạn tối đa và thời gian giữ sách đặt trước (max extension count, min time % to renew, max reservations, `RESERVATION_HOLD_DAYS`) được lấy linh động từ bảng `SystemConfigurations`.
- F5 thực hiện sinh đơn đặt trước trực tuyến. Việc kích hoạt trigger cấp phát (chuyển queue 1 thành 0) sẽ diễn ra ở F6 (khi trả sách tốt tại quầy) hoặc thông qua tiến trình ngầm **Reservation Expiration** chạy định kỳ mỗi 1 giờ.
