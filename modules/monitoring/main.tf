resource "aws_sns_topic" "scalable_infrastructure_topic" {
  name         = "scalable-infrastructure-topic"
  display_name = "Scalable Infrastructure Notifications"
}

resource "aws_sns_topic_subscription" "scalable_infrastructure_subscription" {
  topic_arn = aws_sns_topic.scalable_infrastructure_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_host_count" {
  alarm_name          = "Alarm for Unhealthy Hosts in ALB"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "UnhealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when the number of unhealthy hosts in the ALB exceeds 1"
  alarm_actions       = [aws_sns_topic.scalable_infrastructure_topic.arn]
  dimensions = {
    LoadBalancer = var.alb_arn
    TargetGroup  = var.target_group_arn
  }
}
