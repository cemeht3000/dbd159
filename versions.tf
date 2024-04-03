terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.105"
    }
    archive = "~> 2.2.0"
  }
  required_version = "~> 1.0"
}
