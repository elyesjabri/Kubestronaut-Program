# CKA exam practice questions

## Notes: 

Question 1:
---

    update the Nginx image of the deployment NGINX to 1.19.8
    ```
    kubctl get deployement -o wide 
    kubectl set image deployment nginx nginx=nginx:1.19.8
    k get depoloyment -o wide
    ```
Question 2:
---

    Change the static pod path to /etc/kubernetes/manifests

    ```
    ps -aux | grep kubelet
    ## find the --config file 
    vim /var/lib/kubelet/config.yaml
    ## update the static pod path and save the file

    ```

Question 3:
---

    Upgrade the cluster:
        
    - kubeadm 1.29.0
    - kubelet 1.29.0
    - kubectl 1.29.0

        step 1: draining the node

        step 2: cordon the node

        step 3: use apt update to update to latest

        step 4: use apt install kubeadm with the right version

        step 5: use apt install kubelt with the right version

        step 6: use qpt instqll kubelet with the right version


        step 7: use apt install kubectl with the right version 

        step 8: restart the kubelt by using the command systemctl restart kublet

        step 9: uncordon the node

        ```
        sudo apt update
        kubectl drain workernode01
        kubectl cordon workernode01
        sudo apt install kubeadm=1.29.0-00
        kubeadm upgrade apply v1.29.0
        sudo apt install kubelet=1.19.0-00
        sudo apt install kubectl=1.29.0-00
        sudo systemctl restart kubelet
        kunectl uncordon workernode01
        
        ```

Question 4:
---

Create a deployment with 2 replicas 
        
 - Deployment name:httpd-deploy

 - image: httpd2.4-alpine

 ```
 kubectl create deployment httpd-deploy --image=http2.4-alpine
 kubectl scale deployment httpd-deploy --replicas=2
 ```

Question 5:
---

Create a pod with labels: 
 
- Pod name: messagepod

- image: redis:alpine

- labels: tier=redis

```
kubectl run messagepod --image=redis:alpine --labels tier=redis 

```

Question 6:
---

Create a pod in the "tech" namespace

- Pod name: temp

- image: redis:alpine

```
kubecrl create namespace tech 
kubectl run podtemp --image=redis:alpine -n tech
```

Question 7:
---

create a pod and expose it: 

- Pod name: connection

- image: redis:alpine

- service name: connection-service

- Port: 8080

- Target-port: 8080

```
kubectl run connection --image=redis:alpine

kubectl expose pod connection --name=connection-service --port=8080 --target-port=8080

kubectl describe service connection-service
kubectl get svc 

```

Question 8:
---

Create a deployment with 3 replicas and upgrade by using rolling update:

- Deployment name: nginx-rolling

- image: nginx:1.16

- upgrade inage: nginx:1.17

```
kubectl create deployment nginx-rolling --image=nginx:1.16 --replicas=3 --dry-run=client -o yaml > nginx-rolling.yaml

kubectl create -f nginx-rolling.yaml

kubedescribe deployment nginx-rolling

kubectl set image deployment/nginx-rolling nginx=nginx:1.17 --record 

k rollout history deployment nginx-rolling 
```

Question 9:
---

Create a static pod and use the command "sleep 1000"

- name pod : static-pod
- image: busybox

```
## find the config file 

ps -aux | grep kubelet

kubectl get nodes

## ssh into the desired node
## check for the path of the static pod in the config file
## create a pod manifest file by using the dry-run

```

Question 10:
---

Taint a node to be unschedulable and test it by creating a pod on the noode 

- Taint:
    
    Key: env_type
    value: production
    operator: NoSchedule

- Pod 1:

    name: no-redis
    image: redis:alpine

- Pod 2 with tolerations:

    name: pro-redis
    
    image: redis:alpine

```

kubectl get nodes

kubectl taint node workernode02 env_type=production:NoSchedule

kubectl describe nodes workernode02 | grep taints

kubectl run no-redis --image=redis:alpine 

kubectl run yes-redis --image=redis:alpine --dry-run=client -oo yaml > yes-pod.yaml

vim yes-pod.yaml 

## add toleration to the yaml file 

    tolerations:
    - key : env_type
      effect: NoSchedule
      operator: Equal
      value: production
      esc + :wq

kubectl create -f yes-redis.yaml
```

