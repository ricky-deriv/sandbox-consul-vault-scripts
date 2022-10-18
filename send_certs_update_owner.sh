#!/bin/bash

echo "sending certs and update /etc/consul.d ownership..."

# set aws profile env variable
export AWS_PROFILE=$(cat profile_name)

# check profile in use
user_exist=$(aws sts get-caller-identity | jq .Arn | grep -i cloud_user)

if [[ -z "$user_exist" ]]; then
    echo "username does not match"
    exit
fi

KEY_PAIR_NAME="sandbox-key"

public_dns_names=($@)
host_index=0

for host in "${public_dns_names[@]}";
do
    if [ $host_index -lt 3 ]
    then
        scp -i ~/.ssh/$KEY_PAIR_NAME .secrets/consul-agent-ca.pem .secrets/dc1-server-consul-$host_index* ec2-user@$host:
    else 
        scp -i ~/.ssh/$KEY_PAIR_NAME .secrets/consul-agent-ca.pem ec2-user@$host:
    fi

    ssh -i "~/.ssh/$KEY_PAIR_NAME" ec2-user@$host "sudo mv consul* dc1* /etc/consul.d/; sudo chown --recursive consul:consul /etc/consul.d;"
    host_index=$((host_index+1))
done

echo "[complete] sent and moved certs to all agents, and changes ownership of /etc/consul.d to consul:consul."


