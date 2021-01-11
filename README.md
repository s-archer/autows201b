# autows201_demo

Before you use this repository, please follow the pre-requisites:

-   Create an AWS IAM for programmatic access, and save the access key and secret key to use in the next step.
-   Install aws cli and run 'aws configure'.  This will create a user credentials file ~/.aws/credentials - Terraform will use these credentials to access your AWS account for automation.

-   If you want to update the filter string, to identify a different AMI for use in this deployment.  You can use the aws cli to test your string... just experiment by changing `*BIGIP-15.1*PAYG-Best*25Mbps*` in the following command, to ensure you get one AMI returned:

    `aws ec2 describe-images --region eu-west-2 --filters "Name=name,Values=*BIGIP-15.1*PAYG-Best*25Mbps*" | grep '\"Name\"\|\"ImageId\"\|\"OwnerId\"'`

This deployment will build the following components:

- AWS infrastructure using the VPC module and other aws_ resources
- An NGINX autoscale group, to provide a simple web app
- Hashicorp Consul for service discovery
- A single BIG-IP with 3 NICs
    - BIG-IP is configured via a user-data script injected on first booot, that performs the following tasks:
        - downloads and installs bigip_runtime_init package
        - provides bigip_runtime_init with its yaml configuration file
        - bigip_runtime_init installs DO, AS3 packages (plus other Automation Toolchain components)
        - bigip_runtime_init declares the DO and AS3 json configurations
    - BIG-IP is reported ready when the NGINX application is available via the Virtual Server.

<img src="./images/deploy_diagram.png">

To deploy the infrastructure, you can:
-   cd ./terraform
-   terraform init
-   terraform plan
-   terraform apply

optionally, you can deploy the FAST declaration:
-   cd ../fast
-   terraform init
-   terraform plan
-   terraform apply

To destroy:
-   cd ../fast 
-   terraform destroy
-   cd ../terraform 
-   terraform destroy

...or you can deploy the Terraform templatefile example, which creates AS3 from variables:
-   cd ../tf_templated_as3
-   terraform init
-   terraform plan
-   terraform apply

To destroy:
-   cd ../tf_templated_as3
-   terraform destroy
-   cd ../terraform 
-   terraform destroy
