# React (Vite)
Deploy React projects (React Vite App) using Docker and Kubernetes.

## Docker Setup

### Step 1: Development & Production Dockerfile
Create a Dockerfile in the root of your project:

#### React Vite

Development Dockerfile:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install
COPY . .
EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host"]
```

Production Dockerfile:
```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci
COPY . .
RUN npm run build
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Step 2: Build & Run Docker Image

#### Install Docker  
*Refer to the [Docker Installation Guide](https://github.com/codeincrypt/docker-kubernetes/blob/main/Install.md).*


Build the image:
```sh
docker build -t projectname:latest .
```

List docker images: 
```sh
docker images
```

Run the docker container:
```sh
docker run -d -p 3000:80 projectname
```

List docker containers:
```sh
docker container list
# or
docker ps -a
```

---
### Manage Docker Containers & Images

#### Stop the running docker container
```sh
docker container stop <CONTAINER_ID>
```
#### Start a docker container
```sh
docker container start <CONTAINER_ID>
```

#### Remove a Container
```sh
docker container rm <CONTAINER_ID>
# or 
docker rm <CONTAINER_ID>
```

#### Remove a Docker Image
```sh
docker rmi <USERNAME>/ecommerce
```

## Kubernetes (Docker Hub)

### Step 3: Build & Push Docker Image
```sh
docker build -t <USERNAME>/project .
```

#### Push the Image to Docker Hub
```sh
docker push <USERNAME>/project
```

### Step 4: Create Kubernetes Deployment & Service

**Deployment YML:**

Go to [deployment.yml](https://github.com/codeincrypt/docker-kubernetes/blob/main/deploy/deployment.yml)


**Service YML:**

Go to [service.yml](https://github.com/codeincrypt/docker-kubernetes/blob/main/deploy/service.yml)


**Ingress YML:**

Go to [ingress.yml](https://github.com/codeincrypt/docker-kubernetes/blob/main/deploy/ingress.yml)

---
### Step 5: Deploy to Kubernetes

#### Check if Kubernetes is Running
```sh
kubectl cluster-info
```

#### Apply the Deployment and Service
```sh
kubectl apply -f deployment.yml
kubectl apply -f service.yml
```

#### Check Deployment & Pods
```sh
kubectl get deployments
kubectl get pods
kubectl get services
# or
kubectl get all
```
---
### Step 6: Access the Application

#### Using a Cloud Kubernetes Cluster
```sh
kubectl get svc <SERVICE_NAME>
```

---
### Step 8: Delete Kubernetes Resources

#### Delete a Specific Deployment
```sh
kubectl delete deployment <PROJECT_NAME>
```

#### Delete a Specific Pod
```sh
kubectl delete pod <POD_NAME>
```

#### Delete a Specific Service
```sh
kubectl delete service <SERVICE_NAME>
```

## Summary
This guide provides steps to deploy React applications (CRA & Vite) using Docker and Kubernetes. It covers:
- Writing Dockerfiles for both development and production.
- Building and running Docker containers.
- Pushing images to Docker Hub or AWS ECR.
- Creating Kubernetes deployment and service manifests.
- Deploying and managing the application in Kubernetes.

With this setup, you can efficiently deploy and scale React applications in a containerized environment.
