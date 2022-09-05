# Environment variables, those variables must be set
variable "NEXUS_USERNAME" {
  default = ""
  validation {
    condition     = length(var.NEXUS_USERNAME) > 4
    error_message = "The TF_VAR_NEXUS_USERNAME seems empty, it must be set to be able to provision the environment."
  }
}

variable "NEXUS_PASSWORD" {
  default = ""
  validation {
    condition     = length(var.NEXUS_PASSWORD) > 4
    error_message = "The TF_VAR_NEXUS_PASSWORD seems empty, it must be set to be able to provision the environment."
  }
}

variable "DOCKERHUB_USERNAME" {
  default = ""
  validation {
    condition     = length(var.DOCKERHUB_USERNAME) > 4
    error_message = "The TF_VAR_DOCKERHUB_USERNAME seems empty, it must be set to be able to provision the environment."
  }
}

variable "DOCKERHUB_PASSWORD" {
  default = ""
  validation {
    condition     = length(var.DOCKERHUB_PASSWORD) > 4
    error_message = "The TF_VAR_DOCKERHUB_PASSWORD seems empty, it must be set to be able to provision the environment."
  }
}

variable "JAHIA_LICENSE" {
  default = ""
  validation {
    condition     = length(var.JAHIA_LICENSE) > 4
    error_message = "The TF_VAR_JAHIA_LICENSE seems empty, it must be set to be able to provision the environment."
  }
}

variable "SSH_PRIVATE_KEY_BASE64" {
  default = ""
  validation {
    condition     = length(var.SSH_PRIVATE_KEY_BASE64) > 4
    error_message = "The TF_VAR_SSH_PRIVATE_KEY_BASE64 seems empty, it must be set to be able to provision the environment."
  }
}

variable "SSH_PUBLIC_KEY_BASE64" {
  default = ""
  validation {
    condition     = length(var.SSH_PUBLIC_KEY_BASE64) > 4
    error_message = "The TF_VAR_SSH_PUBLIC_KEY_BASE64 seems empty, it must be set to be able to provision the environment."
  }
}

variable "PERF_TESTS_JAHIA_JFR_RUN" {
  default = false
  type    = bool
}

# If set to true, the docker container does not provision nor run the tests
variable "PERF_TESTS_START_INFRA_ONLY" {
  default = false
  type    = bool
}

variable "DOCKER_JAHIA_IMAGE" {
  default = "jahia/jahia-ee-dev:8-SNAPSHOT"
}

variable "DOCKER_TESTS_IMAGE" {
  default = "jahia/core-perf-test:latest"
}
