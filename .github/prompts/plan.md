# Plan

## First Step

**ASK THE USER**: "What feature would you like to plan? Please describe it."

Wait for user input before proceeding.

---

## Objective

Create a detailed implementation plan for the feature. NO CODE - planning only.

**Execution Order**: CODEBASE FIRST, then questions, then external research.

---

## Phase 1: PARSE - Understand the Request

Extract from input:
- Core problem being solved
- Feature type: NEW_FEATURE | ENHANCEMENT | BUG_FIX | REFACTOR
- Affected systems (backend, frontend, both)

**Formulate user story:**
```
As a <user type>
I want to <action>
So that <benefit>
```

**GATE**: If requirements are AMBIGUOUS → Ask clarifying questions before proceeding.

---

## Phase 2: EXPLORE - Codebase Research

Search the codebase to find:

1. **Similar implementations** - Find analogous features with file:line references
2. **Naming conventions** - How are functions, files, variables named?
3. **Patterns** - Error handling, logging, validation patterns
4. **Integration points** - Where does new code connect to existing?

**Document discoveries:**

| Category | File:Lines | Pattern | Example |
|----------|------------|---------|---------|
| NAMING | `path:10-15` | pattern_name | `actual_code` |
| ERRORS | `path:20-30` | pattern_name | `actual_code` |
| LOGGING | `path:5-10` | pattern_name | `actual_code` |

---

## Phase 3: CLARIFY - Ask Questions

Based on codebase exploration, ask the user clarifying questions about:
- Ambiguous requirements
- Design decisions that could go multiple ways
- Scope boundaries (what's NOT included)

---

## Phase 4: RESEARCH - External Documentation (if needed)

Only if the feature requires external libraries or APIs:
- Search official documentation
- Note version compatibility with existing dependencies
- Document any gotchas or best practices

---

## Phase 5: GENERATE - Create Plan File

**Output path**: `.github/artifacts/plans/{feature-name}.plan.md`

### Plan Template

```markdown
# Plan: {Feature Name}

## Summary
{One paragraph overview}

## User Story
As a {user}
I want to {action}
So that {benefit}

## Metadata
| Field | Value |
|-------|-------|
| Type | NEW_FEATURE / ENHANCEMENT / BUG_FIX / REFACTOR |
| Complexity | LOW / MEDIUM / HIGH |
| Systems | backend / frontend / both |

---

## Patterns to Follow

{Code snippets from codebase exploration - actual examples to mirror}

---

## Files to Change

| File | Action | Purpose |
|------|--------|---------|
| `path/to/file` | CREATE/UPDATE | {why} |

---

## Tasks

### Task 1: {Description}
- **Action**: CREATE/UPDATE `file/path`
- **Details**: {what to implement}
- **Pattern**: Mirror `existing/file:lines`
- **Validate**: {command to verify}

### Task 2: {Description}
...

---

## Validation

Run after implementation:
- Type check: `{command}`
- Lint: `{command}`
- Tests: `{command}`

---

## Out of Scope
- {What we're NOT building}
```

---

## Output

**Report to user:**

```
## Plan Created

**File**: `.github/artifacts/plans/{feature-name}.plan.md`

**Summary**: {2-3 sentences}

**Scope**:
- {N} files to create/update
- {M} tasks

**Next**: Run `/implement` with the plan path
```
