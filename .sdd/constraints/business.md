# .sdd/constraints/business.md
# Phiên bản: 1.1.0 | Trạng thái: LOCKED

Dưới đây là danh sách chính thức **31 Quy tắc Nghiệp vụ (Business Rules - BR01 đến BR31)** của hệ thống LMS Library Management System. AI Agent và Developer bắt buộc phải tuân thủ 100% khi triển khai code nghiệp vụ, không được tự ý thay đổi hoặc tự suy diễn thêm luật mới.

---

## I. XÁC THỰC & BẢO MẬT (AUTHENTICATION & SECURITY)

### BR01: Tự động khóa do nhập sai (Failed Logins)
* **Mô tả:** Hệ thống tự động khóa tài khoản tạm thời nếu người dùng nhập sai thông tin đăng nhập vượt quá số lần quy định cấu hình (`failedLoginAttempts >= max_failed_attempts`). Tài khoản sẽ bị khóa cho đến thời điểm `lockedUntil` được cấu hình.

### BR02: Cấm xóa cứng tài khoản (Soft Delete Users)
* **Mô tả:** Quản trị viên KHÔNG ĐƯỢC PHÉP xóa vĩnh viễn bất kỳ tài khoản người dùng nào khỏi hệ thống, mà chỉ được phép thay đổi trạng thái tài khoản thành `"locked"` (Khóa) để bảo toàn lịch sử giao dịch.

### BR03: Kiểm soát vai trò (RBAC)
* **Mô tả:** Mọi người dùng chỉ được phép truy cập vào các tính năng và dữ liệu tương ứng với vai trò (Role) của mình. Các nỗ lực truy cập trái phép phải bị hệ thống WebFilter chặn lại và ghi nhận vào Audit Log.

### BR22: Quy tắc thay đổi & Đặt lại mật khẩu
* **Mô tả:** Việc đặt lại hoặc thay đổi mật khẩu phải đáp ứng các điều kiện sau:
  * Độ dài tối thiểu 8 ký tự gồm chữ hoa, chữ thường, số và ký tự đặc biệt.
  * Không được trùng với mật khẩu gần nhất.
  * Yêu cầu xác thực bằng mật khẩu hiện tại khi thay đổi.
  * Mã OTP xác thực gồm 6 chữ số và tự động hết hạn sau 15 phút.

### BR30: Mật khẩu mặc định & Đổi mật khẩu lần đầu
* **Mô tả:** Mỗi người dùng mới được cấp tài khoản với mật khẩu mặc định trùng với tên đăng nhập (ví dụ: studentCode hoặc lecturerCode). Ngay sau khi đăng nhập thành công lần đầu tiên, hệ thống **BẮT BUỘC** điều hướng người dùng đến trang đổi mật khẩu và chặn mọi thao tác khác cho đến khi mật khẩu mới được thiết lập thành công.

### BR31: Quy định ghi đè trạng thái khóa tài khoản
* **Mô tả:** Tiến trình tự động khóa tài khoản do nợ phạt không được phép ghi đè lên các lý do khóa nghiêm trọng hơn đang có hiệu lực (như `adminban` hoặc `securitybreach`). Khi người dùng đóng hết tiền phạt, tài khoản chỉ được tự động mở khóa nếu lý do khóa hiện tại là `unpaid` và không còn bất kỳ điều kiện khóa nào khác (như nhập sai mật khẩu, ban của admin).

---

## II. QUẢN LÝ GIAO DỊCH THƯ VIỆN (TRANSACTION & CIRCULATION)

### BR04: Chặn mượn do nợ phạt (Block Borrowing due to Fines)
* **Mô tả:** Người dùng BẮT BUỘC phải thanh toán hoàn toàn bộ các khoản nợ phạt hiện có (`Fine.status = 'unpaid'`) trước khi được phép nhận sách mượn gia hạn, hoặc đặt trước thêm sách mới.

### BR05: Giới hạn mượn và đặt trước tối đa
* **Mô tả:** Người dùng KHÔNG ĐƯỢC PHÉP thực hiện đặt trước sách nếu tổng số lượng "Sách đang mượn" cộng với "Sách đang đặt trước" đã đạt đến hạn mức mượn tối đa của họ (`max_borrow_limit` cấu hình theo vai trò).

