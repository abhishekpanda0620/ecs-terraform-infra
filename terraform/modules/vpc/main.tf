resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, { Name = var.vpc_name })
}

# Public Subnets
resource "aws_subnet" "ecs_public_subnet" {
  for_each          = var.public_subnet_cidr_blocks
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags              = merge(var.tags, { Name = "${var.vpc_name}_public_subnet_${each.key}" })
}

# Private Subnets
resource "aws_subnet" "ecs_private_subnet" {
  for_each          = var.private_subnet_cidr_blocks
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags              = merge(var.tags, { Name = "${var.vpc_name}_private_subnet_${each.key}" })
}

# Internet Gateway
resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}_igw" })
}

# Public Route Table
resource "aws_route_table" "ecs_public_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}_public_route_table" })
}

# Public Route
resource "aws_route" "ecs_public_route" {
  route_table_id         = aws_route_table.ecs_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ecs_igw.id
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "ecs_public_subnet_association" {
  for_each       = aws_subnet.ecs_public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.ecs_public_route_table.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "ecs_eip" {
  domain     = "vpc"
  tags       = merge(var.tags, { Name = "${var.vpc_name}_eip" })
  depends_on = [aws_internet_gateway.ecs_igw]
}

# NAT Gateway (in first public subnet)
resource "aws_nat_gateway" "ecs_nat_gw" {
  allocation_id = aws_eip.ecs_eip.id
  subnet_id     = [for subnet in aws_subnet.ecs_public_subnet : subnet.id][0]
  tags          = merge(var.tags, { Name = "${var.vpc_name}_nat_gw" })
  depends_on    = [aws_internet_gateway.ecs_igw]
}

# Private Route Table
resource "aws_route_table" "ecs_private_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}_private_route_table" })
}

# Private Route (through NAT Gateway)
resource "aws_route" "ecs_private_route" {
  route_table_id         = aws_route_table.ecs_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ecs_nat_gw.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "ecs_private_subnet_association" {
  for_each       = aws_subnet.ecs_private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.ecs_private_route_table.id
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.vpc_name}_ecs_tasks"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.ecs_vpc.id
  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}_ecs_tasks_sg"
    }
  )

  ingress {
    description = "Allow inbound traffic from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # trivy:ignore:AVD-AWS-0104
    cidr_blocks = ["0.0.0.0/0"]
  }
}
