terraform {
  required_version = "0.12.24"
}

provider "google" {
  version = "2.15"

  project = var.project

  region = var.region
}

module "app" {
  source          = "./modules/app"
  public_key_path = var.public_key_path
}

module "db" {
  source          = "./modules/db"
  public_key_path = var.public_key_path
}

module "vpc" {
  source = "./modules/vpc"
}
