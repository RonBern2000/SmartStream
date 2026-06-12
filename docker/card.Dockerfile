FROM node:22-alpine
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app

COPY pnpm-workspace.yaml package.json ./
COPY shared/package.json ./shared/
COPY services/card/package.json ./services/card/

RUN pnpm install --frozen-lockfile

COPY shared/ ./shared/
COPY services/card/ ./services/card/

WORKDIR /app/services/card
CMD ["pnpm", "dev"]
