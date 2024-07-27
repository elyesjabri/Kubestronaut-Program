# Note For Killer.sh CKS course


## ETCD Encryption at REST 

- to check secret directly from ETCD :
```

sudo ETCDCTL_API=3 etcdctl  --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/mysecret

```
- Encrypt all existing secrets using aescbc and a password of our choice

* Steps: 
    * Create a etcd folder to store encryption config

    ```
    mkdir /etc/kubernetes/etcd
    ```

    * create encryption config file

    ```
    vim ec.yaml
    ```
    from the kubernetes documentation search for "Encrypting Confidential Data at Rest"

    *  Write The encryption configuration file

     ```
        apiVersion: apiserver.config.k8s.io/v1
        kind: EncryptionConfiguration
        resources:
            - resources:
                - secrets
        providers:
        - aescbc:
          keys:
            - name: key1
              secret: <BASE 64 ENCODED SECRET>
        - identity: {} 
    ```

    * Need to setup a encryption secret (min lenght 16 char)

    ```
        echo -n passowrdpassword | base64
        ## result to be copied to secret in ec.yaml
    ```

    * Update kube-apiserver to use etcd encryption for secret
    ```
     vim /etc/kubernetes/manifests/kube-apiserver.yaml
     ## add
     --encryption-provider-config=/etc/kubermetes/etcd
    ```

    * Dont forget to mount the new volume to apiserver, so update volumes and volumemounts

    ```
    # Volumes
     - hostPath:
          path: /etc/kubernetes/etcd
          type: DirectoryOrCreate
        name: etcd
    ```


   ```
        # VolumeMounts     

        - mountPath: /etc/kubernetes/etcd
          name: etcd
          readOnly: true
   ```
  * restart kube-apiserever

  ```
  sudo systemctl restart kubelet.service
  ```

* try to read a newly created secret from etcd direcly it should be encrypted 

```
sudo ETCDCTL_API=3 etcdctl  --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/mysecret

```
    
* to encrypt all the old secret with the new encryption provider, we need to recreate all the secret

```
kubectl get secret -A -oyaml | kubectl replace -f -
```

    
## Container Runtime (gVisor / KATA)


* Install gVisor and add runtime to containerd config 

* Create a kubernetes runtimeClasse

```
# RuntimeClass is defined in the node.k8s.io API group
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  # The name the RuntimeClass will be referenced by.
  # RuntimeClass is a non-namespaced resource.
  name: gvisor
# The name of the corresponding CRI configuration
handler: runsc

```
* verify the creation of gvisor runtime class

```
k get runtimeclasses.node.k8s.io
```

* Create a pod that uses gvisor runtimeclass

```

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: gvisor
  name: gvisor
spec:
  runtimeClassName: gvisor
  containers:
    - image: nginx
      name: gvisor
      resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always

```

* hint: uname -r 

## Mutual TLS

## OPA

* OPA Gatekeeper wil provides kubernetes CRD

* OPA GateKeeper works with constraint and constraint Template (K8S CRD)

* Install OPA GateKeeper in k8s cluster

    * check for admission plugin in /etc/kubernetes/kube-api.yaml , you should only see NodeRestrection

    * install .yaml resource for opa and wait for creation


## Image Vulns
* trivy example
    ```
    trivy image nginx:1.17
    trivy image nginx:alpine
    ```

## Secure Supply Chain

 * use private image registry 

 * force fixed image tag insteed of latest

 * Whitelist some registries using OPA

 * using admission webhook insteed of OPA

    * add ImagePolicyWebhook to admission controller in /etc/kubernetes/manifests/kube-apiserver.yaml

## Behaviroal Analytics

    * falco 
    
```
ps -aux | grep httpd
pstree -p | grep httpd
cat /proc/24458/env
```

## Immutability 

* container wont be modified during his life time

* on a image level, remove shell/bash, readonly file , disable root and run only as user

