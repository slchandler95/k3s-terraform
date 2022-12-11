terraform {
  required_version = ">= 0.13.0"
  required_providers {
    xenorchestra = {
      source  = "terra-farm/xenorchestra"
      version = "0.23.3"
    }
  }
}

variable "xo_host" {
  description = "Xen Orchestra IP/URL"
  type        = string
  sensitive   = true
}

variable "xo_user" {
  description = "Xen Orchestra User"
  type        = string
  sensitive   = true
}

variable "xo_pass" {
  description = "Xen Orchestra Password"
  type        = string
  sensitive   = true
}

provider "xenorchestra" {
  url      = var.xo_host
  username = var.xo_user
  password = var.xo_pass
  insecure = true
}