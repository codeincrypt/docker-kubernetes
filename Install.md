# Install Docker and Kubernetes on AWS EC2 & Ubuntu

This guide provides step-by-step instructions to install Docker and Kubernetes on an AWS EC2 instance and an Ubuntu system.

## Prerequisites

- An EC2 instance running EC2 or Ubuntu
- SSH access to the instance

## Steps to Install Docker

### 1. Update Packages

For EC2:
```sh
sudo yum update -y
```

For Ubuntu/Debian
```sh
sudo apt update -y && sudo apt upgrade -y
```

### 2. Install Docker

For EC2:
```sh
sudo yum install docker -y
```

For Ubuntu/Debian
```sh
sudo apt install docker.io -y
```

### 3. Start and Enable Docker

```sh
sudo systemctl start docker
sudo systemctl enable docker
```

### 4. Verify Installation

Check Docker version:
```sh
docker --version
```


## Steps to Install Kubernetes

### 1. Install kubeadm, kubelet, and kubectl

**For EC2:**

1. Add Kubernetes Repository
```sh
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl
EOF
```
2. Install Kubernetes Components
```
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
```
3. Enable and Start Kubelet
```
sudo systemctl enable --now kubelet
```

**For Ubuntu/Debian:**

1. Install Dependencies
```
sudo apt install -y apt-transport-https ca-certificates curl
```
2. Add Kubernetes Repository
```sh
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.asc

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.asc] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
3. Install Kubernetes Components
```
sudo apt install -y kubelet kubeadm kubectl
```

4. Enable and Start Kubelet
```
sudo systemctl enable kubelet
```

### 2. Verify Installation

Check versions:
```sh
kubelet --version
kubeadm version
kubectl version --client
```

## Uninstall Docker and Kubernetes (Optional)

For EC2:
```sh
sudo yum remove docker kubelet kubeadm kubectl -y
```

For Ubuntu/Debian:
```sh
sudo apt remove docker.io kubelet kubeadm kubectl -y
```

## Conclusion

You have successfully installed Docker and Kubernetes on your AWS EC2 instance and Ubuntu system.