```
Apply a label app_type=beta to node node02. Create a new deployment called beta-apps with image:nginx and replicas:3. Set Node Affinity to the deployment to place the PODs on node02 only


NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution
```