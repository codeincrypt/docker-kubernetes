

# React (CRA)
Deploy React project in Docker

## Docker

### Step — 1
Write a Dockerfile
```
# Build the app
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json* ./
RUN npm ci

# Copy the source code and build the app
COPY . .
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom Nginx configuration (create this file next)
COPY nginx.conf /etc/nginx/conf.d

# Copy built assets from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```
### Step — 2
Create a Custom Nginx Configuration
```
server {
  listen 80;
  server_name localhost;

  root /usr/share/nginx/html;
  index index.html;

  # Serve static files
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

### Step — 3
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
Now, open your browser and navigate to http://localhost:8080.



The default docker images will show all top level images, their repository and tags, and their size by using any of this commands
```docker image list``` or ```docker image ls``` or ```docker images```
```
docker images
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
Create Kubernetes Manifests

**Deployment YAML**

Create a file named ```deployment.yaml```:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-vite-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: react-vite
  template:
    metadata:
      labels:
        app: react-vite
    spec:
      containers:
        - name: react-vite
          image: YOUR_DOCKERHUB_USERNAME/my-react-vite-app:latest
          ports:
            - containerPort: 80
```

**Service YAML**

Create a file named ```service.yaml```:

```
apiVersion: v1
kind: Service
metadata:
  name: react-vite-service
spec:
  type: LoadBalancer   # Use NodePort if you're on a local cluster like minikube
  selector:
    app: react-vite
  ports:
    - port: 80
      targetPort: 80
```

### Step — 5
**Deploy to Kubernetes**

Assuming you have ```kubectl``` configured to point to your Kubernetes cluster
```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

Check the deployment status
```
kubectl get deployments
kubectl get pods
```

check the service
```
kubectl get services
```

**Minikube**

If using a cloud provider, your service may get an external IP address. For local clusters like Minikube, you might use:


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
