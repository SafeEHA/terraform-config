# IAM Role for EC2 Instances (Systems Manager access)
resource "aws_iam_role" "ec2_ssm_role" {
  name = "EC2-SSM-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "EC2-SSM-Role"
  }
}

# Attach AWS managed policy for Systems Manager
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Policy for SSM Session Manager access
resource "aws_iam_role_policy" "ssm_session_policy" {
  name = "SSM-Session-Policy"
  role = aws_iam_role.ec2_ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession",
          "ssm:TerminateSession",
          "ssm:ResumeSession",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus"
        ]
        Resource = "*"
      }
    ]
  })
}

# Policy for EC2 Instance Connect
resource "aws_iam_role_policy" "ec2_instance_connect_policy" {
  name = "EC2-Instance-Connect-Policy"
  role = aws_iam_role.ec2_ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ec2-instance-connect:SendSSHPublicKey"
        Resource = "*"
      }
    ]
  })
}

# Instance Profile for Public Instance
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "EC2-SSM-Profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# IAM Role for S3 Access (Private Instance)
resource "aws_iam_role" "s3_access_role" {
  name = "S3-Access-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "S3-Access-Role"
  }
}

# S3 Access Policy
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "S3-Access-Policy"
  role = aws_iam_role.s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.daily_reports.arn}/*"
      }
    ]
  })
}

# Attach Systems Manager policy to S3 role as well
resource "aws_iam_role_policy_attachment" "s3_role_ssm_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile for Private Instance (will be attached in Task 4)
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "S3AccessProfile"
  role = aws_iam_role.s3_access_role.name
}