Question 11:
---

Create a new service account, clusterrole and clusterrolebinding.
Make it possible to list the persistent volumes, and create a pod with the new service account.

- Service account name: nedserviceaccount

- Clusterrole name: pv-role

- Clusterrolebinding name: pv-binding

- pod name: pv-pod

- image: redis 

```
kubectl create serviceaccount nedserviceaccount

kubectl create clusterrole pv-role --resource=persistentvolumes --verb=list

kubectl clusterrolebinding pv-binding --clusterrole=pv-role --service account=default:nedserviceaccoount 

kubectl run pv-pod --image=redis --dry-run=client -o yaml > pv-pod.yaml

vim pv-pod.yaml 

## add the serviceAcountName

kubectl create -f pv-pod.yaml 

kubectl describe pod pv-pod 

```

Question 12:
---

Create a NetworkPolicy that allows all pods in the "tech-deploy" namespace to have communication only on a single port 

- NetworkPolicy name: tech-policy
- Port: 80/TCP

```

kubectl create ns tech-deploy

kubectl label namespace tech-deploy app=tech-deploy 

kubectl create -f np12.yaml

## find match port example in the documentation

kubectl create -f np.yaml

kubectl describe networkPolicy tech-policy -n tech-deploy 

```
Question 13:
---

List all the internal IP's of all the nodes in the cluster and save it to /doc/ip_nodes.txt
```
# hint find example in the documentation 

 kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > ip_nodes.txt
```
Question 14:
---
Create a multipod with two containers. And add the command " sleep 3600" to container 2

- Name container 1: Micro 
    
    iamge: nginx

- Name container 2: Mega
  
  image: busybox

```
k run mega --image=busybox --command sleep 3600 --dry-run=client -o yaml > multi.yaml

vim multi.yaml

## add container 2 

kubectl apply -f multi.yaml

```

Question 15:
---
A new colleague "Jan" joined your team. Create a new user and grant him access to the cluster. He sould have the permission to create,list,get,update and delete pods in the "tech" namespace.

```
## hint: look for Certificate signing requests in the documentation

## hint2: look for role binding in the documentation

# step 1: generate RSA key 

    openssl genrsa -out myuser.key 2048

# step 2: request csr key for the RSA 

    openssl req -new -key myuser.key -out myuser.csr

# step 3:  generate base64 request key
    
    cat myuser.csr | base64 | tr -d "\n" 

# step 4: create a CertificateSigningRequest and edit the request with the generated base64 in step3

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: myuser
spec:
  request: 
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF

# step 5: approve the CertificateSigningRequest

## list and approve CertificateSigningRequest

    kubectl get csr
    kubectl certificate approve myuser

### Create Role and RoleBinding from the doc see Using RBAC Authorization

    vim role.yaml
    vim rolebinding.yaml

# step 6: apply role and rolebinding yaml file

    kubectl apply -f role.yaml 
    kubectl apply -f rolebinding.yaml

# step 7: check role and rolebinding creation in the desired namespace 

    k get role,rolebinding -n tech 

# step 8: test RBAC 

    k auth can-i delete pods -n tech --as myuser

```

Question 16:
---

Create a service from the "green" pod and run a DNS lookup to check the service and write to file /doc/lookup.txt

 - Service name: green-service

 - Port: 80

```
kubectl expose pod green --name=green-service --port=80

k run nslookup --image=busybox -- command sleep 3600

k exec -it dnslookup -- nslookup green-service > lookup.txt 

```

Question 17:
---

Create a secret and mount it to the pod "yellow"

- secret name: yellow-secret
- secret content: password=kube1234

```
kubectl create secret generic yellow-secret --from-literal=password=kube1234

k get secret 

 k get pod yellow -o yaml > yellow.yaml

 vim yellow.yaml 

 # add secret as a volume 

 k describe pod/yellow 
```

Question 18:
---

List all the peersistent volumes sorted by capacity and write to file pervol.txt

```
# check the sheat cheat example in the doc

kubectl get pv --sort-by=.spec.capacity.storage > pervol.txt

```

