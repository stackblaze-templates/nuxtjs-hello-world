# Stage 1: Build
FROM node:lts-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:lts-alpine AS runner

WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S nuxt && adduser -u 1001 -S nuxt -G nuxt

# Copy only what is needed to run the app
COPY --from=builder --chown=nuxt:nuxt /app/.nuxt ./.nuxt
COPY --from=builder --chown=nuxt:nuxt /app/node_modules ./node_modules
COPY --from=builder --chown=nuxt:nuxt /app/nuxt.config.js ./nuxt.config.js
COPY --from=builder --chown=nuxt:nuxt /app/package.json ./package.json
COPY --from=builder --chown=nuxt:nuxt /app/server-middleware ./server-middleware

USER nuxt

EXPOSE 3000

ENV HOST=0.0.0.0 PORT=3000 NODE_ENV=production

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/ || exit 1

CMD ["npm", "start"]
