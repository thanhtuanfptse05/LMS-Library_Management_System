-- ============================================================
-- LMS SEED DATA — BẢNG EmailTemplate (Mẫu Email Hệ Thống - Passive Notification)
-- Version: 1.0.0 | Tạo: 2026-06-26
-- ============================================================
-- Lưu ý quan trọng:
--   - Bảng EmailTemplate dành riêng cho tiến trình ngầm Async Email Sender.
--   - 6 mẫu dưới đây là CỐT LÕI, được seed khi deploy lần đầu.
--   - Manager được phép chỉnh sửa subject và bodyContent trên giao diện.
--   - Manager KHÔNG ĐƯỢC PHÉP tạo hoặc xóa mẫu (DAO không có insert/delete).
--   - updatedBy/updatedAt = NULL khi chưa ai chỉnh sửa (mẫu nguyên bản).
-- ============================================================


INSERT INTO EmailTemplate (tempName, description, subject, bodyContent)
VALUES

-- ============================================================
-- [1] Khôi phục mật khẩu
-- Trigger: ForgotPasswordServlet -> sau khi UPDATE passwordHash thành công
-- Placeholders: {{userName}}, {{tempPassword}}
-- ============================================================
(
    'RESET_PASSWORD',
    'Gửi mật khẩu tạm thời khi người dùng sử dụng chức năng "Quên mật khẩu". Hệ thống tự động kích hoạt khi người dùng yêu cầu khôi phục.',
    'Khôi phục mật khẩu — Thư viện Đại học LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <h2 style="color:#1a4fa3;margin-top:0;">🔐 Khôi phục mật khẩu</h2>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Hệ thống <strong>Thư viện LMS</strong> đã nhận được yêu cầu khôi phục mật khẩu cho tài khoản của bạn.</p>
  <p>Mật khẩu tạm thời của bạn là:</p>
  <div style="background:#f0f4ff;border:1px solid #c7d6f7;border-radius:8px;padding:16px 24px;font-size:24px;letter-spacing:4px;font-weight:bold;color:#1a4fa3;text-align:center;">{{tempPassword}}</div>
  <p style="margin-top:20px;">Vui lòng <strong>đăng nhập ngay</strong> bằng mật khẩu tạm thời và đổi sang mật khẩu mới để bảo vệ tài khoản.</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Nếu bạn không yêu cầu khôi phục mật khẩu, hãy bỏ qua email này. Tài khoản của bạn vẫn an toàn.</p>
</div></body></html>'
),

-- ============================================================
-- [2] Sách đặt trước sẵn sàng nhận tại quầy
-- Trigger: 3 nguồn — OnlineCirculationService (đặt online sách có sẵn),
--          DeskCirculationService (trả sách đôn hàng chờ),
--          ReservationExpirationProcessor (hủy đơn quá hạn đôn hàng chờ)
-- Placeholders: {{userName}}, {{bookTitle}}, {{pickupDeadline}}
-- ============================================================
(
    'RESERVATION_READY',
    'Thông báo cho độc giả biết sách đặt trước đã có sẵn tại quầy và hạn chót cần đến lấy. Kích hoạt khi đơn đặt trước chuyển sang trạng thái readypickup từ 3 luồng: đặt online, trả sách (đôn hàng chờ), hoặc hủy đơn quá hạn (đôn hàng chờ).',
    'Sách của bạn đã sẵn sàng — Thư viện LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <h2 style="color:#16a34a;margin-top:0;">📚 Sách của bạn đã sẵn sàng!</h2>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Cuốn sách bạn đặt trước đã có sẵn tại quầy thư viện:</p>
  <div style="background:#f0fff4;border:1px solid #bbf7d0;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0;font-size:16px;font-weight:bold;color:#166534;">📖 {{bookTitle}}</p>
  </div>
  <p>⏰ <strong>Hạn chót nhận sách:</strong> <span style="color:#dc2626;font-weight:bold;">{{pickupDeadline}}</span></p>
  <p>Vui lòng đến quầy thủ thư để nhận sách trước thời hạn trên. Sau thời gian này, yêu cầu đặt trước của bạn sẽ tự động bị hủy.</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Thư viện Đại học LMS — Phục vụ tri thức, kiến tạo tương lai.</p>
</div></body></html>'
),

