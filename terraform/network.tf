# --- VPC ---
resource "aws_vpc" "dream_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "dream-vpc"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --- Subnet ---
resource "aws_subnet" "dream_subnet" {
  vpc_id                  = aws_vpc.dream_vpc.id
  cidr_block               = var.subnet_cidr
  map_public_ip_on_launch  = true
  availability_zone        = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "dream-subnet"
    Project     = var.project_name
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "dream_igw" {
  vpc_id = aws_vpc.dream_vpc.id

  tags = {
    Name        = "dream-igw"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --- Route Table ---
resource "aws_route_table" "dream_rt" {
  vpc_id = aws_vpc.dream_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dream_igw.id
  }

  tags = {
    Name        = "dream-rt"
    Project     = var.project_name
    Environment = var.environment
  }
}

# --- Subnet <-> Route Table Association ---
resource "aws_route_table_association" "dream_rt_assoc" {
  subnet_id      = aws_subnet.dream_subnet.id
  route_table_id = aws_route_table.dream_rt.id
}
