#!/bin/bash

# generate and import key pair to aws

# set aws profile env variable
export AWS_PROFILE=$(cat profile_name)

# check profile in use
user_exist=$(aws sts get-caller-identity | jq .Arn | grep -i cloud_user)

if [[ -z "$user_exist" ]]; then
    echo "username does not match"
    exit
fi

echo "checking if key pair exists..."
KEY_PAIR_NAME="sandbox-key"

if [[ -f ~/.ssh/$KEY_PAIR_NAME ]]; then
    echo "key-pair exists"
else 
    echo "key-pair doesn't exist"
    echo "generating key-pair"
    ssh-keygen -t rsa -C "$KEY_PAIR_NAME" -f ~/.ssh/$KEY_PAIR_NAME -P ""
fi

echo "exporting public key to aws key-pair..."
aws ec2 import-key-pair --key-name "$KEY_PAIR_NAME" --public-key-material fileb://~/.ssh/$KEY_PAIR_NAME.pub

echo "[complete] upload public key to aws key-pair complete!"
