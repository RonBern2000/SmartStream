FROM node:22-alpine
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app

COPY pnpm-workspace.yaml package.json ./
COPY shared/package.json ./shared/
COPY client/package.json ./client/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY client/ ./client/

WORKDIR /app/client
CMD ["pnpm", "dev", "--host"]
