#====================================================
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "vpc_for_domain"
    }
}
#====================================================
resource "aws_internet_gateway" "igw_my_domain" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "igw_for_domain"
    }
}
#====================================================
resource "aws_subnet" "my_subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1a"
  tags = {
    Name = "subnet_1"
  }
}
#====================================================
#second subnet for min_size < 1 in asg
resource "aws_subnet" "my_subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1b"
  tags = {
    Name = "subnet_2"
  }
}
#====================================================
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_my_domain.id
  }
  tags = {
    Name = "route_teble_for_domain"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet_az1.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.my_subnet_az2.id
  route_table_id = aws_route_table.route_table.id
}