variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
  default     = "dream-vacation-app"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of an existing AWS EC2 key pair used for SSH access. Must already exist in the target region."
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH into the instance. Restrict this to your own IP/32 in production."
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_ports" {
  description = "Extra TCP ports the app needs open besides 22 and 80 (backend API + current frontend host port)"
  type        = list(number)
  default     = [3001, 8081]
}

variable "cpu_alarm_threshold" {
  description = "CPUUtilization percentage that triggers the CloudWatch alarm"
  type        = number
  default     = 70
}