-- ============================================================
-- [3] Xác nhận gia hạn sách thành công
-- Trigger: OnlineCirculationService -> sau khi UPDATE BorrowRecord.endDate thành công
-- Placeholders: {{userName}}, {{bookTitle}}, {{newDueDate}}, {{extensionCount}}, {{maxExtension}}
-- ============================================================
(
    'RENEWAL_CONFIRMATION',
    'Xác nhận gia hạn sách trực tuyến thành công cho độc giả. Kích hoạt khi độc giả tự gia hạn trên trang cá nhân Portal và hệ thống cập nhật endDate của BorrowRecord thành công.',
    'Gia hạn sách thành công — Thư viện LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <h2 style="color:#0369a1;margin-top:0;">🔄 Gia hạn sách thành công</h2>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Bạn đã gia hạn thành công thời gian mượn sách sau:</p>
  <div style="background:#f0f9ff;border:1px solid #bae6fd;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0 0 8px;font-size:16px;font-weight:bold;color:#0c4a6e;">📖 {{bookTitle}}</p>
    <p style="margin:0;color:#0369a1;">📅 Hạn trả mới: <strong>{{newDueDate}}</strong></p>
    <p style="margin:4px 0 0;font-size:13px;color:#64748b;">Lần gia hạn thứ {{extensionCount}} / {{maxExtension}}</p>
  </div>
  <p>Vui lòng trả sách trước hoặc đúng ngày hạn trả mới để tránh bị tính phạt.</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Thư viện Đại học LMS — Phục vụ tri thức, kiến tạo tương lai.</p>
</div></body></html>'
),

-- ============================================================
-- [4] Cảnh báo sách quá hạn và thông báo phạt
-- Trigger: OverdueProcessor (tiến trình ngầm 00:00 AM)
--          -> sau khi INSERT Fine + UPDATE User.status='locked' thành công
-- Placeholders: {{userName}}, {{bookTitle}}, {{dueDate}},
--               {{overdueDays}}, {{finePerDay}}, {{totalFine}}
-- ============================================================
(
    'OVERDUE_NOTICE',
    'Cảnh báo tự động cho độc giả khi sách quá hạn trả. Kích hoạt bởi tiến trình ngầm Overdue Processor chạy lúc 00:00 AM mỗi đêm. Kèm thông tin số tiền phạt đã phát sinh và lý do tài khoản bị khóa tạm thời.',
    'Cảnh báo: Sách quá hạn và tài khoản bị tạm khóa — Thư viện LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin-bottom:24px;">
    <h2 style="color:#dc2626;margin:0;">⚠️ Sách quá hạn — Tài khoản tạm khóa</h2>
  </div>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Hệ thống ghi nhận bạn chưa trả sách đúng hạn:</p>
  <div style="background:#fff7ed;border:1px solid #fed7aa;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0 0 8px;font-size:16px;font-weight:bold;color:#9a3412;">📖 {{bookTitle}}</p>
    <p style="margin:0;color:#c2410c;">📅 Hạn trả: {{dueDate}}</p>
    <p style="margin:4px 0 0;color:#c2410c;">⏱️ Số ngày trễ hạn: <strong>{{overdueDays}} ngày</strong></p>
  </div>
  <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0;font-size:13px;color:#6b7280;">Mức phạt: {{finePerDay}} VND/ngày</p>
    <p style="margin:8px 0 0;font-size:18px;font-weight:bold;color:#dc2626;">💰 Tổng tiền phạt: {{totalFine}} VND</p>
  </div>
  <p>Tài khoản của bạn đã bị <strong>tạm khóa</strong> cho đến khi hoàn tất thanh toán khoản phạt trên. Vui lòng đến quầy thư viện hoặc thanh toán trực tuyến qua hệ thống.</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Thư viện Đại học LMS — Mọi thắc mắc vui lòng liên hệ quầy thủ thư.</p>
</div></body></html>'
),

