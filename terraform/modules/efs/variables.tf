variable "env_prefix" {
  default     = ""
  description = "Prefix for naming the environment"
  type        = string
}

variable "security_group_id" {
  default     = ""
  description = "ID of the security group"
  type        = string
}

variable "subnet_id" {
  default     = ""
  description = "ID of the subnet shared amongst ec2 instances"
  type        = string
}
