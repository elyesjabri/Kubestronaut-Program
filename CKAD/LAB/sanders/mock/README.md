# Sample Question Overview

## Working woth namespaces

Create a Namespace ckad-ns1 in your cluster. In this Namespace, run the following Pods:

1. A pod with the name pod-a, running the httpd server image
2. A pod with the name pod-b, running the nginx server image as well as the alpine image

```
kubectl create ns ckad-ns1

k run pod-a --image=httpd -n ckad-ns1
k run pod-b --image=nginx -n ckad-ns1
```

## Using Secrets

Create a Secret that defines the variable passowrd=secret. Create a Deployment with the name secretapp, which starts the nginx image and uses this variable. 

```
HINT: 

kubectl set env --help
```

##  Creating Custom Images 

Create a Dockerfile that runs an alpine image with the command "echo hello world" as the default command. Build the image, and export it in OCI format to a tar file with the name "greetworld"

```


```

## Using SideCars

Create a Multi-container Pod with the name sidecar-pod, that runs in the ckad-ns3 Namespace

* The primary container is running busybox, and writes the ouput of the date command to the /var/log/date.log file every 5 seconds

* The second container should run as a sidecar and provide nginx web-access to this file, using an hostPath shared volume. (mount on /usr/share/nginx/html)

* Make sure the image for this container is only pulled if it's not available on the local system yet

## Fixing a Deployment

Start the deployment from the redis.yaml file in the course Git repository. Fix any problems that my occur while starting it.

## Using Probes

Create a Pod that runs the nginx webserver

* The webserver should be offering its services on port 80 and run in the ckad-ns3 Namespace

* This Pod should check the /healthz path on the API-server before starting the main container

## Creating a Deployment 

Write a manifest file with the name nginx-exam.yaml that meets the following requirements:

* It starts 5 replicas that run the nginx:1.18 image

* Each Pod has the label type=webshop

* Create the Deployment such that while updating, it can temporarily run 8 application instances at the same time, of which 3 should always be available

* The Deployment itself should use the label service=nginx

* Update the Deployment to the latest version on the nginx image

## Exposing Applications

In the ckad-ns6 Namespace,creaate a Deployment that runs the nginx 1.19 image and give it the name nginx-deployment

* Eensure it runs 3 replicas

* After verifying that the Deployment runs successfully, expose it such that users that are extterennal to the cluster can reach it by addressing the Node Port 32000 on the Kubernetes Cluster node 

* Configure Ingress to access the application at myngix.com 

## Using NetworkPolicies

Create a YAML file with the name my-nw-policy that runs two Pods and a NetworkPolicy 

* The first Pod should run an Nginx server with default settings

* The second Pod should run a busybox image with the sleep 3600 command

* Use a NetworkPolicy to restrict traffic between pods in the following way:

     *  Access to the nginx server is allowed for the busybox pod
     *  The busybox Pod is not restricted in any way

## Using Storage

All object in this assignment should be created in the ckad-1311 Namespace.

* Create a PersistentVolume with the name 1311-pv. it should provide 2 GiB of storage and read/write acess to multiple clients simultaneously. Use the hostPath storage type.

* Next, create a PersistentVolumeClain that requests 1 GiB fron any PersistenVolume that allows multiple clinets simultaneous read/write access. The name of the object should be 1311-pvc

* Finally, create a Pod with the name 1311-pod that uses this PersistentVolume, it should run an nginx image and mount the volume on the directory/webdata

## Using Quota 

Create a Namespace with the name limited, in which 5 Pods can be started and a total amount of 1000 millicore and 2 GiB of RAM is available 

Run a Deployment with the name restrictnginx in the Namespace, with 3 Pods where every Pod initially requests 64 MiB RAM, with an upper limits of 256 MiB RAM

## Creating Canary Deployments 

Run a Deployment with the name myweb, using the nginx:1.14 image and 3 replicas. Ensure this Deployment is accessible through a Service with the name canary, which uses the NodePort service type.

Update the Deployment to the latest version of Nginx, using the canary Deployment update strategy, in such a way that 40% of the application offers access to the updated application and 60% still uses the old applications.

## Managing Pod Permissions 

Create a Pod manifest file to run a Pod with the name sleepbox. It should run the latest version of busybox, with the sleep 3600 command as the default command. Ensure the primary Pod user is a member of the supplementary group 2000 while this Pod is started.

## Using a ServiceAccount 

Create a Pod with the name allaccess. Also create a ServiceAccount with the name allaccess and ensure that the Pod is using the ServiceAccount. Notice that no further RBAC setup is required.

