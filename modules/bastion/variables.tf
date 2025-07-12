variable "bastion_ami" {
  description = "AMI ID for the Bastion host"
  type        = string
  default = "ami-0fab1b527ffa9b942" # Amazon Amazon Linux 2023 kernel-6.1 AMI Ireland (eu-west-1) 
}

variable "bastion_instance_type" {
  description = "Instance type for the Bastion host"
  type        = string
  default     = "t2.micro"
}

variable "bastion_subnet_id" {
  description = "Subnet ID for the Bastion host"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group for the Bastion host"
  type        = string
}

variable "bastion_key_name" {
  description = "Key pair name for SSH access to the Bastion host"
  type        = string
  default     = "scalable-server-key"  
}