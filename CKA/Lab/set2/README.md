# CKA Lab Challenge

## Notes for Set2

* challange 11:

Kuberntes worker Node "node01" not respending have a look and fix the issue.
```
kubedescribe node node01
ssh node01 
sudo systemctl status kublete
sudo systemctl restart kublete 
kubectl get nodes
```
* challange 12:

List the InternalIP of all nodes of the cluser.Save the result to a file /root/Internal_IP_List.

Ansser should be in the format: InternalIP of First Node <space> IntenalIP os Second Node (in a single line)

```
k get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > Inertnal_IP_LIST

```
* challange 13:

One static Pod "web-static", image busybox is currently running on controleplane node move that static pod to run on node01, don't need to do any other changes.

Note: Static Pod name should be changed from web-static-controlplan to web-static-node01

```
# find the path of the manifest file of the static pod 
ps -aux | grep kubelet 
cat /var/lib/kubelet/config.yaml | grep staticPod
cd /etc/kubernetes/manifests/
cat static.yaml
# move the file to the workernode01 and remove the static pod manifest from the control-plane node
```
* challange 14:

Create a new deployment called web-003 scale the deployment to 3 replicas 

Make sure desired number of pod always running.

```
k create deployment web-003 --image=nginx --replicas=3 --dry-run=client -o yaml > web003.yaml
kubectl apply -f web003.yaml
#the deployement will fail to create the 3 replicas set of the pod so we need to invistigate why 
kubectl -n kube-system get pods 
#the kube-controller-manager is on Crashloopbackoff state
kubectl -n kube-sytem logs kube-controller-manager-controlplane
kubectl -n kube-system describe kube-controller-manager-controlplane
#fund some probleme causing the crash
# need to find the manifest of the static pod
cd /etc/kubernetes/manifest
vim kube-controller-manager
# find a typo in the commande section
```
* challange 15:

Upgrade the cluster (Master and Work ser Node) from 1.18.0 to 1.19.0

Make sure to first drain both Node and make it available after upgrade
```
kubectl get nodes
kubectl drain controlplane --ignore-demonsetes
sudo apt update
apt-cache madison kubeadm
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo apt install kubeadm=1.29.1-1.1
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.29.1
k uncordon masternode
```
* challange 16:

There are 2 worker node associate with kubernetes cluster, use JSONPATH query to retrieve nodes osImage name and store it in file getAllOsImageNodeName.txt
```
k get nodes -o wide
k describe node 
k get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > getAllOsImageNodeName.txt
```
* challange 17:

Deploy a web-load-5461 pod using the nginx:1.17 image with the labels set to tier=web.
```
 kubectl run web-load-5461 --image=nginx:1.17 --labels tier=web --dry-run=client -o yaml > web-load-5461.yaml
```
* challange 18:

Create a pod "front-end-helper" that write "binary downloaded successfully" into a file "front-end-helper-log.txt" and then exit.

Check,Pod "front-end-helper" should be deleted automatically when it's completed.
```
kubectl run front-end-helper --image=busybox -it --rm  --restart=Never -- /bin/sh -c 'echo binary downloßaded successfully' > front-end-helper-log.txt 
```

* challange 19:

Check how many nodes are in ready state and write the information about nodoes tainted with "NoSchedule" into file CKAC00466.txt

At least one node's taint information should be logged in a file with bellow format.
```
{"name": "<<Node_Value>>"
"taints": <<value>>}
{ "name": "<<Node Value>>"
"taints":<<value>>?
```
```
kubectl get nodes
kubectl describe node | grep -i taint 
kubectl taint node workernode04 cpu=high:NoSchedule
kubectl get nodes -o json 
kubectl get nodes -o json | jq ".items[]|{name:.metadata.name, taints:.spec.taints}" > CKAC00466.txt
```
* challange 20:

Create a new namespace named airfusion.
Create a new network policy named my-net-pol in the airfusion namespace.

_Requirements:_

 1. Network Policy should allow PODS within the airfusion to connect to each other only on Port 80. No other ports should be allowed.
 2. No PODs from outside of the airfusion should be able to connect to any pods inside the airfusion.

 ```
 k create ns airfusion 
 k get ns 
 vim networkpolicy_airfusion.yaml  
 ```
 ```
  1 apiVersion: networking.k8s.io/v1
  2 kind: NetworkPlicy
  3 metadata:
  4   name: my-net-pol
  5   namespace: airfusion
  6 spec:
  7   podselector: {}
  8   policyTypes:
  9   - ingress
 10   ingress:
 11   - from:
 12     - podSelector: {}
 13     ports:
 14     - protocol: TCP
 15       port: 80
 ```
 ```
 kubectl apply -f networkpolicy_airfusion.yaml 
 ```

 
