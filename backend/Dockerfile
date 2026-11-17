
# Use Node.js LTS on Alpine Linux
FROM node:24-alpine

# Set the application directory
WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json ./

# Install production dependencies only
RUN npm ci --omit=dev

# Copy the backend application
COPY server.js ./

# Run as a non-root user
USER node

# Backend application port
EXPOSE 3007

# Start the Express server
CMD ["node", "server.js"]
