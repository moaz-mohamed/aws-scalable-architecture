variable "vpc_id" {
  description = "VPC ID where the Application Load Balancer will be created"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group for the Application Load Balancer"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the Application Load Balancer"
  type        = list(string)
}

