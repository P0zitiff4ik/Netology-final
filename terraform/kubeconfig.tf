data "yandex_client_config" "client" {}

data "yandex_kubernetes_cluster" "kubernetes" {
  name = yandex_kubernetes_cluster.k8s_cluster.name
}

# provider "kubernetes" {
#   load_config_file = false

#   host                   = data.yandex_kubernetes_cluster.kubernetes.master.0.external_v4_endpoint
#   cluster_ca_certificate = data.yandex_kubernetes_cluster.kubernetes.master.0.cluster_ca_certificate
#   token                  = data.yandex_client_config.client.iam_token
# }

locals {
  # Преобразуем PEM-сертификат в Base64 (теперь его можно безопасно вставлять в kubeconfig)
  ca_cert_base64 = base64encode(data.yandex_kubernetes_cluster.kubernetes.master.0.cluster_ca_certificate)
  kubeconfig_content = templatefile("${path.module}/templates/kubeconfig.tpl", {
    ca_cert   = local.ca_cert_base64
    endpoint  = data.yandex_kubernetes_cluster.kubernetes.master.0.external_v4_endpoint
    k8s_token = data.yandex_client_config.client.iam_token
  })
}
output "kubeconfig" {
  description = "Generated kubeconfig content"
  value     = local.kubeconfig_content
  sensitive = true
}

provider "github" {
  token = var.github_token    
  owner = var.github_owner   
}

data "github_actions_public_key" "example_public_key" {
  repository = var.github_repository
}

resource "github_actions_secret" "kube_config" {
  repository      = var.github_repository
  secret_name     = "KUBE_CONFIG"
  plaintext_value = local.kubeconfig_content
}

resource "github_actions_variable" "kube_config_var" {
  repository = var.github_repository
  value = local.kubeconfig_content
  variable_name = "KUBE_CONFIG"
}

resource "local_file" "kube_config" {
  filename = "${path.module}/../kubeconfig.yaml"
  content  = local.kubeconfig_content  
}

resource "github_actions_secret" "iam_token" {
  repository      = var.github_repository
  secret_name     = "YC_CR_TOKEN"
  plaintext_value = data.yandex_client_config.client.iam_token
}

resource "github_actions_secret" "registry" {
  repository      = var.github_repository
  secret_name     = "YC_REGISTRY_ID"
  plaintext_value = yandex_container_registry.registry.id
}