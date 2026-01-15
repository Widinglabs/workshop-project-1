# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Project Overview

This is an Agentic Engineering Workshop project for learning the PIV Loop methodology (Planning → Implementing → Validating). It contains a fullstack product catalog application with filtering capabilities to be implemented.

## Branch Rules

- **Base branch**: `exercise-3`
- Create new branches from `exercise-3`
- **Never** commit or push to `main`

## Commands

### Backend (FastAPI + Python)

```bash
cd app/backend

# Setup
uv venv --python 3.12
uv sync

# Run API server (http://localhost:8000)
uv run python run_api.py

# Run all tests
uv run pytest tests/ -v

# Run specific test file
uv run pytest tests/test_products_filtering.py -v

# Lint and format
uv run ruff check .
uv run ruff format .
```

### Frontend (React + Bun)

```bash
cd app/frontend

# Setup
bun install

# Run dev server (http://localhost:3000)
bun dev

# Lint and format
bun run check      # Check for issues
bun run check:fix  # Fix issues
bun run lint       # Lint only
bun run format     # Format only
```

## Architecture

### Backend Structure

- `app/api/` - FastAPI route handlers (delegate to services)
- `app/services/` - Business logic layer
- `app/models/` - Pydantic models for request/response
- `app/core/` - Configuration and logging
- `app/data/` - Seed data (30 products in-memory)
- `tests/` - Pytest tests (filtering tests are skipped stubs to implement)

### Frontend Structure

- `src/components/` - React components (ProductCard, ProductGrid, UI primitives)
- `src/lib/` - Utilities (api-client.ts, logger.ts)
- `src/types/` - TypeScript type definitions
- Uses shadcn/ui components, React Hook Form, Zod for validation

### Key Patterns

**Logging**: Both backend and frontend use structured JSON logging:

```python
# Backend
logger = StructuredLogger(__name__)
logger.info("filtering_products", category="electronics", count=8)
```

```typescript
// Frontend
logger.info("fetching_products", {
  endpoint: "/api/products",
  operation: "filter",
});
```

**Models**: Use `Decimal` for prices, `Literal` types for categories:

```python
ProductCategory = Literal["electronics", "clothing", "home", "sports", "books"]
product_price_usd: Decimal  # Not float
```

**API Client**: Type-safe with `ApiError` class for error handling.

## Type Safety

- Backend: Full Pydantic models with Field validators
- Frontend: Strict TypeScript, Biome linting with `noExplicitAny: warn`
