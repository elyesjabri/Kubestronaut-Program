# Notes for lab6 




###   Question 1 3%

Deploy a pod called nginxpod with image nginx in controlplanem Make sure pod is not scheduled in worker node

```
k run nginxpod --image=nginx --dry-run=client -o yaml > 1.yaml

vim 1.yaml 

## under spec: app 

#nodeName: masternode

```

### Question 2 4%

Expose a existing pod called nginxpod as a service, service name should be nginxsvc and pod port=80 

```
k expose po nginx --name=nginxsvc --port=80 

```

### Question 3 6%

Expose a existing pod called nginxpodm service name as nginxnideportsvc, servoce should access through Nodeport (Nodeport=30200)

```
 k expose po nginx --name=ngnxsvcnodeport --port=80 --type=NodePort  

 # to edit the port  

 k edit svc ngnxsvcnodeport  

```

### Question 4 4%

You can find an existing deployment frontend in production namespace, scale down the replicas to 2 and change the image to nginx:1.25

```
 k create deployment frontend --image=nginx --replicas=4 -n production 

k get deploy -n production   

k scale deploy frontend --replicas=2 -n production   

k set image deployment frontend nginx=nginx:1.25 -n production 

k describe deployment frontend -n production | grep -i nginx 
```


### Question 5 6%

Auto scale the existing deploument frontend in prodcution namespace at 80% of pod CPU usagem and set Minimum replicas=3 and Maxixmum replicas=5 

```
k -n production autoscale deploy frontend --min=3 --max=5 --cpu-percent=80

k get hpa -n production

```
### Question 6 4%

Expose existing deployment in production namespace named as frontend through Nodeport and Nodeport service name should be frontendsvc

```
 k expose deployment frontend --name=frontendsvc --port=80 --type=NodePort -n production
```
### Question 7 3%

You can find a pod named task-pv-pod in the default namespacem please check the status of the pod and trouvleshootm you can recreate the pod if you want

```
k get poo 

## pod is in pending status 

k descripe pod task-pod

## pv not fund 
## create or fix the pv and pvc 
## pv and pvc exist 
## check desc pod again 
## find typo edit the pod config and fix it 
```

### Question 8 6%

Deploy a pod withthe following specifications:

Pod name: web-pod

image: httpd

Node: workernode02

note: do not modify any setting on master and worker nodes 

```
k run  web-pod --image=httpd  --dry-run=client -o yaml > httpod.yaml 

vim httpod.yaml 

# under spec: add nodeName:workernode02

## The pod is pending status

k describe pod 

## taint and toleration error 

k get nodes -o workernode02 -o jsonpath='{.spec.taints}'

## add toleration to the pod config under the spec: 

 #
tolerations:
- key: "key1"
  operator: "Exists"
  effect: "NoSchedule"

### k replace -f htmpod.yaml --forde
```

### Question 9 6%

Create a new PersostentVolume named web-pv it should have a capacity of 2Gi, accessMode ReadWriteOnce, hostPath /vol/data and no storageClassName defined. 

Next create a new PersistentVolumeClaim in NameSoace production named web-pvc. It should request 2Gi Storage accessMode ReadWriteOnce and should not define a storageClassName. the PVC should bound to the PV correctly. 

Finally create a new Deployment web-deploy in Namespace production which mounts that volume at /tmp/web-data. The pods of that deployment should be of image nginx:1.14.2

```
look for pv and second link in the k8s documentation 
```
### Question 10 2%

Create a kubernetes Pod named "my-busybox" with the busyboox:1.13.1 image. The pod should run a sleep command for 4800 seconds. Verify that the Pod is running in node01

```
k run my-busybox --image=busybox:1.13.1 --command sleep 4800 --dry-run=client -o yaml > mybusybox.yaml
```

### Question 11 4%

You have a kubernetes cluster that runs a three-tier web application.
a frontend tier (port 80), an application tier (port 8080), and a backend tier (3306). The security team has mandated that the backend tier hsould only be accessible from the application tier.

```
from documentation
```

### Question 12 4%

