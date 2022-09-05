variable "env_name" {
  default     = ""
  description = "Environment name"
  type        = string
}

variable "public_root_domain" {
  default     = ""
  description = "Public root domain for the AWS tenant"
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

variable "cluster_pg_id" {
  default     = ""
  description = "Cluster Placement Group ID"
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

variable "docker_run_env" {
  default     = ""
  description = "Docker environment variable"
  type        = string
}

variable "docker_run_cmd" {
  default     = ""
  description = "Docker run command to start the container"
  type        = string
}

variable "docker_run_image" {
  default     = ""
  description = "Docker Image to start"
  type        = string
}

variable "hostname" {
  default     = ""
  description = "Hostname of the machine"
  type        = string
}

variable "zone_id_public" {
  default     = ""
  description = "ID of the public DNS zone to attach the server to"
  type        = string
}

variable "zone_id_private" {
  default     = ""
  description = "ID of the private DNS zone to attach the server to"
  type        = string
}

variable "server_name_jahia_public" {
  default     = ""
  description = "Public DNS address of the machine"
  type        = string
}

variable "ec2_instance_type" {
  default     = "t2.medium"
  description = "Type of EC2 instance to be started"
  type        = string
}


variable "server_name_jahia_private" {
  default     = ""
  description = "Private DNS address of the machine"
  type        = string
}

variable "NEXUS_USERNAME" {
  default     = ""
  description = "Username to connect to nexus"
  type        = string
}

variable "NEXUS_PASSWORD" {
  default     = ""
  description = "Password to connect to nexus"
  type        = string
}

variable "DOCKERHUB_USERNAME" {
  default     = ""
  description = "Username to connect to Docker Hub"
  type        = string
}

variable "DOCKERHUB_PASSWORD" {
  default     = ""
  description = "PASSWORD to connect to Docker Hub"
  type        = string
}

variable "JAHIA_LICENSE" {
  default     = ""
  description = "A Base64 encoded Jahia license"
  type        = string
}

variable "sleep" {
  default     = 10
  description = "Sleep time after docker run has been called"
  type        = number
}

variable "cron" {
  default     = "*/5 * * * *"
  description = "Cron expression for this node"
  type        = string
}

variable "PERF_TESTS_JAHIA_JFR_RUN" {
  default     = false
  description = "Boolean to start JFR recording"
  type        = bool
}

variable "PERF_TESTS_START_INFRA_ONLY" {
  default     = false
  description = "Boolean to indicate that neither provisioning neither the tests should be executed"
  type        = bool
}