-- ============================================================
-- [5] Thông báo phạt sự cố (sách hỏng hoặc mất)
-- Trigger: DeskCirculationService -> sau khi trả sách với condition
--          damaged/lost, sau khi INSERT Fine + UserLockReason thành công
-- Placeholders: {{userName}}, {{bookTitle}}, {{barcode}},
--               {{incidentType}}, {{fineAmount}}
-- ============================================================
(
    'INCIDENT_FINE_NOTICE',
    'Thông báo khoản phạt đền bù khi Thủ thư nhận trả sách bị hư hỏng (damaged) hoặc mất (lost). Số tiền phạt được tính theo hệ số nhân giá sách cấu hình trong SystemConfigurations (DAMAGED_FINE_MULTIPLIER / LOST_FINE_MULTIPLIER).',
    'Thông báo khoản phạt sự cố sách — Thư viện LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin-bottom:24px;">
    <h2 style="color:#dc2626;margin:0;">📋 Thông báo khoản phạt sự cố</h2>
  </div>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Hệ thống ghi nhận sự cố với sách bạn vừa trả:</p>
  <div style="background:#fff7ed;border:1px solid #fed7aa;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0 0 6px;font-size:16px;font-weight:bold;color:#9a3412;">📖 {{bookTitle}}</p>
    <p style="margin:0;font-size:13px;color:#6b7280;">Mã vạch: {{barcode}}</p>
    <p style="margin:6px 0 0;color:#c2410c;">⚠️ Loại sự cố: <strong>{{incidentType}}</strong></p>
  </div>
  <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0;font-size:18px;font-weight:bold;color:#dc2626;">💰 Khoản phạt đền bù: {{fineAmount}} VND</p>
  </div>
  <p>Tài khoản của bạn đã bị <strong>tạm khóa</strong> cho đến khi thanh toán xong khoản phạt trên. Vui lòng đến quầy thư viện để được hỗ trợ.</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Thư viện Đại học LMS — Mọi thắc mắc vui lòng liên hệ quầy thủ thư.</p>
</div></body></html>'
),

-- ============================================================
-- [6] Xác nhận thanh toán phạt thành công
-- Trigger: 2 nguồn — CashPaymentServlet (tiền mặt quầy thủ thư)
--                     SePay Webhook handler (quét QR online)
-- Placeholders: {{userName}}, {{paymentId}}, {{amount}},
--               {{paymentMethod}}, {{paidAt}}
-- ============================================================
(
    'PAYMENT_CONFIRMATION',
    'Xác nhận thanh toán khoản phạt thành công cho độc giả. Kích hoạt từ 2 luồng: Thủ thư duyệt tiền mặt tại quầy (CashPaymentServlet) hoặc hệ thống nhận Webhook xác nhận từ SePay sau khi độc giả quét mã QR trực tuyến.',
    'Xác nhận thanh toán phạt thành công — Thư viện LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <h2 style="color:#16a34a;margin-top:0;">✅ Thanh toán thành công</h2>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Khoản phạt của bạn đã được thanh toán thành công. Chi tiết giao dịch:</p>
  <div style="background:#f0fff4;border:1px solid #bbf7d0;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0 0 6px;font-size:13px;color:#6b7280;">Mã giao dịch: <strong>#{{paymentId}}</strong></p>
    <p style="margin:0 0 6px;font-size:18px;font-weight:bold;color:#166534;">💰 Số tiền: {{amount}} VND</p>
    <p style="margin:0 0 6px;color:#166534;">💳 Phương thức: {{paymentMethod}}</p>
    <p style="margin:0;font-size:13px;color:#6b7280;">⏰ Thời gian: {{paidAt}}</p>
  </div>
  <p>Tài khoản của bạn đã được <strong>mở khóa</strong> (nếu không còn khoản phạt nào khác). Cảm ơn bạn đã sử dụng dịch vụ thư viện!</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Thư viện Đại học LMS — Phục vụ tri thức, kiến tạo tương lai.</p>
</div></body></html>'
),

-- ============================================================
-- [7] Xác nhận mượn sách thành công
-- Trigger: DeskCirculationService -> sau khi Check-out thành công tại quầy
-- Placeholders: {{userName}}, {{bookTitle}}, {{endDate}}
-- ============================================================
(
    'CHECKOUT_CONFIRMATION',
    'Xác nhận mượn sách thành công tại quầy và thông báo hạn trả sách cho độc giả.',
    'Mượn sách thành công — Thư viện LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <h2 style="color:#1a4fa3;margin-top:0;">📖 Mượn sách thành công!</h2>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Bạn đã thực hiện mượn sách thành công tại quầy thủ thư. Thông tin chi tiết:</p>
  <div style="background:#f0f4ff;border:1px solid #c7d6f7;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0 0 8px;font-size:16px;font-weight:bold;color:#1a4fa3;">📚 Sách mượn: {{bookTitle}}</p>
    <p style="margin:0;color:#1a4fa3;">⏰ Hạn trả sách: <strong style="color:#dc2626;">{{endDate}}</strong></p>
  </div>
  <p>Vui lòng trả sách đúng hạn để tránh phát sinh nợ phạt trễ hạn. Cảm ơn bạn!</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Thư viện Đại học LMS — Phục vụ tri thức, kiến tạo tương lai.</p>
</div></body></html>'
),

