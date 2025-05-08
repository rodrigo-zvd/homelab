resource "xenorchestra_vm" "masters" {
  #number of vms
  count = local.masters.count

  #name of vm
  name_label = format(
    "%s-%s",
    local.masters.name_prefix,
    count.index
  )

  #core cpu
  cpus = local.masters.cores

  #memory ram
  memory_max = local.masters.memory

  #configuration of vm
  template = data.xenorchestra_template.template.id

  #cloud-init config
  cloud_config = templatefile("cloud_config.tftpl", {
    hostname = format(
      "%s-%s",
      local.masters.name_prefix,
      count.index
    )
    domain           = local.domain
    manage_etc_hosts = local.cloud_init.cloud_config.manage_etc_hosts
    timezone         = local.cloud_init.cloud_config.timezone
    locale           = local.cloud_init.cloud_config.locale
    keyboard_layout  = local.cloud_init.cloud_config.keyboard_layout
    user             = local.cloud_init.cloud_config.user
    password         = local.cloud_init.cloud_config.password
    chpasswd         = local.cloud_init.cloud_config.chpasswd
    ssh_pwauth       = local.cloud_init.cloud_config.ssh_pwauth
    ssh_public_key   = local.cloud_init.cloud_config.ssh_public_key
    package_update   = local.cloud_init.cloud_config.package_update
    package_upgrade  = local.cloud_init.cloud_config.package_upgrade
  })
  #cloud-init network
  cloud_network_config = templatefile("network_config.tftpl", {
    hostname = format(
      "%s-%s",
      local.masters.name_prefix,
      count.index
    )
    device = local.cloud_init.network_config.device
    ip = format(
      "%s/24",
      cidrhost(
        local.cidr,
        local.masters.network_last_octect + count.index
      )
    )
    gateway = local.gateway
    dns1    = local.dns1
    dns2    = local.dns2
  })


  #extra configuration
  destroy_cloud_config_vdi_after_boot = local.destroy_cloud_config_vdi_after_boot
  auto_poweron                        = local.auto_poweron
  wait_for_ip                         = local.wait_for_ip

  #network of vm
  network {
    network_id = data.xenorchestra_network.network.id
  }

  #disk of vm
  disk {
    sr_id = data.xenorchestra_sr.sr.id
    name_label = format(
      "%s-%s-%s",
      local.masters.name_prefix,
      count.index,
      local.masters.disks.xvda.name
    )
    size = local.masters.disks.xvda.size
  }

  #tags of vm
  tags = [
    local.masters.tags
  ]

  # connection ssh to vm
  connection {
    type        = "ssh"
    user        = local.cloud_init.cloud_config.user
    private_key = file("id_ed25519")
    host = format(
      "%s",
      cidrhost(
        local.cidr,
        local.workers.network_last_octect + count.index
      )
    )
  }
  # wait for cloud-init done
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait | grep -q 'status: done' && exit 0 || exit 1"
    ]

  }
}