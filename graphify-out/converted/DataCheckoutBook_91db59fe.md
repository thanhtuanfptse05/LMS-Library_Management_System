<!-- converted from DataCheckoutBook.xlsx -->

## Sheet: Sheet1
| memberCode | barcode | expected | Ghi chú |
| --- | --- | --- | --- |
| ST20230001 | BC_TEST_CHECKOUT | PASS | 1. Giao sách Walk-in hợp lệ cho sinh viên |
| ST20230001 | BC_NOT_FOUND | FAIL | 2. Lỗi mã vạch bản sao sách không tồn tại |
| SE_TEST_QUOTA | BC_TEST_CHECKOUT | FAIL | 3. Lỗi sinh viên vi phạm hạn mức mượn (Max Quota) |
| SE_TEST_FINE | BC_TEST_CHECKOUT | FAIL | 4. Lỗi chặn cho mượn do độc giả đang nợ phạt unpaid (BR-22) |
| ST20230001 | BC_TEST_CHECKIN_OVERDUE | FAIL | 5. Lỗi bản sao sách đang ở trạng thái borrowed |
| INVALID_CODE | BC_TEST_CHECKOUT | FAIL | 6. Lỗi mã độc giả không tồn tại trên hệ thống |
|  | BC_TEST_CHECKOUT | FAIL | 7. Lỗi thiếu mã độc giả |
| ST20230001 |  | FAIL | 8. Lỗi thiếu mã vạch bản sao sách |
| student1@lms.com | BC_TEST_CHECKOUT | FAIL | 9. Truyền email thay vì mã số độc giả |
| ST20230001 | 978-604-0-99999-3 | FAIL | 10. Nhập mã ISBN đầu sách thay vì Barcode bản sao |