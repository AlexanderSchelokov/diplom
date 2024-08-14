resource "yandex_compute_instance" "cp_vpc" {
  name            = var.cp_vpc_name
  platform_id     = var.platform
  resources {
    cores         = var.cp_vpc_core
    memory        = var.cp_vpc_memory
    core_fraction = var.cp_vpc_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.cp_vpc_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.scheduling_policy
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet[0].id
    nat       = var.nat
}  
metadata = var.metadata
  }

resource "yandex_compute_instance" "work" {
  count           = var.work_count
  name            = "work-node-${count.index + 1}"
  platform_id     = var.work_platform
  zone = var.public_subnet_zones[count.index]
  resources {
    cores         = var.work_cores
    memory        = var.work_memory
    core_fraction = var.work_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.work_disk_size
    }
  }

    scheduling_policy {
    preemptible = var.scheduling_policy
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet[count.index].id
    nat       = var.nat
  }

  metadata = var.metadata
}
