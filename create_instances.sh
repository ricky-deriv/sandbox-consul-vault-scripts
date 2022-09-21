#!/bin/bash

echo "creating ec2 instances..."

# set aws profile env variable
export AWS_PROFILE=$(cat profile_name)

# check profile in use
user_exist=$(aws sts get-caller-identity | jq .Arn | grep -i cloud_user)

if [[ -z "$user_exist" ]]; then
    echo "username does not match"
    exit
fi

KEY_PAIR_NAME="sandbox-key"
INSTANCE_IDS=()

echo "creating default security group for instances..."
aws ec2 create-security-group --group-name default-security --description "default security group for instances"

echo "creating allow inbound ssh access from anywhere..."
aws ec2 authorize-security-group-ingress \
    --group-name default-security \
    --protocol tcp \
    --port 0-65535 \
    --cidr 0.0.0.0/0

# debian ami: ami-09a41e26df464c548

for i in {0..5}
do 
    if [ $i -lt 3 ]
    then 
        ec2_info=$(aws ec2 run-instances \
        --image-id ami-05fa00d4c63e32376 \
        --instance-type t2.micro \
        --security-groups default-security \
        --key-name $KEY_PAIR_NAME \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=consul-server$i}]" | jq .Instances[].InstanceId)
    else 
        ec2_info=$(aws ec2 run-instances \
        --image-id ami-05fa00d4c63e32376 \
        --instance-type t2.micro \
        --security-groups default-security \
        --key-name $KEY_PAIR_NAME \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=consul-client$i}]" | jq .Instances[].InstanceId)
    fi


    INSTANCE_IDS+=( $ec2_info )
done

echo "${INSTANCE_IDS[*]}"


echo "[complete] creation of ec2 instances is complete!"