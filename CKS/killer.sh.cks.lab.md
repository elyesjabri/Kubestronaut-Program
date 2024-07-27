# KillerCoda CKS
## CKS Notes

### 1
The Kubelet on node01 shouldn't be able to set Node labels

starting with node-restriction.kubernetes.io/*
on other Nodes than itself
Verify this is not restricted atm by performing the following actions as the Kubelet from node01 :

add label killercoda/one=123 to Node controlplane
add label node-restriction.kubernetes.io/one=123 to Node node01

We can contact the Apiserver as the Kubelet by using the Kubelet kubeconfig

```
export KUBECONFIG=/etc/kubernetes/kubelet.conf
k get node
```

```
ssh node01
    export KUBECONFIG=/etc/kubernetes/kubelet.conf
    k label node controlplane killercoda/one=123 # works but should be restricted
    k label node node01 node-restriction.kubernetes.io/one=123 # works but should be restricted
```

Enable the NodeRestriction Admission Controller and verify the issue is gone by trying to

add label killercoda/two=123 to Node controlplane
add label node-restriction.kubernetes.io/two=123 to Node node01

```
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=172.30.1.2
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction
    - --enable-bootstrap-token-auth=true
```

### 2 Check existing AppArmor profiles

You're asked to verify if the following AppArmor profiles are available on node01 :

docker-default
snap.lxd.lxc
ftpd
/usr/sbin/tcpdump
Create file /root/profiles.txt on node controlplane . It should contain only these profile names that are available on node01 .


### 3 Auditing Enable Audit Logging

Configure the Apiserver for Audit Logging.

The log path should be /etc/kubernetes/audit-logs/audit.log on the host and inside the container.

The existing Audit Policy to use is at /etc/kubernetes/audit-policy/policy.yaml . The path should be the same on the host and inside the container.

Set argument --audit-log-maxsize=7

Set argument --audit-log-maxbackup=2

```

mkdir /etc/kubernetes/audit-logs

vium /etc/kubernetes/manifests/kube-apiserver.yaml

# add new Volumes
volumes:
  - name: audit-policy
    hostPath:
      path: /etc/kubernetes/audit-policy/policy.yaml
      type: File
  - name: audit-logs
    hostPath:
      path: /etc/kubernetes/audit-logs
      type: DirectoryOrCreate

# add new VolumeMounts
volumeMounts:
  - mountPath: /etc/kubernetes/audit-policy/policy.yaml
    name: audit-policy
    readOnly: true
  - mountPath: /etc/kubernetes/audit-logs
    name: audit-logs
    readOnly: false


# enable Audit Logs
spec:
  containers:
  - command:
    - kube-apiserver
    - --audit-policy-file=/etc/kubernetes/audit-policy/policy.yaml
    - --audit-log-path=/etc/kubernetes/audit-logs/audit.log
    - --audit-log-maxsize=7
    - --audit-log-maxbackup=2

```

### 3 CertificateSigningRequests sign manually

In the first step we'll create a CSR and in the second step we'll manually sign the CSR with the K8s CA file.

The idea here is to create a new "user" that can communicate with K8s.

For this now:

Create a new KEY at /root/60099.key for user named 60099@internal.users
Create a CSR at /root/60099.csr for the KEY

### 4 CertificateSigningRequests sign via API

Here we are first creating a CSR and then we'll sign this using the K8s Api.

The idea here is to create a new "user" that can communicate with K8s.

For this now:

Create a new KEY at /root/60099.key for user named 60099@internal.users
Create a CSR at /root/60099.csr for the KEY

```
openssl genrsa -out 60099.key 2048

openssl req -new -key 60099.key -out 60099.csr

```
Create a K8s CertificateSigningRequest resource named 60099@internal.users and which sends the /root/60099.csr to the API.

Let the K8s API sign the CertificateSigningRequest.

Download the CRT file to /root/60099.crt .

Create a new context for kubectl named 60099@internal.users which uses this CRT to connect to K8s.

### 5 CIS Benchmarks fix Controlplane

### 6 Container Hardening

There is a Dockerfile at /root/image/Dockerfile .

It’s a simple container which tries to make a curl call to an imaginary api with a secret token, the call will 404 , but that's okay.

Use specific version 20.04 for the base image
Remove layer caching issues with apt-get
Remove the hardcoded secret value 2e064aad-3a90–4cde-ad86–16fad1f8943e . The secret value should be passed into the container during runtime as env variable TOKEN
Make it impossible to podman exec , docker exec or kubectl exec into the container using bash
You can build the image using

```
# Dockerfile
FROM ubuntu
RUN apt-get update
RUN apt-get -y install curl
ENV URL https://google.com/this-will-fail?secret-token=
CMD ["sh", "-c", "curl --head $URL=2e064aad-3a90-4cde-ad86-16fad1f8943e"]
```

```
# Optimised Dockerfile

FROM ubuntu:20.04
RUN apt-get update && apt-get -y install curl
ENV URL https://google.com/this-will-fail?secret-token=
RUN rm /usr/bin/bash
CMD ["sh", "-c", "curl --head $URL$TOKEN"]

```

```
# to test container

podman build -t app .
podman run -d -e TOKEN=2e064aad-3a90-4cde-ad86-16fad1f8943e app sleep 1d # run in background
podman ps | grep app
podman exec -it 4a848daec2e2 bash # fails
podman exec -it 4a848daec2e2 sh # works

```


### 7 Container Image Footprint User

There is a given Dockerfile under /opt/ks/Dockerfile .

Using Docker:

Build an image named base-image from the Dockerfile.
Run a container named c1 from that image.
Check under which user the sleep process is running inside the container

```
# Build and run

cd /opt/ks/
docker build -t base-image .
docker run --name c1 -d base-image

```

```
# Show the user of processes

docker exec c1 ps

# (to start again) Delete container

docker rm c1 --force


```

Modify the Dockerfile /opt/ks/Dockerfile to run processes as user appuser
Update the image base-image with your change
Build a new container c2 from that image


```
FROM alpine:3.12.3
RUN adduser -D -g '' appuser
USER appuser
CMD sh -c 'sleep 1d'


```

### 8 Container Namespaces Docker

Run two Docker containers app1 and app2 with the following attributes:

they should run image nginx:alpine

they should share the same PID kernel namespace

they should run command sleep infinity

they should run in the background (detached)

Then check which container sees which processes and make sense of why.

```
docker run --name app1 -d nginx:alpine sleep infinity

docker exec app1 ps aux

docker run --name app2 --pid=container:app1 -d nginx:alpine sleep infinity

```

### 9 Create two Podman containers sharing the same PID namespace

Run two Podman containers app1 and app2 with the following attributes:

they should run image nginx:alpine

they should share the same PID kernel namespace

they should run command sleep infinity

they should run in the background (detached)

Then check which container sees which processes and make sense of why.


```
podman run --name app1 -d nginx:alpine sleep infinity

podman run --name app2 --pid=container:app1 -d nginx:alpine sleep infinity

```

### 10 Falco Change rules

Falco has been installed on Node controlplane and it runs as a service.

It's configured to log to syslog, and this is where the verification for this scenario also looks.

Cause the rule "shell in a container" to log by:

creating a new Pod image nginx:alpine
kubectl exec pod -- sh into it
check the Falco logs contain a related output

```
service falco status

cat /var/log/syslog | grep falco

```

```
k run pod --image=nginx:alpine

k exec -it pod -- sh

cat /var/log/syslog | grep falco | grep shell
```

Change the Falco output of rule "Terminal shell in container" to:

include NEW SHELL!!! at the very beginning
include user_id=%user.uid at any position
include repo=%container.image.repository at any position
Cause syslog output again by creating a shell in that Pod.

Verify the syslogs contain the new data.

```
cd /etc/falco/

cp falco_rules.yaml falco_rules.local.yaml

vim falco_rules.local.yaml

```

```
- rule: Terminal shell in container
  desc: A shell was used as the entrypoint/exec point into a container with an attached terminal.
  condition: >
    spawned_process and container
    and shell_procs and proc.tty != 0
    and container_entrypoint
    and not user_expected_terminal_shell_in_container_conditions
  output: >
    NEW SHELL!!! (user_id=%user.uid repo=%container.image.repository %user.uiduser=%user.name user_loginuid=%user.loginuid %container.info
    shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline terminal=%proc.tty container_id=%container.id image=%container.image.repository)
  priority: NOTICE
  tags: [container, shell, mitre_execution]
```

### 11 ImagePolicyWebhook Setup

An ImagePolicyWebhook setup has been half finished, complete it:

Make sure admission_config.json points to correct kubeconfig
Set the allowTTL to 100
All Pod creation should be prevented if the external service is not reachable
The external service will be reachable under https://localhost:1234 in the future. It doesn't exist yet so it shouldn't be able to create any Pods till then
Register the correct admission plugin in the apiserver

```
#/etc/kubernetes/policywebhook/admission_config.json should look like this:

{
   "apiVersion": "apiserver.config.k8s.io/v1",
   "kind": "AdmissionConfiguration",
   "plugins": [
      {
         "name": "ImagePolicyWebhook",
         "configuration": {
            "imagePolicy": {
               "kubeConfigFile": "/etc/kubernetes/policywebhook/kubeconf",
               "allowTTL": 100,
               "denyTTL": 50,
               "retryBackoff": 500,
               "defaultAllow": false
            }
         }
      }
   ]
}

```
```
#The /etc/kubernetes/policywebhook/kubeconf should contain the correct server:

apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/policywebhook/external-cert.pem
    server: https://localhost:1234
  name: image-checker
...

```

```
The apiserver needs to be configured with the ImagePolicyWebhook admission plugin:

spec:
  containers:
  - command:
    - kube-apiserver
    - --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
    - --admission-control-config-file=/etc/kubernetes/policywebhook/admission_config.json

```

### 12 Image Use Digest

Image tags can be overwritten, digests not.

Create a Pod named crazy-pod which uses the image digest nginx@sha256:eb05700fe7baa6890b74278e39b66b2ed1326831f9ec3ed4bdc6361a4ac2f333 .

```
k run crazy-pod --image=nginx@sha256:eb05700fe7baa6890b74278e39b66b2ed1326831f9ec3ed4bdc6361a4ac2f333

```

### 13 Image Vulnerability Scanning Trivy

Using trivy :

Scan images in Namespaces applications and infra for the vulnerabilities CVE-2021-28831 and CVE-2016-9841 .

Scale those Deployments containing any of these down to 0 .


### 14 Immutability Readonly Filesystem

Create a Pod named pod-ro in Namespace sun of image busybox:1.32.0 .

Make sure the container keeps running, like using sleep 1d .

The container root filesystem should be read-only.

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-ro
  name: pod-ro
  namespace: sun
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox:1.32.0
    name: pod-ro
    securityContext:
      readOnlyRootFilesystem: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always

```

The Deployment web4.0 in Namespace moon doesn't seem to work with readOnlyRootFilesystem .

Add an emptyDir volume to fix this

```
...
    spec:
      containers:
      - command:
        - sh
        - -c
        - date > /etc/date.log && sleep 1d
        image: busybox:1.32.0
        name: container
        securityContext:
          readOnlyRootFilesystem: true
        volumeMounts:
        - mountPath: /etc
          name: temp
      volumes:
      - name: temp
        emptyDir: {}

```

### 15 Ingress Create
### 16 Ingress SSL/TLS 

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout cert.key -out cert.crt -subj "/CN=world.universe.mine/O=world.universe.mine"
```

### 17 NetworkPolicy Create Default Deny

There are existing Pods in Namespace app .

We need a new default-deny NetworkPolicy named deny-out for all outgoing traffic from Namespace app .

It should still allow DNS traffic on port 53 TCP and UDP.

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-out
  namespace: app
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - ports:
    - port: 53
      protocol: TCP
    - port: 53
      protocol: UDP

```

### 18 Network Policy MetaData protection

Cloud providers can have Metadata Servers which expose critical information, for example GCP or AWS.

For this task we assume that there is a Metadata Server at 1.1.1.1 .

You can test connection to that IP using nc -v 1.1.1.1 53 .

Create a NetworkPolicy named metadata-server In Namespace default which restricts all egress traffic to that IP.

The NetworkPolicy should only affect Pods with label trust=nope .

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: metadata-server
  namespace: default
spec:
  podSelector:
    matchLabels:
      trust: nope
  policyTypes:
  - Egress
  egress:
  - to:
    - ipBlock:
        cidr: 0.0.0.0/0
        except:
          - 1.1.1.1/32


```

### 19 NetworkPolicy Namespace Selector

There are existing Pods in Namespace space1 and space2 .

We need a new NetworkPolicy named np that restricts all Pods in Namespace space1 to only have outgoing traffic to Pods in Namespace space2 . Incoming traffic not affected.

We also need a new NetworkPolicy named np that restricts all Pods in Namespace space2 to only have incoming traffic from Pods in Namespace space1 . Outgoing traffic not affected.

The NetworkPolicies should still allow outgoing DNS traffic on port 53 TCP and UDP.

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np
  namespace: space1
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
     - namespaceSelector:
        matchLabels:
         kubernetes.io/metadata.name: space2
  - ports:
    - port: 53
      protocol: TCP
    - port: 53
      protocol: UDP

```

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np
  namespace: space2
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
   - from:
     - namespaceSelector:
        matchLabels:
         kubernetes.io/metadata.name: space1


```

### 20 Privilege Escalation Containers

There is a Deployment named logger which constantly outputs the NoNewPrivs flag.

Let the Pods of that Deployment run with Privilege Escalation disabled.

The logs should show the field change.

```
spec:
  replicas: 3
  selector:
    matchLabels:
      app: logger
  strategy: {}
  template:
    metadata:
      labels:
        app: logger
    spec:
      containers:
      - image: httpd:2.4.52-alpine
        name: httpd
        securityContext:
            allowPrivilegeEscalation: false
...

```

### 21 Privileged Containers

Create a Pod named prime image nginx:alpine .

The container should run as privileged .

Install iptables (apk add iptables ) inside the Pod.

Test the capabilities using iptables -L .

```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: habanero
spec:
  selector:
    matchLabels:
      app: habanero
  serviceName: habanero
  replicas: 1
  template:
    metadata:
      labels:
        app: habanero
    spec:
      #securityContext:                   # remove
        #privileged: true                 # remove
      containers:
        - name: habanero
          image: nginx:alpine
          command:
            - sh
            - -c
            - apk add iptables && sleep 1d
          securityContext:                # add
            privileged: true  

```

### 22 RBAC ServiceAccount Permissions

There are existing Namespaces ns1 and ns2 .

Create ServiceAccount pipeline in both Namespaces.

These SAs should be allowed to view almost everything in the whole cluster. You can use the default ClusterRole view for this.

These SAs should be allowed to create and delete Deployments in their Namespace.

Verify everything using kubectl auth can-i .

### 23 Control User permissions using RBAC

There is existing Namespace applications .

User smoke should be allowed to create and delete Pods, Deployments and StatefulSets in Namespace applications.
User smoke should have view permissions (like the permissions of the default ClusterRole named view ) in all Namespaces but not in kube-system .
User smoke should be allowed to retrieve available Secret names in Namespace applications. Just the Secret names, no data.
Verify everything using kubectl auth can-i .

```

k -n applications create role smoke --verb create,delete --resource pods,deployments,sts
k -n applications create rolebinding smoke --role smoke --user smoke


k get ns # get all namespaces
k -n applications create rolebinding smoke-view --clusterrole view --user smoke
k -n default create rolebinding smoke-view --clusterrole view --user smoke
k -n kube-node-lease create rolebinding smoke-view --clusterrole view --user smoke
k -n kube-public create rolebinding smoke-view --clusterrole view --user smoke


# NOT POSSIBLE: assigning "list" also allows user to read secret values
k -n applications create role list-secrets --verb list --resource secrets

k -n applications create rolebinding ...

```

### 24 Sandbox gVisor

Now that gVisor should be configured, create a new RuntimeClass for it.

Then create a new Pod named sec using image nginx:1.21.5-alpine .

Verify your setup by running dmesg in the Pod.

### 25 Secret ETCD Encryption

Create an EncryptionConfiguration file at /etc/kubernetes/etcd/ec.yaml and make ETCD use it.
One provider should be of type aesgcm with password this-is-very-sec . All new secrets should be encrypted using this one.
One provider should be the identity one to still be able to read existing unencrypted secrets.

```
spec:
  containers:
  - command:
    - kube-apiserver
...
    - --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml
...
    volumeMounts:
    - mountPath: /etc/kubernetes/etcd
      name: etcd
      readOnly: true
...
  hostNetwork: true
  priorityClassName: system-cluster-critical
  volumes:
  - hostPath:
      path: /etc/kubernetes/etcd
      type: DirectoryOrCreate
    name: etcd
...

```

### 26 Secret Access in Pods

Create a Secret named holy with content creditcard=1111222233334444
Create Secret from file /opt/ks/secret-diver.yaml

### 27 Check binary

Download the kubelet binary in the same version as the installed one.

wget https://dl.k8s.io/vX.Y.Z/kubernetes-server-linux-amd64.tar.gz

```
# compare hashes
whereis kubelet
sha512sum /usr/bin/kubelet
sha512sum kubernetes/server/bin/kubelet

```

### 28 Secret ServiceAccount Pod

Create new Namespace ns-secure and perform everything following in there
Create ServiceAccount secret-manager
Create Secret sec-a1 with any literal content of your choice
Create Secret sec-a2 with any file content of your choice (like /etc/hosts )

```
k create ns ns-secure

k -n ns-secure create sa secret-manager

k -n ns-secure create secret generic sec-a1 --from-literal user=admin

k -n ns-secure create secret generic sec-a2 --from-file index=/etc/hosts

```


```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: secret-manager
  name: secret-manager
  namespace: ns-secure
spec:
  volumes:
    - name: sec-a2
      secret:
        secretName: sec-a2
  serviceAccountName: secret-manager
  containers:
    - image: httpd:alpine
      name: secret-manager
      volumeMounts:
        - name: sec-a2
          mountPath: /etc/sec-a2
          readOnly: true
      env:
        - name: SEC_A1
          valueFrom:
            secretKeyRef:
              name: sec-a1
              key: user
  dnsPolicy: ClusterFirst
  restartPolicy: Always

```

### 29 Service Account token mounting 

Modify the the config file /opt/ks/pod-one.yaml to disable the mounting of the ServiceAccount token into that Pod.

Apply the modified file /opt/ks/pod-one.yaml to Namespace one .

Verify that the ServiceAccount token hasn't been mounted into the Pod.

```
spec:
  serviceAccountName: custom
  automountServiceAccountToken: false
  containers:
  - name: webserver

```

Modify the default ServiceAccount in Namespace two to prevent any Pod that uses it from mounting its token by default.

Apply the Pod configuration file /opt/ks/pod-two.yaml to Namespace two .

Verify that the ServiceAccount token hasn't been mounted into the Pod.

```
apiVersion: v1
kind: ServiceAccount
automountServiceAccountToken: false
metadata:
```

### 30 Static Manual Analysis Docker

Perform a manual static analysis on files /root/apps/app1-* considering security.

Move the less secure file to /root/insecure

```


```

### 31 Static Manual Analysis K8s


Perform a manual static analysis on files /root/apps/app1-* considering security.

Move the less secure file to /root/insecure

### 32 Syscall Activity Strace


Use strace to see which syscalls the following commands perform:

kill -9 1234

kill -15 1234

uname

nc -l -p 8080

```


```
Use strace to see what kind of syscalls the kube-apiserver process performs.

```
ps aux | grep kube-apiserver

strace -p 19890 -f # use your PID

# we use -f for "follow forks"

strace -p 19890 -f -cw # use your PID

```

### 33 System Hardening Close Open Ports 

There is an unwanted process running which listens on port 1234 .

Kill the process and delete the binary.

```


```

### 34 System Hardening Manage Packages

Your team has decided to use kube-bench via a DaemonSet instead of installing via package manager.

Go ahead and remove the kube-bench package using the default package manager.