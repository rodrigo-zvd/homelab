variable "xoa_url" {
  description = "URL for Xen Orchestra"
  type        = string
  sensitive   = true
  default     = "ws://xen-orchestra:80"
}

variable "xoa_username" {
  description = "Username for Xen Orchestra"
  type        = string
  sensitive   = true
  default     = "admin@admin.net"
}

variable "xoa_password" {
  description = "Password for Xen Orchestra"
  type        = string
  sensitive   = true
  default     = "admin"
}