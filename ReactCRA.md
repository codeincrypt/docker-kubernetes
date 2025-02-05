
# React (CRA)
Deploy React project in Docker

## Docker

### Step — 1
Development Dockerfile for a React app created with Create React App (CRA)
```
# Use Node.js as the base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project
COPY . .

# Expose the port used by the React development server
EXPOSE 3000

# Start the React development server
CMD ["npm", "start"]
```

or,

Production Dockerfile (Optimized for Deployment) for a React app created with Create React App (CRA)
```
# Use Node.js base image for building the React app
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project
COPY . .

# Build the React app for production
RUN npm run build

# Use Nginx as the base image for serving the React app
FROM nginx:alpine

# Copy the build output stage to Nginx's web directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
```

### Step — 2
**Build & Run the Docker Image**

Build the image using example projectname - ecommerce, tag - latest

Sample Command : ```docker build -t projectname:tag .```
```
docker build -t ecommerce:latest .
```
The default docker images will show all top level images, their repository and tags, and their size by using any of this commands
```docker image list``` / ```docker image ls``` / ```docker images```
```
docker image list
```

Run the container
```
docker run -d -p 3000:80 ecommerce
```

Show all containers (default shows just running) by using any of this commands ```docker container list``` / ```docker container ls```
```
docker container list
```
### Remove/ Start/ Stop Image & Container

Stop the container
```
docker container stop 020a5a4cf50e
```

Start the container
```
docker container start 020a5a4cf50e
```
Delete the container
```
docker container rm 020a5a4cf50e
```

Delete/ Remove the docker images (first you have to remove the docker image) Example command: ```docker rmi karthik/ecommerce```
```
docker rmi username/project
```

## Kubernetes

### Step — 3
**Build & Push Docker Image**

Build the Docker image. Example command: ```docker build -t karthik/ecommerce```
```
docker build -t username/project .
```

Push the Image to Docker Hub (after login). Example command: ```docker push karthik/ecommerce```
```
docker push username/project
```

### Step — 4
**Create Kubernetes Deployment & Service**

Create a file called **deployment.yaml**

```
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
          image: your-dockerhub-username/react-cra:latest
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: react-app-service
spec:
  selector:
    app: react-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer  # Use NodePort if LoadBalancer isn't available

```
### Step — 4
**Deploy to Kubernetes**

Check if Kubernetes is Running
```
kubectl cluster-info
```
Apply the Deployment and Service

```
kubectl apply -f deployment.yaml
```

Check Deployment & Pods
```
kubectl get deployments
kubectl get pods
kubectl get services
```

### Step — 5
Access the Application

If using Minikube, run:
```
minikube service <SERVICE_NAME>
```

If using a Cloud Kubernetes Cluster, get the external IP:
```
kubectl get svc <SERVICE_NAME>
```

### Delete your Kubernetes deployments, pods, and services
Delete a Specific Deployment
```
kubectl delete deployment <PROJECT_NAME>
```

Delete a Specific Pod
```
kubectl delete pod <POD_NAME>
```

Delete a Specific Service
```
kubectl delete service <SERVICE_NAME>
```
