# Nginx-Ingress

**Nginx-Ingress** is a popular ingress controller for kubernetes that uses nginx as the underlying proxy server. An ingress controller is a component that manages incoming HTTP requests to a kubernetes cluster and routes them to the appropriate service or pod.

When using Nginix-Ingress controller, we should deploy our applications using ClusterIP service for more security. only the ingress controller should be deployed with Loadbalancer service.

## Installing the Ingress Controller In AWS

- **Clone Kubernetes Nginx Ingress Manifests into server where you have kubectl**

```sh
git clone https://github.com/LandmakTechnology/nginx-ingress

cd nginx-ingress/deployments
```

- **Create a Namespace And Service Account**

```sh
kubectl apply -f common/ns-and-sa.yaml
```

- **Create RBAC, Default Secret And Config Map**

```sh
kubectl apply -f common/
```

- **Deploy the Ingress Controller**

We include two options for deploying the Ingress controller:

- _Deployment._ Use a Deployment if you plan to dynamically change the number of Ingress controller replicas.
- _DaemonSet._ Use a DaemonSet for deploying the Ingress controller on every node or a subset of nodes.

**Create DaemonSet**

```sh
#When you run the Ingress Controller by using a DaemonSet, Kubernetes will create an Ingress controller pod on every node of the cluster.
kubectl apply -f daemon-set/nginx-ingress.yaml
```

- **Check that the Ingress Controller is Running**

```sh
#Check that the Ingress Controller is Running Run the following command to make sure that the Ingress controller pods are running:
kubectl get pods --namespace=nginx-ingress
```

- **Get Access to the Ingress Controller**

If you created a daemonset, ports 80 and 443 of the Ingress controller container are mapped to the same ports of the node where the container is running. To access the Ingress controller, use those ports and an IP address of any node of the cluster where the Ingress controller is running.

**Create Service Type LoadBalancer**

Create a service with the type LoadBalancer. Kubernetes will allocate and configure a cloud load balancer for load balancing the Ingress controller pods.

```sh
#For aws, run:
kubectl apply -f service/loadbalancer-aws-elb.yaml


#To get the DNS name of the ELB, run:
kubectl describe svc nginx-ingress --namespace=nginx-ingress
#or
kubectl get svc -n nginx-ingress


#You can resolve the DNS name into an IP address using nslookup:
 nslookup <dns-name>
```

## Ingress Resource:

**Define path based or host based routing rules for your services:**

we can create a-records for our applications and define the DNS in the paths or hostname

### Single DNS Sample with host and servcie place holders

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: <name>
  namespace: <namespace>
spec:
  ingressClassName: nginx
  rules:
    - host: <domainName>
      http:
        paths:
          - pathType: Prefix
            path: "/<Path>"
            backend:
              service:
                name: <serviceName>
                port:
                  number: <servicePort>
```

### Multiple DNS Sample with hosts and servcies place holders

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: <name>
  namespace: <namespace>
spec:
  ingressClassName: nginx
  rules:
    - host: <domainName>
      http:
        paths:
          - pathType: Prefix
            path: "/<Path>"
            backend:
              service:
                name: <serviceName>
                port:
                  number: <servicePort>
    - host: <domainName>
      http:
        paths:
          - pathType: Prefix
            path: "/<Path>"
            backend:
              service:
                name: <serviceName>
                port:
                  number: <servicePort>
```

### Path Based Routing Example

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: <name>
  namespace: <nsname>
spec:
  ingressClassName: nginx
  rules:
    - host: <domain>
      http:
        paths:
          - pathType: Prefix
            path: "/<Path>"
            backend:
              service:
                name: <serviceName>
                port:
                  number: <servicePort>
          - pathType: Prefix
            path: "/<path>"
            backend:
              service:
                name: <servcieName>
                port:
                  number: <servicePort>
```
