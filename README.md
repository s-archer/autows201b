# autows201_demo

To find aws imagage filter, use the aws cli:

aws ec2 describe-images --region eu-west-2 --filters "Name=name,Values=*BIGIP-15.1*PAYG-Best*25Mbps*" | grep '\"Name\"\|\"ImageId\"'

Terraform uses credentials in ~/.aws/credentials, so use 'aws configure' to configure the creds.

