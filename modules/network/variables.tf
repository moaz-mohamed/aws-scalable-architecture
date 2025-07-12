variable "azs" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_ec2_subnet_cidrs" {
  description = "List of private EC2 subnet CIDRs"
  type        = list(string)
  default     = ["10.0.32.0/20", "10.0.48.0/20"]
}

variable "private_rds_subnet_cidrs" {
  description = "List of private RDS subnet CIDRs"
  type        = list(string)
  default     = ["10.0.64.0/20", "10.0.80.0/20"]
}
