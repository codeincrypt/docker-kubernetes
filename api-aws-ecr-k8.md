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
docker run -d -p 5000:5000 263789222982.dkr.ecr.us-east-1.amazonaws.com/<REPOSITORY/PROJECTNAME>:latest
```

### Step 2.2 (Skip for Kubernetes) - Verify Running Docker Containers
```sh
docker ps -a
```

## Step 3: Create Registry and Push Docker Image

### Step 3.1: Create AWS ECR Registry (One-Time Only)
- Go to: [AWS ECR Console](https://us-east-1.console.aws.amazon.com/ecr/private-registry/repositories?region=us-east-1)
- Registry Name: `repository/projectname`

### Step 3.2: Authenticate Docker with AWS ECR
```sh
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

### Step 3.3: Push Image to ECR
```sh
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<REPOSITORY/PROJECTNAME>:latest
```

## Step 4: Deploy to Kubernetes
Create Namespace
```sh
kubectl create namespace <NAMESPACE>
```

To get the list of namespaces
```sh
kubectl get namespaces
# or
kubectl get ns
```

Start Deploy, Service & Ingress
```sh
kubectl apply -f deployment.yaml
kubectl apply -f service.yml
kubectl apply -f ingress.yml
```

## Step 5: Check Pods and Services
Checking Running Instances in a Namespace

- Lists all pods running in the specified namespace
- Lists deployments in the specified namespace.
- Lists services in the namespace.

```sh
kubectl get pods -n <NAMESPACE>
kubectl get deployments -n <NAMESPACE>
kubectl get services -n <NAMESPACE>
```
Checking All Running Instances Across the Cluster
- Lists all resources (pods, deployments, services, daemonsets, statefulsets, replicasets, etc.) in all namespaces.
- Lists all resources in a specific namespace.
```
kubectl get all
kubectl get all -n <NAMESPACE>
```


## Step 6: Get Detailed Information
This command retrieves a list of pods running in a specific namespace with additional details.
```sh
kubectl get pods -n <NAMESPACE> -o wide
```
This command provides detailed information about all resources in the specified namespace.
```sh
kubectl describe all -n <NAMESPACE>
```

## Step 7: Get Detailed list of files and directories
This command is used to list the contents of the /usr/share/nginx/html directory inside a running Kubernetes pod.
```sh
kubectl exec <PODS_ID> -n <NAMESPACE> -- ls -l /usr/share/nginx/html
```


## Stop and Delete Resources of Pods and Services
Delete Kubernetes service
```sh
kubectl delete service <PROJECTNAME>-service -n <NAMESPACE>
```
Delete Kubernetes deployments
```sh
kubectl delete deployments <PROJECTNAME> -n <NAMESPACE>
```
Delete Ingress command
```sh
kubectl delete ingress <PROJECTNAME>-ns-ingress --n <NAMESPACE>
```