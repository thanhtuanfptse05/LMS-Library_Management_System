# Implementation Plan: System Configuration (Cấu hình hệ thống)

**Branch**: `main` | **Date**: 2026-07-21 | **Spec**: [SPEC.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-systemConfiguration/SPEC.md)

## Summary (Tóm tắt)
Triển khai hệ thống Quản lý Cấu hình hệ thống động (System Configuration), cho phép Quản trị viên (Admin) và Admin xem, cập nhật các thông số nghiệp vụ (phí phạt, thời gian mượn, hạn mức gia hạn, thông tin cổng SePay, API key AI) trực tiếp qua UI mà không cần sửa code. Hệ thống sử dụng một lớp Cache RAM (`SystemConfigCache`) lưu trữ thông số trong ServletContext để tối ưu hóa hiệu năng đọc của các nghiệp vụ khác, và tự động đồng bộ cache tức thời sau mỗi thay đổi.

## Technical Context (Bối cảnh kỹ thuật)
* **Backend:** Java 17, Java Servlet (Servlet 4.0/5.0)
* **Database:** PostgreSQL (JDBC + DAO Pattern)
* **Caching:** ServletContext Cache (`SystemConfigCache`)
* **Security & Auth:** Session-based Authentication + Java Filter (`AuthFilter`) bảo vệ `/admin/*` và `/admin/*`

## Project Structure (Cấu trúc dự án thực tế)
### Source Code
```text
src/java/
├── controllers/
│   ├── AdminSystemConfigServlet.java        # Controller dành cho Admin sửa cấu hình nghiệp vụ (UC-33)
│   ├── AdminSystemConfigServlet.java   # Controller dành cho Admin quản lý toàn bộ cấu hình (UC-32, UC-33)
│   └── PaymentConfigServlet.java # Controller dành cho cấu hình cổng thanh toán SePay (UC-53)
├── dao/
│   ├── SystemConfigDAO.java            # Thực thi SELECT, INSERT, UPDATE trên bảng SystemConfigurations
│   └── AuditLogDAO.java                # Ghi nhật ký thay đổi cấu hình vào CSDL (BR-14)
├── model/
│   └── SystemConfiguration.java        # Model thực thể SystemConfigurations
├── service/
│   └── SystemConfigService.java        # Xử lý business logic: validate whitelist, kiểm tra kiểu dữ liệu, RBAC, và nạp Cache
└── util/
    # (Hệ thống sử dụng SystemConfigCache để lưu cấu hình trên ServletContext phục vụ các Service khác đọc trực tiếp)
```

## Technical Decisions & Implementation Details (Chi tiết kỹ thuật & Quyết định thiết kế)

### 1. Cơ chế Caching động (ServletContext Caching)
* Khi khởi động ứng dụng, `AppContextListener` kích hoạt nạp toàn bộ cấu hình từ database vào cache RAM.
* Khi có thao tác cập nhật thành công, `SystemConfigService` gọi `SystemConfigCache.reload(ctx)` để cập nhật nóng RAM ngay lập tức mà không cần restart server.

### 2. Whitelist Key và Kiểu dữ liệu (BR-40)
* `SystemConfigService` định nghĩa whitelist `KEY_TYPES` (Map) để quy định kiểu dữ liệu của từng cấu hình:
  * `POSITIVE_INT` (Số nguyên dương > 0): `STUDENT_MAX_BORROW_DAYS`, `LECTURER_MAX_BORROW_DAYS`, `RENEW_DURATION_DAYS`, `RESERVATION_HOLD_DAYS`, `RENEW_THRESHOLD_PERCENT`, `EMAIL_OTP_EXPIRE_MINUTES`, `EMAIL_OVERDUE_NOTICE_DAYS`, `MAX_IMPORT_ROWS`, `IMPORT_EXPIRE_DAYS`.
  * `NON_NEGATIVE_INT` (Số nguyên không âm >= 0): `MAX_EXTENSION_COUNT`.
  * `NON_NEGATIVE_DECIMAL` (Số thực không âm >= 0.0): `FINE_RATE_PER_DAY`, `LOST_FINE_MULTIPLIER`, `DAMAGED_FINE_MULTIPLIER`, `DEFAULT_BOOK_PRICE`.
  * `STRING` (Dạng chuỗi): `SEPAY_API_KEY`, `SEPAY_ACCOUNT_NUMBER`, `SEPAY_BANK_CODE`, `SEPAY_ACCOUNT_NAME`, `SEPAY_QR_URL`, `GEMINI_API_KEY`, v.v.

### 3. Phân quyền và Cô lập nghiệp vụ (BR-31, BR-53)
* Admin chỉ có quyền xem và sửa các cấu hình thuộc nhóm `library` hoặc có tiền tố `SEPAY_`. Việc phân quyền được kiểm tra nghiêm ngặt tại Service Layer:
  ```java
  if ("ADMIN".equals(actorRole) && !"library".equals(current.getConfigGroup()) && !key.startsWith("SEPAY_")) {
      throw new ValidationException("Bạn không có quyền chỉnh sửa nhóm cấu hình này.");
  }
  ```
* Admin có toàn quyền truy cập để xem và sửa đổi tất cả các nhóm cấu hình của hệ thống.
* Việc xóa cấu hình bị chặn đứng 100% ở tầng Service (`action=delete` ném ValidationException) để đảm bảo tính toàn vẹn hệ thống (BR-30).
