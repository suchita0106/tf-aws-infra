resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.eval_period
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_period
  statistic           = "Average"
  threshold           = var.up_threshold
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  tags = {
    Name = "scale-up-alarm"
  }
}

# CloudWatch Metric Alarm for Scaling Down
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale-down-cpu-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.eval_period
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_period
  statistic           = "Average"
  threshold           = var.down_threshold
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  tags = {
    Name = "scale-down-alarm"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                    = "scale-up"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = var.cooldown_period
  autoscaling_group_name  = aws_autoscaling_group.app_asg.name
  metric_aggregation_type = "Average"
  policy_type             = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale_down" {
  name                    = "scale-down"
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = var.cooldown_period
  autoscaling_group_name  = aws_autoscaling_group.app_asg.name
  metric_aggregation_type = "Average"
  policy_type             = "SimpleScaling"
}
