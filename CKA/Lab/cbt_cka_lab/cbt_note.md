# CbtNugget CKA Notes


## RBAC in Kubernetes

1. Certificate Signing requests

```
# Generate RSA key 

openssl genrsa -out elyes.key 2048
```
```
# Create a Certificate Signing requests file

openssl req -new -key elyes.key -out elyes.csr -subj "/CN=elyes/O=administrator"
```
```
# generate user key for the cluster (need to provide cluster pki)

sudo openssl x509 -req -in elyes.csr -CAcreateserial -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -out elyes.crt -days 1000
```
```
# generate a boilerplate for kubeconfig file

kubectl --kubeconfig=elyes.config 

# cat elyes.config to view the empty config file structure

cat elyes.conf

# set the cluster name 

kubectl --kubeconfig=elyes.config config set-cluster productioncluster 

# add the server ip 

kubectl --kubeconfig=elyes.config config set-cluster productioncluster --server=https://masternode:6443

# add the cluster Certificate authority file 

kubectl --kubeconfig=elyes.config config set-cluster productioncluster --server=https://masternode:6443 --certificate-authority=/etc/kubnernetes/pki/ca.crt

# If you want to embed the CA in the config file (use --embed-certs option)

kubectl --kubeconfig=elyes.config config set-cluster productioncluster --server=https://masternode:6443 --certificate-authority=/etc/kubnernetes/pki/ca.crt --embed-certs

# add the user generated CA and keys to the config file

kubectl --kubeconfig=elyes.config config set-credentials --embed-certs --client-certificate elyes.crt --client-key elyes.key elyes --username elyes

# add the server context and namespace to the kubeconfig 

kubectl --kubeconfig elyes.config config set-context elyesctx --cluster productioncluster --user elyes --namespace databases
```

```
# create role for the user (and for the example user/namespace)

kubectl --kubeconfig elyes.config config set-context elyesctx --cluster productioncluster --user elyes --namespace databases

# create role binding for role/user

kubectl create rolebinding databasesmanagerbinding --user=elyes --role=databasemanager -n databases

# to test the config file and roles 

kubectl --kubeconfig elyes.config get svc 
```

## Kubernetes Manifest files

## Kubernetes Networking

```
# test nginx pod 
k run nginx1 --image=nginx --port=80

# set pod label for svc selector later
kubectl label pod nginx1 name=myapp status=staging

# service nodeport creation
kubectl create service nginxapp nodeport --tcp=32222:80 

# update svc selector to match pod's selector
k set selector svc nginxapp name=myapp

# service of type clusterIp 
k create service clusterip ngclusterip --tcp=80:80

```

## CoreDNS in Kubernetes

## Kubernetes Pod Liveness Probes

## Kubernetes deployments

## Kubernetes Pod AutoScaller (HPA)

To limite pod / service throttling we should define requested ressource and limitation 

```
## example 

 resources:
          limits:
           cpu: 300m
          requests:
            cpu: 50m

```

If we reach the limits we can set a HPA to auto increase pod number to the desired state and workload

```
 kubectl autoscale deployment php-apache --min=1 --max=4 --cpu-percent=50

 kubectl get hpa 
```

In order to work properly, HPA need to get pod metrics from the kubernetes metrics API Server

```
kubectl top pods
kubectl top nodes
```

to install the monitoring Api-Server

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
In my case im using a virtual cluster so in order to work correctly we need to pass the metrics=true while bootstraping the vcluster via a value.yaml file

```
proxy:
  metricsServer:
    nodes:
      enabled: true
    pods:
      enabled: true

```

To stress out the nginx server deployment and to memic client connection load we can use another pod with siege installed on it 

```
kubectl run ubuntu --image=ubuntu -- sleep 36--

kubectl exec ubuntu -- sh 

## on the pods's bash 

apt update
apt install wget curl httpie siege -y

#to verify svc connection

httpie nginx-svc

#to simulate traffic and workload

siege http://nginx-svc

#we should see cpu incress in pod's and after a while HPA will kick in to scale up the deployment to the desired state
```
## Cluster AutoScaller

## Network Policies
```
k run mysqlclient2 --stdin --tty --image=mysql -- bash
```
## Storage 

## Build image container in kubernets

