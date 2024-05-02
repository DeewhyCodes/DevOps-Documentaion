https://www.baeldung.com/ops/kubernetes-service-types  #visit link for popular service creation commands and manifest files
kubectl get pods -o wide -n kube-system: This command verifies if kubectl is working and shows the status of the pods in the kube-system namespace.
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml: This command installs the Weave Net pod network addon.
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml: This command installs the Calico pod network addon.
kubectl get nodes: This command lists the nodes in the cluster.
kubectl get pods: This command lists the pods in the default namespace.
kubectl get pods --all-namespaces: This command lists the pods in all namespaces.
kubectl get pods --show-labels: This command lists the pods in the specified namespace including their labels
kubeadm token create --print-join-command: This command generates a join command for worker nodes to join the cluster.
kubeadm token list: This lists all the tokens and their validity
kubectl run nginx-demo --image=nginx --port=80: This command runs a new pod with the nginx image and exposes port 80.
kubectl expose pod nginx-demo --port=80 --target-port=80 --type=NodePort: This command exposes the nginx-demo pod as a NodePort service.
kubectl get services: This command lists the services in the default namespace.
kubectl get svc/ep/namespace/pods -o wide: this lists any of the options with more deatils about them.
kubectl describe  svc/ep/namespace/pods: this shows full information of any of the specified option
kubectl describe  svc/ep/namespace/pods -ns(wherever applicable)/svc(wherever applicable)/po(where applicable) nameofOption: this lists information about the specified option.
kubectl config set-context --current --namespace=my-namespace: this sets the default namespace to the one specified



Note: The kubeadm join token command should be executed on the master node, and the kubectl commands should be executed on the master machine.
