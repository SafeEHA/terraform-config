# Public Instance (Bastion Host)
resource "aws_instance" "public_instance" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # Install EC2 Instance Connect
              yum install -y ec2-instance-connect
              EOF

  tags = {
    Name = "Public Instance"
  }
}

# Private Instance
resource "aws_instance" "private_instance" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # Install EC2 Instance Connect and AWS CLI
              yum install -y ec2-instance-connect
              yum install -y aws-cli
              EOF

  tags = {
    Name = "Private Instance"
  }
}