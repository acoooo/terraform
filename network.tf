resource "aws_vpc" "primary-vpc" {
  cidr_block           = var.primary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"

  tags = {
    Name = "primary-vpc"
  }
}

resource "aws_vpc" "secondary-vpc" {
  cidr_block           = var.secondary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"

  provider = aws.central-eu

  tags = {
    Name = "secondary-vpc"
  }
}

resource "aws_subnet" "primary_vpc_public_subnets" {
  count                   = length(var.primary_vpc_public_subnet_cidr)
  vpc_id                  = aws_vpc.primary-vpc.id
  cidr_block              = var.primary_vpc_public_subnet_cidr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "primary-vpc-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "primary_vpc_private_subnets" {
  count                   = length(var.primary_vpc_private_subnet_cidr)
  vpc_id                  = aws_vpc.primary-vpc.id
  cidr_block              = var.primary_vpc_private_subnet_cidr[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "primary-vpc-private-subnet-${count.index}"
  }
}

resource "aws_subnet" "primary_vpc_database_subnets" {
  count                   = length(var.primary_vpc_database_subnet_cidr)
  vpc_id                  = aws_vpc.primary-vpc.id
  cidr_block              = var.primary_vpc_database_subnet_cidr[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "primary-vpc-database-subnet-${count.index}"
  }
}

resource "aws_subnet" "secondary_vpc_public_subnets" {
  count                   = length(var.secondary_vpc_public_subnet_cidr)
  vpc_id                  = aws_vpc.secondary-vpc.id
  cidr_block              = var.secondary_vpc_public_subnet_cidr[count.index]
  map_public_ip_on_launch = true

  provider = aws.central-eu

  tags = {
    Name = "secondary-vpc-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "secondary_vpc_private_subnets" {
  count                   = length(var.secondary_vpc_private_subnet_cidr)
  vpc_id                  = aws_vpc.secondary-vpc.id
  cidr_block              = var.secondary_vpc_private_subnet_cidr[count.index]
  map_public_ip_on_launch = false

  provider = aws.central-eu

  tags = {
    Name = "secondary-vpc-private-subnet-${count.index}"
  }
}

resource "aws_subnet" "secondary_vpc_database_subnets" {
  count                   = length(var.secondary_vpc_database_subnet_cidr)
  vpc_id                  = aws_vpc.secondary-vpc.id
  cidr_block              = var.secondary_vpc_database_subnet_cidr[count.index]
  map_public_ip_on_launch = false

  provider = aws.central-eu

  tags = {
    Name = "secondary-vpc-database-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "primary_internet_gateway" {
  vpc_id = aws_vpc.primary-vpc.id
  tags = {
    Name = "primary-vpc-igw"
  }
}

resource "aws_internet_gateway" "secondary_internet_gateway" {
  vpc_id = aws_vpc.secondary-vpc.id

  provider = aws.central-eu

  tags = {
    Name = "secondary-vpc-igw"
  }
}

resource "aws_eip" "primary-elastic-ip" {
  vpc = true
}

resource "aws_eip" "secondary-elastic-ip" {
  provider = aws.central-eu

  vpc = true
}

resource "aws_nat_gateway" "primary_nat_gateway" {
  allocation_id = aws_eip.primary-elastic-ip.id
  subnet_id     = aws_subnet.primary_vpc_public_subnets[0].id
}

resource "aws_nat_gateway" "secondary_nat_gateway" {
  provider      = aws.central-eu
  allocation_id = aws_eip.secondary-elastic-ip.id
  subnet_id     = aws_subnet.secondary_vpc_public_subnets[0].id
}

resource "aws_route_table" "primary-public-crt" {
  vpc_id = aws_vpc.primary-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_internet_gateway.id
  }

  route {
    cidr_block = aws_vpc.secondary-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "primary-public-crt"
  }
}

resource "aws_route_table" "secondary-public-crt" {
  vpc_id   = aws_vpc.secondary-vpc.id
  provider = aws.central-eu

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_internet_gateway.id
  }

    route {
    cidr_block = aws_vpc.primary-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "secondary-public-crt"
  }
}

resource "aws_route_table" "primary-nat-crt" {
  vpc_id = aws_vpc.primary-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.primary_nat_gateway.id
  }

    route {
    cidr_block = aws_vpc.secondary-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "primary-nat-crt"
  }
}

resource "aws_route_table" "secondary-nat-crt" {
  vpc_id   = aws_vpc.secondary-vpc.id
  provider = aws.central-eu

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.secondary_nat_gateway.id
  }

    route {
    cidr_block = aws_vpc.primary-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "secondary-nat-crt"
  }
}

resource "aws_route_table_association" "primary_crta" {
  count          = length(var.primary_vpc_public_subnet_cidr)
  subnet_id      = aws_subnet.primary_vpc_public_subnets[count.index].id
  route_table_id = aws_route_table.primary-public-crt.id
}

resource "aws_route_table_association" "primary_nat_crta" {
  count          = length(var.primary_vpc_private_subnet_cidr)
  subnet_id      = aws_subnet.primary_vpc_private_subnets[count.index].id
  route_table_id = aws_route_table.primary-nat-crt.id
}

resource "aws_route_table_association" "secondary_crta" {
  count          = length(var.secondary_vpc_public_subnet_cidr)
  subnet_id      = aws_subnet.secondary_vpc_public_subnets[count.index].id
  route_table_id = aws_route_table.secondary-public-crt.id
  provider       = aws.central-eu

}

resource "aws_route_table_association" "secondary_nat_crta" {
  count          = length(var.secondary_vpc_private_subnet_cidr)
  subnet_id      = aws_subnet.secondary_vpc_private_subnets[count.index].id
  route_table_id = aws_route_table.secondary-nat-crt.id
  provider       = aws.central-eu

}

resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.primary-vpc.id
  peer_vpc_id = aws_vpc.secondary-vpc.id
  peer_region = "eu-central-1"

}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.central-eu
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
