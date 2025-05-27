# ---- Build Stage ----
  FROM node:18-alpine AS build
  WORKDIR /app

  # Copier sources
  COPY package.json package-lock.json tsconfig*.json ./
  COPY src ./src
  COPY assets ./assets

  # Installer dépendances et builder
  RUN npm ci && npm run build

  # ---- Run Stage (Production) ----
  FROM node:18-alpine
  WORKDIR /app

  # Copier uniquement les fichiers nécessaires (dist + deps prod)
  COPY --from=build /app/dist ./dist
  COPY --from=build /app/node_modules ./node_modules
  COPY --from=build /app/package.json ./

  # Lancer le serveur au démarrage du conteneur
  CMD ["node", "dist/server.js"]
