# KodeKloud Notes for CKS
##



## Cluster Setup and Hardening

### 1. CIS Benchmark 

* CIS : Center for internet securiity

* CIS-CAT lite: an automated tool to test systems against CIS 

* Kube-bench: an opensource alternative from aqua secrity to check if kubernetes was deployed using best-practice

### 2. Security Primitives

* Secure hosts:
    * Password based auth disabled
    * SSH based auth
* kube-apiserver:
    * Who can access the cluster?
    * What can they do ? 

### 3. TLS Introduction

#### Cert used in a cluster deployed by kubeadm 

```
cd /etc/kubernetes/manifest

cat kube-apiserver.yaml

```

#### To check to cert information 

```
openssl x509 -in /etc/kubernetes/pki/apiserver-etcd-client.crt -text --noout

```

### To check logs in ETCD in case of a problem in a cluster deployed via kubeadm 

````
k get pods -A | grep etcd 

k logs -n kube-system etcd-controlplane 

````

### In case of the kube-apiserver component is not working we can check logs directly from containerd

```
cd /var/logs/containers/

ls | grep etcd 

cat etcd.log

```

### 4. Verif kubernetes binary

```
curl https://dl.k8s.io/1.30.0/kuberentes.tar.gz -l -o kuberenetes.tar.gz

shasum -a 512 kuberentes.tar.gz

or

sha512sum kubernetes.tar.gz


```

## System Hardening

### 1. Least Privilege

* Limit Node Access:

to disable a user account:

```
usermod -s /bin/nologin micheal

grep -i micheal /etc/password

or delete account

userdel bob

id michael

/// to delete user michael from admin group 

deluser michael admin
```
### 2. SSh hardening

to create a key pair
```
ssh-keygen -t rsa
```

to copy the key to the remote server

```
ssh-copy-id mark@node01
```

to disable root login over shh and Password authentication

```
vim /etc/ssh/sshd_config

// PermitRootLogin no
// PasswordAuthentication no
```
restart the ssh server to apply changes

```
systemctl restart sshd
```

#### 3. Restrict Kernel Modules

to list loaded module in the kernel

```
lsmod
```
to block module from loading

```
cat /etc/modprobe.d/blacklist.conf
/// blacklist sctp

```
#### 4. Disable Open Ports

to check the process of a port

```
cat /etc/services | grep -w 53
```

#### 5. Restrict Network Access

* UFW:

to install UFW

```
apt-get update
apt-get install ufw
systemctl enable ufw
systemctl start ufw
ufw status
```

UFW Rules:

```
ufw default allow outgoing
ufw default deny incoming

ufw allow from 172.16.238.5 to any port 22 proto tcp

ufw allow from 172.16.238.5 to any port 80 proto tcp 

ufw allow from 172.16.100.0/28 to any port 80 proto tcp

ufw deny 8080

ufw enable

ufw satatus

// to delete a rule

ufw delete deny 8080

// or delete with the rule line in ufw status

ufw delete 5

```
### Linux syscall
### appArmor
### Seccomp


## Minimize Microservice Vulnerabilities






## Supply Chain Security




## Monitoring, Logging and Runtime Security

