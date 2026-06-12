FROM node:24-bookworm-slim
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
RUN corepack enable
WORKDIR /app

COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY shared/package.json ./shared/
COPY services/card/package.json ./services/card/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/card/ ./services/card/

WORKDIR /app/services/card
CMD ["pnpm", "dev"]
