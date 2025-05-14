# Week-11Assignment
MERN Stack Blog Deployment with Terraform and Ansible  
    
This repository contains the solution for deploying a MERN stack blog application on AWS using Terraform for infrastructure provisioning and Ansible for backend server configuration.

Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Deployment Steps](#deployment-steps)
4. [Terraform Configuration](#terraform-configuration)
5. [Ansible Playbook](#ansible-playbook)
6. [Application Configuration](#application-configuration)
7. [Verification](#verification)
8. [Cleanup](#cleanup)


The solution consists of:
- Frontend: Hosted on S3 with static website hosting enabled
- Backend: Node.js server running on EC2 instance (Ubuntu 22.04)
- Database: MongoDB Atlas cluster
- Media Storage: Dedicated S3 bucket with proper IAM policies

 Prerequisites
Before starting, ensure you have:
1. AWS account with programmatic access
2. Terraform installed 
3. Ansible installed 
4. MongoDB Atlas account
5. AWS CLI configured with proper credentials
6. SSH key pair for EC2 access

Deployment Steps
1. Clone this repository
git clone https://github.com/noufalasi/mern-blog-deployment.git
cd mern-blog-deployment
2. Initialize Terraform
cd terraform
terraform init
3. Review and modify variables
Edit terraform/variables.tf to match your requirements:
variable "region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

4. Apply Terraform configuration
terraform plan
terraform apply

5. Run Ansible playbook
cd ../ansible
ansible-playbook -i inventory backend-playbook.yml

Terraform Configuration

The Terraform configuration creates the following resources:
EC2 Instance
- Ubuntu 22.04 LTS
- t3.micro instance type
- Security group allowing SSH (22), HTTP (80), and app port (5000)
- IAM role with S3 access permissions

S3 Buckets
1. Frontend Bucket
   - Static website hosting enabled
   - Public read access policy
   - CORS configuration

2. Media Bucket
   - Private access
   - CORS policy for media uploads
   - IAM user with programmatic access

Security
- IAM policy restricting access to media bucket only
- Security group with minimal required ports open

Ansible Playbook

The Ansible playbook performs the following tasks:
1. System Setup
   - Updates packages
   - Installs Node.js via NVM
   - Installs PM2 for process management

2. Application Deployment
   - Clones the blog application repository
   - Creates and configures .env file with:
     - MongoDB Atlas connection string
     - S3 credentials (from Terraform outputs)
     - JWT secrets
   - Installs dependencies
   - Starts the application with PM2

3. Frontend Deployment
   - Builds the React application
   - Deploys to S3 bucket
Playbook structure:
ansible/
├── inventory
├── backend-playbook.yml
└── roles/
    └── backend/
        ├── tasks/
        ├── templates/
        └── vars/

Application Configuration
Backend .env
PORT=5000
mongodb+srv://blog-user:PassWord@cluster0.bia8xoi.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0   
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
S3_BUCKET=blog-media-bucket

Frontend .env
VITE_BASE_URL=http://<ec2-public-dns>:5000/api
VITE_MEDIA_BASE_URL=https://<media-bucket>.s3.eu-north-1.amazonaws.com

Verification

After deployment, verify:
1. Backend
  
   ssh -i blog-userr-key.pem ubuntu@ec2-instance
   pm2 list
   
   Should show "blog-backend" as running

2. Frontend
   - Access the S3 website endpoint in your browser
   - Verify blog posts load correctly

3. Media Uploads
   - Create a new post with an image
   - Verify image appears in the media bucket
  
     Cleanup

To destroy all resources:
1. Destroy Terraform resources
cd terraform
terraform destroy
2. Manual cleanup:
   - Delete MongoDB Atlas users/IP rules
   - Revoke IAM user credentials
   -  Remove any sensitive data from repository
  
