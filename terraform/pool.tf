data "xenorchestra_pool" "pool" {
  name_label = local.pool
}

data "xenorchestra_template" "template" {
  name_label = local.template
}

data "xenorchestra_sr" "sr" {
  name_label = local.sr
  pool_id    = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "network" {
  name_label = local.network.name_label
  pool_id    = data.xenorchestra_pool.pool.id
}