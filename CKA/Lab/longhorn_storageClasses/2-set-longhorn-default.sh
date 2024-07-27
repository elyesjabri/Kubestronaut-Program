#!/bin/bash
## Set the nfs Storage Classe As the default provider

kubectl patch storageclass longhorn -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'