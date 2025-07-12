resource "aws_vpc" "scalable_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "scalable-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.scalable_vpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_ec2_subnet" {
  vpc_id            = aws_vpc.scalable_vpc.id
  count             = length(var.private_ec2_subnet_cidrs)
  cidr_block        = element(var.private_ec2_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "private-ec2-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_rds_subnet" {
  vpc_id            = aws_vpc.scalable_vpc.id
  count             = length(var.private_rds_subnet_cidrs)
  cidr_block        = element(var.private_rds_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "private-rds-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "scalable_igw" {
  vpc_id = aws_vpc.scalable_vpc.id
  tags = {
    Name = "scalable-igw"
  }
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "scalable_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "scalable-nat-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.scalable_vpc.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.scalable_igw.id
  depends_on             = [aws_internet_gateway.scalable_igw]
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_ec2_route_table" {
  vpc_id = aws_vpc.scalable_vpc.id
  tags = {
    Name = "private-ec2-route-table"
  }
}

resource "aws_route" "private_ec2_route" {
  route_table_id         = aws_route_table.private_ec2_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.scalable_nat_gateway.id
  depends_on             = [aws_nat_gateway.scalable_nat_gateway]
}

resource "aws_route_table_association" "private_ec2_subnet_association" {
  count          = length(aws_subnet.private_ec2_subnet)
  subnet_id      = element(aws_subnet.private_ec2_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_ec2_route_table.id
}

resource "aws_route_table" "private_rds_route_table" {
  vpc_id = aws_vpc.scalable_vpc.id
  tags = {
    Name = "private-rds-route-table"
  }
}

resource "aws_route_table_association" "private_rds_subnet_association" {
  count          = length(aws_subnet.private_rds_subnet)
  subnet_id      = element(aws_subnet.private_rds_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_rds_route_table.id

}

