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

echo "running installation script in instances..."

instances_ids=($@)

for id in "${instances_ids[@]}";
do 
    dns_name=$(aws ec2 describe-instances --instance-ids $id --query 'Reservations[].Instances[].PublicDnsName' | jq -r .[])
    echo "installing for $id..."
    ssh -i "~/.ssh/sandbox-key" ec2-user@$dns_name 'bash -s' < install_for_consul.sh
done

echo "[complete] bulk install complete!"