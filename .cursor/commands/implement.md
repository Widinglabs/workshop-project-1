# Implement

## First Step

**ASK THE USER**: "What is the path to the plan file? (e.g., `.cursor/artifacts/plans/feature-name.plan.md`)"

Wait for user input before proceeding.

---

## Objective

Execute the plan end-to-end with validation after each change.

**Golden Rule**: If validation fails, fix it before moving on. Never accumulate broken state.

---

## Phase 1: LOAD - Read the Plan

1. Read the plan file
2. Extract:
   - Tasks list (in order)
   - Patterns to follow
   - Validation commands

**If plan not found**: Stop and tell user to run `/plan` first.

---

## Phase 2: EXECUTE - Implement Tasks

**For each task:**

### 2.1 Read Context
- Read the pattern/mirror file reference
- Understand the code style to follow

### 2.2 Implement
- Make the change as specified
- Follow existing patterns exactly

### 2.3 Validate Immediately
After EVERY file change, run type-check:

**Backend**: `cd app/backend && uv run ruff check . && uv run python -c "import app"`
**Frontend**: `cd app/frontend && bun run check`

**If validation fails:**
1. Read the error
2. Fix the issue
3. Re-run validation
4. Only proceed when passing

### 2.4 Track Progress
Log each completed task:
```
Task 1: {description} ✅
Task 2: {description} ✅
```

---

## Phase 3: VALIDATE - Full Verification

Run all validation commands from the plan:

1. **Type check**: Must pass with 0 errors
2. **Lint**: Must pass (fix any issues)
3. **Tests**: Must pass (write tests if needed)

---

## Phase 4: REPORT - Create Summary

**Output path**: `.cursor/artifacts/reports/{plan-name}-report.md`

### Report Template

```markdown
# Implementation Report

**Plan**: `{plan-path}`
**Date**: {YYYY-MM-DD}
**Status**: COMPLETE / PARTIAL

## Tasks Completed

| # | Task | File | Status |
|---|------|------|--------|
| 1 | {desc} | `path` | ✅ |

## Validation Results

| Check | Result |
|-------|--------|
| Type check | ✅/❌ |
| Lint | ✅/❌ |
| Tests | ✅/❌ ({N} passed) |

## Files Changed

| File | Action | Lines |
|------|--------|-------|
| `path` | CREATE/UPDATE | +{N}/-{M} |

## Issues Encountered
{Any problems and how they were resolved, or "None"}
```

---

## Output

**Report to user:**

```
## Implementation Complete

**Plan**: `{plan-path}`
**Status**: ✅ Complete

### Validation
| Check | Result |
|-------|--------|
| Type check | ✅ |
| Lint | ✅ |
| Tests | ✅ ({N} passed) |

### Files Changed
- {N} created, {M} updated

### Report
`.cursor/artifacts/reports/{name}-report.md`

**Next**: Run `/validate` to confirm everything works
```
