provider "github" {
  token = var.github_token    
  owner = var.github_owner   
}

data "github_actions_public_key" "example_public_key" {
  repository = var.github_repository
}

resource "github_actions_secret" "kube_config" {
  repository      = var.github_repository
  secret_name     = "KUBE_CONFIG"
  plaintext_value = local.kubeconfig_content
}

resource "github_actions_secret" "iam_token" {
  repository      = var.github_repository
  secret_name     = "YC_CR_TOKEN"
  plaintext_value = data.yandex_client_config.client.iam_token
}

resource "github_actions_secret" "registry" {
  repository      = var.github_repository
  secret_name     = "YC_REGISTRY_ID"
  plaintext_value = yandex_container_registry.registry.id
}