Question 19:
---

From the pod label environment=process, find all the pods running high CPU workloads and write the name of which is consuming the most CPU to the file /doc/cpu.txt

```
 kubectl top pod --sort-by cpu -l environment=cpu | head -2 > cpu.txt 
```

Question 20:
---

Use JSON path to get all the node names and store them in the file /doc/namesofnodes.txt

```
# look for the cheat sheat 

kubectl get nodes -o jsonpath='{.items[*].metadata.name}' > namesnodes.txt

```


Question 21:
---

Show the logs from the container and save it to /doc/nginx.log

- Pod name: direct-pod

- Container: nginx 

- Namespace: dev-net 

```
kubectl get pods -n dev-net -o wide 
kubectl logs direct-pod -c nginx -n dev-net > nginx.log
```

Question 22:
---

Create a new ingress resource and expose service "hello" on path /hello by using service port 5678

- Name: ingress-connect
- Namespace : host-dev

```
#check the documentation for ingress 

  1 apiVersion: networking.k8s.io/v1
  2 kind: Ingress
  3 metadata:
  4   name: ingress-connect
  5   namespace: host-dev
  6 spec:
  6   rules:
  7   - http:
  8       paths:
  9       - path: /hello
 10         pathType: Prefix
 11         backend:
 12           service:
 13             name: hello
 14             port: 
 15               number: 5678
```
```
kubectl create -f ingress.yaml

kubectl get ingress -n host-dev
```


Question 23:
---

Overwrite the label of the dev-nginx pod with the value "env=true"

```
kubectl describe pod dev-nginx | grep labels

kubectl label pod/dev-nginx env=true --overwrite
```

Question 24:
---

Upgrade the image in the deployment "green" to "busybox:1.28", check the history and roll back

```
kubectl describe deployment green | grep Image

kubectl set image deployment green busybox=busybox:1.28

kubectl rollout undo deployment green 
```

Question 25:
---

Find out how which pods are availble with the label env=green in the cluster and write them to the file /doc/podsvailble.txt 

```
kubectl get pods -l env=green > podsavailible.txt
```

Question 26:
---

The pod "red" is failing. Find out why and fix the issue

```
Kubectl describe pod/red 
## find the error message 
### find type 
kubectl get pod/red --dry-run=client -o yaml > pod26.yaml 
vim pod26.yaml 
## fix the typo 
kubectl delete pod/red 
kubecrl apply -f pod26.yaml
```

Question 27:
---

Create a pod that will only be shceduled on a node with a specific label 

- Pod name: blue 

- image: nginx 

```
kubectl get nodes 

kubectl label nodes workernode06 disk=green

kubectl run testlabel --image=nginx --dry0run=client -o yaml > pod27.yaml 

#### add selector to the pod manifest 

vim pod27.yaml

# spec:
#   nodeSelector:
#       disk: green

kubecrl create -f pod27.yaml
kubectl get pod pod27 -o wide
```

Question 28:
---

Create a pod which uses a persistent volume for storage 

- Pod name: yellow 

- image: busyboox

- Persistent volume name: yellow-pv-volume

- persistent volume claim name: pvc-yellow

- Persistent Volume claim size: 100mi

```
# check the documentation for persistent volume claim

```

Question 29:
---

remove the taint added to the node "workennode04"

```
kubectl taint node workernode04 cpu- 
```

Question 30:
---

Take a Backup and restore ETCD 

```
kubectl get nodes 

## ssh into node

ps -aux | grep kubelet 

### find --config file
##### use ETCD backup from documentation ETCDCTL_
sudo cat /var/lib/kubelet/config.yaml 

cat /etc/kubernetes/manifests/etcd.yaml 

sudo cat /etc/kubernetes/manifests/etcd.yaml | grep .crt
sudo cat /etc/kubernetes/manifests/etcd.yaml | grep .key 

sudo ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key  snapshot save 2018635back
```
Question 31:
---

Schedule a pod on the node "workernode02" by using tolerations

- Pod name: blue-pod 

- image: nginx 

```
kubectl describe node workernode04 | grep Taint 

kubectl run podt --image:nginx --dry-run=client -o yaml > tpod.yaml 

vim tpod.yaml

```

