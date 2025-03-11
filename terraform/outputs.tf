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

# output "kubernetes_cluster_kubeconfig" {
#     description = "Kubeconfig for the Kubernetes cluster"
#     value       = yandex_kubernetes_cluster.k8s_cluster.kubeconfig
# }
