variable "env_prefix" {
  default     = ""
  description = "Prefix for naming the environment"
  type        = string
}

variable "vpc_id" {
  default     = ""
  description = "ID of the VPC"
  type        = string
}

variable "public_root_domain" {
  default     = ""
  description = "Root domain to attach the public domain to"
  type        = string
}

variable "env_public_domain" {
  default     = ""
  description = "Public domain to be used for the environment"
  type        = string
}

variable "env_private_domain" {
  default     = ""
  description = "Private domain to be used for the environment"
  type        = string
}

