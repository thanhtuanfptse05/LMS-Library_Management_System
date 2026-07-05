# Phase 0: Research & Architecture Decisions

**Feature**: Book Suggestions (F20)
**Date**: 2026-07-05

## 1. Technical Context Unknowns

*All unknowns were resolved during the specification and clarification phases.*

| Category | Decision | Rationale | Alternatives Considered |
|---|---|---|---|
| Target Platform/Stack | Java Servlet, JSP, JDBC, PostgreSQL | Mandatory per Constitution (`.specify/memory/constitution.md`). | Frameworks (Spring/Hibernate) rejected due to explicit Constitution constraints. |
| Deletion Strategy | Hard-delete cho Giảng viên (voteCount=1), Soft-delete cho Thủ thư | Đề xuất chưa ai vote không có giá trị thống kê, có thể xóa hoàn toàn. Đề xuất bị từ chối vẫn giữ lại (soft-delete) để thống kê. | Giữ nguyên soft-delete cho mọi trường hợp (bị loại vì gây rác DB không cần thiết). |
| Performance Goals | ≤ 500 bản ghi, 1 request / 2 giây | Đây là giới hạn thực tế theo workload nội bộ trường ĐH. | Không có điều kiện rõ ràng (bị loại vì khó viết test). |

## 2. Dependency & Integration Research

- **Database**: `postgresql-42.7.3.jar` is already available in the project, connection through port `6543`.
- **System Configurations**: Limits (e.g., `MAX_SUGGESTION_PER_LECTURER`) will be read from the existing `SystemConfigurations` table which is cached via `SystemConfigCache` if implemented, or retrieved directly via DAO.
- **Frontend**: The views will use standard JSTL for logic and presentation, HTML/CSS for UI components, maintaining 100% Vietnamese language support. 

## 3. Conclusion

The architectural approach is fully validated against the project Constitution and the technical constraints. Proceeding to Phase 1 (Design & Contracts) for Data Model formulation.
