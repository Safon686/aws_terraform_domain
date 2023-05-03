# Terraform AWS Infrastructure for safon686.com

This Terraform project creates the following AWS resources:
- Application Load Balancer (ALB)
- 2 AWS Target Groups
- AWS Auto Scaling Group (ASG) based on AWS Launch Template
- Nginx containers running on the instances
- S3 bucket for syncing index.html
- IAM role for instances to access S3

## Usage

1. Install Terraform.
2. Clone this repository.
3. Run `terraform init`.
4. Run `terraform apply`.

## AMI /packer

1. AWS AMI ubuntu is built with PACKER, pre-installed with docker and packaged the necessary containers.
2. Two NGINX containers are configured to work with volumes and on two different ports 80 and 8080. The content of the container issued is different and is determined from individual volumes.

3. A bash scripts file has been added to images locally, allowing you to later add and update the content of containers from a remote s3.

## Infrastructure /terraform

1. The base uses aws_launch_template (main.tf) which uses the AWS AMI created earlier (see AMI /packer ). When starting terraform, find the current version of ami by filters.
2. aws_autoscaling_group(main.tf) using aws_launch_template starts ec2.
3. aws_lb(lb.tf) is created with aws_lb_listener(lb.tf) configured on port 443. Pre-generated ssl certificate is used.
4. aws_lb_target_group(lb.tf) are created, which distribute traffic to different ports of nginx containers.
5. The aws_lb_target_group is routed according to the rules specified in aws_lb_listener_rule(lb.tf).
6. Records are created in route53(route53.tf) based on the previously created DNS name safon686.com

## Network /terraform

1. aws_vpc(network.tf) is created
2. Two aws_subnet(network.tf) are created in different availability_zones. In the case of using more than 1 ec2, due to different availability_zones, greater reliability of infrastructure health is ensured. The number of ec2s is defined in aws_autoscaling_group(main.tf) with the "min_size" parameter
3. An aws_route_table(network.tf) is created, which provides traffic access from global to nginx containers. Global access from aws_vpc is via aws_internet_gateway(main.tf)
4. Traffic control is carried out due to the created aws_security_group (main.tf)

## Questions? Write to: safon686@gmail.com