# Deploy FAST API on Kubernetes

## Step 1: Clone the Latest Code
```sh
sudo su - ec2-user
git clone <REPOSITORY_URL>
```

## Step 2: Build Docker Image
```sh
docker build -t <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/repository/python-api:latest .
```

### Step 2.1 (Skip for Kubernetes) - Run Docker Image Locally
```sh
docker run -d -p 5000:5000 263789222982.dkr.ecr.us-east-1.amazonaws.com/repository/python-api:latest
```

### Step 2.2 (Skip for Kubernetes) - Verify Running Docker Containers
```sh
docker ps -a
```

## Step 3: Create Registry and Push Docker Image

### Step 3.1: Create AWS ECR Registry (One-Time Only)
- Go to: [AWS ECR Console](https://us-east-1.console.aws.amazon.com/ecr/private-registry/repositories?region=us-east-1)
- Registry Name: `repository/python-api`

### Step 3.2: Authenticate Docker with AWS ECR
```sh
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

### Step 3.3: Push Image to ECR
```sh
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/eda/python-api:latest
```

## Step 4: Deploy to Kubernetes
```sh
kubectl apply -f deployment.yaml
kubectl apply -f service.yml
```
Check all the running instances

```
kubectl get all
kubectl get all -n <NAMESPACE>
```

## Step 5: Check Pods and Services
```sh
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get svc <SERVICE_NAME>
```

## Step 6: Get Detailed Information
```sh
kubectl get pods -n <NAMESPACE> -o wide
kubectl describe all -n <NAMESPACE>
```

## Stop and Delete Resources
```sh
kubectl delete service <SERVICE_NAME>
kubectl delete deployments <DEPLOYMENT_NAME>
```