# Terraform and Ansible Project: Infrastructure Automation 

## Project Overview
This project aims to build infrastructure using Terraform across two availability zones (AZs), configure Docker on private instances using Ansible, and automate deployment using GitOps practices. The CI/CD pipeline is implemented using Jenkins, GitHub Actions, or GitLab Pipelines.

---

## 1. Terraform Infrastructure Setup

### 1.1. VPC & Networking
- **VPC Creation**: Define a VPC resource in Terraform with the required CIDR block.
- **Subnets**: 
  - Create **one public subnet** and **one private subnet** per availability zone.
  - The public subnet will host the Load Balancer (LB) and the Bastion Host.
  - The private subnet will host the instances (app servers).
  
### 1.2. Security Groups
Configure security groups to allow:
- **SSH** from specific IPs to the Bastion Host.
- **HTTP/HTTPS** traffic to the Load Balancer.
- **Internal communication** between the Load Balancer and the instances in the private subnets.

---

## 2. Auto Scaling Group (ASG) & Load Balancer

### 2.1. Launch Configuration/Template
- Use a Terraform `aws_launch_template` or `aws_launch_configuration` to define instance details such as:
  - AMI ID
  - Instance type
  - Security group
  - Private/public IP settings

### 2.2. Auto Scaling Group (ASG)
- Create an Auto Scaling Group (ASG) to manage two EC2 instances in the private subnets across both AZs.

### 2.3. Load Balancer (LB)
- Deploy an Application Load Balancer (ALB) in the public subnets, routing traffic to the instances in the private subnets.

---

## 3. Private Instance Configuration
- **Terraform Output**: Output the private instance IPs to a file using Terraform’s `local_file` resource.
- This file will be used later as an inventory file for Ansible.

---

## 4. Bastion Host Configuration

### 4.1. Bastion Host
- Deploy an EC2 instance in the public subnet to act as a Bastion Host.
- Configure it to:
  - Allow SSH access from your specific IP.
  - Allow SSH access to the private instances using their private IPs.

### 4.2. File Copy to Bastion
- Use Terraform’s `provisioner` to copy the Ansible playbooks and configuration files to the Bastion Host after infrastructure provisioning.

---

## 5. Ansible Configuration

### 5.1. Ansible Inventory File
- Use the Terraform output file (with private instance IPs) as an inventory for your Ansible playbooks.

### 5.2. Docker Installation
- Create a custom Ansible role to:
  - Install Docker.
  - Configure Docker to run at startup.
  - Ensure the Nginx container is running on each instance.

### 5.3. Nginx Setup
- Use a task in the Ansible role to deploy an Nginx container on each private instance using Docker.

---

## 6. GitOps & CI/CD Implementation

### 6.1. Git Repository
- Store both Terraform and Ansible configurations in a version-controlled Git repository.

### 6.2. CI/CD Pipeline Stages

1. **Terraform Init & Plan**: Initialize Terraform and show the planned infrastructure changes.
2. **Terraform Apply**: Apply the infrastructure changes.
3. **Ansible Playbook Execution**: Once the infrastructure is provisioned, trigger the Ansible playbook execution on the Bastion Host to configure the private instances.

### 6.3. CI/CD Tool
- Choose one of the following CI/CD tools to automate the deployment:
  - **Jenkins**: Create a `Jenkinsfile` to define the pipeline.
  - **GitHub Actions**: Define the pipeline using a `.yaml` configuration file.
  - **GitLab Pipelines**: Set up the pipeline with a `.gitlab-ci.yml` file.