You have a Kubernetes cluster and running pods in multiple namespaces, The security team has mandated that the db pods on Project-a namespace only accessible from the service pods that are running in project-b namespace.

```
```


### Question 13 4%

You can find a pod named multi-pod is running in the cluster and that is logging to a volume. You need to insert a sidecar container into the pod that will also read the logs from the volume using this command "tail -f /var/busybox/log*" . side car specifications given below 

image: busybox 

name: sidecar 

Volumepath: /var/busybox/log

```
check side car from doc
and multi.yaml
```

### Question 14 2%

Create a CronJob for running every 2 minutes with busybox image. The job name should be my-job and it should print hte urrent date and time to the console. after running the job save any one of the pod logs to below path /root/logs.txt

```
example in k8s doc 
```

### Question 15 1%

Find the schedulable nodes in the cluster and save the name and count in to the below file

file path: /root/nodes.txt

```
kubectl get nodes -o jsonpath='{.items[*].spec.taints}'  
```

### Question 16 6%

Deploy a pod on node01 as per the below specification 

pod name: web-pod2 

container name: web 

image: nginx 

```
#kubelet damon in workernode02 not working 
```

### Question 17 6%

Join node01 worker node to the cluster, and you have to deploy a pod in the node01 , pod name should be web and image should be nginx

```

kubectl get nodes

### join node01
### in the documentation search for kubeadm token 
### ssh on master node 

kubeadm token create --print-join-command 

## run the generated command on ssh node01
### we got some error 
### find the problem

systemctl status kublet 
### kubelet not running 
systemctl restart kublet 
### join again 
#### node aded to the cluster 
#### pod creation 

k run web --image=nginx
```

### Question 18 6%

There was a security incident where an intruder was able to access the whole cluster from a single hacked web Pod.

To prevent this create a NetworkPolicy in default Namespace. It should allow the web-* Pods only to connect to service-* Pods on port 8080

After implimentation, connections from web-* Pods to application-* Pods on poort 80 should also be blocked

```
## get egress from networkpolicies documentation 
## see egress18.yaml example
```
### Question 19 5%

Create a new service account gitops in Namespace project-1 create a Role and a RoleBinding, both named gitops-role and gitops-rolebinding as well. These should allow the new SA to only create Secrets and ConfigMaps in that Namespace.

```
 k create sa gitops -n project-1

k get sa -n project-1

k create role -n project-1 gitops-role  --verb=create --resource=configmap,secrets

k get role -n project-1

k describe -n project-1 role/gitops-role

k create -n project-1 rolebinding gitops-rolebinding --role=gitops-role  --serviceaccount=project-1:gitops

k get rolebinding -n project-1

k -n project-1 auth can-i create pod --as system:serviceaccount:project-1:gitops
k -n project-1 auth can-i create configmap --as system:serviceaccount:project-1:gitops
k -n project-1 auth can-i create secrets --as system:serviceaccount:project-1:gitops
k -n project-1 auth can-i create namespaces --as system:serviceaccount:project-1:gitops
k -n project-1 auth can-i create deployments --as system:serviceaccount:project-1:gitops
```

### Question 20 %

```
https://killercoda.com/killer-shell-cka/scenario/ingress-create
```

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: world
  namespace: world
  annotations:
    # this annotation removes the need for a trailing slash when calling urls
    # but it is not necessary for solving this scenario
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx # k get ingressclass
  rules:
  - host: "world.universe.mine"
    http:
      paths:
      - path: /europe
        pathType: Prefix
        backend:
          service:
            name: europe
            port:
              number: 80
      - path: /asia
        pathType: Prefix
        backend:
          service:
            name: asia
            port:
              number: 80
  ```

### Question 21  5%

Use namespace projcet-1 for the following. Create a DaemonSet named daemon-imp with image httpd:2.4-alpine and labels id=daemon-imp and uuid=184226a0b-5f59-4e10-923f-c0e078e83462. 

The pods it creates should request 20 millicore cpu and 20 mebibyte memory. The pods of that DaemonSet shoould run on all nodes, also controlplanes.

```
kaf damon20.yaml   
```

### Question 22  5%

ETCD Backup and restore 

```
ETCD SnapShot in the documentation
```
### Question 23  12%

Create a snapshot of ETCD and save it to /root/backup.etcd-backup-new.db

you can use the below certificates for taking the snapshot 

CA certificate: /root/certificates/ca.crt

Client certificate: /root/certificates/server.crt

key: /root/certificates/server.key

restore an old snapshot located at /root/backup/etcd-backup-old.db to /var/liv/etcd-backup

```
same as the k8s documentation, search for etcd snapshot 

