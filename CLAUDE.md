# SmartStream — Pokémon Pack Tracker Overlay

SaaS streaming tool for logging Pokémon card pulls in real time. Streamers search cards, log pulls, and viewers see them animate live via an OBS browser source.

Two URLs, one React app — view selected by `?mode=` query param:
- `localhost:3000?mode=control` — streamer's control panel
- `localhost:3000?mode=overlay` — transparent OBS browser source (auth via static overlay key)

---

## Architecture — Microservices

Four backend services + one frontend, all TypeScript. Shared types in `shared/`.

```
API Gateway (Nginx / Traefik)
  ├── auth-svc     Express TS  — login, users, sessions
  ├── card-svc     Express TS  — PokéTCG proxy + Redis cache (stateless)
  ├── session-svc  Express TS  — pull logging, session CRUD, Redis publish
  ├── ws-svc       Node TS     — Socket.IO + Redis subscribe + broadcast
  └── client       Nginx       — static React + Vite build
```

Pull broadcast flow:
`session-svc` → saves pull to Postgres → publishes to Redis pub/sub → `ws-svc` subscribes → emits `new_pull` to Socket.IO clients

---

## Tech decisions (locked)

| Concern | Decision | Rationale |
|---|---|---|
| Language | TypeScript everywhere | PokéTCG response shapes are complex; shared types between services |
| Monorepo | pnpm + Turborepo | `shared/` must build before services; Turbo enforces order + caches |
| Database | Postgres — separate schemas per service, one instance | Relational data, aggregations, SQLite → Postgres migration path gone (SaaS) |
| Cache / Pub-Sub | Redis | Shared API cache across pods; Socket.IO adapter for multi-pod ws-svc; auth sessions |
| DI framework | None (Inversify rejected) | 4-node dependency graph; explicit constructor injection is sufficient |
| Web auth | Session ID in httpOnly cookie → Redis | Instant revocation; simpler than JWT for this use case |
| Overlay auth | Static per-streamer API key in URL | OBS browser source can't use cookies; key is regeneratable from control panel |
| Local dev | Docker Compose (all services + Postgres + Redis) | Cannot `npm run dev` with 5 services |
| Production | Kubernetes + Skaffold | Independent scaling of card-svc and ws-svc |
| Inter-service auth | Internal network trust (K8s cluster-internal) | Sufficient for v1; revisit with mTLS/Istio when compliance requires |
| DB-per-service | Separate Postgres schemas, one instance | True DB-per-instance when there's a measured reason to split |

---

## Project structure

```
smartstream/
  services/
    auth/           Express TS — users, login, session management
    card/           Express TS — PokéTCG API proxy, Redis cache
    session/        Express TS — session + pull CRUD, Redis publish
    ws/             Node TS   — Socket.IO server, Redis subscriber
  client/           React + Vite TS — ControlPanel.jsx, OverlayView.jsx
  shared/           TS types shared across all packages
  k8s/              Kubernetes manifests (one subdir per service)
  docker/           Dockerfiles (one per service + client)
  docker-compose.yml
  skaffold.yaml
  turbo.json
  pnpm-workspace.yaml
  .env.example
```

### client/src layout

```
views/        ControlPanel.tsx, OverlayView.tsx
components/   CardSearch.tsx, PullCard.tsx, SessionStats.tsx
hooks/        useSocket.ts, useCardSearch.ts
App.tsx       reads ?mode= param, renders correct view
```

---

## Commands

```bash
# local dev (all services)
docker compose up

# local dev with K8s hot reload
skaffold dev

# build all (Turbo handles order: shared → services → client)
pnpm run build

# build single service
pnpm --filter @smartstream/card-svc run build

# type check all
pnpm run typecheck

# add dependency to a service
pnpm --filter @smartstream/auth-svc add express
```

---

## External API — PokéTCG

Base URL: `https://api.pokemontcg.io/v2`
Auth: `X-Api-Key: $POKETCG_API_KEY` header
Card search: `GET /cards?q=name:"pikachu"` — returns name, set, rarity, image URL, TCGPlayer market price

**Always proxy through `card-svc`** — key stays server-side, responses cached in Redis (TTL: 1hr).

---

## Database schemas

**auth schema**
- `users`: id, email, password_hash, streamer_name, overlay_key, created_at

**sessions schema**
- `sessions`: id, user_id (FK), set_name, started_at, ended_at, pack_count
- `pulls`: id, session_id (FK), card_id, card_name, set_id, rarity, market_price, pulled_at
- `card_cache`: card_id (PK), payload_jsonb, cached_at

---

## Conventions

- All packages named `@smartstream/<name>` in package.json
- Services expose REST only — no service calls another service's REST endpoint directly; use Redis pub/sub for events
- API responses: `{ data: T } | { error: string }`
- Prices: USD floats
- Dates: ISO 8601 strings
- Components: PascalCase `.tsx`
- Hooks: `use*.ts`
- No `any` — use `unknown` and narrow

---

## Process rule — deep dive before each phase

Before implementing any new phase or adopting any technology, stop and compare options with explicit tradeoffs. No code until the approach is agreed.

Build order:
1. Scaffold — monorepo, Docker Compose, all services boot and connect
2. Card search — card-svc proxy → Redis cache → client dropdown
3. Auth — user signup/login, overlay key generation
4. Pull logging — session-svc CRUD → Postgres
5. WebSocket broadcast — Redis pub/sub → ws-svc → overlay animation
6. Session management — start/end, pack count, stats
7. Overlay design — transparent bg, card animations, rarity styling
8. Export + history — CSV/JSON, session list
9. K8s + Skaffold — production deployment manifests
