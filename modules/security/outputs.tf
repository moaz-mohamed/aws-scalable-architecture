output "ec2_sg_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

output "alb_sg_id" {
  description = "The ID of the Application Load Balancer security group"
  value       = aws_security_group.alb_sg.id
}

output "bastion_sg_id" {
  description = "The ID of the Bastion host security group"
  value       = aws_security_group.bastion_sg.id
}

output "rds_sg_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}

