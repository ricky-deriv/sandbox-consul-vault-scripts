#!/bin/bash

echo "creating consul.hcl file..."

consul_type=$1
private_ip=$2
instance_name=$3
gossip_key=$4
instance_index=$5

if [[ $consul_type == "server" ]]
then
    printf "server = true
datacenter = \"dc1\"
data_dir = \"/opt/consul\"
bootstrap_expect = 3

encrypt = \"$gossip_key\"
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true

ca_file = \"/etc/consul.d/consul-agent-ca.pem\"
cert_file = \"/etc/consul.d/dc1-server-consul-$instance_index.pem\"
key_file = \"/etc/consul.d/dc1-server-consul-$instance_index-key.pem\"

auto_encrypt {
  allow_tls = true
}

acl {
  enabled = true
  default_policy = \"allow\"
  enable_token_persistence = true
}

connect {
  enabled = true
}

addresses {
  grpc = \"127.0.0.1\"
}

ports {
  grpc  = 8502
}
" > consul.hcl 

else
    printf "datacenter = \"dc1\"
data_dir = \"/opt/consul\"
client_addr = \"$private_ip\"
advertise_addr = \"$private_ip\"
node_name = \"$instance_name\"
ui = false
retry_join = [\"consul-server0.sandbox.com\", \"consul-server1.sandbox.com\", \"consul-server2.sandbox.com\"]
encrypt = \"$gossip_key\"
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true

ca_file = \"/etc/consul.d/consul-agent-ca.pem\"

auto_encrypt {
  tls = true
}

acl {
  enabled = true
  default_policy = \"allow\"
  enable_token_persistence = true
}

connect {
  enabled = true
}

addresses {
  grpc = \"127.0.0.1\"
}

ports {
  grpc  = 8502
}" \
    > consul.hcl
fi

echo "[complete] consul.hcl file created"

