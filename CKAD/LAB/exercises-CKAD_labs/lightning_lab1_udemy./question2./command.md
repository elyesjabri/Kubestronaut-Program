
check what is the network policy
```
master $ kubectl get netpol
NAME           POD-SELECTOR   AGE
default-deny   <none>         114s
```

```
master $ kubectl describe netpol/default-deny
Name:         default-deny
Namespace:    default
Created on:   2020-07-05 19:58:43 +0000 UTC
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     <none> (Allowing the specific traffic to all pods in this namespace)
  Allowing ingress traffic:
    <none> (Selected pods are isolated for ingress connectivity)
  Not affecting egress traffic
  Policy Types: Ingress
master $
```

we have to add network policy to allow traffic on 80/TCP

```
master $ kubectl get svc
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes       ClusterIP   10.96.0.1       <none>        443/TCP   26m
secure-service   ClusterIP   10.107.135.96   <none>        80/TCP    17m
```