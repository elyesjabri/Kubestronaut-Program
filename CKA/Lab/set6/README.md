# Set6 lab 

## Challenge No:1

Crete a new pod called admin-pod with image busybox.

Allow the pod to be able to set .

The container should sleep for 3200 seconds. 

```
k run admin-pod --image=busybox --command sleep 3600 --dry-run=client -o yaml > task1.yaml

# then add sys_time and command from documentation
```

## challenge No:2 

Troubleshoot and fix the kubeconfig file

```
kubcetl config view 

found miss match port number 

```

## challenge No:3

Create a new deployment called web-proj-268, with image nginx:1.16 and 1 replicas. Next upgrade the deployment to version 1.17 using rolling update 

Make sure that the version upgrade is recorded in the resouee annotation.

```
k create deployment web-proj-268 --image=nginx:1.16 --replicas=1     

k set image deployment web-proj-268 nginx=nginx:1.17 --record      

k describe deployment web-proj-268 | grep nginx           

k rollout history deployment web-proj-268     
```

## challenge No:4

Create a new deployment called web-003, Scale the deployment to 3 replicas. Make sure desired number of pod always running.

```
k create deployment web-003 --image=nginx 

k scale deployment web-003 --replicas=3  

### unable to create the pods 
### kubectl -n kube-system get pods 
### kune-controller-manager CrashLoopBackOff

kubectl -n kube-system logs kube-controller-manager-controlplane
kubectl -n kube-system describe kube-controller-manager-controlplane

### typo 

cd /etc/kubernetes/manifest

vim kube-controller-manager.yaml 

### find and fix the typo 

```

## challenge No:5

Upgrade the cluster (Master and worker Node) from 1.18.0 to 1.19.0 

Make sure to first drain both Node and make it available after upgrade 

```
k get node 

k drain control-plan --ignore-daemonsets

apt update 

apt install kubeadm=1.19.0-00

kubeadm upgrade apply v1.19.0

apt install kubelet=1.19.0-00

systemctl restart kubelet 

kubectl get nodes 

kubectl uncordon controlplane

kubectl get nodes 

kubectl drain node01 --ignore-daemonset

## repeat the steps on all the nodes 

```

## challange No:6

Deploy a web-load-5461 pod using the nginx:1.17 image with the labels set to tier=web.

```
 k run web-load-54-61 --image=nginx:1.17 -l tier=web  

 k describe pod web-load-54-61  | grep -i tier  

 k get pods --show-labels  
```

