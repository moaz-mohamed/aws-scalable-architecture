output "Application_URL" {
  description = "Application URL"
  value       = module.alb.alb_dns_name
}