---
paths:
  - "app/frontend/**/*.{ts,tsx}"
---

# Frontend Rules

- Strict TypeScript — no `any` types
- Use Biome for linting and formatting: `bun run check`
- Structured logging: `logger.info("action_name", { key: value })`
- API calls go through `src/lib/api-client.ts` with `ApiError` handling
- Types live in `src/types/`, components in `src/components/`
- Use shadcn/ui primitives for UI components
