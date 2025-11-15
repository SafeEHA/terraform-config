
# Public Instance Security Group
resource "aws_security_group" "public_instance_sg" {
  name        = "Public Instance SG"
  description = "Security group for public instance (bastion host)"
  vpc_id      = aws_vpc.lab_vpc.id

  # Outbound Rules
  egress {
    description = "Allow HTTP to any"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS to any"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow SSH to private subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.2.0/24"]
  }

  tags = {
    Name = "Public Instance SG"
  }
}

# Private Instance Security Group
resource "aws_security_group" "private_instance_sg" {
  name        = "Private Instance SG"
  description = "Security group for private instance"
  vpc_id      = aws_vpc.lab_vpc.id

  # Inbound Rules
  ingress {
    description = "Allow SSH from public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.1.0/24"]
  }

  # Outbound Rules
  egress {
    description = "Allow HTTP to any"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS to any"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private Instance SG"
  }
}

# Security Group for EFS Mount Targets (for future use)
resource "aws_security_group" "efs_mount_sg" {
  name        = "EFSMountTargetSecurityGroup"
  description = "Security group for EFS mount targets"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description     = "Allow NFS from private instance"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.private_instance_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EFSMountTargetSecurityGroup"
  }
}