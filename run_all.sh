#!/bin/bash

echo "running all scripts to create and configure consul nodes..."

# script to setup aws cli profile
bash setup_aws_cli.sh $1 $2 $3 $4

# script to generate if not exists and export key-pair
bash import_key_pair.sh

# script to create 6 instances
bash create_instances.sh

source vars.txt

echo "instance ids: $ids"

# update hostnames and /etc/hosts
bash get_update_hostnames.sh $ids

# install for consul
bash bulk_install_for_consul.sh $ids

# create and send consul.hcl, and start consul service in all instances
bash send_consul_hcl_files.sh $ids

echo "[complete] run all complete!"