#!/bin/bash

echo "creating consul.hcl file..."

consul_type=$1
private_ip=$2
instance_name=$3

if [[ $consul_type == "server" ]]
then
    printf 'server = true
datacenter = "dc1"
data_dir = "/opt/consul"
bootstrap_expect = 3' > consul.hcl 
else
    printf "datacenter = \"dc1\"
data_dir = \"/opt/consul\"
client_addr = \"$private_ip\"
advertise_addr = \"$private_ip\"
node_name = \"$instance_name\"
ui = false
retry_join = [\"consul-server0.sandbox.com\", \"consul-server1.sandbox.com\", \"consul-server2.sandbox.com\"]" \
    > consul.hcl
fi

echo "[complete] consul.hcl file created"

