variable "db_username" {
  description = "Username for the RDS database"
  type        = string
  sensitive   = true
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
