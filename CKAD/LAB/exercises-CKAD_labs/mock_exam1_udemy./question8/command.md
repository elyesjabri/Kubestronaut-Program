```
master $ kubectl create configmap  cm-3392845 --dry-run -o yaml > c.yaml
W0708 04:44:03.275846   10463 helpers.go:535] --dry-run is deprecated and can be replaced with --dry-run=client.
master $ vi c.yaml
master $
master $
master $ kubectl create -f c.yaml
Error from server (BadRequest): error when creating "c.yaml": ConfigMap in version "v1" cannot be handled as a ConfigMap: v1.ConfigMap.Data: ReadString: expects " or n, but found 3, error found in #10 byte of ...|DB_PORT":3306},"kind|..., bigger context ...|322.mycompany.com","DB_NAME":"SQL3322","DB_PORT":3306},"kind":"ConfigMap","metadata":{"creationTimes|...
master $ vi c.yaml
master $ kubectl create -f c.yaml
Error from server (BadRequest): error when creating "c.yaml": ConfigMap in version "v1" cannot be handled as a ConfigMap: v1.ConfigMap.Data: ReadString: expects " or n, but found 3, error found in #10 byte of ...|DB_PORT":3306},"kind|..., bigger context ...|322.mycompany.com","DB_NAME":"SQL3322","DB_PORT":3306},"kind":"ConfigMap","metadata":{"creationTimes|...
master $
master $
master $ vi c.yaml
master $
master $
master $ kubectl create -f c.yaml
configmap/cm-3392845 created
master $
master $
master $
master $ kubectl describe configmap/cm-3392845
Name:         cm-3392845
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
DB_HOST:
----
sql322.mycompany.com
DB_NAME:
----
SQL3322
DB_PORT:
----
3306
Events:  <none>
master $
master $
```