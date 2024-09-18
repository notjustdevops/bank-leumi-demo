# path: Leumi-Jenkins-Pipeline/modules/vpc/main.tf

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-vpc" })
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-public-subnet" })
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-private-subnet" })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-igw" })
}
