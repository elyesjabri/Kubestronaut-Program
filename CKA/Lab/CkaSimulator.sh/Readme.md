# Cka Simulator Notes
## Killer.sh 

### Task1:

You have access to multiple cluster from you main terminal through kubectl context. Write all those context names into /opt/course/contexts.

Next write a command to display the current context into /opt/course/1/context-default-kublectl.sh , the command should use kubectl .

Finally write a second command doing the same thing into /opt/course/1/context-default-no-kubectl.sh , but wihtout the use of kubectl 

```
k config get-contexts -o name > /opt/course/contexts

echo "k config get-contexts -o name" /opt/course/1/context-default-kublectl.sh

echo " cat /etc/kubernetes/kubelet.conf | grep -i current-context | sed sed 's/current-context: //' "> /opt/course/1/context-default-no-kubectl.sh
```

### Task2:

Use context: kubectl config use-context k8s-c1-H 

Create a single Pod of image httpd:2.4.41-alpine in Namespace default. The pod should be named pod1 and the conatainer should be named pod1-container. This pod should only be scheduled on a master node, do not add new labels to any nodes.

```
kubectl config use-context k8s-c1-H 


k run pod1 --image=httpd:2.4.41-alpine --dry-run=client -o yaml > 2.yaml

vim 2.yaml 

### add nodeName and fix container name

Kaf 2.yaml 

k get nodes -o wide | grep pod1
```

### Task 3: 

Use context kubectl config use-context k8s-c1-h 

There are two pods named o3db-* in Namesoace project-c13. C13 management asked you to cale the pods down to obne replicas to save resources.

```
kubectl config use-context k8s-c1-h 

k get statfullset -n project-c13

k scale statfullset o3db --replicas=1 -n project-c13
```

### Task 4:

Use context kubectl config use-context k8s-c1-H 

Do the following in Namespace default. Create a single pod named ready-if-service-ready of image nginx:1.16.1-alpine. Configure a livenessProbe which simple runs TRUE . also configure a ReadinessProbe which does check it the url http://service-am-i-ready:80 is reachble, you can use wget -T2 -0- http://service-am-i-ready:80 for this. Start the pd and confirm it isn't ready because of the RedinessProbe.

Createa second Pod named am-i-ready of image nginx:1.16.1-alpine with label id: cross-server-ready .  

The already existing Service service-am-i-ready should now have thad second Pod as endpoint .

Now the first pod should be in ready state, Confirm That.

```
kubectl config use-context k8s-c1-H 

k run ready-if-service-ready -n default --image=mginx --dry-run -o yaml > 4.yaml

........


```

### Task 5: 

use context kubectl config use-context k8s-c1-H 

There are various Pods in all namespaces. Write a command into /opt/course/5/find_pods.sh which lists all Pods sorted by their AGE (metadata.creationTimestamp)

write a second command into  /opt/course/5/find_pods-uid.sh which lists all Pods sorted by field metadata.uid . Use kubectl sorting for both commands. 

```
echo "k get pods -A --sort-by=metadata.creationTimestamp " > file

k get pods -A --sort-by=metadata.uid

```

### Task 6: 

Use context kubectl config use-context k8s-c1-H 

Create a new PersistentVolume named sfari-pv. it should have a capacity of 2Gi, accessMode ReadWriteOnce, hostPath /volumes/data and no storageClassName defined.

Next Create a new PersistentVolumeClaim in namespace project-tigeer named safari-pvc. It should request 2Gi storage, accessMode ReadWriteOnce and should not define a storageClassName. The PVC should bound to the PV correctly.

Finally create a new deployment safari in Namespace project-tiger which mnounts that volume at /tmp/safari-data . The pods of that Deployment should be of image httpd:2.4.41-alpine .

```
### look for pv and pvc in the documentation 

```

### Task 7: 

Use Context: kubectl config use-context k8s-c1-H 

The metrics-server has been installed in the cluster. Your college would like to know the kubectl commands to : 

1- show Nodes resource usage

2- show Pods and their containers resource usage.

Please write the commands into /opt/course/7/node.sh and /opt/course/7/pod.sh

```
k top nodes 

k top pods 

k top pods --containers

```

### Task 8:

ssh into the master node with ssh cluster1-master1 . 

check how the master components kublet, kube-apiserver, kube-scheduler, kube-controller-manager and etcd are started/installed on the master node. 

write your finding into file /opt/course/8/master-components.txt . The file should be structured like : 

kubelet:
kube-apiserver:
kube-scheduler:
kube-controller-manager:
etcd:
dns:

choice of type are : not-installed, process, static-pod,pod

### Task 9: 

Use contest kubectl config use-context k8s-c2-AC 

Ssh into the master node with ssh cluster2-master1.

Temporarilly stop the kube-scheduler, this means in a way that you cans start it again afterwards.