```
#add toleration to manifest under spec:

tolerations:
- effect: NoSchedule
  key: app 
  operator: Equal
  value: front
```
```
kubectl create -f tpod.yaml
```
Question 32:
---

Apply autoscaling to the "green-deployment" with a minimum of 5 and maximum of 10 replicas and a target CPU of 75%

```
kubectl autoscale deployment green-deployment --min=5 --max=10 --cpu-percent=75
kubectl get hpa 
```
Question 33:
---

Check how manu nodes are in ready state and write it to the file readynodes.txt

```

k get nodes
kubectl describe nodes | grep  ready | wc -l > readynodes.txt
```
Question 34:
---

Create a pod and set the environment variable "dev=dev10"

- Pod name: grey

- image: nginx
```
kubectl run grey --image=nginx --restart=Never --env dev=dev10
kubectl exec -it grey -- sh -c 'echo $dev'    
kubectl describe pod grey | grep dev 
```
Question 35:
---

Create a configmap and add it to the pod 

- Pod name: blue

- Configmap name: data-config

- Data: user=root,password=pass1234

```
kubectl create configmap data-config --from-literal=user=root --from-literal=password=pass1234
kubectl get cm 
kubectl describe cm/data-config     
k get pod green -o yaml > pod35.yaml 
vim pod35.yaml
```
```
# under volumeMounts:

 27     envFrom:  
 28     - configMapRef:
 29         name: deta-config

```
```
kubectl delete pod/green
kubectl apply -f pod35.yaml
k exec -it green -- env 
```

Question 36:
---

List all the events sorted by the timestamp and writee the result file to events.log

```
#check the doc for the kubectl cheat sheet 
# Liste les événements (Events) classés par timestamp
kubectl get events --sort-by=.metadata.creationTimestamp > events.log
```
Question 37:
---

Create a pod with a non-persistent volume

- pod name: non-per-pod

- image: redis

- mount path: /data/per-redis

```
# check documentation for empty dir 
  1 apiVersion: v1
  2 kind: Pod
  3 metadata:
  4   name: non-per-pod
  5 spec:
  6   containers:
  7   - image: redis
  8     name: non-per-pod
  9     volumeMounts:
 10     - mountPath: /data/per-redis
 11       name: cache-volume
 12   volumes:
 13   - name: cache-volume
 14     emptyDir: {}

```
```
kubectl create -f pod37.yaml
k describe pod/non-per-pod | grep volume 
```

Question 38:
---

The node "workernode04" is in "NotReady" state.
Invistigate and bring the node back to ready state 

Question 39:
---

Make the node "workernode05" unvailable and reschedule all the pods on it 

```
k get pods -o wide
k get nodes
k cordon workernode05
k drain workernode06 --ignore-daemonsets --force
k get pods -o wide
```

Question 40:
---

Create a pod that echo's "go to tech-educator.com" and then exits.
The pod should be delted automatically when it's completed 

- pod name: tech-pod

- iamge: busybox

```
kubectl run tech-pod --image=busybox -it --rm --restart=Never -- /bin/sh -c 'echo go to tech-educator.com'
```
Question 41:
---
Annotate the existing pod "yellow" and use the value "name=green-pod"

```
k get pods | grep green 
 kubectl annotate pod green name=green-pod 
```
Question 42:
---

Get list of all pods in all the namespaces and write it to the file podsnamespaces.txt

```
kubectl get pods -A > podsnamespaces.txt
```
Question 43:
---

Update the password in the existing configmap "data-config" to "NewPass1234"

```
k describe cm/data-config 
k get configmap data-config -o yaml > configmap43.yaml
kubectl replace -f configmap43.yaml --force

```
Question 44:
---
Yoou just created the pod "blue", but it's not scheduling on the node. Troubelshoot and fix the issue

Question 45:
---

Create a network policy and allow traffic from the "green" pod to the "finance-service" and the "data-service"

- policy name: internal-policy

- policy type: egress

- label pod: role=post

- egress allow: finance

- finance port: 8080

- egress allow: data

- Data Port: 5432 

