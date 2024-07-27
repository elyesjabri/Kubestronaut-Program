question.md
```
Create a redis deployment using the image redis:alpine with 1 replica and label app=redis. Expose it via a ClusterIP service called redis on port 6379. Create a new Ingress Type NetworkPolicy called redis-access which allows only the pods with label access=redis to access the deployment.



Image: redis:alpine
Deployment created correctly?
Service created correctly?
Network Policy allows the correct pods?
Network Policy applied on the correct pods?
```