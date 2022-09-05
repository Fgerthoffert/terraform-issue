terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.59"
    }
  }
  backend "remote" {}
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = local.tfsettings.aws_region
  default_tags {
    tags = {
      CreatedBy   = "Terraform"
      Author      = local.tfsettings.env_author
      Environment = local.tfsettings.env_name
      Link        = local.tfsettings.env_link
      Purpose     = local.tfsettings.env_purpose
    }
  }
}

# Data Source to fetch the current AWS account_id
data "aws_caller_identity" "current" {}

# Retrieve general and workspaces specific variables and merge them together
locals {
  tfdefaultsettingsfile        = "./tfsettings.yaml"
  tfdefaultsettingsfilecontent = fileexists(local.tfdefaultsettingsfile) ? file(local.tfdefaultsettingsfile) : "NoTFdefaultSettingsFileFound: true"
  default_tfsettings           = yamldecode(local.tfdefaultsettingsfilecontent)

  tfsettingsfile        = "./environments/${terraform.workspace}/tfsettings.yaml"
  tfsettingsfilecontent = fileexists(local.tfsettingsfile) ? file(local.tfsettingsfile) : "NoTFSettingsFileFound: true"
  tfworkspacesettings   = yamldecode(local.tfsettingsfilecontent)

  tfsettings = merge(local.default_tfsettings, local.tfworkspacesettings)

  # Data Source to fetch the current AWS account_id
  account_id = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source = "./modules/vpc"

  vpc_subnet = local.tfsettings.vpc.subnet
  env_prefix = local.tfsettings.env_prefix
}

module "ec2" {
  source = "./modules/ec2"

  env_prefix = local.tfsettings.env_prefix

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  ec2_subnet          = local.tfsettings.ec2.subnet
  ssh_pub_key         = base64decode(var.SSH_PUBLIC_KEY_BASE64)
}

module "efs" {
  source = "./modules/efs"

  env_prefix        = local.tfsettings.env_prefix
  security_group_id = module.ec2.security_group_id
  subnet_id         = module.ec2.subnet_id
}

module "route53" {
  source = "./modules/route53"

  vpc_id             = module.vpc.vpc_id
  env_prefix         = local.tfsettings.env_prefix
  public_root_domain = local.tfsettings.route53.public_root_domain
  env_public_domain  = local.tfsettings.route53.env_public_domain
  env_private_domain = local.tfsettings.route53.env_private_domain
}

module "ec2-bastion" {
  source = "./modules/ec2-bastion"

  env_prefix = local.tfsettings.env_prefix

  vpc_id                    = module.vpc.vpc_id
  internet_gateway_id       = module.vpc.internet_gateway_id
  security_group_id         = module.ec2.security_group_id
  private_security_group_id = module.ec2.private_security_group_id
  subnet_id                 = module.ec2.subnet_id
  key_name                  = module.ec2.key_name
  efs_dns_name              = module.efs.dns_name

  env_name             = local.tfsettings.env_name
  ec2_subnet           = local.tfsettings.ec2.subnet
  ssh_allowed_pub_keys = local.tfsettings.ssh_pub_keys
  ssh_pub_key          = base64decode(var.SSH_PUBLIC_KEY_BASE64)
  ssh_private_key      = base64decode(var.SSH_PRIVATE_KEY_BASE64)

  http_logs_username = local.tfsettings.bastion.http_logs_username
  http_logs_password = local.tfsettings.bastion.http_logs_password

  # DNS Configuration
  zone_id_public            = module.route53.zone_id_public
  zone_id_private           = module.route53.zone_id_private
  server_name_jahia_public  = "${local.tfsettings.bastion.hostname}.${local.tfsettings.route53.env_public_domain}"
  server_name_jahia_private = "${local.tfsettings.bastion.hostname}.${local.tfsettings.route53.env_private_domain}"
}

module "ec2-docker" {
  source = "./modules/ec2-docker"

  for_each = local.tfsettings.docker_containers

  vpc_id                    = module.vpc.vpc_id
  internet_gateway_id       = module.vpc.internet_gateway_id
  security_group_id         = module.ec2.security_group_id
  private_security_group_id = module.ec2.private_security_group_id
  subnet_id                 = module.ec2.subnet_id
  key_name                  = module.ec2.key_name
  cluster_pg_id             = module.ec2.cluster_placement_group_id
  efs_dns_name              = module.efs.dns_name

  # Defining environment variables
  NEXUS_USERNAME              = var.NEXUS_USERNAME
  NEXUS_PASSWORD              = var.NEXUS_PASSWORD
  DOCKERHUB_USERNAME          = var.DOCKERHUB_USERNAME
  DOCKERHUB_PASSWORD          = var.DOCKERHUB_PASSWORD
  JAHIA_LICENSE               = var.JAHIA_LICENSE
  PERF_TESTS_JAHIA_JFR_RUN    = var.PERF_TESTS_JAHIA_JFR_RUN
  PERF_TESTS_START_INFRA_ONLY = var.PERF_TESTS_START_INFRA_ONLY

  ec2_subnet           = local.tfsettings.ec2.subnet
  ssh_allowed_pub_keys = local.tfsettings.ssh_pub_keys
  ssh_pub_key          = base64decode(var.SSH_PUBLIC_KEY_BASE64)
  ssh_private_key      = base64decode(var.SSH_PRIVATE_KEY_BASE64)

  env_prefix = local.tfsettings.env_prefix

  env_name          = local.tfsettings.env_name
  hostname          = each.key
  ec2_instance_type = each.value.ec2_instance_type

  docker_run_env = join("###", each.value.environment)

  docker_run_image = (each.value.image == "DOCKER_JAHIA_IMAGE" ? var.DOCKER_JAHIA_IMAGE : (each.value.image == "DOCKER_TESTS_IMAGE" ? var.DOCKER_TESTS_IMAGE : each.value.image))

  docker_run_cmd = "docker run -d --name docker_container --env-file=/tmp/docker-run.env --log-driver=journald --log-opt tag=docker ${join(" ", each.value.docker_params)} --env AWS_ENVIRONMENT_SPECS=${base64encode(jsonencode(local.tfsettings))} ${each.value.volume} DOCKER_IMAGE ${join(" ", each.value.docker_command)}"

  # DNS Configuration
  zone_id_public            = module.route53.zone_id_public
  zone_id_private           = module.route53.zone_id_private
  server_name_jahia_public  = "${each.key}.${local.tfsettings.route53.env_public_domain}"
  server_name_jahia_private = "${each.key}.${local.tfsettings.route53.env_private_domain}"

  # Adding depends_on to wait for the bastion server to be ready (including preparing the EFS mount) before starting ecs containers
  depends_on = [module.ec2-bastion, module.efs]
}
