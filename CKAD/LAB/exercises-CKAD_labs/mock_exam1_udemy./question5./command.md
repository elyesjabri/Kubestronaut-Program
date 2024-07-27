command.md

```
master $ kubectl describe replicaset/rs-d33393
Name:         rs-d33393
Namespace:    default
Selector:     name=busybox-pod
Labels:       <none>
Annotations:  <none>
Replicas:     4 current / 4 desired
Pods Status:  0 Running / 4 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  name=busybox-pod
  Containers:
   busybox-container:
    Image:      busyboxXXXXXXX
    Port:       <none>
    Host Port:  <none>
    Command:
      sh
      -c
      echo Hello Kubernetes! && sleep 3600
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  34s   replicaset-controller  Created pod: rs-d33393-w799v
  Normal  SuccessfulCreate  34s   replicaset-controller  Created pod: rs-d33393-mj9sn
  Normal  SuccessfulCreate  34s   replicaset-controller  Created pod: rs-d33393-kg7ft
  Normal  SuccessfulCreate  34s   replicaset-controller  Created pod: rs-d33393-gddwd
master $
master $
master $ kubectl describe pod/rs-d33393-w799v
Name:         rs-d33393-w799v
Namespace:    default
Priority:     0
Node:         node01/172.17.0.18
Start Time:   Tue, 07 Jul 2020 03:49:47 +0000
Labels:       name=busybox-pod
Annotations:  <none>
Status:       Pending
IP:           10.32.0.13
IPs:
  IP:           10.32.0.13
Controlled By:  ReplicaSet/rs-d33393
Containers:
  busybox-container:
    Container ID:
    Image:         busyboxXXXXXXX
    Image ID:
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      echo Hello Kubernetes! && sleep 3600
    State:          Waiting
      Reason:       InvalidImageName
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-vh42j (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  default-token-vh42j:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-vh42j
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason         Age               From               Message
  ----     ------         ----              ----               -------
  Normal   Scheduled      44s               default-scheduler  Successfully assigned default/rs-d33393-w799v to node01
  Warning  InspectFailed  7s (x6 over 42s)  kubelet, node01    Failed to apply default image tag "busyboxXXXXXXX": couldn't parse image reference "busyboxXXXXXXX": invalid reference format: repository name must be lowercase
  Warning  Failed         7s (x6 over 42s)  kubelet, node01    Error: InvalidImageName
master $
master $
master $ kubectl scale replicaset/rs-d33393
Error: required flag(s) "replicas" not set
master $ kubectl scale replicaset/rs-d33393 --replicas 4
replicaset.apps/rs-d33393 scaled
master $
master $ kubectl describe replicaset/rs-d33393
Name:         rs-d33393
Namespace:    default
Selector:     name=busybox-pod
Labels:       <none>
Annotations:  <none>
Replicas:     4 current / 4 desired
Pods Status:  0 Running / 4 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  name=busybox-pod
  Containers:
   busybox-container:
    Image:      busybox
    Port:       <none>
    Host Port:  <none>
    Command:
      sh
      -c
      echo Hello Kubernetes! && sleep 3600
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age    From                   Message
  ----    ------            ----   ----                   -------
  Normal  SuccessfulCreate  2m25s  replicaset-controller  Created pod: rs-d33393-w799v
  Normal  SuccessfulCreate  2m25s  replicaset-controller  Created pod: rs-d33393-mj9sn
  Normal  SuccessfulCreate  2m25s  replicaset-controller  Created pod: rs-d33393-kg7ft
  Normal  SuccessfulCreate  2m25s  replicaset-controller  Created pod: rs-d33393-gddwd
master $
master $
master $

```


```
manually deleted old pods
TODO: find better way of deleteing old pods so that new one are created with right image
```