resource "aws_instance" "bastion_host" {
  ami           = var.bastion_ami # Default: "ami-0fab1b527ffa9b942" (Amazon Linux 2023 kernel-6.1 AMI Ireland)
  instance_type = var.bastion_instance_type
  subnet_id    = var.bastion_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name      = var.bastion_key_name
  tags = {
    Name = "Bastion Host"
  }
}