#!/bin/bash

echo "installing for consul config..."

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install consul
consul --version

echo "[complete] installtion complete!"