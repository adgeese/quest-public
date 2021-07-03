# Quest Terraform IaC
Terraform, Infrastructure as Code to deploy the 

# Proof of a Quest Endeavoured
Configure and build a Docker application on AWS with Terraform. The application will be load balanced
and available through GitHub. SSL Certificate will be created leveraging the Let's Encrypt Terraform
demonstration. Existing domain on-hand named microhedg.es has been leveraged as home. 

## Screenshot of Success
```
quest-success.png
 or,
Browse to https://www.microhedg.es/
```

Note: The load balancer, target group, and the ssl certificate upload are not part of this IaC implementation in Terraform. Those were done manually, even though with another couple hours we could be fully Applied and Destroyed automatically. Thank you for your consideration of my time, and hope you see this as a good push towards the final accomplishment for a production delivery. Looking forward to talking out some of the points of interest in this implementation, as Terraform may be best suited with an Ansible integration for the final configurations. Something that I have more experience with, and suited to accomplish. Though, I felt this was a good representation with the time provided.

## Requirements
- Terraform
- AWS and CLI installed
- Docker

# Building and Releasing the Docker Quest Application
## Build the docker image
docker build . -f Dockerfile -t quest

## Tag built container
docker tag quest 659589102240.dkr.ecr.us-west-2.amazonaws.com/quest

## Login to aws repo
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 659589102240.dkr.ecr.us-west-2.amazonaws.com

## Pushing image to repo
docker push 659589102240.dkr.ecr.us-west-2.amazonaws.com/quest

## Pull to the EC2 Instance
sudo docker pull 659589102240.dkr.ecr.us-west-2.amazonaws.com/quest:latest

## Start docker container
sudo docker run -d -p 80:3000 -it  659589102240.dkr.ecr.us-west-2.amazonaws.com/quest:latest


# Terraform Process
* 1 VPC
* 1 public subnet
* 1 Internet Gateway
* 1 Security Group
* 1 EC2
  * Provision: 
     * Install Docker
     * Install Git
     * Install Go
     * Download and run SSL Proxy to create Let's Encrypt SSL Certificate
     * Upload AWS Certificates from Let's Encrypt
     * Create Target Group
     * Register Instance to Target Group
     * Create Load Balancer for Target Group using the AWS Certificate uploaded

## Deploying the Application using Terraform

```
cd tf
ssh-keygen -f quest-key-pair
terraform init
terraform plan -out terraform.out
terraform apply terraform.out
terraform destroy
```

# Author

```
Brandon Wilkins - brandon@adgee.se
```
