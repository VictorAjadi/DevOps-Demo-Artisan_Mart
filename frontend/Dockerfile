# =========================
# Build stage
# =========================
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./

ENV NODE_ENV=development

RUN npm ci --include=dev && npm cache clean --force

COPY . .

RUN node ./node_modules/vite/bin/vite.js build


# =========================
# Production stage
# =========================
FROM nginx:1.25-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]