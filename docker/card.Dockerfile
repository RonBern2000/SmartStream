FROM node:24-alpine
RUN apk upgrade --no-cache
RUN corepack enable
WORKDIR /app

COPY .npmrc pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY shared/package.json ./shared/
COPY services/card/package.json ./services/card/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/card/ ./services/card/

WORKDIR /app/services/card
CMD ["pnpm", "dev"]
