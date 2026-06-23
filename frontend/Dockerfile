# ─── Stage 1: Build the React app ───────────────────────────────────────────
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependency files and install
COPY package*.json ./
RUN npm install

# Copy source code and build for production
COPY . .
RUN npm run build

# ─── Stage 2: Serve with Nginx ───────────────────────────────────────────────
FROM nginx:stable-alpine

# Remove default Nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the production build from Stage 1
COPY --from=builder /app/build /usr/share/nginx/html

# Copy custom Nginx config so /api requests proxy to the backend
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Nginx starts automatically
CMD ["nginx", "-g", "daemon off;"]
