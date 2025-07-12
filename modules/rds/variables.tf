variable "rds_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t4g.micro" # Default instance class, can be overridden
}

variable "private_rds_subnets_ids" {
  description = "List of private subnets for the RDS instance"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security group ID for the RDS instance"
  type        = string
}

variable "db_port" {
  description = "Port for the RDS database"
  type        = number
  default     = 3306 # Default MySQL port, can be overridden
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
  sensitive = true
  validation {
    condition     = length(var.db_username) > 4
    error_message = "The RDS username must not be empty."
  }
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "The RDS password must be at least 8 characters long."
  }
}

variable "db_name" {
  description = "Name of the RDS database"
  type        = string
  default     = "appdb" # Default database name, can be overridden
  validation {
    condition     = length(var.db_name) > 0
    error_message = "The RDS database name must not be empty."
  }
}

