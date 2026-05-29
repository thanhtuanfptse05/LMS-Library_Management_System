# plan.md — Task tracking format
# Agent update file này SAU MỖI bước hoàn thành

# T005: Implement OrderValidator
# Status: IN PROGRESS | Session: 2025-01-20-14h

## Execution Plan (approved 14:02)
- [x] Step 1: Read SPEC.md §3 (OrderValidator requirements)
- [x] Step 2: Create domain/validator.go
- [x] Step 3: Implement ValidateCreateOrder()
- [x] Step 4: Implement ValidateUpdateOrder()
- [ ] Step 5: Write unit tests (tests/unit/validator_test.go)
- [ ] Step 6: Run tests + fix failures
- [ ] Step 7: Run linter

## Current Status
Completed: Steps 1-4. validator.go created with 3 validation rules.
Next: Write tests for ValidateCreateOrder() — 4 test cases needed.

## Issues Encountered
- Step 3: SPEC §3.4 không rõ về max order items.
  Assumption used: max 100 items (theo Constitution §BUS-03).
  → Flagged for human review.

## Rollback Point
Before this task: git commit abc123 (clean state)

---

# Khi agent gặp lỗi không fix được:
## ❌ Failed Attempt (không xóa — giữ lại cho learning)
- Attempt: Dùng custom error type cho validation errors
- Result: Conflicts với existing error handling pattern trong codebase
- Decision: Use fmt.Errorf with sentinel errors (theo pattern hiện có)
