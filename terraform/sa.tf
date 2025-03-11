resource "yandex_iam_service_account" "k8s-res-sa" {
  name        = "k8s-res-sa"
  description = "Сервисный аккаунт, от имени которого будут создаваться ресурсы, необходимые кластеру Managed Service for Kubernetes"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-res-sa" {
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.k8s-res-sa.id}"
  role = "editor"
}


resource "yandex_iam_service_account" "k8s-node-sa" {
  name        = "k8s-node-sa"
  description = "Сервисный аккаунт, от имени которого узлы будут скачивать из реестра необходимые Docker-образы"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-node-sa" {
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.k8s-node-sa.id}"
  role = "container-registry.images.puller"
}


resource "yandex_iam_service_account" "k8s-ic-sa" {
  name        = "k8s-ic-sa"
  description = "Сервисный аккаунт, необходимый для работы Application Load Balancer Ingress-контроллера"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-ic-sa-alb" {
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.k8s-ic-sa.id}"
  role = "alb.editor"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-ic-sa-vpc" {
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.k8s-ic-sa.id}"
  role = "vpc.publicAdmin"
}


resource "yandex_resourcemanager_folder_iam_member" "k8s-ic-sa-cert" {
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.k8s-ic-sa.id}"
  role = "certificate-manager.certificates.downloader"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-ic-sa-cv" {
  folder_id = var.folder_id
  member = "serviceAccount:${yandex_iam_service_account.k8s-ic-sa.id}"
  role = "compute.viewer"
}