Create a single Pod named manual-schedule of image httpd:2.4-alpine, confirm its createed but not scheduled on any node.

Now you're thescheduler and have allits power, manually schedule that pod on node cluster2-aster1. Make sure it's runnng.

Start the kube-scheduler again and confirm its running correctly by creating a second pod named manual0schedule2 of image httpd:2.4.-alpine and check if it's running on cluster2-worker1.

```
kubectl config use-context k8s-c2-AC 

ssh cluster2-master1

```

### Task 10:

Use context kubectl config use-context k8s-c1-H 

Create a new ServiceAccount processor in Namespcae project-hamster. Create a role and rolebinding, both named processor as Well. These should allow the new SA to only create Secrets ans ConfigMaps in that Namespace

```
 k auth can-i create pod   --as=system:serviceaccount:project-hamster:processor -n project-hamster
```

### Task 11:

Use context kubectl config use-context k8s-c1-H 

Use Namespace project-tiger for the following. Create a DaemonSet named ds-important with image httpd:2.4-alpine and labels id=ds-important and uuid=98930645. The Pods it creates should request 10 millicore cpu and 10 mebibyte memory. the pods of that daemonSet should run on all nodes, master and worker.

```
## daemonset example in documenation 

```

### Task 12: 

Use context kubectl config use-context k8s-c1-H 

Use namespace project-tiger for the following. Create a deployment named deploy-important with label id=very-important (the pods should also have this label) and 3 replicas. It hould contain two containers, the first named container1 with image nginx and the second one named container2 with image httpd.

These should be only ever one pod of that deployment running on one woeker node. We have two woweker nodes: cluster1-worker1 and cluster1-worker2. Because the deployment has three replicas the result should be that on both nodes one pod is running. The thirs pod won't be schduled, unless a new worker node will be added.

In a way we kind of simulate the behaviour of a DaemonSet here, but using a deployment and a fixed number of replicas.


```
##### anti affinity pod !!!

```

### Task 13:

Use context kubectl config use-context k8s-c1-H 

Create a pod named multi-container-playground in namespace default with three containersm named c1,c2,c3. There should be a volume attached to that pod and mounted into every container, but the volume shouldn't be persisted or shared with other pods.

container c1 should be of image nginx and have the name of the node whre its pod is running available as environement viariable MY_NODE_NAME. 

Container c2 should be of image busybox and write the oudput of the date command every second in the shared volume into fole date.log . You can use while true; do date >> /your/vol/path/date.log; sleep1; done for this.

Container c3 should be of image busybox and constantly send the content of file date.log from the shared volume to stdout. You can use tail -f /your/vol/path/date.log for this.

Check the logs of container c3 to confirm correct setup 



```

```

### Task 24:

Use context kubectl config use-context k8s-c1-H 

There was a security incident where an intruder was able to access the whole cluster from a single hacked backend pod.

to prevent this create a NetworkPolicy called np-backend in Namespace project-snake. It should allow the backed-* pods only to:

* connect to db-1* Pods on port 1111
* connect to db2-* Pods on port 2222

Use the app label of Pods in your policy.

After implementation, connections from backend-* Pods to vault-* Pods on port 3333 should for example no longer work.

```

### 




```

### Task14:

 Use context kubectl use-context k8s-c1-H

You're ask to find out the following information about the cluster k8s-c1-H

1. how many master nodes are available ?

2. how many worker nodes are available ?

3. What is the Service CIDR ?

4. Which Networking (or CNI plugin) is configured and where is its config file?

5. Which suffix will static pods have that run on cluster1-worker1?

Write you answer into file /opt/course/14/cluster-info.

```
k get nodes | grep -i control | wc -l

k get nodes | grep -i worker | wc -l 

k get pods -o wide -n kube-system | grep api 

sudo cat /etc/kubernetes/manifest/kube-apiserver.yaml | less

#### look for CIDR service range

```

### Task 15:

Use context kubectl config use-context k8s-c2-AC 

Write a command into /opt/course/15/cluster-events.sh 

which shows the latest events in the whole cluster, ordred by time (metadata.creationTimestamp). Use kubectl for it.

Now kill the kube-proxy Pod running on node cluster2-worker1 and write the vents this caused into  /opt/course/15/pod_kill.log 

Finally kill the containerd container of the kube-proxy Pod on node cluster2-worker1 and write the events into /opt/course/15/container_kill.log

Do you notice differences in the events both action caused ? 


```
k get events -A --sort-by="metadata.creationTimestamp" 

```

### Task 16:

Use context: kubectl config use-context k8s-C1-H

Create a new Namespace called cka-master.

Write the names of all namespaced kubernets resources (like pod,secret,configmap,....) into /opt/course/16/resources.txt.


Find the project-* Namespace with the highest number of Roles defined in it and write its name and amounts of Roles into /opt/course/16/croded-namespace.txt



