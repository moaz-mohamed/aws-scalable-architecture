resource "aws_lb" "scalable_alb" {
  name               = "scalable-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  tags = {
    Name = "Scalable ALB"
  }
}


resource "aws_lb_target_group" "scalable_alb_target_group" {
  name     = "scalable-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "Scalable ALB Target Group"
  }
}

resource "aws_lb_listener" "scalable_alb_listener" {
  load_balancer_arn = aws_lb.scalable_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scalable_alb_target_group.arn
  }
  tags = {
    Name = "Scalable ALB Listener"
  }
}

resource "aws_wafv2_web_acl" "scalable_waf" {
  name        = "scalable-waf"
  description = "WAF for Scalable ALB"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "scalable-waf"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "scalable_waf_association" {
  resource_arn = aws_lb.scalable_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.scalable_waf.arn
}