# CLAUDE.md — Claude Code Project Memory
# Đọc file AGENTS.md trước để hiểu full project context
# Project: Library Management System (LMS) | Sprint: Milestone 2

## MANUAL MEMORY (human-maintained)

### Architecture Decisions (ADR)
# ADR-001: Bắt buộc dùng Raw JDBC + DAO Pattern — ràng buộc của môn SWP391. KHÔNG import Hibernate/JPA.
# ADR-002: Mô hình Table-per-Type (TPT) cho User — Bảng cha User + bảng con Student, Lecturer, Librarian, LibraryManager, Admin. Phải JOIN khi query chi tiết.
# ADR-003: Soft-Delete + Audit Log — KHÔNG dùng DELETE trên BorrowRecord, Fine, Payment, Reservation. Cập nhật status + INSERT AuditLogs.
# ADR-004: Session-based Auth thay vì JWT — Vì hệ thống dùng JSP (server-rendered), không cần stateless API.

### Lessons Learned (từ incidents và code review)
# LESSON-001: Luôn dùng try-with-resources trong DAO — học từ Connection Leak bug.
# LESSON-002: KHÔNG dùng string concatenation cho SQL — đã bị SQL Injection từ lỗi cũ.
# LESSON-003: Gửi email phải qua ExecutorService — app bị đơ 5s khi gửi OTP đồng bộ.
# LESSON-004: Fine Sync Logic phải check lock_reason trước khi unlock — KHÔNG mù quáng set status='active' khi fine paid.

### Current Sprint Notes
# Sprint: Milestone 2 focus: Core Transaction Flow
# Xác thực bảo mật (Login/OTP/Filter) + Luồng giao dịch lõi (Mượn/Trả/Phạt)
# DB Schema đã chốt 20 bảng — KHÔNG tự ý tạo thêm bảng

## PATTERNS TO FOLLOW
# Controller pattern: src/java/controller/[module]/[Name]Servlet.java
# Service pattern:    src/java/service/[Name]Service.java
# DAO pattern:        src/java/dao/[Name]DAO.java
# Model pattern:      src/java/model/[Name].java
# Filter pattern:     src/java/filter/[Name]Filter.java
# Util pattern:       src/java/util/[Name]Util.java
# Listener pattern:   src/java/listener/[Name]Listener.java
# View pattern:       web/WEB-INF/views/[module]/[name].jsp (kebab-case)
# Always: gọi AuditLogDAO.insert() sau mỗi C/U/D quan trọng
# Always: tạo Service test file cùng lúc với Service file

## DB SCHEMA REFERENCE
# 20 bảng đã chốt — xem database/LMS_Library_Management_System.sql
# User (TPT): User, MemberProfile, Student, Lecturer, Librarian, LibraryManager, Admin
# Catalog: Books, BookCopy, Category, Tag, BookCategory (junction), BookTag (junction)
# Transaction: BorrowRecord, Reservation, Fine, Payment
# System: SystemConfigurations, AuditLogs, Notification

## KEY BUSINESS LOGIC NOTES
# Reservation-first flow: Mọi yêu cầu mượn ĐỀU qua Reservation trước → pending / readypickup → fulfilled
# Fine-first policy (BR-LMS-004): User PHẢI trả hết phạt trước khi mượn/gia hạn/đặt trước
# Fine Sync (BR-LMS-035): Fine unpaid → auto lock User. Fine all paid → check lock_reason trước khi unlock
# Return triggers queue: Trả sách → kiểm tra Reservation pending → gán cho người đầu hàng

## AUTO MEMORY (Claude Code appends here)
# [Claude Code sẽ tự động thêm entries khi bạn làm việc]
# [2026-05-29]: Khởi tạo bộ não dự án .sdd/ + .agents/ với đầy đủ 32 FR, 23 UC, 29 BR.
