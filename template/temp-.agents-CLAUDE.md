# CLAUDE.md — Claude Code Project Memory
# Đọc file AGENTS.md trước để hiểu full project context

## MANUAL MEMORY (human-maintained)

### Architecture Decisions (ADR)
# ADR-001: Chọn JWT thay vì Session vì app cần stateless API cho mobile
# ADR-002: Prisma thay vì TypeORM vì type-safety tốt hơn với PostgreSQL
# ADR-003: Vitest cho frontend test vì nhanh hơn Jest 3x

### Lessons Learned (từ incidents và code review)
# LESSON-001: Luôn index foreign keys — học từ N+1 query bug Sprint 1
# LESSON-002: Validate file size TRƯỚC khi upload — max 10MB
# LESSON-003: Wrap Prisma calls trong try-catch với custom PrismaError

### Current Sprint Notes
# Sprint 2 focus: Business logic — Order management module
# Blocked: Payment gateway API key pending from PM
# Next: Implement notification system after order features done

## PATTERNS TO FOLLOW
# Service pattern: src/services/[name].service.ts
# Controller pattern: src/controllers/[name].controller.ts
# Always create: service test file alongside service file
# Error codes: use constants from src/constants/errors.ts

## AUTO MEMORY (Claude Code appends here)
# [Claude Code sẽ tự động thêm entries khi bạn làm việc]