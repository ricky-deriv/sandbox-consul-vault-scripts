#!/bin/bash

# set aws profile env variable
export AWS_PROFILE=$(cat profile_name)

# check profile in use
user_exist=$(aws sts get-caller-identity | jq .Arn | grep -i cloud_user)

if [[ -z "$user_exist" ]]; then
    echo "username does not match"
    exit
fi

KEY_PAIR_NAME="sandbox-key"

instances_ids=($@)
instances_public_dns_names=()
private_ips=()
hosts_content=""
instance_index=0

echo "adding hostnames to known_hosts file..."
for id in "${instances_ids[@]}";
do  
    dns_name=$(aws ec2 describe-instances --instance-ids $id --query 'Reservations[].Instances[].PublicDnsName' | jq -r .[])
    instances_public_dns_names+=($dns_name)
    # ssh keyscan 
    ssh-keyscan -H $dns_name >> ~/.ssh/known_hosts
    host_content=""

    private_ip=$(aws ec2 describe-instances --instance-ids $id --query 'Reservations[].Instances[].PrivateIpAddress' | jq -r .[])
    private_ips+=($private_ip)
    if [ $instance_index -lt 3 ]
    then 
        host_content="\n$private_ip consul-server$instance_index.sandbox.com consul-server$instance_index"
    else 
        host_content="\n$private_ip consul-client$instance_index.sandbox.com consul-client$instance_index"
    fi

    hosts_content="$hosts_content$host_content"
    instance_index=$((instance_index+1))
done

instance_index=0
for public_dns_name in "${instances_public_dns_names[@]}";
do
    if [ $instance_index -lt 3 ]
    then 
        bash set_hostname_hosts.sh $public_dns_name consul-server$instance_index.sandbox.com "$hosts_content"
    else 
        bash set_hostname_hosts.sh $public_dns_name consul-client$instance_index.sandbox.com "$hosts_content"
    fi
    instance_index=$((instance_index+1))
done
echo "${instances_public_dns_names[*]}"
echo "${private_ips[*]}"
echo "[complete] changing hostname and adding hosts to /etc/hosts"
