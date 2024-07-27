```
kubectl create deployment httpd-frontend --image httpd:2.4-alpine
```

can do --dry-run=client -o yaml > dep.yaml 
and edit the replicas count