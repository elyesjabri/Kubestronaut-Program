# commands for rollback deployment
```
kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record
kubectl rollout history deployment.v1.apps/nginx-deploy
kubectl rollout undo deployment.v1.apps/nginx-deploy
```