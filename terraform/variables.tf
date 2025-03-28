variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-d"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "platform" {
  type        = string
  default     = "standard-v2"
  description = "https://cloud.yandex.ru/docs/compute/concepts/platforms"
}

variable "account_id" {
  type        = string
  description = ""
}

variable "github_token" {
  type        = string
  description = "https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token"
}

variable "github_owner" {
  type        = string
  description = "https://docs.github.com/en/github/setting-up-and-managing-organizations-and-teams/about-organizations"
}

variable "github_repository" {
  type        = string
  description = "https://docs.github.com/en/github/getting-started-with-github/create-a-repo"
  default = "Netology-final"
}