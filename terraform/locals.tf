locals {
  # global configurations
  cidr    = "192.168.1.0/24"
  gateway = "192.168.1.1"
  dns1    = "8.8.8.8"
  dns2    = "8.8.4.4"
  domain  = "lab.local"

  auto_poweron                        = true
  wait_for_ip                         = true
  destroy_cloud_config_vdi_after_boot = true

  pool     = "xcp-optiplex"
  template = "official-ubuntu-24-cloudinit-xe"
  sr       = "Local storage"
  network = {
    name_label = "LAN"
  }

  cloud_init = {
    cloud_config = {
      manage_etc_hosts = true
      timezone         = "America/Sao_Paulo"
      locale           = "pt_BR.utf8"
      keyboard_layout  = "br"
      user             = "ubuntu"
      password         = "ubuntu"
      chpasswd         = false
      ssh_pwauth       = true
      ssh_public_key   = file("id_ed25519.pub")
      package_update   = true
      package_upgrade  = true
    }
    network_config = {
      device = "enX0"
    }
  }

  # master specific configuration
  masters = {
    # how many nodes?
    count = 1

    name_prefix = "k8s-master"

    # hardware info
    cores  = 2
    memory = 2147483648
    disks = {
      xvda = {
        name = "xvda"
        size = 107374182400 #100gb
      }
    }

    # 192.168.0.7x and so on...
    network_last_octect = 70

    tags = "masters"
  }

  # worker specific configuration
  workers = {
    count = 1

    name_prefix = "k8s-worker"

    # hardware info
    cores  = 2
    memory = 2147483648
    disks = {
      xvda = {
        name = "xvda"
        size = 107374182400 #100gb
      }
    }

    network_last_octect = 80

    tags = "workers"
  }
}