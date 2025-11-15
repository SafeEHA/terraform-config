# Variables
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "vpc-s3-lab"
}