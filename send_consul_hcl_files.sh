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

echo "creating and sending consul.hcl files..."

instances_ids=($@)
instance_index=0

for id in "${instances_ids[@]}";
do
    instance_details=$(aws ec2 describe-instances --instance-ids $id)
    public_dns_name=$(echo $instance_details | jq -r .Reservations[].Instances[].PublicDnsName)
    private_ip=$(echo $instance_details | jq -r .Reservations[].Instances[].PrivateIpAddress)
    name=$(echo $instance_details | jq -r .Reservations[].Instances[].Tags[].Value)
    
    echo "creating consul.hcl file..."
    if [[ $instance_index -lt 3 ]] 
    then
        bash create_consul_config_file.sh "server" "$private_ip" "$name"
    else 
        bash create_consul_config_file.sh "client" "$private_ip" "$name"
    fi

    echo "copying consul.hcl file over to remote server..."
    scp -i ~/.ssh/$KEY_PAIR_NAME consul.hcl ec2-user@$public_dns_name:

    echo "moving file from home dir to /etc/consul.d dir..."
    ssh -i ~/.ssh/$KEY_PAIR_NAME ec2-user@$public_dns_name "sudo mv ~/consul.hcl /etc/consul.d"

    echo "starting consul service and printing members..."
    ssh -i ~/.ssh/$KEY_PAIR_NAME ec2-user@$public_dns_name "sudo systemctl stop consul; sudo systemctl enable consul && sudo systemctl start consul; sudo systemctl status consul;"

    instance_index=$((instance_index+1))
done


echo "[complete] consul.hcl files created and sent"