### BR06: Thời hạn mượn linh hoạt theo vai trò (Role-based Loan Duration)
* **Mô tả:** Thời gian mượn tối đa cho một cuốn sách (`max_loan_days`) được quy định linh hoạt dựa trên vai trò của người mượn (Sinh viên, Giảng viên) lấy trực tiếp từ cấu hình hệ thống `SystemConfigurations`.

### BR07: Điều kiện gia hạn sách (Extension Eligibility)
* **Mô tả:** Người dùng chỉ được gia hạn thời gian mượn sách nếu tựa sách đó hiện tại **KHÔNG CÓ** bất kỳ ai khác đang xếp hàng chờ đặt trước (`Reservation` có status là `pending` hoặc `readypickup`).

### BR08: Giới hạn số lần gia hạn (Max Extension Count)
* **Mô tả:** Mỗi giao dịch mượn sách chỉ được phép gia hạn tối đa một số lần nhất định (`max_extensions` theo cấu hình), tuyệt đối không được phép gia hạn vô hạn.

### BR21: Xử lý mượn sách đặt trước khi có nợ phạt
* **Mô tả:** Khi đến lượt nhận sách đặt trước, nếu người dùng đang có nợ phạt, hệ thống **VẪN** giữ sách và báo trạng thái `"Ready for Pickup"`. Tuy nhiên, hệ thống sẽ **KHÓA** chức năng giao sách tại quầy; người dùng bắt buộc phải thanh toán xong nợ phạt thì Thủ thư mới có thể quét mã cho mượn cuốn sách đó.

### BR29: Tính toàn vẹn của giao dịch (Transaction Integrity)
* **Mô tả:** Mọi giao dịch mượn và trả sách phải được liên kết chặt chẽ với ID thành viên (`userId`), ID sách (`bookId`), và ID giao dịch (`borrowRecordId`) hợp lệ.

---

## III. HÀNG CHỜ ĐẶT TRƯỚC (RESERVATION QUEUE)

### BR09: Chặn đặt trước đối với sách quá hạn
* **Mô tả:** Các tựa sách nếu đang ở trạng thái "quá hạn" (tất cả các bản sao đều chưa được trả dù đã lố ngày hẹn trả) thì hệ thống tạm thời chặn, không cho người dùng mới đặt trước.

### BR10: Thời gian giữ sách đặt trước
* **Mô tả:** Khi sách đặt trước đã có sẵn bản sao thực tế, hệ thống chuyển trạng thái sang `"Ready for Pickup"` và chỉ giữ bản sao sách đó cho người dùng trong một khoảng thời gian hiệu lực quy định (`reservation_validity_days` theo cấu hình).

### BR11: Hủy đặt trước quá hạn & Tự động luân chuyển
* **Mô tả:** Nếu người dùng không đến nhận sách trong thời gian hiệu lực, hệ thống tự động hủy quyền đặt trước của họ. Bản sao sách vật lý đó nếu ở tình trạng bình thường, **BẮT BUỘC** phải được ưu tiên luân chuyển ngay cho thành viên hợp lệ tiếp theo trong hàng chờ.

### BR12: Phạt do đặt sách không lấy (No-Show Penalty)
* **Mô tả:** Nếu người dùng có số lần "đặt sách nhưng không đến lấy" vượt quá mức cho phép (`max_no_show_limit`), tài khoản sẽ bị tự động phạt (khóa tài khoản) theo cấu hình của Admin (`no_show_lock_duration_days`).

---

## IV. TÀI SẢN & KHO SÁCH (PHYSICAL INVENTORY)

### BR13: Quét trả & Đánh giá hao mòn tài sản
* **Mô tả:** Ngay tại thời điểm quét mã nhận trả sách, Thủ thư bắt buộc phải ghi nhận tình trạng vật lý của sách. Nếu sách bị "Hư hỏng nặng" (Severely Damaged) hoặc "Mất" (Lost), hệ thống KHÔNG ĐƯỢC đưa sách vào luân chuyển hàng chờ mà phải loại khỏi kho và kích hoạt luồng phạt đền bù.

### BR24: Tính hợp lệ của bản ghi sách
* **Mô tả:** Mỗi bản ghi sách phải có mã ISBN hoặc mã thư viện duy nhất cùng các thông tin bắt buộc hợp lệ như tiêu đề, tác giả, nhà xuất bản, năm xuất bản, thể loại, mã phân loại, số lượng và giá sách.

