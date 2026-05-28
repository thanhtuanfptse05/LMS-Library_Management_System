# .agents/AGENTS.md — Agent-Specific Extensions
# Version: 1.0.0 | Kế thừa tất cả rules từ root AGENTS.md

> **⚠️ SOURCE OF TRUTH**: File này BỔ SUNG (extend) cho root `AGENTS.md`.
> Mọi quy tắc chung (Tech Stack, Forbidden Patterns, DoD, Git Conventions) 
> đã được định nghĩa tại root — KHÔNG lặp lại ở đây.

## EXPERTISE (Chi tiết bổ sung)
- Primary: Java JDK 17, Servlet/JSP, Microsoft SQL Server, JDBC thuần, DAO Pattern.
- Secondary: HTML/CSS3, JavaScript thuần, Design Patterns (Singleton, Factory).
- Cấm tuyệt đối (Avoid strictly): Spring, Spring Boot, Hibernate, JPA hoặc bất kỳ ORM framework nào.

## DECISION RULES (Bổ sung cho Section 8 root)
- Phân quyền (RBAC): Mọi endpoint bắt đầu bằng `/admin/`, `/librarian/`, `/student/` phải được bảo vệ bởi `@WebFilter`.
- Xóa dữ liệu: Các bảng giao dịch cốt lõi (`BorrowRecord`, `Fine`, `Payment`) KHÔNG ĐƯỢC Hard-delete. Chỉ cập nhật status (Soft-delete) và INSERT vào `AuditLogs`.
- KHÔNG thay đổi lược đồ 20 bảng CSDL đã chốt mà không hỏi ý kiến Human.

## TOOLS ĐƯỢC PHÉP DÙNG (Trong ngữ cảnh .agents/)
- Read/write files: `/src/java/` và `/web/`.
- Execute: Chạy Unit Test (JUnit 5).
- Git: status, diff, commit với format `[type]: [scope] - [description]`.

## THAM CHIẾU
- Root rules: xem `/AGENTS.md`
- Kiến trúc & Lessons Learned: xem `/CONTEXT.md`