```
vim network45.yaml
  1 apiVersion: networking.k8s.io/v1
  2 kind: NetworkPolicy
  3 metadata:
  4   name: internal-policy
  5   namespace: default
  6 spec:
  7   podSelector:
  8     matchLabels:
  9       role: post
 10   policyTypes:
 11   - Egress
 12   egress:
 13   - to:
 14     - podSelector:
 15         matchLabels:
 16           name: finance
 17     ports:
 18       - protocol: TCP
 19         port: 8080
 20   - to:
 21     - podSelector:
 22        matchLabels:
 23          name: data
 24     ports:
 25        - protocol: TCP
 26          port: 5432

```

Question 46:
---

Create a pod and set "SYS_TIME" + sleep 3600 seconds

- pod name: grey

- image: busybox

```
# check k8s documentation for sys_time
kubectl run grey --image=busybox --command sleep 3600 --dry-run=client -o yaml > pod46.yaml
vim pod46.yaml
```
```
  1 apiVersion: v1
  2 kind: Pod
  3 metadata:
  4   creationTimestamp: null
  5   labels:
  6     run: grey
  7   name: grey
  8 spec:
  9   containers:
 10   - command:
 11     - sleep
 12     - "3600"
 13     image: busybox
 14     name: grey
 15     securityContext:
 16       capabilities:
 17         add: ["SYS_TIME"]
 18     resources: {}
 19   dnsPolicy: ClusterFirst
 20   restartPolicy: Always

```
```
kubectl get pods grey 
kubectl get pod grey -o yaml
```
Question 47:
---

Create a clusterrole and a clusterrolebinding which provides "get","watch" and "list" access to the pods

- Clusterrole name: cluster-administrator 

- Clusterrolebinding name: clusterbinding-administrator

- Serviceaacount: admin-sa

```
kubectl create clusterrole cluster-administrator --verb=get,watch-list --resource=pods
kubectl create clusterrolebinding clusterbinding-administrator --clusterrole=clusterrole-administrator --serviceaccount=default:admin-sa
kubectl  auth can-i get pods --as   --serviceaccount=defaultadmin-sa   
```

Question 48:
---

Get the Ip address of the "green" pod and write it to ip.txt

```
kubectl get pods -l run=blue -A -o jsonpath='{range.items[*]}{@.status.podIP}{""}{"\n"}{end}' >ip.txt
```

Question 49:
---

Find out the version of the cluster and write it to versioncluster.txt

```
k get nodes > versioncluster.txt
```

Question 50:
---

Change the mountpath of the nginx container in the "online" statefulset to "/usr/share/nginx/updated-html"

```
kubectl get statefulset -o wide
k get statefulset stateful  -o yaml > statf50.yaml   
vim statf50.yaml
## change the path in the mountpath
kubectl replace -f statf50.yaml --force

```
Question 51:
---

Create a cronjob which prints the date and "Running" every minute

- pod name: show-date-job

- image: busybox

```
# look for cronjob in the k8s documentation
vim cronjob51.yaml

apiVersion: batch/v1
kind: CronJob
metadata:
  name: run-cron-date
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox:1.28
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; hello
          restartPolicy: OnFailure  
---

kubectl get cronjobs 

```
Question 52:
---

Use JSONPATH and get a list of all the pods with name and namespace, and write to the file name-namespace.txt

```
k get pods -A 
k get pods -A -o jsonpath='{range.items[*]}{.metadata.name}{"\t"}{.metadata.namespace}{"\n"}{end}' > name-namespace.txt
```

Question 53:
---

Create a networkpolicy and allow traffic from all the pods in the "dev-tech" namespace and from pods with the label "type=review" to the pods matching the label "app=postgress"

```
  1 kind: NetworkPolicy
  2 apiVersion: networking.k8s.io/v1
  3 metadata:
  4   name: allow-dev-tech
  5   namespace: default
  6 spec:
  7   podSelector:
  8     matchLabels:
  9       app: postgress
 10   ingress:
 11     - from:
 12       - namespaceSelector:
 13           matchLabels:
 14             app: dev-tech
 15         podSelector:
 16           matchLabels:
 17             type: review

```

Question 54:
---

Create a pod with container port 80.
It should check the pod running at endpoint /healthz on port 80 + verify + delete the pod 

