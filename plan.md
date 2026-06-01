# plan.md — Task tracking format
# Agent update file này SAU MỖI bước hoàn thành

# T001: Khởi tạo cấu trúc "Bộ não dự án" (.sdd/ và .agents/)
# Status: COMPLETED | Session: 2026-05-29-22h

## Execution Plan (approved 22:15)
- [x] Step 1: Khởi tạo plan.md để theo dõi tiến độ
- [x] Step 2: Tạo `.agents/.agentignore`
- [x] Step 3: Tạo `.agents/AGENTS.md` (Agent Persona)
- [x] Step 4: Tạo `.agents/CLAUDE.md` (Project Memory)
- [x] Step 5: Tạo root `AGENTS.md` (Hiến pháp kỹ thuật)
- [x] Step 6: Tạo root `CLAUDE.md` (DNA & Kiến trúc dự án)
- [x] Step 7: Tạo `.sdd/constitution.md` (Quy tắc Layer 1/2/3)
- [x] Step 8: Tạo `.sdd/constraints/global.md` (Tech stack & conventions)
- [x] Step 9: Tạo `.sdd/constraints/business.md` (31 Business Rules)
- [x] Step 10: Tạo `.sdd/constraints/safety.md` (Data & Code Safety)
- [x] Step 11: Tạo `.sdd/shared_context.md` (33 FR và 23 UC)
- [x] Step 12: Tạo `.sdd/specs/_template.md` (Spec template)
- [x] Step 13: Tạo `.github/workflows/constitution-check.yml` (CI check)

## Current Status
- **T001: Project Brain Setup**: Completed (13/13 steps).
- **T-AUTH-04: AuthFilter**: Completed. Mapped to `/*`, implements role-based access control with secure redirects.
- **T-AUTH-05: LoginServlet**: Completed. Handles secure GET/POST with BCrypt verification, timing attack protection, auto-unlock, and failed attempt locks.
- **T-AUTH-06: ForgotPasswordServlet**: Completed. Handles POST with fake success, BCrypt password generation, and non-blocking asynchronous email delivery.
- **T-AUTH-07: LogoutServlet**: Completed. Invalidates sessions and redirects securely to `/login`.

Next: Implement View Layer (T-AUTH-08: login.jsp, forgot-password.jsp changes).

## Issues Encountered
None.

## Rollback Point
Before Web Layer Servlets: commit `5a5dc64`.
