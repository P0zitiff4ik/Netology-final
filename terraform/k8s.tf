resource "yandex_kubernetes_cluster" "k8s_cluster" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-res-sa,
    yandex_resourcemanager_folder_iam_member.k8s-node-sa,
    module.vpc_prod
  ]
  timeouts {
    create = "10m"   # или используйте другое подходящее значение
  }
  name               = "diploma-cluster"
  description        = "Kubernetes cluster for diploma project"
  service_account_id = yandex_iam_service_account.k8s-res-sa.id
  node_service_account_id = yandex_iam_service_account.k8s-node-sa.id
  network_id         = module.vpc_prod.vpc_network_id
  release_channel = "STABLE"
  labels = {
    "environment" = "production"
  }
  master {
    regional {
      region = "ru-central1"
      location {
        zone      = module.vpc_prod.vpc_zone[0]
        subnet_id = module.vpc_prod.vpc_subnet_id[0]
      }

      location {
        zone      = module.vpc_prod.vpc_zone[1]
        subnet_id = module.vpc_prod.vpc_subnet_id[1]
      }

      location {
        zone      = module.vpc_prod.vpc_zone[2]
        subnet_id = module.vpc_prod.vpc_subnet_id[2]
      }
    }
    version = "1.29"
    public_ip = true
    security_group_ids = [yandex_vpc_security_group.example.id]
    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }

      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    }

    master_logging {
      enabled                    = true
      folder_id                  = var.folder_id
      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
      audit_enabled              = true
    }
  }
}

resource "yandex_kubernetes_node_group" "workers" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "diploma-node-group"
  description = "Node group for diploma project"
  version    = "1.29"
  labels = {
    "environment" = "production"
  }
  instance_template {
    platform_id = "standard-v3" # Intel Broadwell
    network_interface {
      subnet_ids = ["${module.vpc_prod.vpc_subnet_id[0]}", "${module.vpc_prod.vpc_subnet_id[1]}", "${module.vpc_prod.vpc_subnet_id[2]}"]
      nat = true
      security_group_ids = [yandex_vpc_security_group.example.id]
    }
    resources {
      memory = 4
      cores  = 2
      core_fraction = 50
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = true  # Использование прерываемых ВМ
    }
    container_runtime {
      type = "containerd"
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  allocation_policy {
    location {
        zone      = module.vpc_prod.vpc_zone[0]
      }

      location {
        zone      = module.vpc_prod.vpc_zone[1]
      }

      location {
        zone      = module.vpc_prod.vpc_zone[2]
      }
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}