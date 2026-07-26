<!-- converted from DataCheckinBook.xlsx -->

## Sheet: Sheet1
| memberCode | barcode | condition | expected | Ghi chú |
| --- | --- | --- | --- | --- |
| SE_TEST_FINE | BC_TEST_CHECKIN_OVERDUE  | good | PASS | 1. Nhận trả sách tốt quá hạn 10 ngày, tự động tính phạt 50k |
| SE_TEST_FINE | BC_TEST_CHECKIN_DAMAGED  | damaged | PASS | 2. Nhận trả sách hỏng tại quầy, tự động tính đền bù & tạo Incident |
| SE_TEST_FINE | BC_TEST_CHECKIN_LOST  | lost | PASS | 3. Nhận trả báo mất sách tại quầy, tự động trừ tổng kho |
| SE_TEST_FINE | BC_NOT_BORROWED | good | FAIL | 4. Lỗi trả bản sao đang ở trạng thái available (chưa được mượn) |
| SE_TEST_FINE | BC_NOT_EXIST | good | FAIL | 5. Lỗi mã vạch bản sao không tồn tại |
| SE_TEST_FINE |  | good | FAIL | 6. Lỗi thiếu mã vạch bản sao |
| INVALID_CODE | BC_TEST_CHECKIN_OVERDUE | good | FAIL | 7. Lỗi mã sinh viên không tồn tại trên hệ thống |
|  | BC_TEST_CHECKIN_OVERDUE | good | FAIL | 8. Lỗi thiếu mã sinh viên |