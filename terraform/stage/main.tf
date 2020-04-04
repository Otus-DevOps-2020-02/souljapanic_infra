terraform {
  # required_version = "0.12.24"
  required_version = "~> 0.12"
}

provider "google" {
  version = "2.15"

  project = var.project

  region = var.region
}

module "app" {
  source           = "../modules/app"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  dbipaddr         = module.db.db_internal_ip
}

module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
}
