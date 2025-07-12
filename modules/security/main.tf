resource "aws_security_group" "bastion_sg" {
  vpc_id      = var.scalable_vpc_id
  name        = "bastion-sg"
  description = "Security group for bastion host allowing SSH access"
  tags = {
    Name = "Bastion SG"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id      = var.scalable_vpc_id
  name        = "ALB SG"
  description = "Security group for Application Load Balancer allowing HTTP access"
  tags = {
    Name = "ALB SG"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id      = var.scalable_vpc_id
  name        = "EC2 SG"
  description = "Security group for EC2 instances allowing HTTP from ALB and SSH from Bastion"
  depends_on  = [aws_security_group.alb_sg, aws_security_group.bastion_sg]
  tags = {
    Name = "EC2 SG"
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id      = var.scalable_vpc_id
  name        = "RDS SG"
  description = "Security group for RDS instances allowing access from EC2 instances"
  depends_on  = [aws_security_group.ec2_sg]
  tags = {
    Name = "RDS SG"
  }
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
