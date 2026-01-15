---
description: Prime agent with codebase understanding
---

# Prime: Load Project Context

Build comprehensive understanding of this codebase by analyzing structure and key files.

## 1. Analyze Project Structure

Run `git ls-files` to see all tracked files.

Run `tree -L 3 -I 'node_modules|__pycache__|.git|dist|build|.venv'` to see directory structure.

## 2. Read Core Documentation

- Read `AGENTS.md` for project guidance
- Read `README.md` for exercise overview
- Read `tasks/TASK1.md` (backend task)
- Read `tasks/TASK2.md` (frontend task)

## 3. Read Key Backend Files

- `app/backend/pyproject.toml` - dependencies and config
- `app/backend/app/main.py` - FastAPI app entry
- `app/backend/app/api/products.py` - products endpoint
- `app/backend/app/models/product.py` - product model
- `app/backend/app/services/product_service.py` - business logic
- `app/backend/tests/test_products_filtering.py` - tests to pass

## 4. Read Key Frontend Files

- `app/frontend/package.json` - dependencies
- `app/frontend/src/App.tsx` - main component
- `app/frontend/src/lib/api-client.ts` - API client
- `app/frontend/src/types/product.ts` - TypeScript types

## 5. Check Current State

Run `git status` and `git log -5 --oneline` to understand current state.

## Output

Provide a concise summary:

- **Project**: What this is and its purpose
- **Tech Stack**: Backend (FastAPI/Python) and Frontend (React/Bun) details
- **Task**: What needs to be implemented (filtering)
- **Key Patterns**: Logging, models, type safety conventions observed
- **Current State**: Branch, any uncommitted changes

Keep it scannable with bullet points.
