# this helps in avoiding to write entire command
# saves time for CKAD

```
alias k="kubectl"
alias kc="k create"
alias kg="k get"
alias kd="k describe"
alias kr="k run"

export do="--dry-run=client -o yaml"
```

Example:

```
kg po nginx
```

```
master $ kr nginx --image=nginx --restart=Never $do > pod.yaml
```