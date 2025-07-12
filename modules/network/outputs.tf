output "scalable_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.scalable_vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public_subnet[*].id
}

output "private_ec2_subnet_ids" {
  description = "List of private EC2 subnet IDs"
  value       = aws_subnet.private_ec2_subnet[*].id
}

output "private_rds_subnet_ids" {
  description = "List of private RDS subnet IDs"
  value       = aws_subnet.private_rds_subnet[*].id
}





