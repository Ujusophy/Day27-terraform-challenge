resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.public_azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.private_azs[count.index]
  tags = {
    Name = "${var.name}-private-subnet-${count.index}"
  }
}

resource "aws_db_subnet_group" "example" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = {
    Name = "${var.name}-db-subnet-group"
  }
}
