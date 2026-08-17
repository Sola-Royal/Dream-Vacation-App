# --- Latest Ubuntu LTS AMI ---
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- Security Group: SSH + HTTP (+ app ports currently used by docker-compose.prod.yml) ---
resource "aws_security_group" "dream_sg" {
  name        = "dream-sg"
  description = "Allow SSH and HTTP access for Dream Vacation App"
  vpc_id      = aws_vpc.dream_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.app_ports
    content {
      description = "App port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dream-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --- EC2 Instance ---
resource "aws_instance" "dream_app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.dream_subnet.id
  vpc_security_group_ids      = [aws_security_group.dream_sg.id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  monitoring                  = false # keep false to stay fully within Free Tier — detailed monitoring is not free

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name        = "dream-app-server"
    Project     = var.project_name
    Environment = var.environment
  }
}
