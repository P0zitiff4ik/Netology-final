data "yandex_client_config" "client" {}

data "yandex_kubernetes_cluster" "kubernetes" {
  name = yandex_kubernetes_cluster.k8s_cluster.name
}

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

resource "local_file" "kube_config" {
  filename = "${path.module}/../kubeconfig.yaml"
  content  = local.kubeconfig_content  
}
