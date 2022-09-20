#!/bin/bash

echo "running installation script in instances..."

instances=($@)

for instance in "${instances[@]}";
do 
    echo "installing for $instance..."
    ssh -i "~/.ssh/sandbox-key" ec2-user@$instance 'bash -s' < install_for_consul.sh
done

echo "[complete] bulk install complete!"
