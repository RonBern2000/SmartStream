FROM node:24-bookworm-slim
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
RUN corepack enable
WORKDIR /app

COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY shared/package.json ./shared/
COPY services/ws/package.json ./services/ws/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/ws/ ./services/ws/

WORKDIR /app/services/ws
CMD ["pnpm", "dev"]
