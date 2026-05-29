# .sdd/constraints/safety.md
# Đây là "last line of defense" — không được vi phạm

## DATA SAFETY
KHÔNG ĐƯỢC (blocking — cần human confirm):
  - Xóa bất cứ thứ gì trong /data/ directory
  - DROP TABLE, TRUNCATE trong migration files
  - DELETE FROM ... WHERE (không có WHERE clause = thảm họa)
  - Thay đổi column type của existing data (migration risk)

PHẢI LÀM:
  - Tạo git checkpoint trước mọi schema migration
  - Test migration với rollback plan
  - Backup reminder trước migration: "Bạn đã backup chưa?"

## CODE SAFETY
KHÔNG ĐƯỢC tự ý:
  - Thêm package vào go.mod (hỏi trước)
  - Thay đổi Docker base image (security review needed)
  - Modify .github/workflows/ (CI changes = security sensitive)
  - Push vào main/master/production branches

## PRODUCTION SAFETY
  - Không access production database trực tiếp
  - Không hardcode production endpoints, credentials
  - Không log sensitive data (xem business.md PII section)
  - Không bypass auth middleware "cho nhanh"

## KHI KHÔNG CHẮC CHẮN
  - Dừng lại và báo cáo, không assume
  - "Tôi không chắc về constraint X. Làm thế nào bạn muốn?"
  - Better to ask and be slow than assume and be wrong