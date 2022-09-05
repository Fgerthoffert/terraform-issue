resource "aws_subnet" "ec2_sn" {
  cidr_block = var.ec2_subnet
  vpc_id     = var.vpc_id

  tags = {
    "Name" = "${var.env_prefix}-ec2_sn"
  }
}

resource "aws_route_table" "ec2_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }
  tags = {
    Name = "${var.env_prefix}-ec2_rt"
  }
}

resource "aws_route_table_association" "ec2_rt_assoc" {
  subnet_id      = aws_subnet.ec2_sn.id
  route_table_id = aws_route_table.ec2_rt.id
}