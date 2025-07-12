output "alb_target_group_arn" {
    description = "ARN of the target group for the Application Load Balancer"
    value       = aws_lb_target_group.scalable_alb_target_group.arn
}

output "alb_dns_name" {
    description = "DNS name of the Application Load Balancer"
    value       = aws_lb.scalable_alb.dns_name
}

output "alb_arn" {
    description = "ARN of the Application Load Balancer"
    value       = aws_lb.scalable_alb.arn
}