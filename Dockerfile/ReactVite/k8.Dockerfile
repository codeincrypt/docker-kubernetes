FROM node:20.13.1 AS build
 
WORKDIR /usr/src/app
# Copy package.json and package-lock.json first for caching
COPY package*.json ./
# Remove existing node_modules & package-lock.json (to avoid corruption)
RUN rm -rf node_modules package-lock.json
# Install dependencies
RUN npm install --force
# Copy the rest of the app files
COPY . .
# Build the React app
RUN npm run build
# Stage 2: Serve the React app with Nginx
FROM nginx:latest
# Remove the default Nginx website files
RUN rm -rf /usr/share/nginx/html/*
 
RUN mkdir -p /usr/share/nginx/html/ui/flipkart
# Copy the built React app from the build stage
COPY --from=build /usr/src/app/dist/flipkart /usr/share/nginx/html/ui/flipkart
# Set proper permissions for the content
RUN chmod -R 755 /usr/share/nginx/html/ui/flipkart
 
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]