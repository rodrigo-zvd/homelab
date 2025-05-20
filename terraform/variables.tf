variable "xoa_url" {
  description = "URL for Xen Orchestra"
  type        = string
  sensitive   = true
  default     = "ws://localhost:8081"
}

variable "xoa_username" {
  description = "Username for Xen Orchestra"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "xoa_password" {
  description = "Password for Xen Orchestra"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "minio_url" {
  description = "URL for Minio"
  type        = string
  sensitive   = true
  default     = "http://localhost:9000"
}