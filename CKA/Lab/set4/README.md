# CKA Lab Challenge

## Notes for Set4

* challange 31:

Create a multi-container pod, "multi-pod" in development namespace using images: nginx and redis.

```
kubectl get ns
kubectl create ns development
k run multi-pod --image=nginx --dry-run=client -o yaml > multi-pod.yaml  
#add the second container to the manifest
vim multi-pod.yaml
```
```
  1 apiVersion: v1
  2 kind: Pod
  3 metadata:
  4   creationTimestamp: null
  5   labels:
  6     run: multi-pod
  7   name: multi-pod
  8   namespace: development
  9 spec:
 10   containers:
 11   - image: nginx
 12     name: nginx
 13     resources: {}
 14   - image: redis
 15     name: redis
 16   dnsPolicy: ClusterFirst
 17   restartPolicy: Always
 18 status: {}
```

* challange 35:

There are 3 Node in the Cluster, create DeamonSet (Name:mypod,Image:nginx) on each node execpt one node (Worker-node-3)

```
kubectl get node
kubectl taint node workernode03 env=qa:Noschedule
kubectl describe node workernode03 | grep Taint

#deamonset is like a deploy same manifest except for the kind

```
