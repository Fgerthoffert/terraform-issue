resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_subnet
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    "Name" = "${var.env_prefix}-vpc"
  }
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["AmazonProvidedDNS", "8.8.8.8", "8.8.4.4"]
}

###### Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.env_prefix}-igw"
  }
}
