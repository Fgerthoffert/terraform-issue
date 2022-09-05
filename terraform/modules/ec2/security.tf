resource "aws_security_group" "ec2_sg" {
  name        = "${var.env_prefix}-ec2_sg"
  description = "Controls access to EC2 resources"
  vpc_id      = var.vpc_id

  ingress {
    description = "Public SSH access to all hosts"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Public access to the bastion HTTP server"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "EFS mount target"
  #   from_port   = 2049
  #   to_port     = 2049
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/0"]
  # }

  ingress {
    description = "Access to Jahia"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access to Unomi public"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["10.0.0.0/8"]
  }
}

resource "aws_security_group" "ec2_sg_private" {
  name        = "${var.env_prefix}-ec2_sg_private"
  description = "Controls access to EC2 resources within the private network"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.ec2_subnet]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.ec2_subnet]
  }
}