```

 k api-resources --namespaced -o name | less

 k get ns | grep project

 k get roles  -A --no-headers | grep project

```


### task 17:

Use context kubectl config use-context k8s-c1-H

in Namespace project-tiger create a pod named tigers-reunite of image httpd with labels pod-container and container=pod. Find out on which node the pod is scheduled . SSh into that node and find the containerd container belonging to that pod.

Using command crictl:

1. write the ID of the container and the info.runtimeType into /opt/course/17/pod-container.txt

2. write the logs of the container into /opt/course/17/pod-container.log

```

sudo crictl ps | grep reunite

sudo crictl inspect c2744efd7445 | grep -i runtimeType -B 20

sudo crictl logs c7489445456

```

### Task18:

Use context kubectl config use-context k8s-c3-CCC 

There seems to be an issue with the kubelet not running on cluster3-worker1. Fix it and confirm that cluster has node cluster-worker1 avaible in Ready state afterwoards. You should be able to schedule a Pod on cluster3-worker1 afterwards.

Write the reason of the issue into /opt/course/18/reason.txt


```

k get nodes

### workernode03 is not ready 
### ssh into the node

ps aux | grep -i kubelet 

sudo systemctl status kubelet 

sudo systemctl start kubelet

whereis kubelet 

### fix the service.d with the correct bin path 

sudo systemctl daemon-reload 

sudo systemctl restart kubelet


```

### Task19: 


Use context kubectl config use-context k8s-c3-CCC

Do the following in a new Namespace secret. Create a pod named secret-pod of image busybox which should keep running for some time.

There is an existing Secret located at /opt/course/19/secret1.yaml, create it in the Namespace secret and mount it readmonly into the pod at /tmp/secret1

Create a new secret in Namespace secret called secret2 which sould contain user=user1 and pass=1234. These entries should be available inside the Pod's container as environment variable APP_USER and APP_PASS.

Confirm eveything is working.

```
k create -f secret.yaml -n secret

k create secret generic secret2 -n secret --from-literal="user=user1" --from-litral="pass=1234"

vim pod-secret.yaml 

####### https://kubernetes.io/docs/concepts/configuration/secret/




```


### Task 20:


Your coworker said node cluster3-worker2 is running an older kubernets version and it is not part of the cluster. Update kuberntes on that node to the exact version that's running on cluster3-master1.Then add this node to the cluster. Use Kubeadm for this.


### Task21:

Create a Static Pod named my-static-pod in Namespace default on cluster3-master1. It should be of image nginx and have resouce request for 10m CPU and 20Mi memory.

Then Create a NodePort Service named static-pod-service which exposes that static Pod on port 80 and check if it has Endpoints and if its reachble through the cluster3-master1 internal IP address. You can connect to the internal node IPs from your main Terminal.


```

##### for the static pod ssh to the node 

cd /etc/kubernetes/manifest/

k run static-pod --image=nginx -n default --dry-run=client -o yaml > staticpod.yaml

vim staticpod.yaml 

### from the documentation copy request limite quota to the staticpod.yaml 

k get pods 

k expose pod -n default --name:static-pod-service static-pod-cluster3-master1 --port=80 --type=NodePort 

k get svc -n default 

curl 10.32.0.4:80

##### check the suffix for the pod 

```


### Task 22: 


Check how long the kube-apiserver server certificate is valid on cluster2-master1. Do this with openssl or cfssl. Write the expiration date into /opt/course/22/expiration.

Also run the correct Kubeadm command to list the expiration dates and confirm both methodes show the same date.

Write the correct kubeadm command tht would renew the apiserver server certificate into /opt/course/22/kubeadm-renew-cert.sh 



```

 sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml | less

#### shearch for apiserver.crt


 openssl x509 --noout --text -in /etc/kubernetes/pki/apiserver.crt | grep -i validity -A 2

 sudo kubeadm certs check-expiration | grep apiserver
```


### Task 23:




de cluster2-worker1 has been added to the cluster using kubeadm ans TLS bootstraping.

Find the issuer and Extended key usage values of the cluster2-worker1:

1. kubelet client certificatem the one used for outgoing connections to the kube-apiserver.

2. kublet server certificate, the one used for incoming connections from the kube-apiserver 

Write the information into file /opt/course/12/certificate-info.txt 

Compare the "issuer" and "Extended Key usage" fields of both certificates and make sens of these.

```
sudo openssl x509 --noout --text -in /var/lib/kubelet/pki/kubelet-client-current.pem | grep -i issue


sudo openssl x509 --noout --text -in /var/lib/kubelet/pki/kubelet-client-current.pem | grep -i Extended -A 10

## do the same for the other type of certificate 
```

### Task 25:

Make a backup of etcd running on cluster3-master1 and save it on the master node at /tmp/etcd-backup.db . 

Then create a pod of your kind in the cluster

Finally restore the backup, confirm the cluster is still working and that the created pod is no longer with us 









