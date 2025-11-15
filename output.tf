# ============================================
# OUTPUTS
# ============================================

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.lab_vpc.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private_subnet.id
}

output "public_instance_id" {
  description = "Public Instance ID"
  value       = aws_instance.public_instance.id
}

output "private_instance_id" {
  description = "Private Instance ID"
  value       = aws_instance.private_instance.id
}

output "private_instance_private_ip" {
  description = "Private Instance Private IP"
  value       = aws_instance.private_instance.private_ip
}

output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.daily_reports.id
}

output "s3_bucket_arn" {
  description = "S3 Bucket ARN"
  value       = aws_s3_bucket.daily_reports.arn
}

output "private_route_table_id" {
  description = "Private Route Table ID (for VPC Endpoint)"
  value       = aws_route_table.private_rt.id
}

output "s3_access_profile_name" {
  description = "S3 Access Profile Name (to attach in Task 4)"
  value       = aws_iam_instance_profile.s3_access_profile.name
}

output "connection_instructions" {
  description = "Instructions to connect to instances"
  value       = <<-EOT
    
    ====================================
    LAB ENVIRONMENT PROVISIONED!
    ====================================
    
    Region: ${var.aws_region}
    VPC ID: ${aws_vpc.lab_vpc.id}
    
    S3 Bucket: ${aws_s3_bucket.daily_reports.id}
    
    Public Instance ID: ${aws_instance.public_instance.id}
    Private Instance ID: ${aws_instance.private_instance.id}
    Private Instance IP: ${aws_instance.private_instance.private_ip}
    
    To connect to Public Instance:
    aws ssm start-session --target ${aws_instance.public_instance.id} --region ${var.aws_region}
    
    From Public Instance, connect to Private Instance:
    mssh -o ServerAliveInterval=120 ${aws_instance.private_instance.id} -r ${var.aws_region}
    
    S3 Access Profile (for Task 4): ${aws_iam_instance_profile.s3_access_profile.name}
    Private Route Table (for VPC Endpoint): ${aws_route_table.private_rt.id}
    
    Next Steps:
    1. Proceed with Task 2: Create VPC Endpoint
    2. In Task 4: Attach S3AccessProfile to Private Instance
    
    ====================================
  EOT
}