# TASK.md — Danh sách Task Thực thi: feat-systemConfiguration
# Version: 1.1 | Trạng thái: COMPLETED | Ngày cập nhật: 2026-07-21

## Ghi chú thực thi
- Ký hiệu: `[ ]` chưa làm | `[/]` đang làm | `[x]` hoàn thành | `[!]` bị block

---

## PHASE 0 — Khởi động & Kiểm tra thiết lập
- [x] **TASK-SC-00:** Đọc mã nguồn và thiết lập cache cấu hình, kiểm tra lớp `SystemConfigCache` để xác định các phương thức lấy giá trị.
- [x] **TASK-SC-01:** Kiểm tra `AppContextListener.java` để nạp cache khi ứng dụng khởi động.
- [x] **TASK-SC-02:** Kiểm tra và cấu hình `AuthFilter.java` bảo vệ các URL `/admin/*` và `/admin/*`.

---

## PHASE 1 — Xây dựng Lớp Dữ liệu (Data Layer)
- [x] **TASK-SC-10:** Tạo thực thể `src/java/model/SystemConfiguration.java`.
- [x] **TASK-SC-11:** Tạo lớp truy xuất dữ liệu `src/java/dao/SystemConfigDAO.java` triển khai các phương thức:
  * `findAll(Connection conn)`
  * `findByGroup(Connection conn, String group)`
  * `findByKey(Connection conn, String key)`
  * `update(Connection conn, String key, String value, int updatedBy)`
- [x] **TASK-SC-12:** Xây dựng cơ chế cache `SystemConfigCache.java` và tích hợp vào `AppContextListener.java` để tự động load dữ liệu.
- [x] **TASK-SC-13:** Thêm dữ liệu mẫu (Seed Data) cho 24 key cấu hình vào `LMS_Seed_Data_PostgreSQL.sql`.

---

## PHASE 2 — Phát triển Lớp Nghiệp vụ (Service Layer)
- [x] **TASK-SC-20:** Tạo lớp `src/java/service/SystemConfigService.java` xử lý logic:
  * Kiểm tra whitelist và phân quyền RBAC (chặn Admin sửa nhóm system/fine).
  * Gọi `validateValue()` để kiểm tra định dạng dữ liệu (số nguyên dương, số nguyên không âm, số thực không âm).
  * Thực thi DB Transaction: gọi DAO cập nhật, gọi `auditLogDAO` ghi log, và reload cache RAM thông qua `SystemConfigCache.reload()`.

---

## PHASE 3 — Lớp Điều khiển (Controller Layer)
- [x] **TASK-SC-30:** Tạo Servlet điều khiển cho Admin: `src/java/controllers/AdminSystemConfigServlet.java` (@WebServlet("/admin/system-config")).
- [x] **TASK-SC-31:** Tạo Servlet điều khiển cho Admin: `src/java/controllers/AdminSystemConfigServlet.java` (@WebServlet("/admin/system-config")).
- [x] **TASK-SC-32:** Tạo Servlet cấu hình SePay: `src/java/controllers/PaymentConfigServlet.java` (@WebServlet("/admin/payment-config")).

---

## PHASE 4 — Xây dựng Giao diện (View Layer - JSP)
- [x] **TASK-SC-40:** Xây dựng trang `web/admin/system-config-list.jsp` hiển thị danh sách cấu hình, lọc theo nhóm, phân loại badge màu sắc.
- [x] **TASK-SC-41:** Thiết kế modal sửa giá trị cấu hình inline tích hợp thông báo validate lỗi trực quan bằng tiếng Việt.
- [x] **TASK-SC-42:** Xây dựng trang `web/admin/payment-config.jsp` phục vụ cấu hình tham số SePay QR.

---

## PHASE 5 — Kiểm thử (Testing)
- [x] **TASK-SC-50:** Viết Unit Test trong `test/systemConfig/SystemConfigServiceTest.java` kiểm tra validate các định dạng kiểu dữ liệu.
- [ ] **TASK-SC-51:** Viết Integration Test kiểm tra tích hợp DAO (Đã test và xác nhận chạy ổn định qua kiểm thử thủ công).
- [x] **TASK-SC-52:** Thực hiện kiểm thử chấp nhận (Acceptance Test) theo đúng kịch bản trong SPEC.md.

---

## PHASE 6 — Review & Code Clean
- [x] **TASK-SC-60:** Kiểm tra phân quyền an toàn, rà soát log và dọn dẹp code debug.
- [x] **TASK-SC-61:** Cập nhật `CHANGELOG.md` ghi nhận lịch sử phiên bản.
