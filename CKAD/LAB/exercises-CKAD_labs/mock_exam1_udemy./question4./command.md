command.md

```
master $ kubectl run messaging --image=redis:alpine --dry-run=client -o yaml > pod.yaml
master $
master $
master $ vi pod.yaml
master $
master $
master $
master $ kubectl create -f pod.yaml
pod/messaging created
master $
master $
master $
master $ kubectl get pod --show-labels
NAME                              READY   STATUS    RESTARTS   AGE     LABELS
httpd-frontend-74fd6fd8cd-2k5zl   1/1     Running   0          7m27s   app=httpd-frontend,pod-template-hash=74fd6fd8cd
httpd-frontend-74fd6fd8cd-d9lqw   1/1     Running   0          7m27s   app=httpd-frontend,pod-template-hash=74fd6fd8cd
httpd-frontend-74fd6fd8cd-n9qth   1/1     Running   0          7m27s   app=httpd-frontend,pod-template-hash=74fd6fd8cd
messaging                         1/1     Running   0          12s     run=messaging,tier=msg
nginx-448839                      1/1     Running   0          13m     run=nginx-448839
webapp-color                      1/1     Running   0          20m     name=webapp-color
master $
master $

```