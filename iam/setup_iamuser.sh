!#/bin/bash

terrafrom init
terrform plan
terraform apply --auto-approve

aws configure set aws_access_key_id $(terraform output -raw new_user_access_key) --profile terraform-user
aws configure set aws_secret_access_key $(terraform output -raw new_user_secret_key) --profile terraform-user
aws configure set region us-east-1 --profile terraform-user




