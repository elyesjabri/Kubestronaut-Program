#!/bin/bash
# kubectl create namespace longhorn-system
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace 
# helm install longhorn ./longhorn/chart/ --namespace longhorn-system
kubectl -n longhorn-system get pod

# This is not required, nor do I taint nodes anymore.I allow Longhorn storage to use any available space on any node that is not running etcd / control plane.You can simply skip this step and it will work like this.If you’re still convinced you need dedicated nodes, it’s much easier doing it in the Longhorn UI after a node joins the cluster than with taints.

# kubectl taint nodes luna-01 luna-02 luna-03 luna-04 CriticalAddonsOnly=true:NoExecute
# kubectl taint nodes luna-01 luna-02 luna-03 luna-04 StorageOnly=true:NoExecute  