variable "pool_name" {
  description = "XCP-NG Pool Name"
  type        = string
}

variable "network_name" {
  description = "XCP-NG Network Name"
  type        = string
  default     = "Pool-wide network associated with eth0"
}

variable "storage_name" {
  description = "XCP-NG Storage Repository Name"
  type        = string
  default     = "Local storage"
}

variable "template_name" {
  description = "XCP-NG VM Template Name"
  type        = string
}

variable "ssh_key" {
  description = "Public SSH Key for cloud-init"
  type        = string
}

variable "netmask" {
  description = "Network Netmask"
  type        = string
  default     = "255.255.255.0"
}

variable "gateway" {
  description = "Network Default Gateway"
  type        = string
  default     = "192.168.1.1"
}

variable "dns" {
  description = "Network DNS Nameserver"
  type        = string
  default     = "192.168.1.1"
}

variable "num_k3s_masters" {
  description = "Number of k3s master VM(s)"
  type        = number
  default     = 1
}

variable "num_k3s_workers" {
  description = "Number of k3s worker VM(s)"
  type        = number
  default     = 1
}

variable "master_cores" {
  description = "k3s master CPU cores allocation"
  type        = number
  default     = 4
}

variable "worker_cores" {
  description = "k3s worker CPU cores allocation"
  type        = number
  default     = 2
}

variable "master_memory" {
  description = "k3s master RAM allocation in bytes"
  type        = number
  default     = 4294967296
}

variable "worker_memory" {
  description = "k3s worker RAM allocation in bytes"
  type        = number
  default     = 4294967296
}

variable "storage_size" {
  description = "VM Disk Size in bytes"
  type        = number
  default     = 10737418240
}