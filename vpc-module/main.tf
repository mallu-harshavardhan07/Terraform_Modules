resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.project}-${var.env}"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-igw"
  }
}
resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.env}-public-subnet"
  }
}
resource "aws_subnet" "private_subnet" {
  count = length(var.private_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = "${var.project}-${var.env}-private-subnet"

  }
}
resource "aws_subnet" "database_subnet" {
  count = length(var.database_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = "${var.project}-${var.env}-database-subnet"

  }
}
resource "aws_eip" "lb" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

}
resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.main.id
}
resource "aws_route" "public_r" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}
resource "aws_route" "private_r" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}
resource "aws_route" "database_r" {
  route_table_id            = aws_route_table.database_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}
resource "aws_route_table_association" "public_rta" {
    count = length(var.public_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_rta" {
  count = length(var.private_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "database_rta" {
    count = length(var.database_cidr)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database_rt.id
}