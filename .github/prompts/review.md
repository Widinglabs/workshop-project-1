# Code Review

## First Step

**ASK THE USER**: "What would you like to review? Options: file path(s), 'staged', 'all', or a branch name"

Wait for user input before proceeding.

---

Review the specified target against base branch (`exercise-2`).

---

## Objective

Perform a thorough code review:

1. **Understand** what the changes accomplish
2. **Check** code against project patterns and rules
3. **Run** validation (type-check, lint, tests)
4. **Categorize** issues by severity
5. **Report** findings

**Golden Rule**: Be constructive. Every issue should have a clear recommendation.

---

## Phase 1: CONTEXT - Get the Changes

### 1.1 Determine Review Target

| Input | Action |
|-------|--------|
| File path(s) | Review specific file(s) |
| `staged` | Review staged changes (`git diff --cached`) |
| `all` | Review all changes vs exercise-2 |
| Branch name | Review branch diff vs exercise-2 |

### 1.2 Get the Diff

```bash
# For specific files
git diff exercise-2 -- {file(s)}

# For staged changes
git diff --cached

# For all changes vs base
git diff exercise-2

# For branch comparison
git diff exercise-2..{branch}
```

### 1.2 Read Project Rules

Read `AGENTS.md` to understand:
- Code style rules
- Testing requirements
- Architecture patterns

---

## Phase 2: REVIEW - Analyze the Code

### 2.1 For Each Changed File

1. **Read the full file** (not just diff)
2. **Read similar files** to understand patterns
3. **Check changes** against the checklist below

### 2.2 Review Checklist

**Correctness**
- [ ] Does the code do what it should?
- [ ] Are edge cases handled?
- [ ] Is error handling appropriate?

**Type Safety**
- [ ] Are all types explicit?
- [ ] Are return types declared?

**Pattern Compliance**
- [ ] Follows existing patterns in codebase?
- [ ] Naming consistent with conventions?
- [ ] Imports from correct places?

**Security**
- [ ] User input validated?
- [ ] No secrets exposed?

**Completeness**
- [ ] Tests for new code?
- [ ] No TODOs left unaddressed?

---

## Phase 3: VALIDATE - Run Checks

### Backend

```bash
cd app/backend
uv run ruff check .
uv run ruff format --check .
uv run pytest tests/ -v
```

### Frontend

```bash
cd app/frontend
bun run check
```

Capture pass/fail for each.

---

## Phase 4: CATEGORIZE - Issue Severity

| Level | Criteria | Examples |
|-------|----------|----------|
| **Critical** | Must fix | Security issues, crashes, data loss |
| **High** | Should fix | Type errors, missing error handling, logic bugs |
| **Medium** | Consider | Pattern violations, missing edge cases |
| **Low** | Suggestion | Style preferences, minor improvements |

---

## Phase 5: REPORT - Generate Review

**Output path**: `.github/artifacts/reviews/{branch-name}-review.md`

### Report Template

```markdown
# Code Review: {branch-name}

**Date**: {YYYY-MM-DD}
**Base**: exercise-2
**Files Changed**: {count}

---

## Summary

{2-3 sentences: What these changes do and overall assessment}

---

## Changes Overview

| File | Changes | Assessment |
|------|---------|------------|
| `path/file` | +{N}/-{M} | PASS/WARN/FAIL |

---

## Issues Found

### Critical
{List or "None"}

### High Priority
{List or "None"}

### Medium Priority
{List or "None"}

### Suggestions
{List or "None"}

**Issue format:**
- **`file:line`** - {description}
  - **Fix**: {recommendation}

---

## Validation Results

| Check | Status |
|-------|--------|
| Ruff lint | PASS/FAIL |
| Ruff format | PASS/FAIL |
| Backend tests | PASS/FAIL |
| Frontend check | PASS/FAIL |

---

## What's Good

{Positive aspects - good patterns, clean code, etc.}

---

## Recommendation

{Summary of what needs to happen before merge}
```

---

## Output

Report to user:

```
## Code Review Complete

**Branch**: {branch-name} vs exercise-2
**Files Changed**: {count}

### Issues Found
| Severity | Count |
|----------|-------|
| Critical | {N} |
| High | {N} |
| Medium | {N} |
| Suggestions | {N} |

### Validation
| Check | Result |
|-------|--------|
| Lint | PASS/FAIL |
| Format | PASS/FAIL |
| Tests | PASS/FAIL |

### Report
`.github/artifacts/reviews/{branch-name}-review.md`
```
