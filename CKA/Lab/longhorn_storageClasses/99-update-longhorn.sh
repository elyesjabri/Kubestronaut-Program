#!/bin/bash
# helm upgrade
helm upgrade longhorn longhorn/longhorn -f manifests/0-longhorn/values.yaml  --namespace longhorn-system  
echo "Deployment Values Updated :D"


