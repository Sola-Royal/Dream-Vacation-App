# --- CloudWatch Alarm: High CPU on the app instance ---
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "dream-app-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods   = 2
  metric_name          = "CPUUtilization"
  namespace            = "AWS/EC2"
  period               = 300
  statistic            = "Average"
  threshold            = var.cpu_alarm_threshold
  alarm_description    = "Triggers when average CPU utilization exceeds ${var.cpu_alarm_threshold}% for 10 minutes"
  treat_missing_data    = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.dream_app.id
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# --- CloudWatch Dashboard: quick visual of CPU for screenshots/monitoring ---
resource "aws_cloudwatch_dashboard" "dream_app" {
  dashboard_name = "dream-app-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "EC2 CPUUtilization"
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.dream_app.id]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          view   = "timeSeries"
        }
      }
    ]
  })
}
