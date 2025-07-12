variable "alb_arn" {
    description = "ARN of the Application Load Balancer"
    type        = string
}

variable "target_group_arn" {
    description = "ARN of the target group for the ALB"
    type        = string
}

variable "notification_email" {
    description = "Email address for receiving notifications"
    type        = string
    validation {
        condition     = can(regex(".+@.+\\..+", var.notification_email))
        error_message = "The notification_email must be a valid email address."
    }
    default = "moaz.farrag@outlook.com"
}