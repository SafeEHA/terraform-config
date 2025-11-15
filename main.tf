# ============================================
# VPC ENDPOINTS AND S3 LAB - TERRAFORM SCRIPT
# ============================================
# This script provisions the initial lab environment for Task 1
# including VPC, subnets, EC2 instances, security groups, and S3 bucket

# Provider Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}









