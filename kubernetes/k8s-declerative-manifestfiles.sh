To create services using manifest files, you need to define the services in YAML or JSON files
and then apply them to your Kubernetes cluster using the kubectl apply command.

Here are examples of manifest files for each service:
1) Deployment:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image

        
2) Service (ClusterIP):

apiVersion: v1
kind: Service
metadata:
  name: my-svc
spec:
  selector:
    app: my-app
  ports:
  - name: http
    port: 80
    targetPort: 8080
  type: ClusterIP


 3) Service (LoadBalancer):

apiVersion: v1
kind: Service
metadata:
  name: my-lb
spec:
  selector:
    app: my-app
  ports:
  - name: http
    port: 80
    targetPort: 8080
  type: LoadBalancer


4) Service (NodePort):

apiVersion: v1
kind: Service
metadata:
  name: my-np
spec:
  selector:
    app: my-app
  ports:
  - name: http
    port: 80
    targetPort: 8080
    nodePort: 30080
  type: NodePort


some manifest files for replications:
1) ReplicaSet:

apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image

2)  ReplicationController:

apiVersion: v1
kind: ReplicationController
metadata:
  name: my-rc
spec:
  replicas: 3
  selector:
    app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image

3) StatefulSet:

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-sts
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image

--To pull from a private repository:
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: <registry>/<image>:<tag>
  imagePullSecrets:
  - name: my-dockerhub-secret

--To create a generic secret file
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  username: YWRtaW4=    # Base64-encoded value
  password: cGFzc3dvcmQ=   # Base64-encoded value


Deploment Strategies
#Recreate strategy
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 4
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: mylandmarktech/hello:1    
        ports:
        - containerPort: 80
---
---
kind: Service
apiVersion: v1
metadata:
  name: appsvc
spec:
  selector:
    app: myapp
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 31400 #[30000-32676]
--------------------------------------------------
kind: Service
apiVersion: v1
metadata:
  name: appsvc
spec:
  selector:
    app: myapp
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 31400 #[30000-32676]

RollingUpdates strategy:   no downtime 
# Deployment RollingUpdate
---------------------
kind: Deployment
apiVersion: apps/v1
metadata:
  name: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello
  strategy:
    type: RollingUpdate
    rollingUpdate:
       maxSurge: 1
       maxUnavailable: 1
  minReadySeconds: 30   
  selector:
    matchLabels:
      app: myapp 
  template:
    metadata:
      name: hello
      labels:
        app: myapp
    spec:
      containers:
      - name: helloworld
        image: mylandmarktech/hello:1
        ports:
        - containerPort: 80

To apply these manifest files, use the following command:
kubectl apply -f <manifest_file>.yaml
