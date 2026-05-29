# PROJECT CONSTITUTION — [Project Name]
# Version: 1.0.0 | Owner: @tech-lead
# Status: LOCKED — chỉ thay đổi qua RFC process
# Áp dụng cho: mọi AI agent, mọi developer, mọi PR

═══════════════════════════════════════════════
  LAYER 1: HARD RULES — KHÔNG BAO GIỜ VI PHẠM
═══════════════════════════════════════════════

## SEC-01: Bảo mật thông tin
THE system SHALL NOT lưu bất kỳ secret nào dưới dạng plaintext trong source code, config files, hoặc logs.
Áp dụng cho: API keys, passwords, tokens, PII, NHNN data.
Enforcement: git-secrets pre-commit hook (tự động).

## SEC-02: Authentication bắt buộc
THE system SHALL yêu cầu xác thực cho mọi endpoint thay đổi dữ liệu (POST, PUT, PATCH, DELETE).
Ngoại lệ: public endpoints phải được document rõ lý do.

## SEC-03: Input validation
THE system SHALL validate và sanitize tất cả user input trước khi xử lý hoặc lưu vào database.
Không có raw SQL query với user input không được parameterize.

## DATA-01: Không xóa dữ liệu vĩnh viễn
THE system SHALL dùng soft-delete (deleted_at) thay vì hard-delete cho mọi entity business-critical.
Hard-delete chỉ được phép cho: logs > 90 ngày, temp files.

═══════════════════════════════════════════════
  LAYER 2: ARCHITECTURAL CONSTRAINTS
═══════════════════════════════════════════════

## ARCH-01: Service boundary
Services SHALL giao tiếp qua API contracts (REST/gRPC/events).
Direct DB access từ service khác là PROHIBITED.
Exception process: RFC trong .sdd/rfcs/ + tech lead sign-off.

## ARCH-02: Event-driven cho async operations
Operations > 2 giây SHALL được xử lý asynchronously qua message queue (Kafka/RabbitMQ).
Sync HTTP call với timeout > 2s là architectural violation.

## ARCH-03: Idempotency
Mọi mutating API endpoint SHALL có idempotency mechanism (idempotency-key header hoặc natural idempotent design).

═══════════════════════════════════════════════
  LAYER 3: ENGINEERING STANDARDS
═══════════════════════════════════════════════

## ENG-01: Test coverage
Minimum test coverage: 80% cho business logic.
Exception: proof-of-concept branches (cần xóa trước merge main).

## ENG-02: Documentation
Mọi public API endpoint SHALL có OpenAPI documentation.
Mọi business rule SHALL có EARS tag trong code comments.

## ENG-03: Error handling
THE system SHALL không expose internal error details ra client.
Error response format: {error_code, message, request_id}.
Stack trace SHALL chỉ xuất hiện trong server logs, không response.

## ENG-04: Dependency
Third-party library SHALL được pin version cụ thể.
Major version update cần security review.

═══════════════════════════════════════════════
  AI AGENT SELF-CHECK PROTOCOL
═══════════════════════════════════════════════

## Trước khi submit bất kỳ code nào, AI phải self-check:

CHECKLIST SEC:
  [ ] Không có hardcoded secrets (grep: password=, key=, token=)
  [ ] Mọi endpoint mutating có auth middleware
  [ ] Input validation present trước DB operations

CHECKLIST ARCH:
  [ ] Không có cross-service DB access
  [ ] Async operations > 2s dùng queue
  [ ] Mutating endpoints có idempotency

CHECKLIST ENG:
  [ ] Unit tests cover happy path + error cases
  [ ] EARS tags trong code comments
  [ ] Error responses không chứa stack trace

## Nếu vi phạm phát hiện:
AI SHALL báo cáo: "[CONSTITUTION VIOLATION] Rule: {ID}
  File: {file}, Line: {n}. Action taken: {description}"
AI SHALL KHÔNG submit code vi phạm Layer 1.
AI SHALL hỏi human approval cho Layer 2 violations.