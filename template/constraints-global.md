# .sdd/constraints/global.md
# Owner: @tech-lead | Version: 1.2.0

## TECHNOLOGY STACK (immutable trừ khi có RFC)
### Backend
Language:   Go 1.23+
HTTP:       net/http + chi router (v5)
Database:   pgx/v5 (NOT gorm, NOT sqlc direct — dùng sq query builder)
Cache:      go-redis/v9
Events:     segmentio/kafka-go
Testing:    testify/suite + testify/mock

### Infrastructure
Container:  Docker (multi-stage builds)
Orchestr.:  Kubernetes (helm charts trong /deploy/helm/)
Monitoring: Prometheus + Grafana (metrics endpoint: /metrics)

## NAMING CONVENTIONS
Packages:    lowercase, plural, no underscores (orders/, not order/)
Files:       snake_case (order_validator.go, not orderValidator.go)
Interfaces:  Er suffix (OrderStorer, not IOrderStore)
Errors:      Err prefix (ErrOrderNotFound, not NotFoundError)
Constants:   SCREAMING_SNAKE for env vars, CamelCase for Go consts

## APPROVED EXTERNAL PACKAGES (current list)
github.com/go-chi/chi/v5         # HTTP router
github.com/jackc/pgx/v5          # PostgreSQL driver
github.com/redis/go-redis/v9      # Redis client
github.com/Masterminds/squirrel  # SQL query builder
github.com/stretchr/testify       # Testing
go.uber.org/zap                   # Structured logging

## BANNED PACKAGES (với lý do)
github.com/jinzhu/gorm            # Performance issues, magic behavior
github.com/gorilla/mux            # Replaced by chi, inconsistent API
github.com/dgrijalva/jwt-go       # Known vulnerabilities, archived

## ADDING NEW PACKAGES
Quy trình: PR với justification → tech lead approve → update this file.
Agent KHÔNG được add package mà không có approval.