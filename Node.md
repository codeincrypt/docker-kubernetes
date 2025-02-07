# Node.js Deployment in Docker and Kubernetes

## Prerequisites
- Node.js installed
- Docker installed
- Kubernetes (Minikube or a cloud provider like GKE, EKS, or AKS)
- kubectl CLI installed
- Helm (optional, for managing Kubernetes applications)

---

## 1. Docker Setup

### Create a `Dockerfile`
Create a `Dockerfile` in the root of your project:

```dockerfile
# Use official Node.js image as a base
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy the rest of the application
COPY . .

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
```

### Step:2 Build and Run Docker Image

#### Install Docker  
*Refer to the [Docker Installation Guide](https://github.com/codeincrypt/docker-kubernetes/blob/main/Install.md).*


Build the image:
```sh
docker build -t my-node-app .
```

List docker images: 
```sh
docker images
```

Run the docker container:
```sh
docker run -d -p 3000:3000 my-node-app
```

List docker containers:
```sh
docker container list
```

---

## 2. Kubernetes Deployment

### Create Kubernetes Configuration Files
Create a `deployment.yaml` file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-node-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-node-app
  template:
    metadata:
      labels:
        app: my-node-app
    spec:
      containers:
        - name: my-node-app
          image: my-node-app:latest
          ports:
            - containerPort: 3000
```

Create a `service.yaml` file:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-node-app-service
spec:
  selector:
    app: my-node-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: LoadBalancer
```

### Deploy to Kubernetes
```sh
# Apply deployment
kubectl apply -f deployment.yaml

# Apply service
kubectl apply -f service.yaml
```

### Verify Deployment
```sh
kubectl get pods
kubectl get services
```

---

## 3. Pushing Docker Image to a Registry (Optional)
```sh
# Tag the image for Docker Hub or another registry
docker tag my-node-app my-dockerhub-username/my-node-app:latest

# Push to Docker Hub
docker push my-dockerhub-username/my-node-app:latest
```

Update `deployment.yaml` to use:
```yaml
image: my-dockerhub-username/my-node-app:latest
```

---

## 4. Cleanup
```sh
# Delete deployment and service
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
```

