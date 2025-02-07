# deployment.yaml
Understanding ```deployment.yaml``` in Kubernetes 

**deployment.yaml** file
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app  # Name of the deployment
spec:
  replicas: 2  # Number of pods to run
  selector:
    matchLabels:
      app: react-app  # Must match the template labels
  template:
    metadata:
      labels:
        app: react-app  # Label to identify the pod
    spec:
      containers:
        - name: react-app
          image: your-dockerhub-username/react-app:latest  # Docker image to deploy
          ports:
            - containerPort: 80  # Exposing port inside the container
---
apiVersion: v1
kind: Service
metadata:
  name: react-app-service  # Name of the service
spec:
  selector:
    app: react-app  # Links service to pods with this label
  ports:
    - protocol: TCP
      port: 80        # Port exposed on the service
      targetPort: 80  # Port inside the container
  type: LoadBalancer  # Exposes the app externally (use NodePort if needed)
```

**Breakdown of Each Section**
- apiVersion - Defines the Kubernetes API version used.
  - apps/v1 → Used for deployments.
  - v1 → Used for services.

- kind - Specifies the type of resource being created.
  - Deployment → Ensures a specified number of pods are running.
  - Service → Exposes the app internally or externally.

- metadata - Defines metadata like the name of the deployment or service.

- spec.replicas - Defines how many pods should run simultaneously. If one crashes, Kubernetes automatically replaces it.

- selector.matchLabels - Ensures the deployment only manages pods with the given label (app: react-app).

- template (Pod Configuration) - Defines how the pods should be created.
  - containers: Lists all containers inside the pod.
  - image: Specifies the Docker image for the application.
  - ports: Defines which port the container listens on.

- Service Section
  - selector → Matches pods with label app: react-app.
  - ports → Specifies how traffic is directed.
  - type
    - ClusterIP → Default, internal access only.
    - NodePort → Exposes service on a port (e.g., 30000-32767).
    - LoadBalancer → Exposes service to the internet (used in cloud environments like AWS/GCP).


**Common Edits**

- Change the number of replicas:
```replicas: 3  # Runs 3 pods instead of 2```

- Change the image version: ```image: your-dockerhub-username/react-app:v2```

- Change service type to NodePort: ```type: NodePort```