# .sdd/shared_context.md
# File này là NGUỒN SỰ THẬT CHUNG cho mọi agents
# Update bởi: Lead Agent sau mỗi major decision
# Read bởi: Tất cả agents trước khi bắt đầu task
# Version: timestamp-based (không phải semver)

## LAST UPDATED: 2025-01-20 15:30 UTC
## Updated by: Lead Agent (task: T007 backend implementation)

## API CONTRACTS (Source of Truth)
# Field names, types, và status của mọi API endpoint

POST /auth/register
  Request:  { email: string, password: string }
  Response: { user_id: string, created_at: ISO8601 }
  Status: ✅ IMPLEMENTED (backend-agent, commit: abc123)

POST /auth/login
  Request:  { email: string, password: string }
  Response: { access_token: string, refresh_token: string }
  Status: ✅ IMPLEMENTED (backend-agent, commit: def456)

GET /orders
  Response: { orders: Order[], meta: { total: int, cursor: string } }
  Status: 🔄 IN PROGRESS (backend-agent, ETA: 2h)
  Note: Field name changed from "order_list" to "orders" — 2025-01-20 14:00

## DATA TYPES
# Canonical type definitions — no ambiguity

Order:
  id: UUID string
  user_id: UUID string (NOT userId — snake_case throughout)
  status: enum ["pending", "processing", "shipped", "delivered"]
  created_at: ISO8601 string (NOT timestamp, NOT unix epoch)
  items: OrderItem[]

## KNOWN BREAKING CHANGES
# Log mọi API changes để agents khác biết cần update
2025-01-20 14:00: Renamed "order_list" → "orders" in GET /orders
  Impact: Frontend agent cần update response parsing
  Status: ⚠️ Frontend agent CHƯA UPDATE — pending

## SHARED DEPENDENCIES
# Libraries được dùng bởi nhiều agents — phải consistent
Auth: golang-jwt/jwt (backend) ↔ jwt-decode (frontend)
Date: time.Time (backend) ↔ date-fns (frontend) — format: ISO8601

## ENVIRONMENT
Dev DB:   postgresql://localhost:5432/devdb
Dev API:  http://localhost:8080
Dev Frontend: http://localhost:3000