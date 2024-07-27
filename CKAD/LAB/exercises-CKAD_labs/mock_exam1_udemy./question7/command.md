

```
master $
master $ kubectl edit pod/webapp-color
error: pods "webapp-color" is invalid
A copy of your changes has been stored to "/tmp/kubectl-edit-yefdz.yaml"
error: Edit cancelled, no valid changes were saved.
master $
master $
master $
master $
master $ kubectl get pod pod/webapp-color -o yaml > web.yaml
error: there is no need to specify a resource type as a separate argument when passing arguments in resource/name form (e.g. 'kubectl get resource/<resource_name>' instead of 'kubectl get resource resource/<resource_name>'
master $ kubectl get pod/webapp-color -o yaml > web.yaml
master $
master $
master $ vi web.yaml
master $
master $
master $ kubectl delete -f web.yaml
pod "webapp-color" deleted
master $ kubectl create -f web.yaml
pod/webapp-color created
master $
master $
master $
master $ kubectl describe pod/webapp-color
Name:         webapp-color
Namespace:    default
Priority:     0
Node:         node01/172.17.0.19
Start Time:   Wed, 08 Jul 2020 04:42:01 +0000
Labels:       name=webapp-color
Annotations:  <none>
Status:       Running
IP:           10.44.0.4
IPs:
  IP:  10.44.0.4
Containers:
  webapp-color:
    Container ID:   docker://e4ffd2286799f3b18a956280bcf4942145a2b3a1fd8698eebfc7476534933513
    Image:          kodekloud/webapp-color
    Image ID:       docker-pullable://kodekloud/webapp-color@sha256:99c3821ea49b89c7a22d3eebab5c2e1ec651452e7675af243485034a72eb1423
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 08 Jul 2020 04:42:04 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      APP_COLOR:  green
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-p8895 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-p8895:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-p8895
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason   Age   From             Message
  ----    ------   ----  ----             -------
  Normal  Pulling  8s    kubelet, node01  Pulling image "kodekloud/webapp-color"
  Normal  Pulled   7s    kubelet, node01  Successfully pulled image "kodekloud/webapp-color"
  Normal  Created  7s    kubelet, node01  Created container webapp-color
  Normal  Started  6s    kubelet, node01  Started container webapp-color
master $
master $
```