### BR26: Chuẩn phân loại sách (Data Classification)
* **Mô tả:** Sách phải được phân loại và quản lý theo các chuẩn thư viện được công nhận rộng rãi như Dewey Decimal Classification (DDC) hoặc Library of Congress Classification (LCC).

---

## V. TÀI CHÍNH & PHẠT (FINANCE)

### BR14: Công thức tính phạt trễ hạn
* **Mô tả:** Tiền phạt trễ hạn được tính cộng dồn: `amount = số ngày trễ * fine_per_day` (đơn giá phạt trễ hạn/ngày được cấu hình trong `SystemConfigurations`).

### BR15: Mức phạt trần tối đa (Max Fine Cap)
* **Mô tả:** Tổng số tiền phạt trễ hạn cho một giao dịch mượn sách không được phép vượt quá mức trần tối đa đã được cấu hình (ví dụ: `max_fine_multiplier = 1.5`, tức tối đa 150% giá trị cuốn sách đó).

### BR16: Phạt đền bù độc lập (Compensation Fine)
* **Mô tả:** Nếu người dùng làm Mất hoặc Hư hỏng nặng sách, hệ thống áp dụng mức phạt đền bù tài sản độc lập, không cộng gộp hay bị giới hạn bởi mức phạt trễ hạn thông thường.

### BR17: Hủy giao dịch thanh toán treo (VNPAY Timeout)
* **Mô tả:** Các giao dịch thanh toán trực tuyến (VNPAY) nếu không nhận được phản hồi xác nhận thành công từ cổng thanh toán trong vòng 15 phút sẽ tự động bị hệ thống quét ngầm hủy bỏ và chuyển trạng thái giao dịch sang `canceled`.

---

## VI. TÍCH HỢP AI, GIÁM SÁT & CẤU HÌNH (INTEGRATIONS, CONFIG & AUDIT)

### BR18: Vai trò hỗ trợ của AI Integration
* **Mô tả:** Các kết quả do hệ thống AI cung cấp (như gợi ý sách cá nhân hóa, phân tích hành vi đọc, chatbot giải đáp FAQ) chỉ mang tính chất hỗ trợ và tham khảo. Mọi quyết định cuối cùng mang tính chế tài (như duyệt mượn, phạt tiền, khóa tài khoản) bắt buộc phải do hệ thống luật định sẵn của database hoặc do thủ thư/admin thực thi trực tiếp.

### BR19: Nhật ký Audit bất biến (Immutable Audit Log)
* **Mô tả:** Hệ thống phải duy trì một nhật ký hoạt động (Audit Log) cho mọi thao tác C/U/D cốt lõi. Dữ liệu nhật ký này là bất biến, tuyệt đối không thể bị sửa chữa hay xóa bỏ bởi bất kỳ ai trong hệ thống.

### BR20: Cấu hình tập trung & Áp dụng ngay lập tức
* **Mô tả:** Toàn bộ các tham số vận hành nghiệp vụ thư viện (giới hạn mượn, đơn giá phạt/ngày, thời gian khóa tài khoản, hiệu lực đặt trước) phải được lưu tập trung trong bảng `SystemConfigurations`. Mọi thay đổi cấu hình từ phía quản trị viên phải được hệ thống áp dụng ngay lập tức cho các giao dịch phát sinh mới.

### BR25: Tính toàn vẹn của chứng từ (Document Management)
* **Mô tả:** Phiếu mượn sách, xác nhận trả sách và thông báo phạt phải tuân theo mẫu biểu chuẩn mực của thư viện trường đại học. File PDF xuất ra phải được đảm bảo tính toàn vẹn dữ liệu và chống chỉnh sửa trái phép để làm bằng chứng đối chiếu.

### BR27: Tự động gửi thông báo (Notifications)
* **Mô tả:** Các hành động quan trọng gồm mượn sách, trả sách, cập nhật đặt trước, thanh toán phạt và gia hạn thành công phải kích hoạt thông báo tự động gửi qua email của người dùng (chạy bất đồng bộ) hoặc tin nhắn trên hệ thống.

### BR28: Mã hóa dữ liệu nhạy cảm (Security & Encryption)
* **Mô tả:** Tất cả các dữ liệu nhạy cảm liên quan đến thành viên (số điện thoại, email, mật khẩu) và giao dịch tài chính phải được mã hóa an toàn khi truyền đi và khi lưu trữ trong cơ sở dữ liệu theo chính sách bảo mật của trường đại học.
