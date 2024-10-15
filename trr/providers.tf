terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  zone = "ru-central1-a"
}

provider "yandex" {
  token = "${file("./yctoken")}"
  cloud_id = "${file("./cloudid")}"
  folder_id = "${file("./folderid")}"
  zone = local.zone
}