-- ============================================================
-- [8] Yêu cầu thu hồi sách mượn
-- Trigger: DeskBorrowingManagerServlet -> Sau khi Thủ thư gửi Gmail Thu hồi
-- Placeholders: {{userName}}, {{bookTitle}}, {{barcode}}, {{recallReason}}
-- ============================================================
(
    'RECALL_NOTICE',
    'Thông báo yêu cầu độc giả mang sách tới quầy thư viện trả theo yêu cầu thu hồi của Thủ thư.',
    'Thông báo: Yêu cầu thu hồi sách mượn — Thư viện LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <div style="background:#fff7ed;border:1px solid #fed7aa;border-radius:8px;padding:16px 20px;margin-bottom:24px;">
    <h2 style="color:#c2410c;margin:0;">📢 Yêu cầu thu hồi sách mượn</h2>
  </div>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Thư viện xin thông báo yêu cầu <strong>thu hồi lại cuốn sách</strong> bạn đang mượn với lý do cụ thể sau:</p>
  <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0;font-size:14px;color:#dc2626;font-weight:bold;">💬 Lý do thu hồi: {{recallReason}}</p>
  </div>
  <div style="background:#f0f4ff;border:1px solid #c7d6f7;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0 0 6px;font-size:16px;font-weight:bold;color:#1a4fa3;">📖 Tên sách: {{bookTitle}}</p>
    <p style="margin:0;font-size:13px;color:#475569;">🏷️ Mã vạch bản sao: <strong>{{barcode}}</strong></p>
  </div>
  <p>Vui lòng mang cuốn sách này đến <strong>Quầy Lưu thông Thư viện</strong> để hoàn tất thủ tục trả sách trong thời gian sớm nhất.</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Thư viện Đại học LMS — Phục vụ tri thức, kiến tạo tương lai.</p>
</div></body></html>'
),

-- ============================================================
-- [9] Hủy đơn đặt trước bởi Thủ thư
-- Trigger: OnlineCirculationService -> Sau khi Thủ thư hủy đơn đặt trước
-- Placeholders: {{userName}}, {{bookTitle}}, {{cancelReason}}
-- ============================================================
(
    'RESERVATION_CANCELLED',
    'Thông báo gửi độc giả khi lượt đặt trước sách của họ bị hủy bởi Thủ thư.',
    'Thông báo: Hủy lượt đặt trước sách — Thư viện LMS',
    '<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"></head><body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:30px;">
<div style="max-width:560px;margin:auto;background:#fff;border-radius:12px;padding:36px;box-shadow:0 2px 16px rgba(0,0,0,0.08);">
  <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px 20px;margin-bottom:24px;">
    <h2 style="color:#dc2626;margin:0;">🚫 Thông báo hủy lượt đặt trước sách</h2>
  </div>
  <p>Xin chào <strong>{{userName}}</strong>,</p>
  <p>Thư viện xin thông báo lượt đặt trước cuốn sách <strong>{{bookTitle}}</strong> của bạn đã bị hủy bởi Thủ thư.</p>
  <div style="background:#fff7ed;border:1px solid #fed7aa;border-radius:8px;padding:16px 20px;margin:16px 0;">
    <p style="margin:0;font-size:14px;color:#c2410c;font-weight:bold;">💬 Lý do hủy: {{cancelReason}}</p>
  </div>
  <p>Nếu có thắc mắc, vui lòng liên hệ với quầy thủ thư để được trợ giúp.</p>
  <hr style="border:none;border-top:1px solid #eee;margin:24px 0;"/>
  <p style="font-size:12px;color:#888;">Thư viện Đại học LMS — Phục vụ tri thức, kiến tạo tương lai.</p>
</div></body></html>'
)

ON CONFLICT (tempName) DO NOTHING;
