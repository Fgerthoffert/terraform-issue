variable "vpc_subnet" {
  default     = ""
  description = "The base subnet of the VPC"
}

variable "env_prefix" {
  default     = ""
  description = "Prefix for naming the environment"
  type        = string
}