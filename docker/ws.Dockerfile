FROM node:24-alpine
RUN apk upgrade --no-cache
RUN corepack enable
WORKDIR /app

COPY .npmrc pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY shared/package.json ./shared/
COPY services/ws/package.json ./services/ws/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/ws/ ./services/ws/

WORKDIR /app/services/ws
CMD ["pnpm", "dev"]
