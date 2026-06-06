# CONTEXT.md — Quản lý Đặt trước và Gia hạn trực tuyến (Feature 5)
# Phiên bản: 1.0.0 | Ngày: 2026-06-06

## 1. PROBLEM STATEMENT
Sinh viên và Giảng viên cần công cụ tự phục vụ (Self-service) để giữ chỗ tài liệu từ xa và kéo dài thời gian mượn mà không cần trực tiếp đến quầy. Hệ thống cần giải quyết bài toán cấp phát công bằng khi sách hết (xếp hàng đợi) và đảm bảo sách đang có người chờ sẽ không bị người đang cầm gia hạn (chiếm dụng tài nguyên).

## 2. DOMAIN KNOWLEDGE
- **Reservation (Đặt trước):** Chia làm 2 nhóm. 
  + `queuePosition = 0` và `status = 'readypickup'`: Sách đã có sẵn trong kho, đang được giữ cho người này.
  + `queuePosition > 0` và `status = 'pending'`: Sách đang được mượn hết, người này đang đứng chờ.
- **Renewal (Gia hạn):** Hành động kéo dài `endDate` của một `BorrowRecord` đang active, bị giới hạn bởi số lần (`extensionCount`) và thời điểm.

## 3. STAKEHOLDERS
- **Student / Lecturer (Người dùng):** Khách hàng trực tiếp sử dụng tính năng từ xa.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Data Integrity:** Không cho phép gia hạn nếu đang có Reservation chờ (queuePosition > 0) cho đầu sách đó (BR-21).
- **Concurrency:** Tranh chấp đặt trước sách (queue 0 vs queue > 0) BẮT BUỘC sử dụng Transaction lock hoặc atomic update để tránh cấp phát vượt quá `availableQuantity`.

## 5. ASSUMPTIONS
- Các giới hạn tối đa (max extension count, min time % to renew, max reservations) được lấy linh động từ bảng `SystemConfigurations`.
- F5 chỉ thực hiện sinh đơn, việc kích hoạt trigger cấp phát (chuyển queue 1 thành 0) sẽ diễn ra ở F6 (khi người trước trả sách) hoặc background job.
