# Note  nfs Storage Lab


1.  Deploy and configure NFS server:

Run the following commands on the node you considered for the NFS server. You can deploy a clustered NFS server with high availability support.

```
sudo apt update

sudo apt install -y nfs-server

sudo mkdir /data

## need to add client to nfs config file

cat <<EOF >> /etc/exports
/data 192.168.12.8(rw,no_subtree_check,no_root_squash)
EOF

systemctl enable --now nfs-server

exportfs -ar
```

These commands install NFS server and export /data , which is accessible by the Kubernetes cluster. In the case of a multi-node Kubernetes cluster, you should allow all Kubernetes worker nodes.

2. Prepare Kubernetes worker nodes:

Now, to connect to the NFS server, the Kubernetes nodes need the NFS client package. You should run the following command only on the Kubernetes worker nodes – and control-plane nodes if they act as workers too.

```
apt install -y nfs-common

```

3. Using NFS in Kubernetes:

### Method 1 — Connecting to NFS directly with Pod manifest:

To connect to the NFS storage directly using the Pod manifest, use the NFSVolumeSource in the PodSpec. Here is an example:

```
apiVersion: v1
kind: Pod
metadata:
  name: test
  labels:
    app.kubernetes.io/name: alpine
    app.kubernetes.io/part-of: kubernetes-complete-reference
spec:
  containers:
    - name: alpine
      image: alpine:latest
      command:
        - touch
        - /data/test
      volumeMounts:
        - name: nfs-volume
          mountPath: /data
  volumes:
    - name: nfs-volume
      nfs:
        server: masternode
        path: /data
        readOnly: no
```

### Method 2 — Connecting using the PersistentVolume resource:

Use the following manifest to create the PersistentVolume object for the NFS volume. You should note that the storage size does not take any effect.

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-volume
  labels:
    storage.k8s.io/name: nfs
    storage.k8s.io/part-of: kubernetes-complete-reference
    storage.k8s.io/created-by: ssbostan
spec:
  accessModes:
    - ReadWriteOnce
    - ReadOnlyMany
    - ReadWriteMany
  capacity:
    storage: 10Gi
  storageClassName: ""
  persistentVolumeReclaimPolicy: Recycle
  volumeMode: Filesystem
  nfs:
    server: masternode
    path: /data
    readOnly: no

```

### Method 3 — Dynamic provisioning using StorageClass:

You must install the NFS provisioner to provision PersistentVolume dynamically using StorageClasses. I use the nfs-subdir-external-provisioner to achieve this. The following commands install everything we need using the Helm package manager.

```
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner

helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --create-namespace \
  --namespace nfs-provisioner \
  --set nfs.server=masternode \
  --set nfs.path=/data
```

Verify with kubectl get storageclasses :
```
kubectl get sc
```
Set the nfs Storage Classe As the default provider : 

```
kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'\n
```

To create the PersistentVolumeClaim, use the following manifest:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-test
  labels:
    storage.k8s.io/name: nfs
    storage.k8s.io/part-of: kubernetes-complete-reference
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: nfs-client
  resources:
    requests:
      storage: 1Gi
```

4. Kubernetes and NFS storage specification:

NFS has the following specifications in the Kubernetes world. It would help to consider them before using the NFS storage in production.

ReadWriteOnce, ReadOnlyMany, and ReadWriteMany access modes.
The storage size does not take any effect!
In the case of dynamic provisioning, volumes are separated into different directories but without access controls or proper isolation.


