# Note for mock Exam 

Task
SECTION: ARCHITECTURE, INSTALL AND MAINTENANCE


For this question, please set the context to cluster2 by running:


kubectl config use-context cluster2


Install etcd utility on cluster2-controlplane node so that we can take/restore etcd backups.


You can ssh to the controlplane node by running ssh root@cluster2-controlplane from the student-node.

```
student-node ~ ➜ ssh root@cluster2-controlplane

cluster2-controlplane ~ ➜ cd /tmp
cluster2-controlplane ~ ➜ export RELEASE=$(curl -s https://api.github.com/repos/etcd-io/etcd/releases/latest | grep tag_name | cut -d '"' -f 4)
cluster2-controlplane ~ ➜ wget https://github.com/etcd-io/etcd/releases/download/${RELEASE}/etcd-${RELEASE}-linux-amd64.tar.gz
cluster2-controlplane ~ ➜ tar xvf etcd-${RELEASE}-linux-amd64.tar.gz ; cd etcd-${RELEASE}-linux-amd64
cluster2-controlplane ~ ➜ mv etcd etcdctl  /usr/local/bin/


```

##

SECTION: ARCHITECTURE, INSTALL AND MAINTENANCE


Find the pod that consumes the most CPU and store the result to the file /opt/high_cpu_pod in the following format cluster_name,namespace,pod_name.


The pod could be in any namespace in any of the clusters that are currently configured on the student-node.

NOTE: It's recommended to wait for a few minutes to allow deployed objects to become fully operational and start consuming resources.

```
Check out the metrics for all pods across all clusters:


student-node ~ ➜  kubectl top pods -A --context cluster1 --no-headers | sort -nr -k3 | head -1
kube-system   kube-apiserver-cluster1-controlplane            30m   258Mi   

student-node ~ ➜  kubectl top pods -A --context cluster2 --no-headers | sort -nr -k3 | head -1
kube-system   metrics-server-7cd5fcb6b7-fhdrl           5m    18Mi   

student-node ~ ➜  kubectl top pods -A --context cluster3 --no-headers | sort -nr -k3 | head -1
kube-system   metrics-server-7cd5fcb6b7-zvfrg           5m    18Mi   

student-node ~ ➜  kubectl top pods -A --context cluster4 --no-headers | sort -nr -k3 | head -1
kube-system   metrics-server-7cd5fcb6b7-zvfrg           5m    18Mi   

Save the result in the correct format to the file:


student-node ~ ➜  echo cluster1,kube-system,kube-apiserver-cluster1-controlplane > /opt/high_cpu_pod 

```

##

SECTION: ARCHITECTURE, INSTALL AND MAINTENANCE


For this question, please set the context to cluster3 by running:


kubectl config use-context cluster3


A pod called logger-cka03-arch has been created in the default namespace. Inspect this pod and save ALL INFO and ERROR's to the file /root/logger-cka03-arch-all on the student-node.

```
kubectl logs logger-cka03-arch --context cluster3 > /root/logger-cka03-arch-all
```

##
SECTION: TROUBLESHOOTING


For this question, please set the context to cluster1 by running:


kubectl config use-context cluster1


The blue-dp-cka09-trb deployment is having 0 out of 1 pods running. Fix the issue to make sure that pod is up and running.

```
sub path for nginx ///


```

##

For this question, please set the context to cluster1 by running:


kubectl config use-context cluster1


One of the nginx based pod called cyan-pod-cka28-trb is running under cyan-ns-cka28-trb namespace and it is exposed within the cluster using cyan-svc-cka28-trb service.

This is a restricted pod so a network policy called cyan-np-cka28-trb has been created in the same namespace to apply some restrictions on this pod.


Two other pods called cyan-white-cka28-trb and cyan-black-cka28-trb are also running in the default namespace.


The nginx based app running on the cyan-pod-cka28-trb pod is exposed internally on the default nginx port (80).


Expectation: This app should only be accessible from the cyan-white-cka28-trb pod.


Problem: This app is not accessible from anywhere.


Troubleshoot this issue and fix the connectivity as per the requirement listed above.


Note: You can exec into cyan-white-cka28-trb and cyan-black-cka28-trb pods and test connectivity using the curl utility.


You may update the network policy, but make sure it is not deleted from the cyan-ns-cka28-trb namespace.

```
kubectl edit networkpolicy cyan-np-cka28-trb -n cyan-ns-cka28-trb
Under spec: -> egress: you will notice there is not cidr: block has been added, since there is no restrcitions on egress traffic so we can update it as below. Further you will notice that the port used in the policy is 8080 but the app is running on default port which is 80 so let's update this as well (under egress and ingress):

Change port: 8080 to port: 80
- ports:
  - port: 80
    protocol: TCP
  to:
  - ipBlock:
      cidr: 0.0.0.0/0
Now, lastly notice that there is no POD selector has been used in ingress section but this app is supposed to be accessible from cyan-white-cka28-trb pod under default namespace. So let's edit it to look like as below:

ingress:
- from:
  - namespaceSelector:
      matchLabels:
        kubernetes.io/metadata.name: default
   podSelector:
      matchLabels:
        app: cyan-white-cka28-trb
Now, let's try to access the app from cyan-white-pod-cka28-trb

kubectl exec -it cyan-white-cka28-trb -- sh
curl cyan-svc-cka28-trb.cyan-ns-cka28-trb.svc.cluster.local
Also make sure its not accessible from the other pod(s)

kubectl exec -it cyan-black-cka28-trb -- sh
curl cyan-svc-cka28-trb.cyan-ns-cka28-trb.svc.cluster.local
It should not work from this pod. So its looking good now.

```

