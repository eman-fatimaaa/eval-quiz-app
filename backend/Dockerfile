
# Use Node.js LTS on Alpine Linux
FROM node:24-alpine
RUN apk upgrade --no-cache zlib

# Set the application directory
WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json ./

# Install production dependencies, then remove npm from runtime
RUN npm ci --omit=dev \
    && npm cache clean --force \
    && rm -rf /usr/local/lib/node_modules/npm \
              /usr/local/bin/npm \
              /usr/local/bin/npx

# Copy the backend application
COPY server.js ./

# Run as a non-root user
USER node

# Backend application port
EXPOSE 3007

# Start the Express server
CMD ["node", "server.js"]
