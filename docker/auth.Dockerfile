FROM node:24-bookworm-slim
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
RUN corepack enable
WORKDIR /app

COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY shared/package.json ./shared/
COPY services/auth/package.json ./services/auth/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/auth/ ./services/auth/

WORKDIR /app/services/auth
CMD ["pnpm", "dev"]
