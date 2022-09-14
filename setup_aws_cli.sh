#!/bin/bash

# purpose: to configure aws cli to cloud sandbox aws

echo "creating / overwriting aws profile for sandbox_user"

KEY_ID=$1
KEY=$2
REGION_NAME=$3
OUTPUT_FORMAT=$4

if [[ (-z "$KEY_ID") || (-z "$KEY") ]]
then 
    echo "Access Key ID and Secret Access Key are missing!"
    echo "program exiting..."
    exit
fi

if [[ (-z "$REGION_NAME") ]]
then
    REGION_NAME="us-east-1"
    echo "No input for region, hence default is used: us-east-1"
fi

if [[ -z "$OUTPUT_FORMAT" ]]
then
    OUTPUT_FORMAT="json"
    echo "No input for output format, hence default is used: json"
fi

printf "$KEY_ID\n$KEY\n$REGION_NAME\n$OUTPUT_FORMAT" | aws configure --profile sandbox_user

echo ""
echo "setting env var AWS_PROFILE to sandbox_user"
export AWS_PROFILE=sandbox_user

echo "[complete] setting up aws profile for sandbox_user is complete!"