```
healthpod54.yaml 
```

Question 55:
---

Monitor the logs of the pod "green", extract all the log lines matching with "not found" and write to the failed.log

```
kubectl logs green | grep "not found" > failed.log   

```

Question 56:
---

Rollback the deployment "nginx-rolling" to revision 1

```
k rollout history deployment nginx-rolling 
k rollout history deployment nginx-rolling --revision=1  

```

Question 57:
---

list the orange pod the custum columns POD_STATUS and POD_NAME and write the file to status.txt

```
kubectl get pod orange -o=custom-columns="POD_NAME:metadata.name,POD_STATUS:.status.containerStatuses[].state" > status.txt
```

Question 58:
---

For the orange pod, set CPU memory requests and limits 

REQUESTS: CPU=20m,memory=40MI
LIMITS: CPU=160m,memory=200Mi

```
 23     name: green
 24     resources:
 25       limits:
 26         cpu: 160m
 27         memory: 200Mi
 28       requests:
 29         cpu: 20m
 30         memory: 40Mi

```
Question 59:
---

Create a pod with a non-persistent storage 

- Pod name: redis-pod

- Image: redis 

```
#use the emptydire for volumemounts
```
Question 60:
---

Troubleshoot the failed pod "dev-blue" and make it running again
```
# use describe, logs ,events 
```


Question 61:
---

Expose the "yellow-tech" pod initially and create a test-pod for look up 

- Port: 80 
- Service name: yellow-tech-service
- Test pod name: test-yellow-tech
- type: ClusterIp

```
k run yellow-tech --image=nginx  

k expose pod yellow-tech --name=yellow-tech-service --port=80 --target-port=80 --type=ClusterIP

# k run test-yellow-tech --image=busybox -- sleep 4000

# k exec -it test-yellow-tech -- wget --spider --timeout=1 yellow-tech-service

#or in one line

kubectl rub tst-yellow-tech --image=busybox -- wget --spider --timeout=1 yellow-tech-service
```
Question 62:
---

Create a DeamoonSet: 
 
 - Name: blue-deamon
 - image: httpd:alpine
```
kubectl create deployment blue-daemon --image=httpd:alpine --dry-run=client -o yaml > daemonset62.yaml

vim damonset62.yaml

# change the kind to DaemonSet and remove the replicas and status tag

kubectl apply damonset62.yaml

kubectl get deamonset 

k get pods -o wide | grep -i blue   

```
Question 63:
---

There's an issue with the node "workernode07".
The administrator is not able to schedule any pods on the node.
Fix the issue and deploy pod-1.yaml one the node

```
# check the status of the node 
# Scheduling is disabled 
# k describe node workernode07 
# kubectl uncordon workernode07 
# k get nodes workernode07
# check the yaml file of the pod and deploy it
```

Question 64:
---

Get all the objects in all the namespaces and write to file /doc/all.txt

```
 k get all -A  > all.txt   
```
Question 65:
---

Create a pod and assign it to the node "workernode05"

- podname: dev-grey
- Image: nginx 

```
# add nodeName: workernode05
```
Question 66:
---

Find all the pods with the label "env=tech-dev" and write to the file /doc/label.txt
```
kubectl get pods -l env=tech-dev > label.txt

```

Question 67:
---

Create a taint on the node "workernode04" with the key "spray" value of "red" and effect of "NoSchedule" 
```
kubectl taint noode workernode04 spray=red:NoSchedule
```
Question 68:
---

Create a pod and set tolerations 

- Pod name: dev-green
- image: nginx
- Toleration: dpray=red:NoSchedule

```
kubectl describe node workernode04 | grep -i Taints 
kubectl run dev-green --image=nginx --dry-run=client -o yaml > dev-green.yaml
vim dev-green.yaml

#Add toleration 
# toleratioms:
# - effect: NoSchedule
    key: spray
    operator: Equal
    value: red
kubecrl create -f dev-green.yaml
```
Question 69:
---

Check the image version of a pod without using describe command and write the file to grey-image.txt
```
kubectl get pod grey -o jsonpath='{.spec.containers[].image}{"\n"}' > grey-image.txt
```
Question 70:
---

