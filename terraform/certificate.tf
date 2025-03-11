resource "yandex_cm_certificate" "le-certificate" {
  name    = "diploma-certificate"
  domains = ["netology-diploma.online", "*.netology-diploma.online"]

  managed {
    challenge_type  = "DNS_CNAME"
    challenge_count = 1
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "yandex_dns_recordset" "example" {
  count   = yandex_cm_certificate.le-certificate.managed[0].challenge_count
  zone_id = yandex_dns_zone.zone1.id
  name    = yandex_cm_certificate.le-certificate.challenges[count.index].dns_name
  type    = yandex_cm_certificate.le-certificate.challenges[count.index].dns_type
  data    = [yandex_cm_certificate.le-certificate.challenges[count.index].dns_value]
  ttl     = 60
}

data "yandex_cm_certificate" "le-certificate" {
  depends_on      = [yandex_dns_recordset.example]
  certificate_id  = yandex_cm_certificate.le-certificate.id
  wait_validation = true
}
