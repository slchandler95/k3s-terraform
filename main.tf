data "xenorchestra_pool" "pool" {
  name_label = var.pool_name
}

data "xenorchestra_network" "network" {
  name_label = var.network_name
  pool_id    = data.xenorchestra_pool.pool.id
}

data "xenorchestra_sr" "default_sr" {
  name_label = var.storage_name
  pool_id    = data.xenorchestra_pool.pool.id
}

data "xenorchestra_template" "template" {
  name_label = var.template_name
}

resource "xenorchestra_vm" "k3s_master_vm" {
  count            = var.num_k3s_masters
  name_label       = "k3s-master-${count.index}"
  name_description = "k3s"
  template         = data.xenorchestra_template.template.id

  cloud_config = templatefile("./templates/cloud_config.tftpl", {
    hostname = "k3s-master-${count.index}"
    sshkey   = var.ssh_key
  })

  cloud_network_config = templatefile("./templates/network_config.tftpl", {
    ip      = cidrhost("192.168.1.0/24", 40+count.index)
    netmask = var.netmask
    gateway = var.gateway
    dns     = var.dns
  })

  cpus        = var.master_cores
  memory_max  = var.master_memory
  wait_for_ip = true

  network {
    network_id = data.xenorchestra_network.network.id
  }

  disk {
    sr_id      = data.xenorchestra_sr.default_sr.id
    name_label = "k3s-master-${count.index} disk"
    size       = var.storage_size
  }

  tags = [
    "Ubuntu",
    "k3s",
  ]

  timeouts {
    create = "20m"
  }
}

resource "xenorchestra_vm" "k3s_worker_vm" {
  count            = var.num_k3s_workers
  name_label       = "k3s-worker-${count.index}"
  name_description = "k3s"
  template         = data.xenorchestra_template.template.id

  cloud_config = templatefile("./templates/cloud_config.tftpl", {
    hostname = "k3s-worker-${count.index}"
    sshkey   = var.ssh_key
  })

  cloud_network_config = templatefile("./templates/network_config.tftpl", {
    ip      = cidrhost("192.168.1.0/24", 50+count.index)
    netmask = var.netmask
    gateway = var.gateway
    dns     = var.dns
  })

  cpus        = var.worker_cores
  memory_max  = var.worker_memory
  wait_for_ip = true

  network {
    network_id = data.xenorchestra_network.network.id
  }

  disk {
    sr_id      = data.xenorchestra_sr.default_sr.id
    name_label = "k3s-worker-${count.index} disk"
    size       = var.storage_size
  }

  tags = [
    "Ubuntu",
    "k3s",
  ]

  timeouts {
    create = "20m"
  }

  depends_on = [xenorchestra_vm.k3s_master_vm]
}

output "k3s-master-ips" {
  value = ["${xenorchestra_vm.k3s_master_vm.*.ipv4_addresses}"]
}
output "k3s-worker-ips" {
  value = ["${xenorchestra_vm.k3s_worker_vm.*.ipv4_addresses}"]
}