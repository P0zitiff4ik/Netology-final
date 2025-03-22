output "kubernetes_cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.name
}
