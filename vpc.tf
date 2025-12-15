data "aws_availability_zones" "available" {
  state = "available"
}
 
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
 
  tags = {
    Name = "ecs-fargate-vpc"
  }
}
 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
 
  tags = {
    Name = "ecs-fargate-igw"
  }
}
 
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
 
  tags = {
    Name = "ecs-fargate-public-az1"
  }
}
 
resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
 
  tags = {
    Name = "ecs-fargate-public-az2"
  }
}
 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
 
  tags = {
    Name = "ecs-fargate-public-rt"
  }
}
 
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
 
resource "aws_route_table_association" "public_az1" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_az1.id
}
 
resource "aws_route_table_association" "public_az2" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_az2.id
}