Create a pod with a sidecar container for logging:

- podname: pod-logging
- iamge: busybox

```
#look for sidecar example in the documentation 
```
Question 71:
---

find out whre the kubernetes master and KubeDNS are running at and wtite the file to info.txt

```
kubectl cluster-info > info.txt
```

Question 72:
---

print the pod and start time to the file start.txt

```
kubectl get pods -o jsonpath='{range.items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}{end}' > start.txt
```

Question 73:
---

Create a pod and rune the command which shows "Welcom from tech-edu" and sleeps for 100 seconds

- pod name: tech-blue
- image busybox
```
kubectl run tech-edu --image=busybox -- ................ gligt
```
Question 74:
---

Create the pod "green" and specify a CPU request of "1" and a CPU limit of "2"

- image: nginx

```
#look for cpu in the kubernetes documentation 
```
Question 75:
---

Scale the "blue" deployment to 5 replicas 
```
 k scale deployment/blue --replicas=5
```

Question 76:
---

List all the secrets and configMaps in the cluster in all namespaces and write to the file config-secret.txt

```
kubectl get configmaps,secrets -A > config-secret.txt

```

Question 77:
---

Create a networkpolicy which denies all the ingress traffic 

```
# look for default deny imn the documentation 

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
  - Ingress
--- 
## save the file and create the network policy with kubectl create -f 

```
Question 78:
---

Create an init container in a pod which creates the file check.txt int the tech-dir direcotry.
Use the main container to check if the check.txt file exists and execute the sleep 300 commands when it exists

- pod name: blue-check 
- image initcontainer: busybox:1.28
- image container alpine

```
 apiVersion: v1
kind: Pod
metadata:
  name: blue-check
spec:
  volumes:
  - name: blue-vol
    emptyDir: {}
  containers:
  - name: alpine
    image: alpine
    command: ['sh','-c','if [ -f /tech-folder/check.txt ]; then sleep 300; fi']
    volumeMounts:
    - name: blue-vol
      mountPath: /tech-folder
  initContainers:
  - name: init-busybox
    image: busybox:1.28
    command: ['sh','-c','mkdir /tech-folder; echo>/tech-folder/check.txt']
    volumeMounts:
    - name: blue-vol
      mountPath: /tech-folder

```

Question 79:
---

list the logs of the pod named "dev-green" and search for the pattern "start" and write it to the file /doc/start.txt

```
k get pods 
k logs pod/dev-green | grep start  > start.txt
```
Question 80:
---

Expose the deployment "blue-deploy"

- name service : blue-service
- port: 6379
- Type: Node Port
```
kubectl expose deployment blue-deploy --name=blue-service --port=6379 --target-port=6379 --type=NodePort
```
Question 81:
---

Create two pods with different labels 

- pod 1 name: pod-1
- image: nginx
- label: env=green
#
- pod 2 name: pod-2 
- image: nginx 
- labels: env=red

```
kubectl run pod-1 --image=nginx  -l env=green
kubecrl run pod-2 --image-nginx -l env=red

```
Question 82:
---

Create a new clusterrole named "green-clusterrole" which allowa you to create deployments.

after create a new serviceaccount named "green-sa" in the tech namespace.

and finally, bind the clusterrole to the serviceaccount by creating a rolebinding named "green-rb".

```
kubectl create clusterrole green-clusterrole --verb=create --resource=deployments

kubectl create sa green-sa -n tech   

kubectl create rolebinding green-rb --clusterrole=green-clusterrole --serviceaccount=default:green-sa -n tech

```

Question 83:
---

Find the static pod path and copy the location to /doc/staticpath.txt


```
kubectl get nodes 

#ssh into the nodes 

sudo -i 

ps -aux | grep kublet 

## find the path --config= 

cat /var/lib/kublet/config.yaml | grep staticPodPath > staticpath.txt
```

Question 84:
---

Delete a pod whitout any delay 
```
 k delete pod/yellow --grace-period=0 --force  
```
Question 85:
---

Grep the current context and write it to the file /doc/current.txt

```
cat ~/.kube/config | grep current > current.txt

```

Question 86:
---

Get a list of all the pods which were recently deleted. 
Write the list to the file /doc/recentdelte.txt

