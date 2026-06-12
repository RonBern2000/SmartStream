FROM node:22-alpine
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app

COPY pnpm-workspace.yaml package.json ./
COPY shared/package.json ./shared/
COPY services/ws/package.json ./services/ws/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/ws/ ./services/ws/

WORKDIR /app/services/ws
CMD ["pnpm", "dev"]
