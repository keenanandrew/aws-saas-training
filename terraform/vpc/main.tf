locals {
  name_prefix = "training"
  tags = {
    Environment = "training"
    Owner       = "keenanandrew"
  }
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, { Name = "${local.name_prefix}-vpc" })
}

# Internet Gateway (for public subnet)
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "${local.name_prefix}-igw" })
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = merge(local.tags, { Name = "${local.name_prefix}-public-1" })
}

# Private subnet (no NAT route)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.20.101.0/24"
  availability_zone = "eu-west-2a"

  tags = merge(local.tags, { Name = "${local.name_prefix}-private-1" })
}

# Public route table -> IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "${local.name_prefix}-rt-public" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private route table (no default route to internet)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "${local.name_prefix}-rt-private" })
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Basic security group for later (app)
resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-sg-app"
  description = "App SG (training)"
  vpc_id      = aws_vpc.this.id

  # No inbound by default (we will add later when needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${local.name_prefix}-sg-app" })
}