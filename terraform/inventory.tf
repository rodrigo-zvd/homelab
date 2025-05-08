resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", {
    masters = [
      for vm in xenorchestra_vm.masters : {
        name = vm.name_label
        ip   = vm.ipv4_addresses[0]
        user = local.cloud_init.cloud_config.user
      }
    ]
    workers = [
      for vm in xenorchestra_vm.workers : {
        name = vm.name_label
        ip   = vm.ipv4_addresses[0]
        user = local.cloud_init.cloud_config.user
      }
    ]
  })

  filename        = "inventory.ini"
  file_permission = "0600"
}
