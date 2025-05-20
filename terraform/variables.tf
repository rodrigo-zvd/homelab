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

variable "minio_url" {
  description = "URL for Minio"
  type        = string
  sensitive   = true
  default     = "http://localhost:9000"
}

variable "minio_access_key" {
  description = "Minio Access Key S3"
  type        = string
  sensitive   = true
  default     = "terraform"
}

variable "minio_secret_key" {
  description = "Minio Secret Key S3"
  type        = string
  sensitive   = true
  default     = "terraform123"
}