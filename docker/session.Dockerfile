FROM node:24-alpine
RUN apk upgrade --no-cache
RUN corepack enable
WORKDIR /app

COPY .npmrc pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY shared/package.json ./shared/
COPY services/session/package.json ./services/session/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/session/ ./services/session/

WORKDIR /app/services/session
CMD ["pnpm", "dev"]
