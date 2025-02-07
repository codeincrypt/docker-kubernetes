# React (CRA & Vite)
Deploy React projects (Create React App & Vite) using Docker and Kubernetes.

## Docker Setup

### Step 1: Development & Production Dockerfile
Create a Dockerfile in the root of your project:

#### Create React App (CRA)
Development Dockerfile:
```dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

Production Dockerfile:
```dockerfile
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### Vite
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
```

---
### Manage Docker Containers & Images

#### Stop a Container
```sh
docker container stop <CONTAINER_ID>
```
#### Start a Container
```sh
docker container start <CONTAINER_ID>
```

#### Remove a Container
```sh
docker container rm <CONTAINER_ID>
```

#### Remove a Docker Image
```sh
docker rmi <USERNAME>/ecommerce
```

## Kubernetes

### Step 3: Build & Push Docker Image
```sh
docker build -t <USERNAME>/project .
```

#### Push the Image to Docker Hub
```sh
docker push <USERNAME>/project
```

### Step 4: Create Kubernetes Deployment & Service

**Deployment YAML (Vite & CRA):**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
        - name: react-app
          image: username/react-app:latest
          ports:
            - containerPort: 80
```

**Service YAML:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: react-app-service
spec:
  type: LoadBalancer
  selector:
    app: react-app
  ports:
    - port: 80
      targetPort: 80
```

---
### Step 5: Deploy to Kubernetes

#### Check if Kubernetes is Running
```sh
kubectl cluster-info
```

#### Apply the Deployment and Service
```sh
kubectl apply -f deployment.yaml
```

#### Check Deployment & Pods
```sh
kubectl get deployments
kubectl get pods
kubectl get services
```
---
### Step 6: Access the Application

#### If using Minikube
```sh
minikube service <SERVICE_NAME>
```

#### If using a Cloud Kubernetes Cluster
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
- Pushing images to Docker Hub.
- Creating Kubernetes deployment and service manifests.
- Deploying and managing the application in Kubernetes.

With this setup, you can efficiently deploy and scale React applications in a containerized environment.

