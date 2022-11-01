variable "root_partition_size" {
  type        = number
  default     = 3
  description = "The size in GB of the root partition for the image."

  validation {
    condition     = var.root_partition_size >= 3
    error_message = "The root partition size must be greater than or equal to 3GB."
  }
}

variable "github_token" {
  type        = string
  sensitive   = true
  default     = ""
  description = "The github token used to increase github api limits when performing the build."
}

variable "version" {
  type        = string
  default     = "22.04.1"
  description = "The version of ubuntu to use for the image."
}

variable "architecture" {
  type        = string
  default     = "arm64"
  description = "The architecture to use for the image."
}

locals {
  setup_dir  = "/workspace/setup"
  image_name = "ubuntu-${var.version}-${var.architecture}"
}
