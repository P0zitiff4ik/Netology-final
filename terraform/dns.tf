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
