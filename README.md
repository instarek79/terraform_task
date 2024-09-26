#Terraform Infrastructure Setup:
VPC & Networking:
VPC Creation: Define a VPC resource in Terraform with the necessary CIDR block.
Subnets: For each availability zone (AZ), create one public and one private subnet. The public subnet will host the Load Balancer (LB) and Bastion Host, while the private subnet will host your instances.
Security Groups: Configure security groups to allow:
SSH from specific IPs to the Bastion Host.
HTTP/HTTPS traffic to the Load Balancer.
Internal communication between the LB and the instances in the private subnets.
Auto Scaling Group (ASG) & Load Balancer:
Launch Configuration/Template: Use a Terraform aws_launch_template or aws_launch_configuration to define the instance details (AMI, instance type, etc.).
Auto Scaling Group (ASG): Create an ASG to manage two EC2 instances in private subnets across both AZs.
Load Balancer (LB): Deploy an Application Load Balancer (ALB) in the public subnets, routing traffic to instances in the private subnets.
Private Instance Configuration:
Output the private instance IPs to a file using Terraform’s local_file resource, which will later serve as an inventory file for Ansible.
2. Bastion Host Configuration:
Bastion Host: Deploy an EC2 instance in the public subnet. Configure it to allow SSH access from your IP and allow SSH access to the private instances using their private IPs.
File Copy: Use Terraform’s provisioner to copy the Ansible playbooks and configuration files to the Bastion Host after infrastructure provisioning.
3. Ansible Configuration:
Ansible Inventory File:
Use the Terraform output file with the private instance IPs as an inventory for your Ansible playbooks.
Docker Installation:
Create an Ansible role to:
Install Docker.
Configure Docker to run at startup.
Ensure the Nginx container is running on each instance.
Nginx Setup:
Use a task in the Ansible role to deploy an Nginx container on each instance.
4. GitOps & CI/CD Implementation:
Git Repository:
Store both Terraform and Ansible configurations in a version-controlled Git repository.
CI/CD Pipeline:
Pipeline Stages:
Terraform Init & Plan: Initialize Terraform and show the planned infrastructure changes.
Terraform Apply: Apply infrastructure changes.
Ansible Playbook Execution: Once infrastructure is ready, trigger the Ansible playbook execution on the Bastion Host to configure the private instances.
CI/CD Tool:
If using Jenkins, create a Jenkinsfile to define the pipeline.
If using GitHub Actions or GitLab Pipelines, define the .yaml pipeline configuration.
