locals {
  common_ingress_vars = {
    tls_host      = "${resource.yandex_dns_zone.zone1}"
    secret_name   = "k8s-secret"
    ingress_class = "nginx"
    path          = "/"
  }
}

# Генерация манифеста для ingress
data "template_file" "ingress_nginx" {
  template = file("${path.module}/templates/ingress.tpl")
  vars = merge(
    local.common_ingress_vars,
    {
      ingress_name = "nginx-ingress"
      namespace    = "ns"                  # пространство имён для nginx
      rule_host    = "${local.common_ingress_vars.tls_host}" # правило для nginx
      service_name = "nginx-service"
      service_port = 80
    }
  )
}

resource "local_file" "ingress_nginx_file" {
  content  = data.template_file.ingress_nginx.rendered
  filename = "${path.module}/../k8s/ingress_nginx.yaml"
}

# Генерация манифеста для мониторинга (например, Grafana)
data "template_file" "ingress_monitoring" {
  template = file("${path.module}/templates/ingress.tpl")
  vars = merge(
    local.common_ingress_vars,
    {
      ingress_name = "monitoring-ingress"
      namespace    = "monitoring" # пространство имён для мониторинга (например, Grafana)
      rule_host    = "grafana.${local.common_ingress_vars.tls_host}" # правило для мониторинга
      service_name = "grafana"
      service_port = 3000
    }
  )
}

resource "local_file" "ingress_monitoring_file" {
  content  = data.template_file.ingress_monitoring.rendered
  filename = "${path.module}/../k8s/ingress_monitoring.yaml"
}

# Генерация манифеста для секрета (TLS-сертификат)
data "yandex_cm_certificate" "diploma-certificate" {
  folder_id = var.folder_id
  name      = "diploma-certificate"
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
    certificate_id   = "${data.yandex_cm_certificate.diploma-certificate.id}"
    property_chain   = "chain"
    property_private = "privateKey"
  }
}

resource "local_file" "extsecret_file" {
  content  = data.template_file.extsecret.rendered
  filename = "${path.module}/../k8s/extsecret.yaml"
}

# Генерация манифеста для приложения (например, nginx)
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