```
kubectl get events -o custom-columns=NAME:.metadata.name | cut -d "." -f1 | cut -d "m" -f1  | uniq > recentdelete.txt
```
Question 87:
---

There is something wrong with the "dark-blue" pod .
TroubleShoot and fix the issue.

```
# usual procedure
```

Question 88:
---

Create the pod "yellow" with the image "redis:alpine" and a storage which lasts as long as the lifetime of the pod 

```
# look for emptyDir: {}  in the documentation
apiVersion: v1
kind: Pod
metadata:
  name: yellow
spec:
  containers:
  - name: yellow
    image: alpine
    volumeMounts:
    - name: redis-storage
      mountPath: /data/alpine
  volumes:
  - name: redis-storage
    emptyDir: {}
```
Question 89:
---

Create a pod and add "runAsUser:2000" and "fsGroup:5000"

- pod name: sec-pod

- image: nginx

```
# check sec context in documentation 

kubectl run sec-pod --image=nginx --dry-run=client -o yaml > secpod89.yaml

vim secpod89.yaml 
--- 
  8 spec:
  9   securityContext:
 10     runAsUser: 2000
 11     fsGroup: 5000
---

kaf secpod89.yaml
```
Question 90:
---

There's an issue with the kubeconfig file located in the folder ~/.kube/config

Troubleshoot and fix the issue

```
# like the usual stuff 
```

Question 91:
---

Create a pod named "sec-blue" with the image "nginx" and set "NET_ADMIN"

```
#check the doc for net_admin

apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-4
spec:
  containers:
  - name: sec-ctx-4
    image: gcr.io/google-samples/node-hello:1.0
    securityContext:
      capabilities:
        add: ["NET_ADMIN"]

```

Question 92:
---

delete all the pods with the label "environment:orange"

```
kubcectl get pods -l environment=orange
kubectl delte pods -l environment=orange
```

Question 93:
---

Create a multipod with three containers:

- Name container1 : container-1 
  image:nginx 

- image container2: container-2
  image: redis

- image contianer3: container-3 
  image: alpine 

```
kubectl run container-1 --image=nginx --dry-run=client -o yaml > multicontainerpod93.yaml
```

Question 94:
---

Replace the "grey" pod with the existing yaml file "pod-replace.yaml" and verify after 

```
kubectl replace -f pod-replace.yaml --force
```

Question 95:
---

Change the requested storage size of the PersistentVolumeClaim "storage-PVC" to 800Mi

```
kubectl get pvc 

kubectl descsribe pvc/storage-pvc

kubectl get pvc/storage-pvc -o yaml > storage.pvc-yaml 

vim storage-pvc.yaml

## change the storage value and wq 
### use the kubectl replace

kubectl replace -f storage-pvc.yaml

```
Question 96:
---

Edit the existing pod "green-nginx" and add the command "sleep 3600" 

```
kubectl get pods 
kubectl get pod/green-nginx -o yaml > green-pod96.yaml 
vim gree-pod96.yaml 
# add command to the conainer 

---
containers:
- image: nginx
  name: nginx
  command: ["sleep","3600"]
--- wq

kubectl delete pod/green-pod96 
kaf green-pod96

```

Question 97:
---

Add a rediness probe to the existing deployment "ready-deployment" 

```
kubectl get deploy

k get deployment/ready-deployment -o yaml > redinessdeploy97.yaml

vim redinessdeploy97.yaml

---
spec:
  containers:
  - image: nginx
    name: nginx
  redinessProbe:
    httpGet:
      path: /ready
      port: 80
    successThreshold: 3 
---
k delete deploy reday-deploy

kaf redinessdeploy97.yaml

k get deploy 

```


Question 98:
---

Get all contexts and write it to the file /doc/contexts.txt

```
kubectl config get-context > contexts.txt
```
Question 99:
---

Create the replicaset "front-replicaset" with the image "nginx" which has # replicas 
```
# create a deployment yaml file 
## change kind to replicaSet
## delete strat
```
Question 100:
---

List all the control plane components and write to the file controlcomp.txt

```
kubectl get pods -n kube-system > controlcomp.txt
```