command.md

```
master $ kubectl create service clusterip messaging-service --tcp=6379 --dry-run -o yaml > svc.yaml
W0707 04:03:04.470087   22896 helpers.go:535] --dry-run is deprecated and can be replaced with --dry-run=client.
master $
master $ kubectl create service clusterip messaging-service --tcp=6379 --dry-run=client -o yaml > svc.yaml
master $
master $
master $
master $ vi svc.yaml




```

```
master $ kubectl get pod -n marketing
NAME                     READY   STATUS    RESTARTS   AGE
redis-86c74545dc-z7nmk   1/1     Running   0          37m
master $ kubectl describe pod/redis-86c74545dc-z7nmk -nmarketing
Name:         redis-86c74545dc-z7nmk
Namespace:    marketing
Priority:     0
Node:         node01/172.17.0.18
Start Time:   Tue, 07 Jul 2020 03:28:28 +0000
Labels:       name=redis-pod
              pod-template-hash=86c74545dc
Annotations:  <none>
Status:       Running
IP:           10.32.0.5
IPs:
  IP:           10.32.0.5
Controlled By:  ReplicaSet/redis-86c74545dc
Containers:
  redis-container:
    Container ID:   docker://89de387f180fcd513a63d2766c6d6a7a59623e69acf923e1a1f82542eae4ab27
    Image:          redis:alpine
    Image ID:       docker-pullable://redis@sha256:b7561e4e994ab52cb2062b9c3e943ab2af3287caf9d9aeb6719acc77013769a5
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Tue, 07 Jul 2020 03:28:47 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-66xww (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-66xww:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-66xww
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  37m   default-scheduler  Successfully assigned marketing/redis-86c74545dc-z7nmk to node01
  Normal  Pulling    37m   kubelet, node01    Pulling image "redis:alpine"
  Normal  Pulled     37m   kubelet, node01    Successfully pulled image "redis:alpine"
  Normal  Created    37m   kubelet, node01    Created container redis-container
  Normal  Started    37m   kubelet, node01    Started container redis-container
master $
master $ vi svc.yaml
master $ kubectl create -f svc.yaml
error: error validating "svc.yaml": error validating data: ValidationError(Service.spec.ports[0]): missing required field "port" in io.k8s.api.core.v1.ServicePort; if you choose to ignore these errors, turn validation off with --validate=false
```