
# React (CRA)
Deploy React project in Docker

### Step — 1
Dockerfile for a React app created with Create React App (CRA). It includes best practices for production builds and development environments.
```
# Use Node.js as the base image for building the React app
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the app's source code to the working directory
COPY . .

# Expose the port that the app will run on
EXPOSE 3000

# Define the command to run your app
CMD ["npm", "start"]
```
### Step — 2
Build & Run the Docker Image

Build the image using example projectname - ecommerce, tag - latest

Sample Command : ```docker build -t projectname:tag .```
```
docker build -t ecommerce:latest .
```

Run the container
```
docker run -d -p 3000:80 ecommerce
```
The default docker images will show all top level images, their repository and tags, and their size by using any of this commands
```docker image list``` or ```docker image ls``` or ```docker images```
```
docker images
```

### Step — 3
Push Docker Image to Docker Hub