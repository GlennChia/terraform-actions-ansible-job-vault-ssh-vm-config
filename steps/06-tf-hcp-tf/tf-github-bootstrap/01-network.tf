resource "aws_vpc" "tf_aap" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.tf_aap_resource_prefix}-vpc"
  }
}

resource "aws_subnet" "tf_aap_public1" {
  vpc_id                  = aws_vpc.tf_aap.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = local.matching_azs[0]

  tags = {
    Name = "${var.tf_aap_resource_prefix}-public-subnet1"
  }
}

resource "aws_internet_gateway" "tf_aap" {
  vpc_id = aws_vpc.tf_aap.id

  tags = {
    Name = "${var.tf_aap_resource_prefix}-igw"
  }
}

resource "aws_route_table" "tf_aap_public" {
  vpc_id = aws_vpc.tf_aap.id

  tags = {
    Name = "${var.tf_aap_resource_prefix}-public-rtb"
  }
}

resource "aws_route" "tf_aap_public_rtb_internet" {
  route_table_id         = aws_route_table.tf_aap_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_aap.id
}

resource "aws_route_table_association" "tf_aap_public_rtb_public_subnet1" {
  subnet_id      = aws_subnet.tf_aap_public1.id
  route_table_id = aws_route_table.tf_aap_public.id
}