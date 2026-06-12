FROM node:24-alpine
RUN apk upgrade --no-cache
RUN corepack enable
WORKDIR /app
