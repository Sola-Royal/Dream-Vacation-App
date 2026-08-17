output "vpc_id" {
  description = "ID of the dream-vpc"
  value       = aws_vpc.dream_vpc.id
}

output "subnet_id" {
  description = "ID of the dream-subnet"
  value       = aws_subnet.dream_subnet.id
}

output "security_group_id" {
  description = "ID of the dream-sg security group"
  value       = aws_security_group.dream_sg.id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.dream_app.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.dream_app.public_ip
}

output "cloudwatch_dashboard_url" {
  description = "Direct link to the CloudWatch dashboard"
  value       = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.dream_app.dashboard_name}"
}
