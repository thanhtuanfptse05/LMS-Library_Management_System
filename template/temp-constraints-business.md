# .sdd/constraints/business.md

## AUTHENTICATION & AUTHORIZATION
Passwords:
  - Hash algorithm: argon2id (memory: 64MB, time: 3, threads: 4)
  - KHÔNG dùng: bcrypt, md5, sha1, sha256 cho passwords
  - KHÔNG lưu plaintext bất kỳ bước nào
  - Minimum length: 12 chars (enforce tại validation layer)

JWT Tokens:
  - Algorithm: RS256 (asymmetric — không HS256)
  - Access token TTL: 15 phút
  - Refresh token TTL: 7 ngày, single-use, rotate on refresh
  - Claims phải có: sub, iat, exp, jti (unique ID for revocation)

## API RULES
Rate Limiting:
  - Mọi endpoint PHẢI return: X-RateLimit-Limit, X-RateLimit-Remaining
  - Default limits: 1000 req/min per tenant, 100 req/min per user
  - Custom limits: configure trong /config/rate_limits.yaml

Pagination:
  - Cursor-based cho lists > 1000 items
  - Offset-based acceptable cho < 1000 items
  - Response phải có: data[], meta{total, cursor, has_more}

## DATA MANAGEMENT
Soft Delete:
  - Business entities: deleted_at timestamp (NOT hard delete)
  - Hard delete chỉ cho: logs > 90d, temp files, test data
  - Agent PHẢI confirm trước khi hard delete bất cứ thứ gì

PII Data:
  - Phone: log dưới dạng "0912***456" (mask 3 digits)
  - Email: log dưới dạng "use***@domain.com" (mask 3 chars)
  - Không bao giờ log: password, payment card, national ID

## DOMAIN GLOSSARY
# Quan trọng: Agent hiểu đúng nghĩa của terms trong codebase
Order:      Confirmed purchase intent. Has order items.
Cart:       Unconfirmed items. Can be abandoned.
Invoice:    Financial document for completed order.
Fulfillment: Process from payment to delivery.
Tenant:     B2B customer (company using our platform).
User:       End user (employee of a Tenant).
