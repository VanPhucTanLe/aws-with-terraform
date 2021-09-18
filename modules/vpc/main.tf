data "aws_availability_zones" "available" {}
# 1. Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "MyVPC-OwnerTL"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    "Name" = "IG-OwnerTL"
  }
}

# 2b. Create NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id     = var.allocation_id #"eipalloc-4b9f3b4c"
  subnet_id         = var.public_subnets[1]
  connectivity_type = "public"

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.internet-gateway_id]
}

# 3. Create two Subnets (Public, Private)
resource "aws_subnet" "public-subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.${0 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "PublicSubnet-OwnerTL-${count.index}"
  }
}

resource "aws_subnet" "private-subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.${100 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "PrivateSubnet-OwnerTL-${count.index}"
  }
}

# 4. Create Custom Route Tables
resource "aws_route_table" "public-route-table" {
  vpc_id = var.vpc_id #"vpc-05769dc8ebef43f9e"

  route {
    cidr_block = var.custom_cidr_block[0]
    gateway_id = var.internet-gateway_id
  }

  tags = {
    Name = "PublicRouteTable-OwnerTL"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = var.vpc_id #"vpc-05769dc8ebef43f9e"

  route {
    cidr_block     = var.custom_cidr_block[0]
    nat_gateway_id = var.nat-gateway_id
    #gateway_id = var.internet-gateway[0]
  }

  tags = {
    Name = "PrivateRouteTable-OwnerTL"
  }
}

# 5. Associate Subnets with Route Tables
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(var.public_subnets, count.index)
  route_table_id = var.public-route-table_id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(var.private_subnets, count.index)
  route_table_id = var.private-route-table_id
}
