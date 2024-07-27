# Raw Notes
# Cluster Setup 
## CIS Benchmark 

* mainly used to check CIS scoring on ubuntu server because CIS-CAT lite support only linux server 

* Need to install jdk & jre to be able to run cis-cat

## Kube-Bench 

* can run it as a binary or a container image inside kubernetes or any container runtime

* runs kubernetes cluster components like workernode, control plane node, etcd and kublets against CIS benchmark 

* to run kube-bench from binary : sudo kube-bench run 

## Ingress with TLS 

* Create Service & Pod
* Create Ingress Resource (with some host name)
* Create TLS, Certificate key-pair

```
openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout tls.key -out tls.crt -subj="/CN=node" -days 7
```
* Create Secret with TLS data
    
    * Check kubernetes documentation for Ingress / TLS
    * encode both .crt .key to base64
```
apiVersion: v1
kind: Secret
metadata:
  name: testsecret-tls
  namespace: default
data:
  tls.crt: base64 encoded cert
  tls.key: base64 encoded key
type: kubernetes.io/tls
```
or 
```
kubectl create secret tls sec-node --cert=tls.crt --key=tls.key
```
* Update Ingress Resource with TLS

    * check in kubernetes documentation for ingress / TLS
```
  tls:
  - hosts:
      - https-example.foo.com
```
* Verify/Test

## Network Policies

* redo netpool from CKA prep

* Protect node metadata and endpoints

## Minimize access to GUI

* Protect by using RBAC

## Verify kubernetes binary before deploy
 * Verify using checksum

 ```
 sha512sum kubelet.tar.gz

 which kubectl (to find already installed bin)

 ```

 # Cluster Hardening

 ## Restrict Access to Kubernetes API 

 * Secure API server with https
 * Anonymous requests to API
 * secure kubernets port 
 * secure kube-api pod

 ## Disable SA auto mount

 * need to set automountServiceAccountToken: false when creating a new service account to use with pods 

 ## Minimize Permission on SA

 * look at RBAC prep from CKA

# System Hardening 

##  Reduce Host OS attack surface

* Create Pod to use host namespace only if necessary.

  * dont use hostIPC: true unless if necessary

  * dont use hostNetwork: true unless if necessary

  * dont use hostPID: true unless if necassary


* Don't run containers in privileged mode

  * dont use privileged:true (root user)

* Limite Node Access to users

* Remove unecessary binaries and services

* Control access using SSH, disable root and password-based logins

* Adding correct firewall rules to restrict host access on opened ports

* Preventing containers from loading unwanted kernel modules

* Identify and adderss open ports

* Restrict Allowed Host Path using PodSecurityPolicies

## Restrict Kernel access with SECCOMP / AppArmor

*  Restrict a Container's Access to Resources

    * Linux capabilities 
    * Network access
    * file permissions etc

* Objective is to secrure / restricing containers what are allowed to do 

* configured through profiles 

* AppArmor Profile - set of rules

* Load the Profile in Kernal 

* AppArmor profile loaded in 2 modes

  * Enforce Mode
  * Complain Mode

* SecComp

  * Restricting the sys calls to Resources

  * Objective is to secure / restricting containers what are allowed to do 

  * Configured through profiles

  * SecComp Profile -list syscalls to allow/deny/audit

  * SecComp Profiles *enabled at kubelet level config (disabled by default)

  * Enable SecComp using Kubelet config 
      
      * --feature-gates=SeccompDefault=true

  * Profiles should be placed at below

    * /vat/lib/kubelet/seccomp/profiles/profile.json

# Minimize Microservice Vulnerabilities

* OPA

* Security Context for containers

  * For privilege and access control settings

    * Discretionary Access Control: Permission to access an object

    * Security Enhanced Limux (SELimux): Objects are assigned security labels.

    * Run as privileged or unprivileged.

    * Linux Capabilities

    * AppArmor Profile: restrict the capabilities of individual programs

    * SecComp: Filter a process's sustem calls

    * AllowPrivilegeEscallation : controls whether a process can gain more privileges than its parent process

    * readOnlyRootFileSystem

## Container Runtime Sandbox using gVisor & Kata
  
## mTls and pod to pod encryption

## minimize base image foot print 







