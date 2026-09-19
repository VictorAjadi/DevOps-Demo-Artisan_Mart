resource "aws_vpc" "artisan_mart_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "artisan_mart_vpc"
  }
}

resource "aws_subnet" "artisan_mart_subnet" {
  vpc_id                  = aws_vpc.artisan_mart_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.avail_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "artisan_mart_subnet"
  }
}

resource "aws_internet_gateway" "artisan_mart_igw" {
  vpc_id = aws_vpc.artisan_mart_vpc.id

  tags = {
    Name = "artisan_mart_igw"
  }
}

resource "aws_default_route_table" "artisan_mart_rtb" {
  default_route_table_id = aws_vpc.artisan_mart_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.artisan_mart_igw.id
  }

  tags = {
    Name = "artisan_mart_rtb"
  }
}