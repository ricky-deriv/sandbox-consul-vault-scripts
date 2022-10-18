#!/bin/bash

echo "restarting consul service..."
KEY_PAIR_NAME="sandbox-key"
public_dns_names=($@)

for host in "${public_dns_names[@]}";
do 
    ssh -i ~/.ssh/$KEY_PAIR_NAME ec2-user@$host "sudo systemctl stop consul; sudo systemctl enable consul && sudo systemctl start consul; sudo systemctl status consul;"
done

echo "[complete] consul restarted."