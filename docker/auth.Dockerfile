FROM node:24-alpine
RUN apk upgrade --no-cache
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
