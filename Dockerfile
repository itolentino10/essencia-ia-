# Stage 1 — Build do frontend
FROM node:22-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2 — Produção (com browsers do Playwright)
FROM mcr.microsoft.com/playwright:v1.58.2-noble
WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist
COPY server ./server
COPY tsconfig.server.json .

ENV PORT=3001
EXPOSE 3001

CMD ["node", "--import=tsx/esm", "server/index.ts"]
