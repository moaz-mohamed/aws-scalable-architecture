variable "flask_ami_id" {
  description = "AMI ID for the Flask application"
  type        = string
  default     = "ami-015955f9a991390aa"
}

variable "key_name" {
  description = "Key pair name for SSH access to the Flask application instances"
  type        = string
  default     = "scalable-server-key"
}

variable "ec2_sg_id" {
  description = "Security group ID for the EC2 instances"
  type        = string
}

variable "private_ec2_subnet_ids" {
  description = "List of private EC2 subnet IDs for the ASG"
  type        = list(string)
}

variable "alb_target_group_arns" {
  description = "List of ALB target group ARNs for the ASG"
  type        = list(string)
}
