#!/bin/bash

echo "setting up hostname and /etc/hosts file..."

instance_dns_name=$1
hostname=$2
hosts_content="$3"

echo $instance_dns_name

ssh -i "~/.ssh/sandbox-key" ec2-user@$instance_dns_name "sudo hostnamectl set-hostname $hostname;
    printf '$hosts_content' | sudo tee -a /etc/hosts; cat /etc/hosts;"
echo ""

