resource "yandex_iam_service_account" "dns-sa" {
  name        = "dns-sa"
  description = "Сервисный аккаунт, от имени которого будут создаваться ресурсы, необходимые для работы с DNS"
}

resource "yandex_dns_zone" "zone1" {
  name        = "diploma-zone"
  description = "Зона для дипломного проекта"

  labels = {
    environment = "production"
  }

  zone             = "netology-diploma.online."
  public           = true
  private_networks = [module.vpc_prod.vpc_network_id]
}

resource "yandex_dns_zone" "ru" {
  name        = "diploma-zone-ru"
  description = "Зона для дипломного проекта"

  labels = {
    environment = "production"
  }

  zone             = "netology-diploma.ru."
  public           = true
  private_networks = [module.vpc_prod.vpc_network_id]
}

resource "yandex_dns_zone_iam_binding" "zone-editor" {
  dns_zone_id = yandex_dns_zone.zone1.id
  members = [
    "serviceAccount:${yandex_iam_service_account.dns-sa.id}"
  ]
  role = "dns.editor"
}

# resource "yandex_iam_service_account" "eso-sa" {
#   name        = "eso-service-account"
#   description = "Сервисный аккаунт, от имени которого будут создаваться secrets в k8s"
# }

# resource "yandex_cm_certificate_iam_member" "eso-downloader" {
#   certificate_id = yandex_cm_certificate.le-certificate.id
#   member = "serviceAccount:${yandex_iam_service_account.eso-sa.id}"
#   role        = "certificate-manager.certificates.downloader"
# }

# resource "yandex_iam_service_account_key" "eso-sa-auth-key" {
#   service_account_id = yandex_iam_service_account.eso-sa.id
#   output_to_lockbox {
#     secret_id = yandex_lockbox_secret.my_secret.id
#     entry_for_private_key = "private"
#   }
#   description        = "key for service account"
#   key_algorithm      = "RSA_4096"
# }

# resource "yandex_dns_recordset" "rs1" {
#   zone_id = yandex_dns_zone.zone1.id
#   name    = "srv.example.com."
#   type    = "A"
#   ttl     = 200
#   data    = ["10.1.0.1"]
# }

# resource "yandex_dns_recordset" "rs2" {
#   zone_id = yandex_dns_zone.zone1.id
#   name    = "srv2"
#   type    = "A"
#   ttl     = 200
#   data    = ["10.1.0.2"]
# }

