variable "env_prefix" {
  default     = ""
  description = "Prefix for naming the environment"
  type        = string
}

variable "vpc_id" {
  default     = ""
  description = "vpc ID"
  type        = string
}

variable "ec2_subnet" {
  default     = ""
  description = "EC2 instances subnets"
  type        = string
}

variable "internet_gateway_id" {
  default     = ""
  description = "VPC internet gateway id"
}

variable "ssh_pub_key" {
  default     = ""
  description = "SSH Public key to connect to the jump server"
}
