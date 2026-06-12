FROM node:24-alpine
RUN apk upgrade --no-cache
RUN corepack enable
WORKDIR /app

COPY .npmrc pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY shared/package.json ./shared/
COPY client/package.json ./client/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY client/ ./client/

WORKDIR /app/client
CMD ["pnpm", "dev", "--host"]
