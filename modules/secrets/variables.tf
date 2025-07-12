variable "db_host" {
    description = "The hostname of the RDS database"
    type        = string
}

variable "db_username" {
    description = "The username for the RDS database"
    type        = string
}

variable "db_password" {
    description = "The password for the RDS database"
    type        = string
    sensitive   = true
}

variable "db_name" {
    description = "The name of the RDS database"
    type        = string
}