# CKA Lab Challenge

## Notes for Set1

* challange 1:

There are various Pods running in all the namescapes of kubernetes Cluster. Write a command into _"Opt/pods_asc.sh"_ which lists all the Pods sorted by their AGE in Asencing order
```kubectl get pods -A -o json | grep metadata   
echo "kubectl get pods -A --sort-by=.metadata.creationTimestamp | tac" >> opt/poods-asc.sh 
chmod +x opt/poods-asc.sh 
```
* challange 2:

Create a static pod on node01 called static-nginx with image nginx and tou have to make sure it is recreated/restartted automatically in case of any failure happens

```
#on Control-Plane node
k run staticnginx --image=nginx --dry-run=client -o yaml > static.yaml
#on workernode01
sudo vim /etc/kubernetes/manifests/staticpod.yaml
#check pods creation on control-plane 
kubectl get pods -o wide | grep workernode01
```
* challange 3:

Create a pod called pod-multi with two caontainers, description mentioned below
Container 1 => name: container1,image:nginx
Container 2=> name: Container2,image:busybox, command: sleep 4800

```
# generate a yaml file for a simple container pod :
k run multicontainer --image=nginx --dry-run=client -o yaml > multicontainer.yaml
# edit the generated yaml file to add a seconde container with the busybox image
```
* challange 4:

create a pod called delta-pod in defense namespace belonging to the development environment (env=dev) and frontend tier (tier=front) with the image: nginx.1.17

```
# create defense namespace
kubectl create ns defense
# generate yaml file
k run delta-pod --image=nginx:1.17 --dry-run=client -o yaml > delta-pod.yaml
# edit delta-pod.yaml and add the env and tiers labels
vim delta-pod.yaml
  add : 
        labels:
        env: dev
        tier: front
        name: delta-pod
# or in one commande line:
k run delta-pod --image=nginx:1.17 -n defense --labels env=dev,tier=front
kubectl apply -f delta-pod.yaml -n defense
# to show lables in namespace: 
kubectl get pods -n defense --show-labels 
```
* challange 5:

Create a new pods called admin-pod with image busybox.
Allow the pod to be able to set system_time.

the container should sleep for 3200 seconds.

```
 k run admin-pod --image=busybox --command sleep 3200 --dry-run=client -o yaml > admin-pod.yaml
 # hint you can use the k8s documentation to add the SYS_TIME capabilities just search for "set capabilites" 
 vim admin_pod.yaml
 #add in the container definition:
    securityContext:
      capabilities:
        add: ["SYS_TIME"]s
kubectl apply -f admin-pod.yaml
```

* challange 6:

A Kubeconfig file called test.kubeconfig has been created in /root/TEST.
There is something wrong with the configuration.
TroubleShoot and fix it.

* in the kubeconfig file :
    * check endpint and port 
    * check the certificate
    * check the context
    * check the user definition 
* in the system shell : 
    * check the config view : kubectl get config view

* challange 7:

Create a new deployment called web-proj-268, with image nginx:1.16 and 1 replica. Next upgrade the deployment to version 1.17 using rolling update.

make sure that the version upgrade is recorded in the source annotation.
```
# create deployment:
k create deployment web-proj-268 --image=nginx:1.16 
# to update the image and inscribe it on the annotation:
kubectl set image deployememt web-proj-268 nginx=nginx:1.17 --record
# to check to the rollout status and history 
k rollout history deployment web-proj-268
```
* challange 8:

Create a pod called web-pod using image nginx,expose it internally with a service called web-pod-svc. Check that you are able to look up the service and pod from within the cluster.

Use the image: busybox:1.28 for dns lookup.
Record results in /root/web-svc.svc and /root/web-pod.pod

```
# for the generation of /root/web-prod.pod file:
k run web-pod-svc --image=nginx --dry-run=client -o yaml > web-pod.pod
# for the generation of /root/web-svc.svc file:
k expose pod web-pod-svc --port=80 --dry-run=client -o yaml > web-svc.svc
# apply the two generated manifests:
kubectl apply - f web-pod.pod
kubectl apply - f web-svc.svc
# Create another pod for dns lookup and svc testing:
k run dnslookup --image=busybox -- sleep 3600
# Test name resolution by testing the webserver:
k exec -it dnslookup -- wget --spider --timeout=1 web-pod-svc
```
* challange 9:

Use JSON PATH query to retrieve the osImagies of all the nodes and store it in a file "allNodes_osImage_45CVB34Ji.txt" at root location.

Note: The osImages are under the nodeInfo section under status of each node.

```
k get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > allNodes_osImage_45CVB34Ji.txt
```

* challange 10:

Create a Persistent Volume with the given specification.

Volume Name: pv-rnd
Storage: 100Mi
Access modes: ReadWriteMany
Host Path: /pv/host_data-rnd

 * hint: search in kuberntes documentation for Persistent Volumes 
 and copy the provided example

```
vim pv.yaml
#add the hostpath under spec to complete the example
   hostPath:
       path: /pv/host_data-rnd
```