terraform {
  required_version = "0.12.13"
}

provider "google" {
  # Версия провайдера
  version = "2.15.0"
  # ID проекта
  project = var.project

  #region = "europe-west-2"
  region      = var.region
  credentials = "/root/.config/gcloud/legacy_credentials/vy.mishukov@gmail.com/adc.json"
}

module "app_with_docker" {
  source          = "../modules/app_with_docker"
  public_key_path = var.public_key_path
  zone            = var.zone
  app_disk_image  = var.app_disk_image
  app_name = var.app_name
  ip_name = var.ip_name
  firewall_puma_name = var.firewall_puma_name
}

