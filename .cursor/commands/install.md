# Install

## Run

Think through each step carefully to ensure nothing is missed.

### Backend

1. Navigate to backend: `cd app/backend`
2. Create virtual environment: `uv venv --python 3.12`
3. Sync dependencies: `uv sync`
4. Start API server (in background): `uv run python run_api.py`
5. Verify API is running: `curl http://localhost:8000/api/products`
6. Run basic tests: `uv run pytest tests/test_products_basic.py -v`

### Frontend

1. Navigate to frontend: `cd app/frontend`
2. Install dependencies: `bun install`
3. Start dev server (in background): `bun dev`
4. Verify frontend is running at http://localhost:3000

## Report

Output what you've done in a concise bullet point list:
- Backend: localhost address, test results
- Frontend: localhost address
- Any issues encountered
