# Automation scripts to setup and configure Consul and Vault clusters on acloudguru playground

### Index
- configure aws cli to aws sandbox: setup_aws_cli.sh
- generate if not exist a key-pair and upload to aws key pairs: import_key_pair.sh
- create security groupn and rule to allow inbound ssh access from anywhere and create 5 ec2 instances: create_instances.sh

## Setting up AWS CLI for the sandbox
file: setup_aws_cli.sh

Command:
```
bash setup_aws_cli.sh <access key id> <secret access key> [region] [output format]
```
* default region: us-east-1
* default output format: json

## Generate if not exist, and upload key-pair to aws
file: import_key_pair.sh

Command:
```
bash import_key_pair.sh
```

## Create 5 EC2 instances
file: create_instances.sh
- create security group and a rule to allow inbound ssh from anywhere.
- create five EC2 instances 
- returns a list of EC2 instances' id.
  