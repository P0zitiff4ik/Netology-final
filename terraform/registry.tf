# Создание Container Registry
resource "yandex_container_registry" "registry" {
  name = "diploma-container-registry"
}

# Создание реестра для контейнеров
resource "yandex_container_repository" "repository" {
  name       = "${yandex_container_registry.registry.id}/my-test-app"
}