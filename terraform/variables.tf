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

variable "s3_access_key" {
  description = "Access Key S3"
  type        = string
  sensitive   = true
  default     = "terraform"
}

variable "s3_secret_key" {
  description = "Secret Key S3"
  type        = string
  sensitive   = true
  default     = "terraform123"
}