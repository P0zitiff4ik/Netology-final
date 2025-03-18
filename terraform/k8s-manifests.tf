locals {
  common_ingress_vars = {
    tls_host      = "netology-diploma.online"
    secret_name   = "k8s-secret"
    ingress_class = "nginx"
    path          = "/"
  }
}

# Data-блок для генерации манифеста для nginx
data "template_file" "ingress_nginx" {
  template = file("${path.module}/templates/ingress.tpl")
  vars = merge(
    local.common_ingress_vars,
    {
      ingress_name = "nginx-ingress"
      namespace    = "ns"                  # пространство имён для nginx
      rule_host    = "netology-diploma.online" # правило для nginx
      service_name = "nginx-service"
      service_port = 80
    }
  )
}

# Сохраняем сгенерированный файл для nginx
resource "local_file" "ingress_nginx_file" {
  content  = data.template_file.ingress_nginx.rendered
  filename = "${path.module}/../k8s/ingress_nginx.yaml"
}

# Data-блок для генерации манифеста для мониторинга (например, Grafana)
data "template_file" "ingress_monitoring" {
  template = file("${path.module}/templates/ingress.tpl")
  vars = merge(
    local.common_ingress_vars,
    {
      ingress_name = "monitoring-ingress"
      namespace    = "monitoring" # пространство имён для мониторинга (например, Grafana)
      rule_host    = "grafana.netology-diploma.online"
      service_name = "grafana"
      service_port = 3000
    }
  )
}

# Сохраняем сгенерированный файл для мониторинга (Grafana)
resource "local_file" "ingress_monitoring_file" {
  content  = data.template_file.ingress_monitoring.rendered
  filename = "${path.module}/../k8s/ingress_monitoring.yaml"
}


data "template_file" "extsecret" {
  template = file("${path.module}/templates/extsecret.tpl")
  vars = {
    extsecret_name    = "external-secret"
    namespace         = "ns"
    refresh_interval  = "1h"
    secret_store_name = "secret-store"
    secret_store_kind = "SecretStore"
    target_name       = "k8s-secret"
    target_type       = "kubernetes.io/tls"
    secret_key_crt    = "tls.crt"
    secret_key_key    = "tls.key"
    # certificate_id    = data.yandex_cm_certificate.le-certificate.id
    certificate_id   = "fpq3p2o1phairijigkl4"
    property_chain   = "chain"
    property_private = "privateKey"
  }
}

resource "local_file" "extsecret_file" {
  content  = data.template_file.extsecret.rendered
  filename = "${path.module}/../k8s/extsecret.yaml"
}

data "template_file" "deployment_nginx" {
  template = file("${path.module}/templates/nginx-deployment.tpl")
  vars = {
    deployment_name = "nginx-deployment"
    namespace       = "ns"
    replicas        = 2
    app_label       = "nginx"
    container_name  = "nginx"
    registry_id     = yandex_container_registry.registry.id
    image_name      = "my-test-app"
    tag             = "latest"
    container_port  = 80
    limit_memory    = "128Mi"
    limit_cpu       = "500m"
    request_memory  = "64Mi"
    request_cpu     = "250m"
  }
}

resource "local_file" "deployment_nginx_file" {
  depends_on = [ yandex_container_registry.registry ]
  content  = data.template_file.deployment_nginx.rendered
  filename = "${path.module}/../k8s/nginx-deployment.yaml"
}
