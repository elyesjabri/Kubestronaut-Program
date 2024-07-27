# CKA Lab Challenge

## Notes for Set3

* challange 21:

Expose the "audit-web-app" web pod as service "audit-web-app-service" application on port 30002 on the nodes on the cluster.

Note: the web application listens on port 8080
```
kubectl run audit-web-app --image=nginx --port=8080 --dry-run=client -o yaml > audit-web-app.yaml 

k expose pod audit-web-app --name=audit-web-app-service --type=NodePort --dry-run=client -o yaml > audit-web-app-service.yaml
#edit the genrated service manifest and add the nodeport: 300002
```
```
  1 apiVersion: v1
  2 kind: Service
  3 metadata:
  4   creationTimestamp: null
  5   labels:
  6     run: audit-web-app
  7   name: audit-web-app-service
  8 spec:
  9   ports:
 10   - port: 8080
 11     protocol: TCP
 12     targetPort: 8080
 13     nodePort: 30002
 14   selector:
 15     run: audit-web-app
 16   type: NodePort
 17 status:
 18   loadBalancer: {}
```

* challange 22:

Taint the worker node workernode01 with details provide below.
Create a pod called dev-pod-nginx using image=nginx, make sure that workloads are not scheduled to this worker node (workernode01)

Create a another pod called prod-pod-nginx using image=nginx with toleration to be scheduled on workernode01

_Details:_

key:env_type,value:production,operator:Equal and effect: NoSchedule

```
kubectl describe nodes | grep Taints 
kubectl taint node workernode01 env_type=production:NoSchedule  
k create deployment simplepod --image=nginx --replicas=8 
k get pods --selector app=simplepod -o wide 
k run prod-pod-nginx --image=nginx --dry-run=client -o yaml > prod-pod-nginx.yanl
vim prod-pod-nginx.yaml
```
```
#add toleration to the manifest 
  1 apiVersion: v1
  2 kind: Pod
  3 metadata:
  4   labels:
  5     run: prod-pod-nginx
  6   name: prod-pod-nginx
  7 spec:
  8   tolerations:
  9   - key: "env_type"
 10     operator: "Equal"
 11     value: "production"
 12     effect: "NoSchedule"
 13   containers:
 14   - image: nginx
 15     name: prod-pod-nginx
 16     resources: {}
 17   dnsPolicy: ClusterFirst
 18   restartPolicy: Always
 19 status: {}
```

* challange 23:

Create a Pod called pod-jxc56fv, using details mentioned below:
 1. securityContext

    runAsUser: 1000

    fsGroup: 2000
 2. image=redis:alpine

```
kubectl run pod-jxc56fv --image=redis:alpine --dry-run=client -o yaml > pod-jxc56fv.yaml
vim pod-jxc56fv.yaml
```
```
  1 apiVersion: v1
  2 kind: Pod
  3 metadata:
  4   labels:
  5     run: pod-jxc56fv
  6   name: pod-jxc56fv
  7 spec:
  8   securityContext:
  9     runAsUser: 1000
 10     fsGroup: 2000
 11   containers:
 12   - image: redis:alpine
 13     name: pod-jxc56fv
 14     resources: {}
 15   dnsPolicy: ClusterFirst
 16   restartPolicy: Always
 17 status: {}
```
```
#test with whoami
kubectl exec -it pod-jxc56fv -- whoami 

```
* challange 24:

Get the node workernode01 information in JSON format and store it in a file at: /opt/outputs/nodes-fz456723je.json

```
kubectl get node workernode01 -o json > nodes-fz456723je.json 
```
* challange 25:

Take a backup of the ETCD database and save it to root directory with the name: "etcd-backup.db"

```
kubectl -n kube-system describe pod/etcd-masternode

##ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=<trusted-ca-file> --cert=<cert-file> --key=<key-file> \
  snapshot save <backup-file-location>

##Need to find certificates Path 
kubectl -n kube-system describe pod/etcd-masternode | grep trusted-ca
kubectl -n kube-system describe pod/etcd-masternode | grep cert
kubectl -n kube-system describe pod/etcd-masternode | grep key

#In case of 
#sudo apt install etcd-client

ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save etcd_backup
```

* challange 26:

A new application finance-audit-prod is deployed in finance namespace. There is something wrong with it.

Identify and fix the issue.

Note: No configuration changed allowed, you can only delete and recreate the pod (if required).

```

kubectl get pods -n finance
kubectl -n finance describe pod/finance2342
kubectl -n finance get pod finance2342 -o yaml > pod.yaml
#Vim and fix the type and save the new file
kubectl -n finance delete pod finance2342 --grace-periode=0 --force
kubectl apply -f pod.yaml -n finance
```

* challange 27:

A new user named "Alex" need too be created.
Grant him access to the cluster, the user "Alex" should have permission to create,list,get,update and delete pods in the space namespace.

The private key exists at location: /root.alex.key and csr at /root/alex.csr

```
#hint: Certificates and Certificate Signing Requests in the documentation
```

* challange 28:

Create a PersistentVolume, PersistentVolumeClaim and Pod with below specifications

PV
--
Volume Name: mypvlog

Storage: 100Mi

Access Modes: ReadWriteMany

Host Path: /pv/log

Reclaim Policy: Retain

PVC
--
VolumeName: pv-claim-log

Storage Request: 50Mi

Access Modes: ReadWriteMany

Pod
--
Name: my-nginx-pod

Image Name: nginx

Volume: PersistentVolumeClaim=pv claim-log

Volume Mount: /log

```
#Hint: look for persistent volume in the documentation
```

PV
--
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mypvlog
spec:
  capacity:
    storage: 100Mi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /pv/log
```

PVC
--
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pv-claim-log
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 50Mi
```

Pod
--
```
apiVersion: v1
kind: pod
metadata:
  name: my-nginx-pod
spec:
  containers:
  - name: mypod
    image: nginx
    volumeMounts:
    - mountPath: /log
      name: mypod
  volumes:
    - name: mypod
      persistentVolumeClaim:
        claimName: pv-claim-log
```


* challange 29:

Worker Node "workernode01" not respinding, have a look and fix the issue.

```
kubectl get nodes 
kubectl describe node workernode01
#ssh into workernode01
sudo systemctl status kubelet.service
sudo systemctl restart kubelet.service
sudo journalctl -u kublet
#failing to load kube config file 
#fix the cert path in the KubeConfig file q

```
* challange 30:

A pod "my-nginx-pod" (image=nginx) in custum namespace is not running. Find the problem and fix it and make it running 

Note: All the supported definition files has been placed at root 

```
kubectl -n custom get pods 
kubectl describe -n custum pod/my-nginx-pod
#miss configuration in the PVC 
#the pv is created in the default name space
```