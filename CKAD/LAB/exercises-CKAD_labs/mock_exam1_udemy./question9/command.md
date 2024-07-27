
```
master $ kubectl create secret db-secret-xxdf --from-literal='DB_Host=sql01' --from-literal='DB_User=root' --from-literal='DB_Password=password123' --dry-run -o yaml > s.yml
Error: unknown flag: --from-literal
See 'kubectl create secret --help' for usage.
master $
master $
master $
master $ kubectl create secret --helpCreate a secret using specified subcommand.

Available Commands:
  docker-registry Create a secret for use with a Docker registry
  generic         Create a secret from a local file, directory or literal value
  tls             Create a TLS secret

Usage:
  kubectl create secret [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
master $ kubectl create secret generic db-secret-xxdf --from-literal='DB_Host=sql01' --from-literal='DB_User=root' --from-literal='DB_Password=password123' --dry-run -o yaml > s.yml
W0708 04:50:13.464799   13034 helpers.go:535] --dry-run is deprecated and can be replaced with --dry-run=client.
master $
master $
master $ vi s.yml
master $ kubectl cerate -f s.yml
Error: unknown command "cerate" for "kubectl"

Did you mean this?
        create

Run 'kubectl --help' for usage.
master $ kubectl create -f s.yml
secret/db-secret-xxdf created
master $
master $
master $
```