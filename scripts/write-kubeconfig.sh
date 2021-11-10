#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: get-kubeconfig.sh <stack>"
  exit 1
fi
control_plane_ip=$(openstack stack output show $1 control_plane_ip -f json | jq -r '.output_value')
openstack stack output show $1 kubeconfig -f json | jq -r '.output_value | fromjson ."1"' | base64 --decode | sed "s/127.0.0.1/${control_plane_ip}/" | sed "s/default/$1/g" > $1.yaml
