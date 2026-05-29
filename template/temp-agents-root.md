# AGENTS.md — Project Context for AI Agents
# Version: 1.0 | Updated: [DATE] | Project: [PROJECT_NAME]

## 1. PROJECT OVERVIEW
Name: [Tên dự án]
Type: [Web App / API / Mobile / Data Pipeline]
Domain: [Lĩnh vực: e-commerce / healthcare / education / ...]
Stage: [Development / Testing / Production]

## 2. TECH STACK (STRICT — do not deviate)
Backend:  [Node.js 20 / Python 3.12 / Go 1.22]
Frontend: [React 18 + TypeScript / Next.js 14 / Vue 3]
Database: [PostgreSQL 16 / MongoDB / SQLite]
ORM:      [Prisma / SQLAlchemy / GORM]
Auth:     [JWT + bcrypt / Supabase Auth / Auth0]
Testing:  [Jest + Supertest / pytest / Go test]
Styling:  [Tailwind CSS 3.x]

## 3. ARCHITECTURE PRINCIPLES
- Follow [MVC / Clean Architecture / Domain-Driven Design]
- API style: [REST / GraphQL / tRPC]
- Error handling: always use [centralized error middleware / try-catch
with typed errors]
- No raw SQL — always use ORM
- No console.log in production code — use structured logger

## 4. FILE NAMING & STRUCTURE
Components:  PascalCase  (e.g. UserCard.tsx)
Utilities:   camelCase   (e.g. formatDate.ts)
API routes:  kebab-case  (e.g. /api/user-profile)
DB tables:   snake_case  (e.g. user_profiles)

## 5. FORBIDDEN PATTERNS
- NEVER store secrets/passwords in plain text or .env files committed to git
- NEVER use any — use proper TypeScript types
- NEVER skip input validation on API endpoints
- NEVER use deprecated libraries without team approval
- NEVER delete files in /data or /uploads without user confirmation

## 6. DEFINITION OF DONE (per task)
- [ ] Unit tests written and passing
- [ ] No linting errors (eslint / flake8)
- [ ] API endpoint documented in Swagger/OpenAPI
- [ ] Error cases handled with proper HTTP status codes
- [ ] No TODO comments left in code

## 7. GIT CONVENTIONS
Branch:  feat/[feature-name] | fix/[bug-name] | spec/[feature-name]
Commit:  [type]: [scope] - [description]
Example: feat(auth): add JWT refresh token endpoint

## 8. CURRENT SPRINT CONTEXT
Sprint:    [Sprint N]
Focus:     [Current sprint goal in 1 sentence]
Active specs: [list files in /.spec/ being worked on]