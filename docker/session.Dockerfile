FROM node:22-alpine
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app

COPY pnpm-workspace.yaml package.json ./
COPY shared/package.json ./shared/
COPY services/session/package.json ./services/session/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/session/ ./services/session/

WORKDIR /app/services/session
CMD ["pnpm", "dev"]