while restoring db to different location update etcd.yaml manifest 

```

### Question 24  4%

You can find a pod named multi0container-pod running in the cluster, take the container logs and the container id of the c2 container and save it into the below mentioned location. restart the C2 container and write the cluster events to the /root.event.log file.

log save to /root/logs.txt

Container id to /root/id.txt

```
k logs multi-container-pod -c c2 > /root/logs.txt

kubectl get events --sort-by=.metadata.creationTimestamp

kubectl get events --sort-by=metadata.creationTimestamp > /root/events.log

```

### Question 25  4%

Create a replicaset with below specifications

Name= web-app

Image= nginx 

Replicas= 3

Please note, there is already a pod runnong in our cluster named web-front, please make sure the total numbr of pods running in the cluster is not more than 3 

```
## to add the exist pod to the replicas set get the pod's label 

k edit po web-frontend 

k create deploy web-app --image=nginx --dry-run=client -o yaml > replicasset25.yaml

vim replicaset25.yaml 

#### change the kind to replicaset
#### add the labels 
#### labels: 
####   tiers: frontend
#### set replicas to 3 

kubectl apply -f replicast25.yaml 

k get pods | grep web-app

k get rs (k get replicast)

k describe rs web-app 

```

### Question 26 %

Config map from KillerCoda 

### Question 27 2%

list the pods in the sfari namespace, sorted by creation time and save the command to the below path 

/root/pods_timestamp.txt

```
k get po -n safari 

k get po -n safari --sort-by=.metadata.creationTimestamp

k get po -n safari --sort-by=.metadata.creationTimestamp | tac 

k get po -n safari --sort-by=.metadata.creationTimestamp > /root/pods_timestamp.txt

```

### Question 28 4%

Create a new deployment named 'web' using the 'nginx:1.16' image with 3 replicas. Ensure that no pods are scheduled on the node named 'kworker'

```
k get nodes 

kubectl cordon kworker

kubectl create deployment --image=nginx -r 3 --dry-run=client -o yaml > deploy28.yaml

kubectl apply -f deploy28.yaml

k get deploy 

k get pods -o wide 

k uncordon kworker

```

### Question 29 6%

Mark the worker node named kworker as unschedukable and reschedule all th epods running on it 

```
k get pods -o wide 

k cordon kworker 

k drain kworker --ignore-daemonsets

```

### Question 30 12%

Given an existing kubernetes cluster running version 1.26.0 upgrade the master node and worker node to version 1.27.0. Be sure to drain the master and worker node before upgrading it and uncordon it after the upgrade

```
k get nodes - o wide 

k cordon masternode

k cordon workernode

k drain masternode --ignore-daemonsetes

k drain workernode --ignore-daemonsetes

#### ssh into masternnode

### follow the k8s documentations 

sudo apt-mark unhold kubeadm 

sudo apt update 

sudo apt install kubeadm=1.27.0-00

sudo apt-mark hold kubeadm 

sudo kubeadm upgrade plan 

sudo kubeadm upgrade apply v.1.27.0-00

### dont forget to update kubelet 

### do the same on workernode

kubectl uncordon masternode

kubectl uncordon workernode
```

### Question 31 4%

Add an init container named init-container (which has been defined in spec file /home/master/opt/web-pod.yaml).

The init container should create an empty file named /workdir/conf.txt 

If /workdir/conf.txt is not detected, the pood should exit.

Once the Spec file has been updated with the init container definition, the pod should be created

```
cd /home/master/opt

vim web-prod.yaml

## lookup for ini container in documentation 

## in the command section use touch commande for creating the config file
## fix the volumeMount 
 name: workdir
 mountpath: /workdir 

```