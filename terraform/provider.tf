# Instruct terraform to download the provider on `terraform init`
terraform {
  required_providers {
    xenorchestra = {
      source  = "terra-farm/xenorchestra"
      version = "0.26.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
  backend "s3" {
    bucket = "xenorchestra-state"
    key = "terraform.state"
    region = "placeholder"

    endpoints = {
      s3 = "http://172.19.0.5:9000"
    }

    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    skip_requesting_account_id = true
    use_path_style = true
    
  }
}

# Configure the XenServer Provider
provider "xenorchestra" {
  # Must be ws or wss
  # url      = "wss://<URL>:<PORT>" # Or set XOA_URL environment variable
  # username = "admin@admin.net"                   # Or set XOA_USER environment variable
  # password = "admin"               # Or set XOA_PASSWORD environment variable

  # This is false by default and
  # will disable ssl verification if true.
  # This is useful if your deployment uses
  # a self signed certificate but should beter
  # used sparingly!
  insecure = true # Or set XOA_INSECURE environment variable to any value
}