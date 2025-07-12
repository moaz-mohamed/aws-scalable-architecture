resource "aws_launch_template" "scalable_launch_template" {
  name                   = "scalable-launch-template"
  image_id               = var.flask_ami_id # Flask application AMI ID
  instance_type          = "t2.micro"       # Instance type for the Flask application
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_sg_id]
  iam_instance_profile {
    name = "EC2SecretsAccessRole" # IAM role for EC2 to access DB credntails from Secrets Manager
  }
}

resource "aws_autoscaling_group" "scalable_asg" {
  launch_template {
    id      = aws_launch_template.scalable_launch_template.id
    version = "$Latest"
  }
  name                      = "scalable-asg"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = var.private_ec2_subnet_ids # Subnets for the ASG
  health_check_type         = "ELB"
  health_check_grace_period = 300                       # Grace period for health checks
  target_group_arns         = var.alb_target_group_arns # ALB target group ARNs for the ASG
  tag {
    key                 = "Name"
    value               = "scalable-asg-instance"
    propagate_at_launch = true
  }

}

// Tergt scaling of average cpu 70%
resource "aws_autoscaling_policy" "target_scaling_policy" {
  name                   = "target-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.scalable_asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

