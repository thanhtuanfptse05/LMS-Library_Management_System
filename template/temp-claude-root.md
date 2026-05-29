CLAUDE.md — Mẫu tham khảo đầy đủ
# CLAUDE.md — [Project Name] v2.1
## TL;DR (Đọc trước — 60 giây)
> Đây là hệ thống quản lý đơn hàng thương mại điện tử.
> Backend: FastAPI + PostgreSQL. Frontend: React + TypeScript.
> Event-driven: Kafka cho async. Redis cho cache.
> CI/CD: GitHub Actions → Docker → Kubernetes.
## KIẾN TRÚC HỆ THỐNG
### Các service chính:
| Service | Port | Mô tả | Repo |
|---------|------|--------|------|
| order-service | 8001 | Xử lý đơn hàng | /services/order |
| payment-service | 8002 | Thanh toán | /services/payment |
| notification-service | 8003 | Email/SMS | /services/notify |
### Flow xử lý đơn hàng:
User → API Gateway → order-service → Kafka topic "orders"
→ payment-service (validate) → Kafka "payments"
→ notification-service (email) + inventory-service (update)
## QUYẾT ĐỊNH KIẾN TRÚC QUAN TRỌNG (ADR)
### ADR-001: Dùng Kafka thay vì HTTP sync
Lý do: payment processing có thể mất 3-10 giây.
HTTP sync → timeout issues. Kafka → đảm bảo không mất event.
Trade-off: complexity cao hơn, cần Kafka cluster.
### ADR-003: Không dùng ORM cho reporting queries
Lý do: Các query phân tích phức tạp → dùng raw SQL với psycopg3.
ORM chỉ dùng cho CRUD operations thông thường.
## PATTERNS ĐƯỢC SỬ DỤNG
### Repository Pattern:
Tất cả DB access đi qua /src/repositories/*Repository.py

LinhNDM | Playbook: Spec-Driven & Agent-Driven Development | Trang 71

Service layer KHÔNG được import SQLAlchemy trực tiếp.
### Error Handling:
Dùng Result type (nevermind library) thay vì raise Exception.
Pattern: Ok(value) | Err(AppError)
## NHỮNG GÌ ĐÃ KHÔNG HOẠT ĐỘNG (Lessons Learned)
- [2024-11] Đã thử GraphQL → quá phức tạp cho use case này. Giữ REST.
- [2024-12] Celery cho background tasks → memory leak. Chuyển sang Kafka.
- [2025-01] Pydantic v1 → đã migrate lên v2. Đừng dùng v1 patterns.
## FILE STRUCTURE QUAN TRỌNG
/src
/api # FastAPI routers — entry points
/services # Business logic — không có DB calls trực tiếp
/repositories # Data access — chỉ có DB calls
/models # Pydantic models + SQLAlchemy models
/events # Kafka producers/consumers
/tests
/unit # Isolated, no DB, no Kafka
/integration # Cần DB + Kafka (docker compose up -d)