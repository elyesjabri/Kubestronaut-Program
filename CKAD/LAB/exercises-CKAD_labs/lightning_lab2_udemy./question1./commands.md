```
kubectl get pod --all-namespaces
kubectl get pod nginx1401 -n dev1401
```


# part1
```
readines probe
since container port is 9080

change http port to 9080

```

# part2
```
livenessProbe:
  exec:
    command:
    - ls
    - /var/www/html/file_check
  initialDelaySeconds: 10
  periodSeconds: 60
```