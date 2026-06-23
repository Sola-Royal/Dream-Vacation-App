# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /app

# Copy dependency files first (for better Docker layer caching)
COPY package*.json ./

# Install all dependencies
RUN npm install --production

# Copy the rest of the backend source code
COPY . .

# Expose the port the server listens on
EXPOSE 3001

# Start the server
CMD ["node", "server.js"]
