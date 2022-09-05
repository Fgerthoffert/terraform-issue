variable "env_name" {
  default     = ""
  description = "Environment name"
  type        = string
}

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

variable "ssh_allowed_pub_keys" {
  default     = ""
  description = "SSH allowed Public keys to connect to the jump server"
}

variable "ssh_pub_key" {
  default     = ""
  description = "SSH Public key to connect to the jump server"
}

variable "ssh_private_key" {
  default     = ""
  description = "SSH Private key (matching the ssh_pub_key)"
}

variable "zone_id_public" {
  default     = ""
  description = "ID of the DNS zone to attach the server to"
  type        = string
}

variable "zone_id_private" {
  default     = ""
  description = "ID of the DNS zone to attach the server to"
  type        = string
}

variable "server_name" {
  default     = ""
  description = "Server name of the bastion server"
  type        = string
}

variable "server_name_jahia_public" {
  default     = ""
  description = "Server name of the bastion server"
  type        = string
}

variable "server_name_jahia_private" {
  default     = ""
  description = "Server name of the bastion server"
  type        = string
}

variable "security_group_id" {
  default     = ""
  description = "ID of the security group"
  type        = string
}

variable "private_security_group_id" {
  default     = ""
  description = "ID of the private group"
  type        = string
}

variable "subnet_id" {
  default     = ""
  description = "ID of the subnet shared amongst ec2 instances"
  type        = string
}

variable "key_name" {
  default     = ""
  description = "EC2 ssh key name"
  type        = string
}

variable "efs_dns_name" {
  default     = ""
  description = "EFS DNS Name"
  type        = string
}

variable "http_logs_username" {
  default     = ""
  description = "Username for http basic auth"
  type        = string
}

variable "http_logs_password" {
  default     = ""
  description = "Password for http basic auth"
  type        = string
}
