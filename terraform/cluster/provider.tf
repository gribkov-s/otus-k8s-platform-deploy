terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
	  version = ">= 0.13"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-d"
  folder_id = var.folder_id
  service_account_key_file = "./keys/key.json"
}