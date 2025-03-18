output "kubernetes_cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.name
}

# output "kubernetes_cluster_master_version" {
#     description = "Kubernetes version of the master"
#     value       = yandex_kubernetes_cluster.k8s_cluster.master.0.version_info
# }

# output "kubernetes_cluster_service_account_id" {
#     description = "Service account ID of the Kubernetes cluster"
#     value       = yandex_kubernetes_cluster.k8s_cluster.service_account_id
# }

# output "kubernetes_cluster_endpoint" {
#     description = "Endpoint of the Kubernetes cluster"
#     value       = yandex_kubernetes_cluster.k8s_cluster.master.0.external_v4_endpoint
# }

# output "kubernetes_cluster_ca_certificate" {
#     description = "CA certificate of the Kubernetes cluster"
#     value       = yandex_kubernetes_cluster.k8s_cluster.master.0.cluster_ca_certificate
# }

# output "container_registry" {
#   description = "Container registry"
#   value       = yandex_container_registry.registry.id
# }

# output "kubeconfig" {
#   value = templatefile("${path.module}/kubeconfig.tpl", {
#     cluster_ca_certificate = data.yandex_kubernetes_cluster.kubernetes.master.0.cluster_ca_certificate
#     endpoint               = data.yandex_kubernetes_cluster.kubernetes.master.0.external_v4_endpoint
#     token                  = data.yandex_client_config.client.iam_token
#     name                   = yandex_kubernetes_cluster.k8s_cluster.name
#   })
# }

# output "iam_token" {
#   description = "IAM token"
#   value       = data.yandex_client_config.client.iam_token
# }