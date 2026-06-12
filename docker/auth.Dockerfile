FROM node:22-alpine
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app

COPY pnpm-workspace.yaml package.json ./
COPY shared/package.json ./shared/
COPY services/auth/package.json ./services/auth/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/auth/ ./services/auth/

WORKDIR /app/services/auth
CMD ["pnpm", "dev"]
